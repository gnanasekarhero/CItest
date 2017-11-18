/**
* @author Kirankumar@@nothing.com
* @date 03/31/2017
* @description: Test Class This Class Deletes Case records in batch.
* $client$ [gsd]: gsd
//class Header Starts
//class Name:[GSDCSCdeleteBatch]
---------------------------------------------------------------------------------------------------------------------------------
//  DateTime[UTC]       |  Email_id                 |Stream     |   Release         |   Description
---------------------------------------------------------------------------------------------------------------------------------
//        05/15/2017    | ~:kirankumar@@nothing.com   |CSC        |   GSDR11-SFDC      |   This Class Delete case records in batch
//Class Header Ends
**/
/*
This Class DeleteCase records in batch
*/

@isTest
Public class GSDBPMdeleteBatchTest{
   
  static testmethod  void executetest(){
      insert new Global_Config__c(Mute_Triggers__c =True);
      Case cas = new Case(Subject='laptop issue',
                            Reason='ABP Support', 
                            Country__c='U.S. Minor Outlying Islands',Partner_ID__c='aGpq000000000ZzCAI',Service_Advisory_Applied__c=True);
        insert cas; 
    Database.insert(new GSD_BPM_Delete_Settings__c(name = 'case',Send_Email__c ='kirankumar@@nothing.com', SOQL_query__c='select id from case'),true);
       Test.starttest(); 
       String quer='case';
    GSDBPMdeleteBatch batchdelete = new GSDBPMdeleteBatch(quer);
     database.executebatch(batchdelete,100);
     
        Test.stoptest();


  }      
   static testmethod  void executetest1(){
       insert new Global_Config__c(Mute_Triggers__c =True);
      Case cas = new Case(Subject='laptop issue',
                            Reason='ABP Support', 
                            Country__c='U.S. Minor Outlying Islands',Partner_ID__c='aGpq000000000ZzCAI',Service_Advisory_Applied__c=True);
        insert cas; 
        delete cas;
    Database.insert(new GSD_BPM_Delete_Settings__c(name = 'case',Send_Email__c ='kirankumar@@nothing.com', SOQL_query__c='select CaseNumber from case where isdeleted = true ALL ROWS'),true);
       Test.starttest(); 
       String quer='case';
    GSDBPMdeleteBatch batchdelete = new GSDBPMdeleteBatch (quer);
     database.executebatch(batchdelete,100);
     
        Test.stoptest();
     }
     static testMethod void testschedule() {
     Test.starttest();
     GSDBPMDeleteBatchSchedulable sh1 = new GSDBPMDeleteBatchSchedulable ('case',100);
     String sch = '0 0 23 * * ?';
     system.schedule('Test Territory Check', sch, sh1); 
      Test.stoptest();
     }     
     static testMethod void testschedule1() {
     Test.starttest();
     GSDBPMDeleteBatchSchedulable sh1 = new GSDBPMDeleteBatchSchedulable ('case',-1);
     String sch = '0 0 23 * * ?';
     system.schedule('Test Territory Check', sch, sh1); 
      Test.stoptest();
     }     
 
}