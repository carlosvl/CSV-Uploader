({
    doInit: function(component,event, helper) {
        // Set the attribute value. 
        // You could also fire an event here instead.

        helper.getObjectNames(component);

    },
    handleUploadFinished : function(component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {
            console.log("UPLOADED")
            var reader = new FileReader();
            reader.readAsText(file, 'UTF-8');
            reader.onload = function(evt) {
                var csv = evt.target.result;
                component.set("v.csvString", csv);
            }
             
        }
    },

    handleGetCSV : function(component, event, helper) {
        var csv = component.get("v.csvString");
        if(csv != null) {
            helper.createCSVObject(component, csv);
            //helper.getFieldNames(component);
             
        }
    },
    getFields: function(component, event, helper) {
        var selectedObject = component.get("v.selectedObject");

        if(selectedObject != null) {
            
            helper.getFieldNames(component,selectedObject);

        }
    },

    saveData : function(component, event, helper) {

        var csvobj=component.get("v.csvObject");
        var picklistvalues=component.find("fieldType") ; 
        var selectedObject=component.get("v.selectedObject") ; 

        var columntp=[]; 	 
        for (var i=0;i<csvobj.headers.length;i++) {
             csvobj.headers[i].column_type=picklistvalues[i].get("v.value");
        	 columntp.push( csvobj.headers[i].column_type);
        }
        var linesCSv=component.get("v.csvObject.lines");

        helper.save(selectedObject,component,columntp,linesCSv);

        //component.set("v.csvString", null);
        //component.set("v.csvObject", null);
    },
    cleanData : function(component, event, helper) {
		component.set("v.csvString", null);
        component.set("v.csvObject", null);
        component.set("v.selectedObject", 'None');
        
    },
    
    showRecType : function(component, event, helper) {
        console.log('The selected Record Type is: ' +component.get("v.selRecType"));
    	
    }
    

    
})