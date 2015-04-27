/*
Author          : Premanath Reddy
Purpose         : This class is for to Generate Finance support letter in Opportunity fianance.
Test class      : financesupport_letter_test (81% covered)
*/
public class financesupport_letter {
    Public String finid{get;set;}
    public String logoURL{get;set;}
    public String signURL{get;set;}
    public boolean firstblock{get;set;}
    public Opportunity_Finance__c oppfin{get;set;}
    public String curr_date{get;set;}
    public String ispdf{get;set;}
    public String isword{get;set;}
    public boolean isVF{get;set;}
    public boolean buttons{get;set;}
    public boolean disp_block{get;set;}
    
    public financesupport_letter(ApexPages.StandardController controller) {
     try{
        disp_block=true;
        buttons=true;
        ispdf=null;
        isword=null;
        isvf=false;
        finid=Apexpages.Currentpage().getParameters().get('id');
        if(Apexpages.Currentpage().getParameters().get('type')=='pdf')
        {
            ispdf='pdf';
            isword=null;
            isvf=false;
        }
        else if(Apexpages.Currentpage().getParameters().get('type')=='word')
        {
            ispdf=null;
            isword='application/msWord';
            isvf=false;
        }
        else
        {
            ispdf=null;
            isword=null;
            isvf=true;
        }
        DateTime d = datetime.now();
        string monthname= d.format('MMMMM');
        string day = String.valueOf(d.day());
        if (day.endsWith('1'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'st';
        }
        else if (day.endsWith('2'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'nd';
        }
        else if (day.endsWith('3'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'rd';
        }
        else 
            day=day+'th';
        
        curr_date=monthname+' '+day+', '+d.Year();
        
        oppfin=[Select id,Name,Opportunity__r.Contact__c,Opportunity__r.Contact__r.Name,Opportunity__r.Name
                ,Opportunity__r.Contact__r.MailingCountry,Opportunity__r.Contact__r.Mailingcity
                ,Opportunity__r.Contact__r.MailingState,Opportunity__r.Contact__r.Mailingpostalcode,Opportunity__r.Contact__r.Mailingstreet
                ,Opportunity__r.Contact__r.FirstName,Opportunity__r.Primary_Campus__c,Opportunity__r.Program_formatted_for_emails_letters__c
                ,Start_Term__c,Scholarship_Amount__c,Hult_Financial_Aid__c,OP_Program__c,Opportunity__r.Start_Year__c,Opportunity__r.owner.email
                from Opportunity_Finance__c where id=:finid];
        
        List<document> documentList=[select id,name from document where Name='Hult Logo for Web' or Name='Margaret Sign'];
        for(integer i=0;i<documentList.size();i++){ 
            if(documentList[i].Name=='Hult Logo for Web'){
                String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                logoURL= URL.getSalesforceBaseUrl().toExternalForm()+s;
                if(logoURL.contains('visual')){
                    logoURL=logoURL.replace('visual','content');
                }
            }
            else if(documentList[i].Name=='Margaret Sign'){
                String s1='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                signURL= URL.getSalesforceBaseUrl().toExternalForm()+s1;
                if(signURL.contains('visual')){
                    signURL=signURL.replace('visual','content');
                }
            }
        }    
      }
      Catch(Exception e){
          disp_block=false;
          firstblock=false;
          buttons=false;
          isvf=false;
          if(finid==null){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Finance ID!');
              ApexPages.addMessage(myMsg);
          }
          else{
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'-->'+e);
              ApexPages.addMessage(myMsg);
          }
      }
    }
    public void donothing()
    {    
    }
}