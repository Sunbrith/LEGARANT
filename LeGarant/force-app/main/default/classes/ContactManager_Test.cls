@isTest
private class ContactManagerTest {
    @isTest 
    static void testCreateNewContact() {
        
        // Call the method to test and add parameters
        Id thisContactId = ContactManager.createNewContact('Testy', 'Testerson', '+330123456789', 'testytesterson@gmail.com');
        
        // Retrieve Id & Email of the created Contact 
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id =:thisContactId];
       
        // Verify the Email is equal to the created Contact
        System.assertEquals(thisContact.Email, 'testytesterson@gmail.com');
    }
    
    @isTest static void testUpdateContact() {
        
        // Set up a test request
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/ContactManager/v1/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone":"+460123456789"}');
        RestContext.request = request;
        
        // Update all fields of existing record (only phone has changed)
        Id thisContactId = ContactManager.updateContact('Testy', 'Testerson','+460123456789' ,'testytesterson@gmail.com');
       
        // Retrieve Id & Phone of the updated Contact
        Contact thisContact = [SELECT Id, Phone FROM Contact WHERE Id=:thisContactId];
        
        // Verify the Phone is equal to the updated Contact
        System.assertEquals(thisContact.Phone, '+460123456789');    
    }
    
    @isTest static void testDeactivateContact() {
        
        // Set up a test request
        Id recordId = CreateTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI =  'https://my.salesforce.com/services/apexrest/ContactManager/v1/' + recordId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Deactivated__c" : "true"}');
        RestContext.request = request;
        
        // Call the method to test
        Id thisContactId = ContactManager.deactivateContact();
        
        // Retrieve Id & Deactivated__c fields of the updated Contact 
        Contact thisContact = [SELECT Id, Deactivated__c FROM Contact WHERE Id =:thisContactId];
       
        // Verify Deactivated__c value is updated to true
        System.assertEquals(thisContact.Deactivated__c, true);
    }    
    
    // Helper method
    static Id CreateTestRecord(){
        // Create test record for Contact
        Contact contactTest = new Contact(
            FirstName = 'Testy',
            LastName = 'Testerson',
            Phone = '+330123456789',
            Email = 'testytesterson@gmail.com'
        );
        insert contactTest;
        return contactTest.Id;
    }
    
}