@RestResource(urlMapping='/ContactManager/v1/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static Id createNewContact(String FirstName, String LastName, String Phone, String Email) {
        
        // Retrieve list of Contacts based on Email
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email =: Email] ;
       
        // Condition if list is not empty i.e. email exists in SFDC
        Contact ctc = (contactList != null&&contactList.size()>0)?contactList[0]:null;
        if (ctc != null) {
           
            // Return the Contact Id
            return ctc.Id;
        }
        
        // Condition if list is empty i.e. email doesn't exist in SFDC
        else{
            
            // Creation of a new Contact
            Contact thisContact = new Contact(
                FirstName       = FirstName,
                LastName        = LastName,
                Phone           = Phone,
                Email           = Email);
            
            insert thisContact;
            
            // Return the Contact Id
            return thisContact.Id;
        }
    }
    
    @HttpPut
    global static Id updateContact(String FirstName, String LastName, String Phone, String Email){
        
        // Add the Contact Id as a parameter in the URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Retrieve the Contact based on the Id
        Contact result = [SELECT Id FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id;  
        thisContact.FirstName = FirstName;
        thisContact.LastName = LastName ;
        thisContact.Phone = Phone ;
        thisContact.Email = Email;
        
        // Update the fields on the Contact
        update thisContact;
        
        // Return the Contact Id
        return thisContact.Id;
    }
    
    @HttpDelete
    global static Id deactivateContact(){
        
        // Add the Contact Id as a parameter in the URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Retrieve value of Deactivated__c field based on the Id
        Contact result = [SELECT Deactivated__c FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id; 
        thisContact.Deactivated__c = true;  
        
        // Update field Deactivated__c to true on the Contact
        update thisContact;
        
        // Return the Contact Id
        return thisContact.Id;
    }
    
}