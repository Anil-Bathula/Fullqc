/*
      Developer : Harsha Simha
        Date    : 11/09/2012                  
                   This trigger will set the new Fee value for the finance based on the Start term and Programid (both - Crossobject_formulas)    
      Test class: mapping_Finwithfee_test
      coverage  : 85%         
      Modified  :Anil.B for jira 702 added if condition written a method to populate values in annual_accomidation_fee__c with values from fee object.
      Modified : 20/3/2014  prem :: connects BBA Finanace Record type fields with Fee by calling the mapping_Finwithfeevalues class for field mapping.
      Modified :Prem : SFSUP-772
*/
trigger add_fee2finance on Opportunity_Finance__c (before insert, before update) 
{
    list<string> finids=new list<string>();
    set<string> setsterms=new set<string>();
    set<string> setpgms=new set<string>();
    map<opportunity_finance__c,id> opfin_ids=new map<opportunity_finance__c,id>();
    String bba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');
    String nonbba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance');
    Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Fees__c').getDescribe().fields.getMap();
    Map<String,string> feelables=new Map<String,string>();
    
    for(Opportunity_Finance__c fin:Trigger.new)
    {
        //SHS :: set Finance record type to 'BBA Finance' if the Program__c value starts with 'Bachelor' else 'non-BBA Finance'
       /* if(trigger.isinsert && trigger.isbefore)
        {            
             if(fin.OP_Program__c!=null && fin.OP_Program__c.startsWith('Bachelor')){
                 fin.recordtypeid=bba_rectype;
             }else{
                 fin.recordtypeid=nonbba_rectype;
             }            
        }*/
        system.debug(fin.Id+'======================='+fin.OP_Program__c+'========'+fin.Start_Term__c+'========='+fin.OP_Programid__c);
        /*For each triggered finance record checks startterm,Programid should not be null and Fees should be null and extracts last 4 digits of start term*/
        if(fin.fees__c==null && fin.Start_Term__c!=null && fin.OP_Programid__c!=null)
        {
            string sterm=fin.Start_Term__c;
            sterm=sterm.trim();
            sterm=sterm.contains(' ')?sterm.replace(' ',''):sterm;
            if(sterm!=null && sterm!='' && sterm.length()>=4 && (fin.OP_Programid__c.length()>=15))
            {
                sterm=sterm.substring(sterm.length()-4,sterm.length());
                setsterms.add(sterm);
                setpgms.add(fin.OP_Programid__c);
            }
              
        }
        //on changing the finance Record Type from Non-BIBA Finance to BBA Finance then below fields are inherting
        if(Trigger.isUpdate){
            Opportunity_Finance__c oldfin=trigger.Isinsert?new Opportunity_Finance__c():Trigger.oldmap.get(fin.id);
            if(oldfin.RecordTypeId==nonbba_rectype && fin.RecordTypeId==bba_rectype && fin.OP_Program__c.startsWith('Bachelor')){
                if(fin.Installment_Plan__c!=null)
                    fin.BBA_Installment_Plan_Picklist__c=fin.Installment_Plan__c;
                if(fin.Insurance__c!=null){
                    if(fin.OP_Program__c.contains('London')){
                        if(fin.Insurance__c=='Single')
                            fin.BBA_Insurance_Picklist_Year_1__c='Erika Insurance';
                        else if(fin.Insurance__c=='Waived')
                            fin.BBA_Insurance_Picklist_Year_1__c='Waived';
                    }
                    else if(fin.OP_Program__c.contains('San Francisco')){
                        if(fin.Insurance__c=='Single')
                            fin.BBA_Insurance_Picklist_Year_1__c='Aetna Insurance';
                        else if(fin.Insurance__c=='Waived')
                            fin.BBA_Insurance_Picklist_Year_1__c='Aetna Insurance';
                    }
                }
                if(fin.Financial_Aid_Category__c!=null)
                    fin.BBA_Merit_Based_Scholarship_Picklist__c=fin.Financial_Aid_Category__c;
                if(fin.Housing_Accommodation__c!=null)
                    fin.BBA_Accommodation_Year_1__c=fin.Housing_Accommodation__c;
                if(fin.Accommodation_weeks__c!=null)
                    fin.BBA_Accommodation_Weeks_Year_1__c=fin.Accommodation_weeks__c;
            }
        }
    }
    /*Extract Fees based on programs and check start term and program if matches assign fee to finance*/
    if(!setsterms.IsEmpty() && !setpgms.IsEmpty())
    {
        String theQuery = 'SELECT ';
        for(Schema.SObjectField s : fieldMap.values()){
           String theName = s.getDescribe().getName();
           theQuery += theName + ',';
           feelables.put(s.getDescribe().getLabel().tolowercase(),s.getDescribe().getName());
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1);
        theQuery += ' from Fees__c where Program_Name__c IN: setpgms and year__c IN: setsterms';
        //dynamic call
        List<Fees__c> fees= Database.query(theQuery);
        
        for(Fees__c f:fees)
        {
            string fid=f.Program_Name__c ;
            for(Opportunity_Finance__c opfin:Trigger.new)
            {   
                if(opfin.OP_ProgramId__c==null || opfin.Start_term__c ==null)
                { 
                    continue;
                }
                string finpid=opfin.OP_ProgramId__c;
                if(fid.substring(0,15)==finpid.substring(0,15)&& opfin.Start_term__c.contains(f.year__c))
                {
                    opfin.Fees__c=f.Id;
                    opfin.CurrencyIsoCode=f.CurrencyIsoCode;
                    //shs :: if bacheclor program map bba related fields from fee to finance.
                    if(opfin.OP_Program__c.startsWith('Bachelor'))
                    {
                        mapping_Finwithfeevalues.biba_method(f,opfin,feelables);
                    }
                    system.debug('=----'+opfin.Fees__c);                    
                   // opportunity_finances(f,opfin);
                    break;
                }
            }
        }
    }
}