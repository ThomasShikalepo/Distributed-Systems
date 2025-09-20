import ballerina/grpc;
import ballerina/protobuf;

public const string CAR_RENTAL_DESC = "0A106361725F72656E74616C2E70726F746F120A6361725F72656E74616C22AC010A0343617212140A05706C6174651801200128095205706C61746512120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121F0A0B6461696C795F7072696365180520012801520A6461696C79507269636512180A076D696C6561676518062001280552076D696C6561676512160A067374617475731807200128095206737461747573223E0A0455736572120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512120A04726F6C651803200128095204726F6C6522A2010A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E4964121F0A0B637573746F6D65725F6964180220012809520A637573746F6D65724964122A0A056974656D7318032003280B32142E6361725F72656E74616C2E436172744974656D52056974656D73121F0A0B746F74616C5F7072696365180420012801520A746F74616C5072696365225A0A08436172744974656D12140A05706C6174651801200128095205706C617465121D0A0A73746172745F64617465180220012809520973746172744461746512190A08656E645F646174651803200128095207656E644461746522320A0D4164644361725265717565737412210A0363617218012001280B320F2E6361725F72656E74616C2E436172520363617222260A0E416464436172526573706F6E736512140A05706C6174651801200128095205706C61746522350A105570646174654361725265717565737412210A0363617218012001280B320F2E6361725F72656E74616C2E4361725203636172222B0A11557064617465436172526573706F6E736512160A06737461747573180120012809520673746174757322280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522380A1152656D6F7665436172526573706F6E736512230A046361727318012003280B320F2E6361725F72656E74616C2E43617252046361727322320A184C697374417661696C61626C65436172735265717565737412160A0666696C746572180120012809520666696C74657222280A105365617263684361725265717565737412140A05706C6174651801200128095205706C61746522500A11536561726368436172526573706F6E736512210A0363617218012001280B320F2E6361725F72656E74616C2E436172520363617212180A076D65737361676518022001280952076D657373616765225D0A10416464546F4361727452657175657374121F0A0B637573746F6D65725F6964180120012809520A637573746F6D6572496412280A046974656D18022001280B32142E6361725F72656E74616C2E436172744974656D52046974656D222D0A11416464546F43617274526573706F6E736512180A076D65737361676518012001280952076D657373616765223A0A17506C6163655265736572766174696F6E52657175657374121F0A0B637573746F6D65725F6964180120012809520A637573746F6D6572496422550A18506C6163655265736572766174696F6E526573706F6E736512390A0B7265736572766174696F6E18012001280B32172E6361725F72656E74616C2E5265736572766174696F6E520B7265736572766174696F6E222F0A134372656174655573657273526573706F6E736512180A076D65737361676518012001280952076D65737361676532F8040A124361725F52656E74616C5F5365727669636512400A076164645F63617212192E6361725F72656E74616C2E416464436172526571756573741A1A2E6361725F72656E74616C2E416464436172526573706F6E736512430A0C6372656174655F757365727312102E6361725F72656E74616C2E557365721A1F2E6361725F72656E74616C2E4372656174655573657273526573706F6E7365280112490A0A7570646174655F636172121C2E6361725F72656E74616C2E557064617465436172526571756573741A1D2E6361725F72656E74616C2E557064617465436172526573706F6E736512490A0A72656D6F76655F636172121C2E6361725F72656E74616C2E52656D6F7665436172526571756573741A1D2E6361725F72656E74616C2E52656D6F7665436172526573706F6E7365124E0A136C6973745F617661696C61626C655F6361727312242E6361725F72656E74616C2E4C697374417661696C61626C6543617273526571756573741A0F2E6361725F72656E74616C2E436172300112490A0A7365617263685F636172121C2E6361725F72656E74616C2E536561726368436172526571756573741A1D2E6361725F72656E74616C2E536561726368436172526573706F6E7365124A0A0B6164645F746F5F63617274121C2E6361725F72656E74616C2E416464546F43617274526571756573741A1D2E6361725F72656E74616C2E416464546F43617274526573706F6E7365125E0A11706C6163655F7265736572766174696F6E12232E6361725F72656E74616C2E506C6163655265736572766174696F6E526571756573741A242E6361725F72656E74616C2E506C6163655265736572766174696F6E526573706F6E7365620670726F746F33";

public isolated client class Car_Rental_ServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CAR_RENTAL_DESC);
    }

    isolated remote function add_car(AddCarRequest|ContextAddCarRequest req) returns AddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/add_car", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarResponse>result;
    }

    isolated remote function add_carContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/add_car", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarResponse>result, headers: respHeaders};
    }

    isolated remote function update_car(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/update_car", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarResponse>result;
    }

    isolated remote function update_carContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/update_car", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarResponse>result, headers: respHeaders};
    }

    isolated remote function remove_car(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/remove_car", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarResponse>result;
    }

    isolated remote function remove_carContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/remove_car", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarResponse>result, headers: respHeaders};
    }

    isolated remote function search_car(SearchCarRequest|ContextSearchCarRequest req) returns SearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/search_car", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchCarResponse>result;
    }

    isolated remote function search_carContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextSearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/search_car", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchCarResponse>result, headers: respHeaders};
    }

    isolated remote function add_to_cart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function add_to_cartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function place_reservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/place_reservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationResponse>result;
    }

    isolated remote function place_reservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.Car_Rental_Service/place_reservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationResponse>result, headers: respHeaders};
    }

    isolated remote function create_users() returns Create_usersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("car_rental.Car_Rental_Service/create_users");
        return new Create_usersStreamingClient(sClient);
    }

    isolated remote function list_available_cars(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.Car_Rental_Service/list_available_cars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function list_available_carsContext(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.Car_Rental_Service/list_available_cars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class Create_usersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class CarStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Car value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Car value;|} nextRecord = {value: <Car>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class Car_Rental_ServiceCarCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCar(Car response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCar(ContextCar response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServicePlaceReservationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPlaceReservationResponse(PlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPlaceReservationResponse(ContextPlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceUpdateCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUpdateCarResponse(UpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUpdateCarResponse(ContextUpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceRemoveCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveCarResponse(RemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveCarResponse(ContextRemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceSearchCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchCarResponse(SearchCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchCarResponse(ContextSearchCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceAddToCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddToCartResponse(AddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddToCartResponse(ContextAddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class Car_Rental_ServiceAddCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddCarResponse(AddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddCarResponse(ContextAddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextCarStream record {|
    stream<Car, error?> content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationResponse record {|
    PlaceReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarResponse record {|
    AddCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarResponse record {|
    UpdateCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsRequest record {|
    ListAvailableCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarResponse record {|
    RemoveCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarResponse record {|
    SearchCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type User record {|
    string id = "";
    string name = "";
    string role = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationResponse record {|
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarResponse record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarResponse record {|
    string status = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CartItem record {|
    string plate = "";
    string start_date = "";
    string end_date = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartRequest record {|
    string customer_id = "";
    CartItem item = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListAvailableCarsRequest record {|
    string filter = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarResponse record {|
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Reservation record {|
    string reservation_id = "";
    string customer_id = "";
    CartItem[] items = [];
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Car record {|
    string plate = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    int mileage = 0;
    string status = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationRequest record {|
    string customer_id = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarResponse record {|
    Car car = {};
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CreateUsersResponse record {|
    string message = "";
|};
