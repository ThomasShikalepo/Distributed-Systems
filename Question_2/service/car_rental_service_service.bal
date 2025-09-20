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

    remote function add_car(AddCarRequest value) returns AddCarResponse|error {
    }

    remote function update_car(UpdateCarRequest value) returns UpdateCarResponse|error {
    }

    remote function remove_car(RemoveCarRequest value) returns RemoveCarResponse|error {
    }

    remote function search_car(SearchCarRequest value) returns SearchCarResponse|error {
    }

    remote function add_to_cart(AddToCartRequest value) returns AddToCartResponse|error {
    }

    remote function place_reservation(PlaceReservationRequest value) returns PlaceReservationResponse|error {
    }

    remote function create_users(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error {
    }

    remote function list_available_cars(ListAvailableCarsRequest value) returns stream<Car, error?>|error {
    }
}
