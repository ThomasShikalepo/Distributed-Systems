import ballerina/grpc;

// --- Tables ---
table<User> key(id) usersTable = table [
    {id: "cust01", name: "Alice", role: "CUSTOMER"},
    {id: "cust02", name: "Bob", role: "CUSTOMER"},
    {id: "admin01", name: "Admin", role: "ADMIN"}
];

table<Car> key(plate) carsTable = table [
    {plate: "CAR001", make: "Toyota", model: "Corolla", year: 2020, daily_price: 50.0, mileage: 20000, status: "AVAILABLE"},
    {plate: "CAR002", make: "Honda", model: "Civic", year: 2019, daily_price: 45.0, mileage: 30000, status: "AVAILABLE"},
    {plate: "CAR003", make: "Ford", model: "Focus", year: 2021, daily_price: 55.0, mileage: 15000, status: "UNAVAILABLE"}
];

table<CartItem> key(customer_id, plate) cartItemsTable = table [];

table<Reservation> key(reservation_id) reservations = table [];

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: CAR_RENTAL_DESC}
service "Car_Rental_Service" on ep {

       // ADD CAR
    remote function add_car(AddCarRequest req) returns AddCarResponse|error {
        Car car = req.car;
        if carsTable.hasKey(car.plate) {
            return {plate: car.plate};
        }
        carsTable.add(car);
        return {plate: car.plate};
    }

    // UPDATE CAR
    remote function update_car(UpdateCarRequest req) returns UpdateCarResponse|error {
        Car car = req.car;
        if !carsTable.hasKey(car.plate) {
            return {status: "Car not found"};
        }
        carsTable.put(car);
        return {status: "UPDATED"};
    }

 // REMOVE CAR
    remote function remove_car(RemoveCarRequest req) returns RemoveCarResponse|error {
        if carsTable.hasKey(req.plate) {
            _ = carsTable.remove(req.plate);
        }
        Car[] remaining = [];
        foreach var c in carsTable {
            remaining.push(c);
        }
        return {cars: remaining};
    }

    // LIST AVAILABLE CARS (server streaming)
    remote function list_available_cars(ListAvailableCarsRequest req) returns stream<Car, error?>|error {
        // Just return a stream from a query expression
        stream<Car, error?> s = from var c in carsTable
                where c.status == "AVAILABLE"
                    select c;
        return s;
    }

    // SEARCH CAR
    remote function search_car(SearchCarRequest req) returns SearchCarResponse|error {
        if carsTable.hasKey(req.plate) {
            Car car = carsTable.get(req.plate);
            return {car: car, message: "FOUND"};
        }
        return {message: "NOT FOUND"};
    }

    // ADD TO CART
    remote function add_to_cart(AddToCartRequest req) returns AddToCartResponse|error {
        CartItem item = req.item;
        cartItemsTable.add({
            customer_id: req.customer_id,
            plate: item.plate,
            start_date: item.start_date,
            end_date: item.end_date
        });
        return {message: "Added to cart"};
    }

    remote function place_reservation(PlaceReservationRequest value) returns PlaceReservationResponse|error {
    }

    remote function create_users(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error {
    }

    
}
