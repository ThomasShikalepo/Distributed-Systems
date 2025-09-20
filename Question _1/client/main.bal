import ballerina/io;
import ballerina/http;

public type Task record {
    string service_;
};

public type WorkOrder record {
    string id;
    string description;
    string status;
    Task[] tasks;
};

public type Schedule record {
    string scheduleName;
    string dueDate;
};

public type Component record {
    string name;
    string serialNumber;
};

public type Asset record {
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    Component[] components;
    Schedule[] schedules;
    WorkOrder[] workOrders;
};



public function main() {
    io:println("Hello, World!");
}
public client class AssetDatabaseClient {
    // The underlying HTTP client.
    private final http:Client httpClient;

    // Constructor to initialize the client with the service's URL.
    function init(string url) returns error? {
        self.httpClient = check new (url);
    }

    // Corresponds to 'resource function get getAllAssets()'
    // Returns an array of 'Asset' records.
    remote function getAllAssets() returns Asset[]|error {
        return self.httpClient->get("/getAllAssets");
    }

    // Corresponds to 'resource function get getSpecificAsset(string assetTag)'
    // Returns an 'Asset' or '()' if not found.
    remote function getSpecificAsset(string assetTag) returns Asset|error|() {
        return self.httpClient->get(string `/getSpecificAsset?assetTag=${assetTag}`);
    }
    }