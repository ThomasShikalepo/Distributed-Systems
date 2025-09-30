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
                manageTrips();
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
  sql:ExecutionResult result = check dbClient->execute(
    `INSERT INTO trips (trip_id, trip_name, departure_time, arrival_time, vehicle_Id, status)
     VALUES (${trip.tripId}, ${trip.trip_name}, ${trip.departure_time}, ${trip.arrival_time}, ${trip.vehicleId}, ${trip.status})`
);

    // Convert Trip to JSON
    json tripJson = trip.toJson();

    // Send to Kafka
    check producer->send({
        topic: "trips",
        value: tripJson.toJsonString()
    });

    io:println("Trip Created: " + tripJson.toJsonString());
}


// Placeholder functions for now
function manageTrips() {
    io:println("Feature: update or cancel trips (to be implemented)");
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


