import ballerina/http;
import ballerina/io;

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

    remote function newAsset(Asset newAsset) returns Asset|error {
        return self.httpClient->post("/newAsset", newAsset);
    }

    // Corresponds to 'resource function put updateAsset(@http:Payload Asset updatedAsset)'
    // Updates an existing asset.
    remote function updateAsset(Asset updatedAsset) returns Asset|error {
        return self.httpClient->put("/updateAsset", updatedAsset);
    }

    // Corresponds to 'resource function get getAssetsByFaculty(@http:Query string faculty)'
    remote function getAssetsByFaculty(string faculty) returns Asset[]|error {
        return self.httpClient->get(string `/getAssetsByFaculty?faculty=${faculty}`);
    }

    // Corresponds to 'resource function delete deleteAsset(string assetTag)'
    remote function deleteAsset(string assetTag) returns Asset|error {
        return self.httpClient->delete(string `/deleteAsset?assetTag=${assetTag}`);
    }

    // Corresponds to 'resource function post addComponentToAsset(string assetTag, @http:Payload Component newComponent)'
    remote function addComponentToAsset(string assetTag, Component newComponent) returns Asset|error {
        return self.httpClient->post(string `/addComponentToAsset?assetTag=${assetTag}`, newComponent);
    }

    // Corresponds to 'resource function delete removeComponentFromAsset(string assetTag, string serialNumber)'
    remote function removeComponentFromAsset(string assetTag, string serialNumber) returns Asset|error {
        return self.httpClient->delete(string `/removeComponentFromAsset?assetTag=${assetTag}&serialNumber=${serialNumber}`);
    }

    remote function addScheduleToAsset(string assetTag, Schedule newSchedule) returns Asset|error {
        return self.httpClient->post(string `/addScheduleToAsset?assetTag=${assetTag}`, newSchedule);
    }

    remote function removeScheduleFromAsset(string assetTag, string scheduleName, string dueDate) returns Schedule|error {
        return self.httpClient->delete(string `/removeScheduleFromAsset?assetTag=${assetTag}&scheduleName=${scheduleName}&dueDate=${dueDate}`);
    }

    remote function addTaskToWorkOrder(string assetTag, string workOrderId, Task newTask) returns Asset|error {
        return self.httpClient->post(string `/addTaskToWorkOrder?assetTag=${assetTag}&workOrderId=${workOrderId}`, newTask);
    }

    remote function removeTaskFromWorkOrder(string assetTag, string workOrderId, string service_) returns Task|error {
        return self.httpClient->delete(string `/removeTaskFromWorkOrder?assetTag=${assetTag}&workOrderId=${workOrderId}&service_=${service_}`);
    }

    remote function openNewWorkOrder(string assetTag, WorkOrder newWorkOrder) returns Asset|error {
        return self.httpClient->post(string `/openNewWorkOrder?assetTag=${assetTag}`, newWorkOrder);
    }

    remote function updateWorkOrderStatus(string assetTag, string workOrderId, string newStatus) returns Asset|error {
        return self.httpClient->put(string `/updateWorkOrderStatus?assetTag=${assetTag}&workOrderId=${workOrderId}&newStatus=${newStatus}`, ());
    }

    remote function closeWorkOrder(string assetTag, string workOrderId) returns Asset|error {
        return self.httpClient->put(string `/closeWorkOrder?assetTag=${assetTag}&workOrderId=${workOrderId}`, ());
    }

    // Corresponds to 'resource function get getOverdueAssets()'
    remote function getOverdueAssets() returns Asset[]|error {
        return self.httpClient->get("/overdueAssets");

    }

}

public function main() {
    io:println("Hello, World!");
}
