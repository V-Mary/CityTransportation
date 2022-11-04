({
    getRoutes : function(component, event, helper) {
        var action = component.get("c.getBusRoutes");

        action.setCallback(this, function(response){
            component.set("v.routes", response.getReturnValue());

        });

        $A.enqueueAction(action);
    },

    setColumns : function(component){
        component.set('v.columns', [
                {label: 'Bus Route Name', fieldName:'Name', type: 'text'},
                {label: 'Route Number', fieldName:'Route_Number__c', type: 'text'},
                {label: 'Start Time', fieldName:'Start_Time__c', type: 'time'},
                {label: 'End Time', fieldName:'End_Time__c', type: 'time'},
                {label: 'Duration In Minutes', fieldName:'Duration_In_Minutes__c', type: 'integer'},
                {label: 'Total Stops', fieldName:'Total_Stops__c', type: 'integer'}
            ]);
    }

})