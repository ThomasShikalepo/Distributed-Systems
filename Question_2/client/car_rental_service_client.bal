import ballerina/io;

Car_Rental_ServiceClient ep = check new ("http://localhost:9090");

import ballerina/io;

// gRPC client stub generated from your proto
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


    AddCarRequest add_carRequest = {car: {plate: "ballerina", make: "ballerina", model: "ballerina", year: 1, daily_price: 1, mileage: 1, status: "ballerina"}};
    AddCarResponse add_carResponse = check ep->add_car(add_carRequest);
    io:println(add_carResponse);

    UpdateCarRequest update_carRequest = {car: {plate: "ballerina", make: "ballerina", model: "ballerina", year: 1, daily_price: 1, mileage: 1, status: "ballerina"}};
    UpdateCarResponse update_carResponse = check ep->update_car(update_carRequest);
    io:println(update_carResponse);

    RemoveCarRequest remove_carRequest = {plate: "ballerina"};
    RemoveCarResponse remove_carResponse = check ep->remove_car(remove_carRequest);
    io:println(remove_carResponse);

    SearchCarRequest search_carRequest = {plate: "ballerina"};
    SearchCarResponse search_carResponse = check ep->search_car(search_carRequest);
    io:println(search_carResponse);

    AddToCartRequest add_to_cartRequest = {customer_id: "ballerina", item: {plate: "ballerina", start_date: "ballerina", end_date: "ballerina"}};
    AddToCartResponse add_to_cartResponse = check ep->add_to_cart(add_to_cartRequest);
    io:println(add_to_cartResponse);

    PlaceReservationRequest place_reservationRequest = {customer_id: "ballerina"};
    PlaceReservationResponse place_reservationResponse = check ep->place_reservation(place_reservationRequest);
    io:println(place_reservationResponse);

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

