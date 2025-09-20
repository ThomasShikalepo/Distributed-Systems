import ballerina/io;

Car_Rental_ServiceClient ep = check new ("http://localhost:9090");

// --- Admin Menu ---
function adminMenu() {
    io:println("\n--- Admin Menu ---");
    io:println("1. Add Car");
    io:println("2. Update Car");
    io:println("3. Remove Car");
    io:println("4. List Available Cars");
    io:println("5. Exit");
}

// --- Customer Menu ---
function customerMenu() {
    io:println("\n--- Customer Menu ---");
    io:println("1. View Available Cars");
    io:println("2. Search Car by Plate");
    io:println("3. Add Car to Cart");
    io:println("4. Place Reservation");
    io:println("5. Exit");
}

// --- Main Function ---
public function main() returns error? {
    io:println("-----# Welcome to CarRentalService #-----");

    while true {
        io:println("\nEnter your role: \na. Admin\nb. Customer\nc. Exit");
        string userSelection = io:readln();

        if userSelection == "a" {
            check adminSelection();
        } else if userSelection == "b" {
            check customerSelection();
        } else if userSelection == "c" {
            io:println("Exiting Car Rental Service. Goodbye!");
            break;
        } else {
            io:println("Invalid response. Please enter a, b, or c.");
        }
    }
}

// --- Admin Actions ---
function adminSelection() returns error? {
    while true {
        adminMenu();
        io:println("Enter your choice: ");
        int choice = check int:fromString(io:readln());

        match choice {
            1 => {
                check addCar();
            }
            2 => {
                check updateCar();
            }
            3 => {
                check removeCar();
            }
            4 => {
                check listAvailableCars();
            }
            5 => {
                io:println("Exiting Admin Menu...");
                break;
            }
            _ => {
                io:println("Invalid choice. Try again.");
            }
        }

        return;
    }
}

// --- Customer Actions ---
function customerSelection() returns error? {
    while true {
        customerMenu();
        io:println("Enter your choice: ");
        int choice = check int:fromString(io:readln());

        match choice {
            1 => {
                check listAvailableCars();
            }
            2 => {
                check searchCar();
            }
            3 => {
                check addToCart();
            }
            4 => {
                check placeReservation();
            }
            5 => {
                io:println("Exiting Customer Menu...");
                break;
            }
            _ => {
                io:println("Invalid choice. Try again.");
            }
        }

        return;
    }
}


   // --- Admin Functions ---
function addCar() returns error? {
    io:println("Enter Car Details:");
    io:println("Plate: ");
    string plate = io:readln();
    io:println("Make: ");
    string make = io:readln();
    io:println("Model: ");
    string model = io:readln();
    io:println("Year: ");
    int year = check int:fromString(io:readln());
    io:println("Daily Price: ");
    float daily_price = check float:fromString(io:readln());
    io:println("Mileage: ");
    int mileage = check int:fromString(io:readln());
    io:println("Status (AVAILABLE/UNAVAILABLE): ");
    string status = io:readln();

    AddCarRequest req = {
        car: {plate, make, model, year, daily_price, mileage, status}
    };
    AddCarResponse res = check ep->add_car(req);
    io:println("Car Added: ", res.plate);
}


   function updateCar() returns error? {
    io:println("Enter Car Plate to Update: ");
    string plate = io:readln();
    io:println("New Make: ");
    string make = io:readln();
    io:println("New Model: ");
    string model = io:readln();
    io:println("New Year: ");
    int year = check int:fromString(io:readln());
    io:println("New Daily Price: ");
    float daily_price = check float:fromString(io:readln());
    io:println("New Mileage: ");
    int mileage = check int:fromString(io:readln());
    io:println("New Status (AVAILABLE/UNAVAILABLE): ");
    string status = io:readln();

    UpdateCarRequest req = {
        car: {plate, make, model, year, daily_price, mileage, status}
    };
    UpdateCarResponse res = check ep->update_car(req);
    io:println("Car Updated: ", res.status);
}
function removeCar() returns error? {
    io:println("Enter Car Plate to Remove: ");
    string plate = io:readln();
    RemoveCarRequest req = {plate};
    RemoveCarResponse res = check ep->remove_car(req);
    io:println("Remaining Cars: ", res.cars);
}

// --- Shared Functions ---
function listAvailableCars() returns error? {
    ListAvailableCarsRequest req = {filter: ""};
    stream<Car, error?> carsStream = check ep->list_available_cars(req);
    io:println("Available Cars:");
    check carsStream.forEach(function(Car car) {
        io:println(car);
    });
}


   

    AddToCartRequest add_to_cartRequest = {customer_id: "ballerina", item: {plate: "ballerina", start_date: "ballerina", end_date: "ballerina"}};
    AddToCartResponse add_to_cartResponse = check ep->add_to_cart(add_to_cartRequest);
    io:println(add_to_cartResponse);

function placeReservation() returns error? {
    io:println("Enter Your Customer ID: ");
    string customer_id = io:readln();
    PlaceReservationRequest req = {customer_id};
    PlaceReservationResponse res = check ep->place_reservation(req);
    io:println("Reservation Placed: ", res.reservation.reservation_id);
}

    ListAvailableCarsRequest list_available_carsRequest = {filter: "ballerina"};
    stream<Car, error?> list_available_carsResponse = check ep->list_available_cars(list_available_carsRequest);
    check list_available_carsResponse.forEach(function(Car value) {
        io:println(value);
    });

    User create_usersRequest = {id: "ballerina", name: "ballerina", role: "ballerina"};
    Create_usersStreamingClient create_usersStreamingClient = check ep->create_users();
    check create_usersStreamingClient->sendUser(create_usersRequest);
    check create_usersStreamingClient->complete();
    CreateUsersResponse? create_usersResponse = check create_usersStreamingClient->receiveCreateUsersResponse();
    io:println(create_usersResponse);

