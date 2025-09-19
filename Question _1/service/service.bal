import ballerina/http;


// Task record represents a small, 
// specific job that's part of a WorkOrder
type Task record{
  string service_;
};


// Describes faulty assets, theproblem they 
// have, and their resolution
type WorkOrder record{
  string id;
  string description;
  string status;
  Task[] tasks;
};


// Schedule record represents a regular servicing plan
type Schedule record{
  string scheduleName;
//string admissionDate;  // YYYY-MM-DD
  string dueDate;  // YYYY-MM-DD
};


// Component record should represent a part 
// of an asset, like a hard drive in a 
// server or a motor in a printer.
type Component record{
  string name;
  string serialNumber;
};

type Asset record{
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

  // "Component[] components" actually means:
  // components is an array that can hold multiple Component records;
  // Each element in the array must be a complete Component record (not individual strings);
  // Each Component record contains 2 string fields: "name" and "serialNumber"


  // Note:"map<Asset> MainDatabase" is a Map that can hold multiple "Asset" records.

  // We create the MainDatabase as a Map data structure
  // where keys are assetTags and values are Asset records
  map<Asset> MainDatabase = {
    "OQ-001":{
      assetTag: "OQ-001",
      name: "printer",
      faculty: "Computing and Informatics",
      department: "Cyber Security",                 
      status: "ACTIVE",
      acquiredDate: "2024-09-05",
      
      components: [

        {
        name: "Cartridge",
        serialNumber: "##3004A77"
        },

        {
          name: "Sheet Feeder",
          serialNumber: "##788DD33"
        }
      ],
      schedules: [
        {
          scheduleName: "Routine Maintenance Check",
          dueDate: "2024-09-06"
        }
      ],
      workOrders: []
    }
    ,
    "VA-002":{
      assetTag: "VA-002",
      name: "Toyota Hylux",
      faculty: "Commerce, Human Sciences and Education",
      department: "Transport",
      status: "INACTIVE",
      acquiredDate:"2024-04-12",
      components: [],
      schedules: [],
      workOrders: []
    },

    "OE-003":{
      assetTag: "OE-003",
      name: "Bus",
      faculty: "Commerce, Human Sciences and Education",
      department: "Transport",
      status: "INACTIVE",
      acquiredDate:"2024-06-12",
      components: [],
      schedules: [],
      workOrders: []
    }


    
  };

  service / on new http:Listener(8080){
    resource function get getAllAssets() returns Asset[]{
      return MainDatabase.toArray();
    };

    resource function get getSpecificAsset(string assetTag) returns Asset?{
      // Checking if the asset exists using the assetTag passed in the URL
      if MainDatabase.hasKey(assetTag){
        return MainDatabase[assetTag];
      }
      else{
        // If the key is not found it returns null/nothing
        return ;
      }
    }

    resource function put updateWorkOrderStatus(string assetTag, string workOrderId, @http:Query string newStatus) returns Asset|http:NotFound {
        // Find the asset.
        if MainDatabase.hasKey(assetTag) {
            Asset existingAsset = <Asset> MainDatabase[assetTag];
            
            // Find the specific work order to update.
            foreach var workOrder in existingAsset.workOrders {
                if workOrder.id == workOrderId {
                    // Update the status of the work order.
                    workOrder.status = newStatus;
                    return existingAsset;
                }
            }
            // Work order not found.
            return http:NOT_FOUND;
        } else {
            // Asset not found.
            return http:NOT_FOUND;
        }
    }
  }
