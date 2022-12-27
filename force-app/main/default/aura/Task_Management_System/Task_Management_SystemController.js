({
	doInit : function(component, event, helper) {
		console.log('@@'+component.get("v.LCStage"));
        let action = component.get("c.getStage");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LCStage", response.getReturnValue());
                component.set("v.AllStage", response.getReturnValue());
                console.log('###'+component.get("v.LCStage"));
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
        console.log('>>'+component.get("v.LCStage"));
	},
     
    onSelect : function(component, event, helper) {
            component.set("v.LCStage",event.getParam("value"));
            console.log('>>'+component.get("v.LCStage"));
    },
    
    
	
})