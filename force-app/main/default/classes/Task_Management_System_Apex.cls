public class Task_Management_System_Apex {

    @AuraEnabled
    public static List<String> getStage(){
        List<String> stg = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Phase__c.getDescribe();
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            stg.add(p.getValue());
        }
        system.debug('>>>'+stg);
        return stg;
    }
    
    @AuraEnabled
    public static List<Task> getAllTasks(string LCStage, string recId) {
        system.debug('getAllTasks');
        List<Task> taskList = [SELECT Id, Subject, ActivityDate, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName , Status, Priority, Description, Predecessor__c, Duration__c, Phase__c, Sub_Phase__c, Status_Formula__c, Start__c, End_Date__c FROM Task WHERE Phase__c =: LCStage AND WhatId=: recId AND Phase__c != '' ORDER BY Sub_Phase__c ASC];
        system.debug('>>>'+taskList);
        return taskList;
        
    }
    
    @AuraEnabled
    public static void delTasks(string recId) {
        system.debug('delTasks');
        Task delTask = [SELECT Id, Subject FROM TASK WHERE Id =: recId];
        delete delTask;
        
    }
    
    @AuraEnabled
    public static wrapperClass taskDetails(string recId) {
        system.debug('taskDetails');
        wrapperClass wrap = new wrapperClass();
        
        Task taskList = [SELECT Id, WhoId, WhatId, Owner.Name, Owner.FirstName, createddate, Owner.LastName, Subject, ActivityDate, Status, Priority, Description, Type, Phase__c FROM Task WHERE Id=: recId];
        system.debug('>>>'+taskList);
        
        wrap.PhaseName = taskList.Phase__c;
        wrap.TaskName = taskList.Subject;
        wrap.Description = taskList.Description;
        wrap.ActivityDate = taskList.ActivityDate;
        wrap.Status = taskList.Status;
        wrap.Assignee = taskList.Owner.Name;
        
        DateTime dt = taskList.createddate;
        Date sd = date.newinstance(dt.year(), dt.month(), dt.day());
        wrap.StartDate = sd;
        
        Case cs = [SELECT Id, CaseNumber FROM Case WHERE Id =: taskList.WhatId];
        wrap.ParentId = cs.Id;
        wrap.ParentName = cs.CaseNumber;
                
        String returnString = '' ;
        returnString = taskList.Owner.FirstName.toUpperCase().substring(0,1) + ' '+ taskList.Owner.LastName.toUpperCase().substring(0,1);
        wrap.Initials = returnString;
        
      /*  List<String> InitList = new List<String>();
		String s = '';
        for (OpportunityTeamMember oppTeam : [SELECT Id, User.FirstName, User.LastName FROM OpportunityTeamMember WHERE OpportunityId =: taskList.WhatId])
        {
            s = oppTeam.User.FirstName.toUpperCase().substring(0,1) + ' '+ oppTeam.User.LastName.toUpperCase().substring(0,1);
            InitList.add(s);
        }
        system.debug('+++'+InitList);
        InitList.add(returnString);
        wrap.InitialList = InitList;*/
        
        return wrap;
        
    }
    
    public class wrapperClass {
        @AuraEnabled
        public String ParentId {get;set;}
        @AuraEnabled
        public String ParentName {get;set;}
        @AuraEnabled
        public String PhaseName {get;set;}
        @AuraEnabled
        public String TaskName {get;set;}
        @AuraEnabled
        public String Description {get;set;}
        @AuraEnabled
        public String Status {get;set;}
        @AuraEnabled
        public Date ActivityDate {get;set;}
        @AuraEnabled
        public Date StartDate {get;set;}
        @AuraEnabled
        public String Assignee {get;set;}
        @AuraEnabled
        public String Initials {get;set;}
        @AuraEnabled
        public List<String> InitialList {get;set;}
    }
}