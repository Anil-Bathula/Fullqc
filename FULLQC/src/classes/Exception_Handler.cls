public with sharing class Exception_Handler { 
	
	public static Runtime_Errors__c Collect_exceptions(string name,string exc_type,string exc_message,string stacktrace) 
	{
		if(name==null && exc_type==null && exc_message==null && stacktrace==null)
			return null;
		if(exc_message==null )
			return null;	
		Runtime_Errors__c  err_info=new Runtime_Errors__c();
		err_info.Error_info__c=''+name;
		err_info.Error_Type__c=''+exc_type;
		err_info.Error_Description__c=''+exc_message;  
		err_info.Stack_Trace__c=''+stacktrace;
		return err_info;		  
	}
	
	public static void insert_exceptions(List<Runtime_Errors__c> lst_exc) 
	{
		Database.DMLOptions dlo = new Database.DMLOptions();
			dlo.allowFieldTruncation=true; 
		if(lst_exc!=null && !lst_exc.Isempty())		  
		{
			try
			{
				Database.insert(lst_exc,dlo);
			}
			catch(Exception e)
			{
				Runtime_Errors__c  err_info=new Runtime_Errors__c();
				err_info.Error_info__c='Error in inserting exceptions';
				err_info.Error_Type__c=e.getTypeName();
				err_info.Error_Description__c=e.getMessage();  
				err_info.Stack_Trace__c=e.getStackTraceString();
				try{
					Database.insert(err_info,dlo);
				}
				catch(Exception ex){system.debug(ex);}
			}
		}
	}
}