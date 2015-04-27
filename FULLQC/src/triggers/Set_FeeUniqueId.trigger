/*
        Developer : Harsha Simha
        Date      : 11/9/2012
                    Created a Unique Field and inserting an encoded value captured from Fees_ProgramId and Fees_year. 
                    So that there will be only one Fee Record per year and per program.
                    (To eleminate Duplicate Fee record based on year and Program)
        Test class: Fees_Test
        code coverage: 100%
*/
trigger Set_FeeUniqueId on Fees__c (before insert, before update) 
{
    for(Fees__c fee:trigger.new)
    {       
        string feeuniq=blankValue(Fee.Program_Name__c)+':'+blankValue(Fee.Year__c);
        feeuniq=feeuniq.toUpperCase();
        Blob b=Crypto.generateDigest('MD5', Blob.valueOf(feeuniq));//.tostring();
        fee.Uniqueness_ID__c=EncodingUtil.convertToHex(b);       
    }
    public String blankValue(String value) {
        return value == null ? '' : value.trim();
    }   
}