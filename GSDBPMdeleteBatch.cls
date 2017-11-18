/**
* @author Kirankumar@@nothing.com
* @date 03/31/2017
* @description: This Class Deletes Case records in batch.
* $client$ [gsd]: gsd
//class Header Starts
//class Name:[GSDBPMdeleteBatch]
---------------------------------------------------------------------------------------------------------------------------------
//  DateTime[UTC]       |  Email_id                 |Stream     |   Release         |   Description
---------------------------------------------------------------------------------------------------------------------------------
//        05/15/2017    | ~:kirankumar@@nothing.com   |BPM      |   GSDR10.2-SFDC      |   This Class Delete case records in batch
//Class Header Ends
**/
/*
This Class DeleteCase records in batch
*/
public class GSDBPMdeleteBatch implements Database.Batchable<SObject>, Database.Stateful
{
    public  String SOBJECT_TYPE {get;set;}
    public Static String CLASS_NAME = 'GSDBPMdeleteBatch';
    public Static String ORGANIZATION = 'GSD';
    public Static String CODE_TYPE = 'Apex Class';
    public Static String DOMAIN = 'CSC';    
    public string strQuery {get;set;} 
    Public Integer count =0;
    public List<Id> lstDeletedRecordIds = new list<id>();
    GSD_BPM_Delete_Settings__c ObjBPMSetting;
    
    public GSDBPMdeleteBatch (string strObjectName)
    {
        SOBJECT_TYPE = strObjectName;
        ObjBPMSetting = GSD_BPM_Delete_Settings__c.getValues(strObjectName);
        strQuery = ObjBPMSetting.SOQL_query__c;
    }
    
    public Database.QueryLocator Start(Database.BatchableContext context)
    {   
        system.debug('strQuery: '+strQuery );
        return Database.getQueryLocator(strQuery);
    }
    
    public void Execute(Database.BatchableContext context, List<Sobject> lstRecordsToBeDeleted)
    {
        Try{
            count=count+lstRecordsToBeDeleted.size();
            for(Sobject Obj:lstRecordsToBeDeleted)
                lstDeletedRecordIds.add(Obj.Id);
            delete lstRecordsToBeDeleted;            
        }
        Catch (Exception e){
           System.debug('>>> exception'+e);
            MonitorUtility.insertHandledExceptions(e,null,SOBJECT_TYPE,CLASS_NAME,CODE_TYPE,ORGANIZATION,DOMAIN,System.Now());             
        }
    }
    
    public void Finish(Database.BatchableContext context)
    {
        // send email to 
        string email = ObjBPMSetting.Send_Email__c;
        string strEmailBody;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {email};
            mail.setToAddresses(toAddresses);
        
        mail.setSubject('GSD BPM Delete Processed and Deleted Records');   
        strEmailBody = '<html><p>';
        strEmailBody =  strEmailBody + '\n' + 'Total no of records Deleted '+count+', Date and Time '+System.now();
        strEmailBody =strEmailBody +  '</p>';
        if(lstDeletedRecordIds!=null && lstDeletedRecordIds.size()>0)
            strEmailBody = strEmailBody + '\n' + JSON.serialize(lstDeletedRecordIds);
        strEmailBody =strEmailBody +  '</html>';
        mail.setHTMLBody(strEmailBody);
         Messaging.SendEmailResult[] results= Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        }
        else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);
        }
    }
    
}