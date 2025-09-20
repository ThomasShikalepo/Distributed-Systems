import ballerina/grpc;

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
