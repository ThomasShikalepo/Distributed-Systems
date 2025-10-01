import ballerina/io;
import ballerina/uuid;
import ballerinax/kafka;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// Trip record type
public type Trips record {|
    string tripId;
    string trip_name;
    string departure_time; // e.g., "2025-09-28 07:00:00"
    string arrival_time;   // e.g., "2025-09-28 07:45:00"
    string vehicleId?;
    string status = "SCHEDULED"; // SCHEDULED, ONGOING, COMPLETED, CANCELLED
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new (
    host = HOST,
    user = USER,
    password = PASSWORD,
    port = PORT,
    database = DATABASE
);

configurable string KAFKA_BROKE = "localhost:9092";

function adminMenu() {
    io:println("\nAdmin Menu");
    io:println("1. create Trip");
    io:println("2. Manage Trips(update/cancel)");
    io:println("3. Publish Service Disruptions or Schedule Updates");
    io:println("4. View Ticket Sales Reports");
    io:println("5. Exit");
}

function adminSelection() returns error? {
    while true {
        adminMenu();
        io:println("Enter your Choice: ");
        int choice = check int:fromString(io:readln());

        match choice {
            1 => {
                check createTrip();
            }
            2 => {
                check manageTrips();
            }
            3 => {
                publishDisruption();
            }
            4 => {
                viewReports();
            }
            5 => {
                io:println("Exiting Admin menu...");
                break;
            }
            _ => {
                io:println("Invalid choice, try again.");
            }
        }
    }
}

// Producer configuration
kafka:ProducerConfiguration producerConfig = {
    clientId: "scheduleUpdates",
    acks: "all"
};

kafka:Producer producer = check new (KAFKA_BROKE, producerConfig);

function createTrip() returns error? {
    io:println("\n--- Admin: Add a Trip ---");
    io:print("Trip Name: ");
    string tripName = io:readln();

    if tripName == "exit" {
        io:println("Cancelled trip creation.");
        return;
    }

    io:print("Departure Time (yyyy-mm-dd hh:mm:ss): ");
    string departureTime = io:readln();

    io:print("Arrival Time (yyyy-mm-dd hh:mm:ss): ");
    string arrivalTime = io:readln();

    io:print("Vehicle ID: ");
    string vehicleId = io:readln();

    // Create Trip record
    Trips trip = {
        tripId: uuid:createType1AsString(),
        trip_name: tripName,
        departure_time: departureTime,
        arrival_time: arrivalTime,
        vehicleId: vehicleId,
        status: "SCHEDULED"
    };

    // Insert into database
  sql:ExecutionResult _ = check dbClient->execute(
    `INSERT INTO trips (trip_id, trip_name, departure_time, arrival_time, vehicle_Id, status)
     VALUES (${trip.tripId}, ${trip.trip_name}, ${trip.departure_time}, ${trip.arrival_time}, ${trip.vehicleId}, ${trip.status})`
     );

    // Convert Trip to JSON
    json tripJson = <json>trip;

    check publishTripEvent("CREATE", trip);
    io:println("Trip Created: " + tripJson.toJsonString());
}


function manageTrips() returns error? {
    io:println("\n--- Manage Trips ---");
    io:println("1. Update Trip");
    io:println("2. Delete Trip");
    io:println("3. back to Admin Menu");

    io:print("Enter your choice: ");
    int choice = check int:fromString(io:readln());

    match choice {
        1 => {
            check updateTrip();
        }
        
        2 => {
            check deleteTrip();
        }

        3 => {
             io:println("Returning to Admin Menu...");
             adminMenu();
        }
        _=> {
            io:println("Invalid choice, try again.");
        }
    }
}

function updateTrip() returns error? {
    io:println("\n--- Update Trip ---");
    io:print("Enter Trip ID to update: ");
    string tripId = io:readln();

    io:println("What do you want to update?");
    io:println("1. Status");
    io:println("2. Departure Time");
    io:println("3. Arrival Time");
    io:println("4. Vehicle ID");

    int choice = check int:fromString(io:readln());

    string newValue = "";

    if choice == 1 {
        io:print("Enter new Status (SCHEDULED/ONGOING/COMPLETED/CANCELLED): ");
        newValue = io:readln();
        sql:ExecutionResult _ = check dbClient->execute(
            `UPDATE trips SET status = ${newValue} WHERE trip_id = ${tripId}`
        );
    } else if choice == 2 {
        io:print("Enter new Departure Time (yyyy-mm-dd hh:mm:ss): ");
        newValue = io:readln();
        sql:ExecutionResult _ = check dbClient->execute(
            `UPDATE trips SET departure_time = ${newValue} WHERE trip_id = ${tripId}`
        );
    } else if choice == 3 {
        io:print("Enter new Arrival Time (yyyy-mm-dd hh:mm:ss): ");
        newValue = io:readln();
        sql:ExecutionResult _ = check dbClient->execute(
            `UPDATE trips SET arrival_time = ${newValue} WHERE trip_id = ${tripId}`
        );
    } else if choice == 4 {
        io:print("Enter new Vehicle ID: ");
        newValue = io:readln();
        sql:ExecutionResult _ = check dbClient->execute(
            `UPDATE trips SET vehicle_Id = ${newValue} WHERE trip_id = ${tripId}`
        );
    } else {
        io:println("Invalid choice. Cancelling update.");
        return;
    }

    // Fetch updated trip
    stream<record {| anydata...; |}, sql:Error?> queryResult = dbClient->query(
        `SELECT * FROM trips WHERE trip_id = ${tripId}`
    );
    record {}? fetchedTrip  = check queryResult.next();

    if fetchedTrip  is record {} {
        // Convert record to JSON safely
        json tripJson = check <json>fetchedTrip ;
        check publishTripEvent("UPDATE", tripJson);
    }

    io:println("Trip updated successfully!");
}


function deleteTrip() returns error? {
    io:println("\n--- Delete Trip ---");
    io:print("Enter Trip ID to delete: ");
    string tripId = io:readln();

    // Fetch trip before deleting
    stream<record {| anydata...; |}, sql:Error?> queryResult = dbClient->query(
        `SELECT * FROM trips WHERE trip_id = ${tripId}`
    );
    record {}? fetchedTrip  = check queryResult.next();

    // Delete the trip
    sql:ExecutionResult _ = check dbClient->execute(
        `DELETE FROM trips WHERE trip_id = ${tripId}`
    );

    // Publish Kafka event
    if fetchedTrip  is record {} {
        // Convert record to JSON safely
        json tripJson = check <json>fetchedTrip ;
        check publishTripEvent("DELETE", tripJson);
    }

    io:println("Trip deleted successfully!");
}




function publishDisruption() {
    io:println("Feature: publish service disruptions (to Kafka topic scheduleUpdates)");
}

function viewReports() {
    io:println("Feature: generate reports (to be implemented)");
}

// Entry point
public function main() returns error? {
    io:println("Admin Service started.\n");
    check adminSelection();
}


function publishTripEvent(string action, json payload) returns error?{
    // Ensure payload is proper JSON
    json eventPlayload = check <json>payload;

    json event = {
        action: action,
        data: eventPlayload
    };

    check producer->send ({
         topic: "trips",
        value: event.toJsonString()
    });

    io:println("Kafka Event Published: " + event.toJsonString());
}