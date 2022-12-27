({
	doInit : function(component, event, helper) {
		    let action = component.get("c.getAllTasks");
        action.setParams({
            LCStage : component.get("v.LCStage"),
            recId : component.get("v.recordId"),
        })
        console.log('>>'+component.get("v.recordId"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.TaskList", response.getReturnValue());
                
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
       $A.enqueueAction(action);  
    
	},
    
    openTabWithSubtab : function(component, event, helper) {
        
         var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Case/'+component.get("v.recordId")+'/view',
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                url: '/lightning/r/Task/'+event.target.id+'/view',
                focus: true
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        
    }
    
 /*   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
        console.log('check>>'+event.target.id);
      component.set("v.clickedTask",event.target.id);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
    
    onSelectAction: function(component, event, helper) {

	console.log(event.getParam("value"));

        let action = component.get("c.delTasks");
        action.setParams({
            recId : event.getParam("value"),
        })
        console.log('>>'+component.get("v.recordId"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

				var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Record has been deleted Successfully",
                    "type":"success"
                });
                toastEvent.fire();

                window.location.reload();
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
       $A.enqueueAction(action);  
        
   },*/

})