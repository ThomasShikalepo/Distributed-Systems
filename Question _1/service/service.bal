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
  

  resource function post newAsset(@http:Payload Asset new_asset) returns Asset|http:Conflict{
      
      // Checking if asset already exists
      if MainDatabase.hasKey(new_asset.assetTag){
        return http:CONFLICT;
      }

      // Adding asset to database 
      MainDatabase[new_asset.assetTag] = new_asset;

      // Return the newly added asset
      return new_asset;
    }

    // Note on newAsset(): The line MainDatabase[new_asset.assetTag] = new_asset; 
    // uses the assetTag as the unique key. It's taking the assetTag value(which 
    // is just a small part of the new_asset record) and using it as the label or 
    // address for where the entire new_asset record will be stored in the MainDatabase.


    // The dot" . " as in new_asset.assetTag is used to access a field or property 
    // of a structured data type.

    resource function put updateAsset(@http:Payload Asset updatedAsset) returns Asset|http:Conflict{
      // If updatedAsset has a key that also exists in MainDatabase
      if MainDatabase.hasKey(updatedAsset.assetTag){
         MainDatabase[updatedAsset.assetTag] = updatedAsset;
         return updatedAsset;
      }else{
        return http:CONFLICT;
      }
 
  }
    //Start Here
// curl "http://localhost:8080/getAssetsByFaculty?faculty=Commerce%2C%20Human%20Sciences%20and%20Education"
// curl 'http://localhost:8080/getAssetsByFaculty?faculty=Computing%20and%20Informatics'

// Function definition: retrieves assets filtered by faculty
    resource function get getAssetsByFaculty(@http:Query string faculty) returns Asset[] {
    
// Initialize an empty array to store assets belonging to the given faculty
      Asset[] filteredAssets = [];
        foreach var [_, asset] in MainDatabase.entries() {
          if asset.faculty == faculty {
            filteredAssets.push(asset);
        }
    }
// Return the array of filtered assets
      return filteredAssets;
}

    resource function delete deleteAsset(string assetTag)  returns Asset|http:Conflict{
      if MainDatabase.hasKey(assetTag){
        Asset removedAsset = MainDatabase.remove(assetTag);
        return removedAsset;
      }else{
        return http:CONFLICT;
      }
    }

    resource function post addComponentToAsset(string assetTag, @http:Payload Component newComponent) returns Asset|http:Conflict|http:NotFound {
        if MainDatabase.hasKey(assetTag) {
            Asset existingAsset = <Asset> MainDatabase[assetTag];
            // Checking if the component already exists to avoid duplicates 
            
            foreach var component in existingAsset.components {
                if component.serialNumber == newComponent.serialNumber {
                    return http:CONFLICT; // Component with this serial number already exists
                }
            }
            // Add the new component to the existing array
            existingAsset.components.push(newComponent);
            return existingAsset;
        } else {
            return http:NOT_FOUND;
        }
    }
    resource function delete removeComponentFromAsset(string assetTag, string serialNumber) returns Asset|http:NotFound {
        // First, we check if the asset with the given assetTag exists in the database.
        if MainDatabase.hasKey(assetTag) {
            // Retrieve the asset record from the map. The <Asset> cast is safe
            // because the hasKey() check confirms the key exists.
            Asset existingAsset = <Asset> MainDatabase[assetTag];
            
            // Initialize a variable to hold the index of the component to remove.
            // A value of -1 indicates the component has not been found yet.
            int indexToRemove = -1;
            
            // Find the index of the component to remove by iterating through the components array.
            foreach int i in 0..<existingAsset.components.length() {
                // If the serialNumber of the current component matches the one provided,
                // we've found our target.
                if existingAsset.components[i].serialNumber == serialNumber {
                    // Store the index of the found component.
                    indexToRemove = i;
                    // Exit the loop immediately to save time.
                    break;
                }
            }
             // After the loop, check if a matching component was found.
            if indexToRemove != -1 {
                // If the component was found, remove it from the array at the stored index.
                Asset removed = <Asset> existingAsset.components.remove(indexToRemove);
                // Return the updated Asset record to the client.
                return removed;
            } else {
                // If the component was not found in the asset, return a Not Found error.
                return http:NOT_FOUND; // Component not found
            }
        } else {
            // If the asset itself was not found in the database, return a Not Found error.
            return http:NOT_FOUND; // Asset not found
        }
    }




  resource function post addScheduleToAsset(string assetTag, @http:Payload Schedule newSchedule) returns Asset|error {
    if MainDatabase.hasKey(assetTag) {
        Asset existingAsset = <Asset> MainDatabase[assetTag];

        foreach var schl in existingAsset.schedules {
            if schl.scheduleName == newSchedule.scheduleName && schl.dueDate == newSchedule.dueDate {
                return error("Schedule with same name and date already exists");
            }
        }

        existingAsset.schedules.push(newSchedule);
        return existingAsset;
    } else {
        return error("Asset not found with tag: " + assetTag);
    }
}

