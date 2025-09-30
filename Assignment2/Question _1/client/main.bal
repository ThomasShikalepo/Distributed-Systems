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

// Main function to demonstrate using the client.
public function main() returns error? {
    AssetDatabaseClient AssetDatabaseClient  = check new ("http://localhost:8080");

    // // Example 1: Get all assets
    // io:println("Fetching all assets...");
    // Asset[] allAssets = check AssetDatabaseClient -> getAllAssets();
    // io:println(allAssets);

    // Example 2: Get a specific asset
    string assetTag = "OQ-001";
    io:println(string `Fetching asset with tag '${assetTag}'...`);
    Asset? specificAsset = check AssetDatabaseClient -> getSpecificAsset(assetTag);
    io:println(specificAsset);

    // // Example 3: Add a new asset
    // Asset newAsset = {
    //     assetTag: "PR-004",
    //     name: "Laptop",
    //     faculty: "Business",
    //     department: "Sales",
    //     status: "ACTIVE",
    //     acquiredDate: "2025-01-20",
    //     components: [],
    //     schedules: [],
    //     workOrders: []
    // };
    // io:println();
    // io:println("Adding a new asset...");
    // Asset createdAsset = check AssetDatabaseClient ->newAsset(newAsset);
    // io:println("Created asset: " + createdAsset.assetTag);

    // // Example 4: Add a component to an existing asset
    // string componentAssetTag = "PR-004";
    // Component newComponent = {
    //     name: "SSD",
    //     serialNumber: "SSD-12345"
    // };
    // io:println();
    // io:println(string `Adding component to asset '${componentAssetTag}'...`);
    // Asset updatedAsset = check AssetDatabaseClient -> addComponentToAsset(componentAssetTag, newComponent);
    // io:println("Updated Asset with new component: ", updatedAsset.components);

    // // Example 5: Delete an asset
    // string tagToDelete = "PR-004";
    // io:println();
    // io:println(string `Deleting asset with tag '${tagToDelete}'...`);
    // Asset deletedAsset = check AssetDatabaseClient ->deleteAsset(tagToDelete);
    // io:println(string `Deleted asset: '${deletedAsset.assetTag}'`);

    // Example 6: Get assets by faculty
    io:println();
    io:println("Fetching assets by faculty 'Computing and Informatics'...");
    Asset[] facultyAssets = check AssetDatabaseClient -> getAssetsByFaculty("Computing and Informatics");
    io:println(facultyAssets);

    // Example 7: Remove a component from an asset
    // string assetTagForComponentRemoval = "OQ-001";
    // string serialNumberToRemove = "##3004A77";
    // io:println();
    // io:println(string `Removing component '${serialNumberToRemove}' from asset '${assetTagForComponentRemoval}'...`);
    // Asset removedComponentAsset = check AssetDatabaseClient -> removeComponentFromAsset(assetTagForComponentRemoval, serialNumberToRemove);
    // io:println("Asset after component removal: " ,removedComponentAsset.components);

    // // Example 8: Update an existing asset
    // string assetTagToUpdate = "VA-002";
    // Asset updatedAssetRecord = {
    //     assetTag: "VA-002",
    //     name: "Toyota Hilux",
    //     faculty: "Commerce, Human Sciences and Education",
    //     department: "Transport",
    //     status: "ACTIVE", // Changing status
    //     acquiredDate: "2024-04-12",
    //     components: [],
    //     schedules: [],
    //     workOrders: []
    // };
    // io:println(string `Updating asset '${assetTagToUpdate}' status to 'ACTIVE'...`);
    // io:println();
    // Asset updateResult = check AssetDatabaseClient -> updateAsset(updatedAssetRecord);
    // io:println("Updated asset: ", updateResult);
    
    // // Example 9: Add a schedule to an asset
    // string assetTagForSchedule = "OQ-001";
    // Schedule newSchedule = {
    //     scheduleName: "Laser Review",
    //     dueDate: "2025-01-01"
    //      };
    // io:println(string `Adding schedule '${newSchedule.scheduleName}' to asset '${assetTagForSchedule}'...`);
    // io:println();
    // Asset scheduleAddedAsset = check AssetDatabaseClient -> addScheduleToAsset(assetTagForSchedule, newSchedule);
    // io:println("Asset after adding schedule: ", scheduleAddedAsset.schedules);

    // Example 10: Remove a schedule from an asset
    // string scheduleNameToRemove = "Laser Review";
    // string dueDateToRemove = "2025-01-01"; // Add the due date
    // io:println();
    // io:println(string `Removing schedule '${scheduleNameToRemove}' from asset '${assetTagForSchedule}'...`);
    // Schedule removedSchedule = check AssetDatabaseClient -> removeScheduleFromAsset(assetTagForSchedule, scheduleNameToRemove, dueDateToRemove);
    // io:println("Removed schedule: ", removedSchedule);


    // // Example 11: Open a new work order
    // string assetTagForWorkOrder = "OE-003";
    // WorkOrder newWorkOrder = {
    //     id: "WO-101",
    //     description: "Engine malfunction",
    //     status: "", // Status is set by the service
    //     tasks: []
    // };
    // io:println();
    // io:println(string `Opening new work order '${newWorkOrder.id}' for asset '${assetTagForWorkOrder}'...`);
    // Asset assetWithNewWorkOrder = check AssetDatabaseClient -> openNewWorkOrder(assetTagForWorkOrder, newWorkOrder);
    // io:println("Asset status after opening work order: " + assetWithNewWorkOrder.status);
    // io:println("Asset work orders: ", assetWithNewWorkOrder.workOrders);

    // Example 12: Add a task to a work order
    // string workOrderIdForTask = "WO-101";
    // Task newTask = {service_: "Diagnose engine"};
    // io:println();
    // io:println(string `Adding task to work order '${workOrderIdForTask}' for asset '${assetTagForWorkOrder}'...`);
    // Asset taskAddedAsset = check AssetDatabaseClient -> addTaskToWorkOrder(assetTagForWorkOrder, workOrderIdForTask, newTask);
    // io:println("Work order tasks: ", taskAddedAsset.workOrders[0].tasks);

    // // Example 13: Update work order status
    // string newStatus = "IN_PROGRESS";
    // io:println();
    // io:println(string `\Updating work order '${workOrderIdForTask}' status to '${newStatus}'...`);
    // Asset statusUpdatedAsset = check AssetDatabaseClient -> updateWorkOrderStatus(assetTagForWorkOrder, workOrderIdForTask, newStatus);
    // io:println("Updated work order status: ", statusUpdatedAsset.workOrders[0].status);

    // Example 14: Remove a task from a work order
    // string serviceToRemove = "Diagnose engine";
    // io:println();
    // io:println(string `Removing task '${serviceToRemove}' from work order '${workOrderIdForTask}'...`);
    // Task removedTask = check AssetDatabaseClient -> removeTaskFromWorkOrder(assetTagForWorkOrder, workOrderIdForTask, serviceToRemove);
    // io:println("Removed task: ", removedTask);

    // // Example 15: Close a work order
    // io:println();
    // io:println(string `Closing work order '${workOrderIdForTask}' for asset '${assetTagForWorkOrder}'...`);
    // Asset closedWorkOrderAsset = check AssetDatabaseClient -> closeWorkOrder(assetTagForWorkOrder, workOrderIdForTask);
    // io:println("Asset status after closing work order: ", closedWorkOrderAsset.status);
    // io:println("Closed work order status: ", closedWorkOrderAsset.workOrders[0].status);

    // Example 16: Retrieve all overdue assets
    io:println();
    io:println("Fetching all overdue assets...");
    Asset[]|error overdueAssetsResult = AssetDatabaseClient -> getOverdueAssets();
    
    if overdueAssetsResult is error {
        // The service returns an error if no overdue assets are found.
        io:println("Error: " + overdueAssetsResult.message());
    } else {
        // If successful, the result is an array of Asset records.
        io:println("Overdue assets found: ", overdueAssetsResult);
    }


    // // Example 2: Get a specific asset
    // string assetTag = "OQ-001";
    // io:println(string `Fetching asset with tag '${assetTag}'...`);
    // Asset? specificAsset = check AssetDatabaseClient -> getSpecificAsset(assetTag);
    // io:println(specificAsset);

    // Example 1: Get all assets
    io:println();
    io:println("Fetching all assets...");
    Asset[] allAssets = check AssetDatabaseClient -> getAllAssets();
    io:println(allAssets);

}
