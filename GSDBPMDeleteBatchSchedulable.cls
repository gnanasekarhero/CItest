/**
* @author Kirankumar@@nothing.com
* @date 03/31/2017
* @description: This Class Deletes Case records in batch.
* $client$ [gsd]: gsd
//class Header Starts
//class Name:[GSDBPMDeleteBatchSchedulable]
---------------------------------------------------------------------------------------------------------------------------------
//  DateTime[UTC]       |  Email_id                 |Stream     |   Release         |   Description
---------------------------------------------------------------------------------------------------------------------------------
//        05/15/2017    | ~:kirankumar@@nothing.com   |BPM  |   GSDR11-SFDC      |   This Class Delete case records in batch
//Class Header Ends
**/

global  class GSDBPMDeleteBatchSchedulable implements Schedulable{
    public Static String SOBJECT_TYPE ='Case';
    public Static String CLASS_NAME = 'GSDBPMDeleteBatchSchedulable';
    public Static String ORGANIZATION = 'GSD';
    public Static String CODE_TYPE = 'Apex Class';
    public Static String DOMAIN = 'CSC';        
    public string strObjectName{get;set;}
    public integer iBatchSize {get;set;}
    
    global GSDBPMDeleteBatchSchedulable (string strInputObjectName,integer iInputBatchSize){
        strObjectName = strInputObjectName;
        if(iInputBatchSize>0){
                iBatchSize=iInputBatchSize;
        }else{
          iInputBatchSize = 100;
        } 
    
    }
    global void execute(SchedulableContext SC){
     try{              
            GSDBPMdeleteBatch batch = new GSDBPMdeleteBatch(strObjectName);
            database.executebatch(batch,iBatchSize);
        }
        catch (Exception e) {
            MonitorUtility.insertHandledExceptions(e,null,SOBJECT_TYPE,CLASS_NAME,CODE_TYPE,ORGANIZATION,DOMAIN,System.Now()); 
        } 
    }
}