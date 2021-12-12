@isTest
private class AccountManagerTest {
    @isTest 
    static void testCreateNewAccount() {
        
        // Call the method to test and add a parameter 
        ID thisAccountId = AccountManager.createNewAccount('TestAccountREST');
        
        // Retrieve the name of the created Account 
        Account thisAccount = [SELECT Name FROM Account WHERE Id =:thisAccountId];
        
        // Verify the Name is equal to the created Account
        System.assertEquals(thisAccount.Name, 'TestAccountREST');
    }
    
    @isTest static void testUpdateAccount() {
        
        // Set up a test request
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/AccountManager/v1/' + recordId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name":"TestAccountRESTupdt"}');
        RestContext.request = request;
        
        // Update Name of existing record to 'TestAccountRESTupdt'
        Id thisAccountId = AccountManager.updateAccount('TestAccountRESTupdt');
        
        // Retrieve Name & Id of the updated Account
        Account thisAccount = [SELECT Id,Name FROM Account WHERE Id=:thisAccountId];
        
        // Verify the Name is equal to the updated Account
        System.assertEquals(thisAccount.Name, 'TestAccountRESTupdt');
    }
    
    // Helper method
    static Id CreateTestRecord(){
        
        // Create test record for Account
        Account accountTest = new Account(Name = 'TestRecordForAccountREST');
        insert accountTest;
        return accountTest.Id;
    }
    
}