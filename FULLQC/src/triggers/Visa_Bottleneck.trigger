/*************************************************************************
Trigger  : Visa_Bottleneck 
Purpose  :To get the appropriate value from country record when a Program 
or campus is changed on opportunity and country of residence not is null .
Developer :Anil.B
Test class:Fees_Test(88%)
Changes by SHS on 7/4/2014 for SFSUP-745
Modified by Anil.B on 7/10/2014 changed Bachelor of International Business Administration to Bachelor of Business Administration
*************************************************************************/
trigger Visa_Bottleneck on Opportunity (Before Insert,before update) {    
    
    Map<Opportunity,String>opp_ids=new Map<Opportunity,String>();
    Map<string,String> Fields2set=new Map<string,String>();
    
    Fields2set.put('Boston-Master of Business Administration','visa_1b_bottlneck__c');
    Fields2set.put('Boston-Master of International Business','visa_1b_Bottleneck_Boston_MIB__c');
    Fields2set.put('Boston-Master of International Marketing','visa_1b_Bottleneck_Boston_MIM__c');
    Fields2set.put('Dubai-Executive MBA','visa_1b_Bottleneck_Dubai_EMBA__c');
    Fields2set.put('Dubai-Master of Business Administration','visa_1b_Bottleneck_Dubai_MBA__c');
    Fields2set.put('Dubai-Master of International Business','visa_1b_Bottleneck_Dubai_MIB__c');
    Fields2set.put('London-Bachelor of Business Administration','visa_1b_Bottleneck_London_BBA__c');
    Fields2set.put('London-Executive MBA','visa_1b_Bottleneck_London_EMBA__c');
    Fields2set.put('London-Master of Business Administration','visa_1b_Bottleneck_London_MBA__c');
    Fields2set.put('London-Master of Finance','visa_1b_Bottleneck_London_MFIN__c');
    Fields2set.put('London-Master of International Business','visa_1b_Bottleneck_London_MIB__c');
    Fields2set.put('London-Master of International Marketing','visa_1b_Bottleneck_London_MIM__c');
    Fields2set.put('San Francisco-Bachelor of Business Administration','visa_1b_Bottleneck_San_Francisco_BBA__c');
    Fields2set.put('San Francisco-Master of Business Administration','visa_1b_Bottleneck_San_Francisco_MBA__c');
    Fields2set.put('San Francisco-Master of Finance','visa_1b_Bottleneck_San_Francisco_MFIN__c');
    Fields2set.put('San Francisco-Master of International Business','visa_1b_Bottleneck_San_Francisco_MIB__c');
    Fields2set.put('San Francisco-Master of International Marketing','visa_1b_Bottleneck_San_Francisco_MIM__c');
    Fields2set.put('San Francisco-Master of Social Entrepreneurship','visa_1b_Bottleneck_San_Francisco_MSE__c');
    Fields2set.put('Shanghai-Executive MBA','visa_1b_Bottleneck_Shanghai_EMBA__c');
    Fields2set.put('Shanghai-Master of Business Administration','visa_1b_Bottleneck_Shanghai_MBA__c');
    Fields2set.put('Shanghai-Master of International Business','visa_1b_Bottleneck_Shanghai_MIB__c');
 
     for(Opportunity opp:Trigger.New){         
         Opportunity oldopp=Trigger.Isinsert?new Opportunity():trigger.oldmap.get(opp.id);
                  
         If(RecordTypeHelper.isapplicationprocessrecordtype(opp.Recordtypeid) && opp.Country_Of_Residence__c!=null && (opp.Program__c!=oldopp.program__c||opp.Primary_Campus__c!=oldopp.Primary_Campus__c)){
             opp_ids.put(Opp,opp.Country_Of_Residence__c);             
         }        
     }
     
     If(!opp_ids.isEmpty()){     
        Set<String>cids=new set<string>(); 
        cids.addall(opp_ids.Values());
        
        String qrystr='Id,Name';
        for(String fieldName : Fields2set.values()){
            qrystr+=','+fieldName;
        } 
        String query = 'select '+ qrystr+' from country__c where Name IN :cids'; 
        list<Country__c> lst_cont=Database.query(query);
       
        map<string,Country__C> countrymap=new map<string,country__C>();
           for(country__c c:lst_cont)
           {
               countrymap.put(c.Name,c);
           }                                 
           for(Opportunity op:Opp_ids.Keyset()){           
                string countryname=op.Country_Of_Residence__c;                            
                if(countrymap.containsKey(countryname) && fields2set.containsKey(op.Primary_Campus__c+'-'+op.Program_formatted_for_emails_letters__c))
                {
                    string fldapiname=fields2set.get(op.Primary_Campus__c+'-'+op.Program_formatted_for_emails_letters__c);
                    Try{
                        op.Visa_1b_Bottlneck_Max_Days__c=Integer.Valueof(countrymap.get(countryname).get(fldapiname)); 
                     }Catch (Exception e){
                         
                     }   
                }                 
           }
     }
}