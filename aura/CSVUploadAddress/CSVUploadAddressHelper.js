({
    createCSVObject : function(cmp, csv) {
        var action = cmp.get('c.getCSVObject');
        action.setParams({
            csv_str : csv
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
	    if(state == "SUCCESS") {
		cmp.set("v.csvObject", response.getReturnValue());
	    }
        });
        $A.enqueueAction(action);
    },
     save : function(cmp, cshdr,cslines) {
        var action6 = cmp.get('c.saveAdd');
          
         action6.setParams({
            columntype : cshdr,
            lines : cslines
        });
          
        action6.setCallback(this, function(response) {
            var state = response.getState();
	    if(state == "SUCCESS") {
		//cmp.set("v.csvObject", response.getReturnValue());
		alert('Saved Successfully!');
        }else{
            alert(response.getReturnValue());
            
        }
        });
        $A.enqueueAction(action6);
    },
    
    getFieldNames : function(component,selectedObjecthelper){//------------------------------------------------------
    console.log('selectedObjecthelper '+selectedObjecthelper);
	if(selectedObjecthelper=='None')return;
    //calls InventionResearcherController.getInventionContacts
    var action4 = component.get('c.getFieldNames');
    action4.setParams({
            objectName : selectedObjecthelper
            
        });
    // Set up the callback
    action4.setCallback(this, $A.getCallback(function (response) {
        var state = response.getState();
        var resultsToast = $A.get("e.force:showToast");
        if(state === "SUCCESS"){
            //if successful stores query results in ipRecordTypes
            var recordTypes = response.getReturnValue();
            console.log('getRecordTypes returned: ' +recordTypes);                

            component.set('v.fieldNames', response.getReturnValue());
        } else if (state === "ERROR") {
            //otherwise write errors to console for debugging
            alert('Problem with connection. Please try again. Error Code: relIPViewHelper.getIPList.action.setCallback');
            resultsToast.setParams({
                "title": "Error",
                "message": "Invention contacts failed to load due to: " + JSON.stringify(result.error)
            });
            resultsToast.fire();
            var errors = response.getError();
            console.error(errors);
        }
    }));
    $A.enqueueAction(action4);
    },
    getObjectNames : function(component){//------------------------------------------------------
    console.log('getFieldNames helper starting...');

    //calls InventionResearcherController.getInventionContacts
    var action7 = component.get('c.getObjectNames');

    // Set up the callback
    action7.setCallback(this, $A.getCallback(function (response) {
        var state = response.getState();
        var resultsToast = $A.get("e.force:showToast");
        if(state === "SUCCESS"){
            //if successful stores query results in ipRecordTypes
            var recordTypes = response.getReturnValue();
			component.set('v.objectNames', response.getReturnValue());
        } else if (state === "ERROR") {
            //otherwise write errors to console for debugging
            alert('Problem with connection. Please try again. Error Code: relIPViewHelper.getIPList.action.setCallback');
            resultsToast.setParams({
                "title": "Error",
                "message": "Invention contacts failed to load due to: " + JSON.stringify(result.error)
            });
            resultsToast.fire();
            var errors = response.getError();
            console.error(errors);
        }
    }));
    $A.enqueueAction(action7);
    },
})