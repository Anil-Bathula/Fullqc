@istest(SeeAllData=true)
public class TestClass_Helper 
{
	public static string get_Hult_API_Call_Values(string key)
    {
        return HULT_API_CALL__c.getInstance(key).value__c;
    }
}