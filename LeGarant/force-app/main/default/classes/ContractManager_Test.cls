@isTest
private class ContractManagerTest {
    @isTest 
    static void testCreateNewContract() {
        
        // Creation of a new Account
        Account account = new Account();
        account.Name ='TestAccount';
        insert account;
        
        // Call the method to test and add parameters
        Id thisContractId = ContractManager.createNewContract('TestContract','Draft',account.Id, Date.valueOf('2022-01-01'),12);
        
        // Retrieve Id & ContractTerm of the created Contract 
        Contract thisContract = [SELECT Id, ContractTerm FROM Contract WHERE Id =:thisContractId];
        
        // Verify the ContractTerm is equal to the created Contract
        System.assertEquals(thisContract.ContractTerm, 12);
    }
    
    @isTest 
    static void testUpdateContract(){
        
        // Set up a test request
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/ContractManager/v1/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status":"Activated"}');
        RestContext.request = request;
        
        // Retrieve fields On created Contract
        Contract ctc = [SELECT Name ,AccountId, StartDate, ContractTerm FROM Contract WHERE Id =: recordId];
        
        // Update all fields of existing record (only Status has changed)
        Id thisContractId = ContractManager.updateContract(ctc.Name, 'Activated', ctc.AccountId, ctc.StartDate , ctc.ContractTerm);
        
        // Retrieve Id & Status of the updated Contract
        Contract thisContract = [SELECT Id, Status FROM Contract WHERE Id=:thisContractId];
       
        // Verify the Status is equal to the updated Contract
        System.assertEquals(thisContract.Status, 'Activated'); 
    }
    
    // Helper method
    static Id CreateTestRecord(){
        // Create test record for Account
        Account accountTest = new Account();
        accountTest.Name ='TestAccount';
        insert accountTest;
        
        // Create test record for Contract
        Contract contractTest = new Contract(
            Name = 'TestContract',
            Status = 'Draft',
            AccountId = accountTest.Id,
            StartDate = Date.valueOf('2022-01-01'),
            ContractTerm = 12
        );
        insert contractTest;
        return contractTest.Id;
    }
}