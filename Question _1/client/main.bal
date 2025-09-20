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
