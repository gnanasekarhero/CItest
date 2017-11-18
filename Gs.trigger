/**********************************************************
* Trigger Name: ABPRelationshipSuiteBeforeUpdate
*
              
***********************************************************/

trigger ABPRelationshipSuiteBeforeUpdate on Customer_Relationship_Map__c(Before Insert,Before Update) {
Integer result;
Integer resultfinal;
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

ABPRelationshipMeterTotalScore.RelationshipMeter(Trigger.New);
system.debug('resultfinal:'+resultfinal);
}
