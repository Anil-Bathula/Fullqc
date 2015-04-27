public class documentpagecontroller {

    Public List<Rotation_Documents__c> rotdocs{get;set;}
    Public Rotation_Documents__c selecteddoc{get;set;}
    Public Attachment attach{get;set;}
    public List<Attachment> hisList{get;set;}
    public string rotid{get;set;}
    Public boolean display{get;set;}
    public boolean pasprtfields{get;set;}
    Map<Id,rotation_Documents__c> rotmap{get;set;}
    Public String docid{get;set;}
    Public Rotation__c rot{get;set;}
    Public String stuid{get;set;}
    public Rotation__c disp_rot{get;set;}
    Public String stu_name{get;set;}
    Public String stu_id{get;set;}
    Public String pro_pars{get;set;}
    Public String camp_pars{get;set;}
    Public String visatrack{get;set;}
    public String amountdue{get;set;}
    Public Transient String pass_issudt{get;set;}
    Public Transient String pass_expdt{get;set;}
    public boolean dispdocblock{get;set;}
    public boolean disp_subbtn{get;set;}
    
    public pagereference init()
    {
        set<string> profileids=new set<string>();
        try{
            profileids.add(RecordTypeHelper.getprofileid('Hult Career Point Student Profile'));
            profileids.add(RecordTypeHelper.getprofileid('Hult Career Point Student Profile - Off Service'));
            profileids.add(RecordTypeHelper.getprofileid('System Administrator'));
        }
        catch(exception ecx)
        {}
        profileids.add('00eU0000000IrdI');
        profileids.add('00eU0000000J49l');
        
        try{
            user usr = [SELECT contact.Total_Login__c, contact.RecordTypeId,contact.Name,contact.Last_Log_In__c FROM User WHERE id = :UserInfo.getUserId() and (profileid IN:profileids) and (Contact.RecordTypeId=:RecordTypeHelper.getRecordTypeId('Contact', 'Candidate') or Contact.RecordTypeId=:RecordTypeHelper.getRecordTypeId('Contact', 'Student')) ];
            if(usr.ContactId!=null){
                stuid=usr.ContactId;
               
            }
            else
            {    
                if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
                {
                    stuid=ApexPages.CurrentPage().getParameters().get('student_id');
                    system.debug(stuid+'---'+ApexPages.CurrentPage().getParameters().get('student_id'));
                }
                //we can do same here
            }
        }
        catch(Exception e)
        {
            PageReference pageRef = new PageReference('/apex/student_login');
            pageRef.setRedirect(true);
            return pageRef;
           //'http://staging2-hult-international-business-school.cs10.force.com/visarotation'
        }
       try{
       rotid=ApexPages.CurrentPage().getParameters().get('id');
       list<Rotation__c> rot=new list<Rotation__c>();
       List<Opportunity_Finance__c> opfin=new list<Opportunity_Finance__c>();
       
       rot=[select id,Student__c,Student__r.Name,Student__r.Student_ID__c,Type__c,Rotation_Campus__c
           ,Student__r.Program_preParsed__c,Student__r.Campus_parsed_from_Program__c
           ,Visa_Track__r.Name,Visa_Track_Added__c from Rotation__c where id=:rotid];
       opfin=[Select id,Name,Rot_Visa_Module_D__c,Rot_Housing_Mod_D_Fee__c,Rot_Visa_Mod_D_Fee__c,Rot_Insurance_Mod_D_Fee__c,Rot_Housing_Mod_E_Fee__c,Rot_Visa_Mod_E_Fee__c,Rot_Insurance_Mod_E_Fee__c,
                        Rot_Visa_Module_E__c,currencyisoCode,Rot_Housing_Module_D__c,Rot_Housing_Module_E__c
                from Opportunity_Finance__c where Opportunity__r.Contact__c=:rot[0].Student__c];
       stu_name=rot[0].Student__r.Name;
       stu_id=rot[0].Student__r.Student_ID__c;
       pro_pars=rot[0].Student__r.Program_preParsed__c;
       camp_pars=rot[0].Student__r.Campus_parsed_from_Program__c;
       visatrack=' ';
       amountdue=' ';
       if(rot.ISEmpty())
           return null;
        
        disp_rot=rot[0]; 
        
       if(rot[0].Visa_Track__r.Name!=null){
            //visatrack=rot[0].Visa_Track__r.Name+' - ';
            visatrack=rot[0].Visa_Track__r.Name.Contains('CAMPUS CHANGED')?'CAMPUS CHANGED - ':rot[0].Visa_Track__r.Name+' - ';
        }
        if(opfin.size()>0){
            if(disp_rot.Type__c=='Mod D'){
                Decimal rfee1=opfin[0].Rot_Housing_Mod_D_Fee__c==null?0:opfin[0].Rot_Housing_Mod_D_Fee__c;
                Decimal rfee2=opfin[0].Rot_Visa_Mod_D_Fee__c==null?0:opfin[0].Rot_Visa_Mod_D_Fee__c;
                Decimal rfee3=opfin[0].Rot_Insurance_Mod_D_Fee__c==null?0:opfin[0].Rot_Insurance_Mod_D_Fee__c;
                Decimal totdue=rfee1+rfee2+rfee3;
                amountdue='Current balance: '+opfin[0].currencyisoCode+' '+totdue;
            }
            else if(disp_rot.Type__c=='Mod E'){
                Decimal rfee4=opfin[0].Rot_Housing_Mod_E_Fee__c==null?0:opfin[0].Rot_Housing_Mod_E_Fee__c;
                Decimal rfee5=opfin[0].Rot_Visa_Mod_E_Fee__c==null?0:opfin[0].Rot_Visa_Mod_E_Fee__c;
                Decimal rfee6=opfin[0].Rot_Insurance_Mod_E_Fee__c==null?0:opfin[0].Rot_Insurance_Mod_E_Fee__c;
                Decimal totdue=rfee4+rfee5+rfee6;
                amountdue='Current balance: '+opfin[0].currencyisoCode+' '+totdue;
            }
            else if(disp_rot.Type__c=='Mod D & E'){
                Decimal rfee1=opfin[0].Rot_Housing_Mod_D_Fee__c==null?0:opfin[0].Rot_Housing_Mod_D_Fee__c;
                Decimal rfee2=opfin[0].Rot_Visa_Mod_D_Fee__c==null?0:opfin[0].Rot_Visa_Mod_D_Fee__c;
                Decimal rfee3=opfin[0].Rot_Insurance_Mod_D_Fee__c==null?0:opfin[0].Rot_Insurance_Mod_D_Fee__c;
                Decimal rfee4=opfin[0].Rot_Housing_Mod_E_Fee__c==null?0:opfin[0].Rot_Housing_Mod_E_Fee__c;
                Decimal rfee5=opfin[0].Rot_Visa_Mod_E_Fee__c==null?0:opfin[0].Rot_Visa_Mod_E_Fee__c;
                Decimal rfee6=opfin[0].Rot_Insurance_Mod_E_Fee__c==null?0:opfin[0].Rot_Insurance_Mod_E_Fee__c;
                
                Decimal totdue=rfee1+rfee2+rfee3+rfee4+rfee5+rfee6;
                amountdue='Current balance: '+opfin[0].currencyisoCode+' '+totdue;
            }
        }
          
        attach = new Attachment();
        rotdocs=new list<rotation_Documents__c>();
        rotmap=new Map<Id,rotation_Documents__c>();
        getrotdocs();
        }
        Catch(Exception e){System.Debug(e);}
        return null;
    }
    
    public documentpagecontroller(){
    }
    public PageReference tabmethod() {
        String tab1=ApexPages.currentPage().getParameters().get('tab1');
        String tab2=ApexPages.currentPage().getParameters().get('tab2');
        String tab3=ApexPages.currentPage().getParameters().get('tab3');
        String tab4=ApexPages.currentPage().getParameters().get('tab4');
        PageReference pageRef;
        if(tab1=='home'){
            pageRef = new PageReference('/apex/rotationvisaportal');
            if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
            {
                pageRef.getParameters().put('id',stuid);
                system.debug(stuid);
            }
            If(pageRef.getParameters().containsKey('Rec')){pageRef.getParameters().remove('Rec');}
            If(pageRef.getParameters().containsKey('Depend')){pageRef.getParameters().remove('Depend');}
            If(pageRef.getParameters().containsKey('accomm')){pageRef.getParameters().remove('accomm');}
            pageRef.setRedirect(true);
            return pageRef;
        }
        if(tab2=='Rotationinfo'){
            pageRef = new PageReference('/apex/rotationvisaportal');        
            pageRef.getParameters().put('rotinfo','rotinfo');
            pageRef.getParameters().put('Rec',rotid);
            if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
            {
                pageRef.getParameters().put('id',stuid);   
               system.debug(stuid);
            }
            pageRef.setRedirect(true);
        }
        if(tab3=='dependents'){
            pageRef = new PageReference('/apex/rotationvisaportal');        
            pageRef.getParameters().put('depend','depend');
            pageRef.getParameters().put('Rec',rotid);
            if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
            {
                pageRef.getParameters().put('id',stuid);   
               system.debug(stuid);
            }
            pageRef.setRedirect(true);
        }
        if(tab4=='accommdat'){
            pageRef = new PageReference('/apex/rotationvisaportal');        
            pageRef.getParameters().put('accomm','accomm');
            pageRef.getParameters().put('Rec',rotid);
            if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
            {
                pageRef.getParameters().put('id',stuid);
               system.debug(stuid);
            }
            pageRef.setRedirect(true);
        }
        return pageRef;
    }
    public void getrotdocs(){
        
        if(rotid!=null) 
        rotdocs=[select id,Name,For__c,Rotation1__c,Rotation2__c,Dependent__c,supplied__c,Dependent__r.First_Name__c,Dependent__r.Last_Name__c,Dependent__r.Name
                    ,Passport_issued_country__c,Passport_Number__c,Passport_Issue_Date__c,Passport_Expiration_Date__c
                    ,EXACT_Passport_First_Name__c,EXACT_Passport_Middle_Name__c,EXACT_Passport_Family_Name__c,Passport_Type__c
                    ,Rotation1__r.Visa_Track__c,Rotation2__r.Visa_Track__c
                    ,(select id,description,name from attachments) 
                    from rotation_Documents__c where (Rotation1__c=: rotid and (Created_from_Visatrack_Portal__c=false or (Created_from_Visatrack_Portal__c=true and For_Rotation1_available_to_portal__c=true)))
                     or (Rotation2__c=: rotid and (Created_from_Visatrack_Portal__c=false or (Created_from_Visatrack_Portal__c=true and For_Rotation2_available_to_portal__c=true))) 
                     order by for__c desc];
         
        dispdocblock=false;
        for(rotation_Documents__c r:rotdocs){
            rotmap.put(r.id,r);
            if(r.Dependent__c!=null){
                dispdocblock=true;
            }
            if(r.Supplied__c){
                disp_subbtn=true;
            }
        }
        
    }
    
    public void dispdocs() {
        display=true;
        docid=ApexPages.currentPage().getParameters().get('doc');
        system.debug(docid);
        hisList=new List<Attachment>();
        if(rotmap.containsKey(docid)){
            selecteddoc=rotmap.get(docid);
            /*Datetime passissue= selecteddoc.Passport_Issue_Date__c;
            Datetime passexp= selecteddoc.Passport_Expiration_Date__c;
            if(passissue!=null)
                pass_issudt= passissue.format('dd/MM/yyyy');
            if(passexp!=null)
                pass_expdt = passexp.format('dd/MM/yyyy');*/
            
            if(selecteddoc.Passport_Issue_Date__c!=null)
                pass_issudt=(selecteddoc.Passport_Issue_Date__c.day()<=9?('0'+selecteddoc.Passport_Issue_Date__c.day()):(''+selecteddoc.Passport_Issue_Date__c.day()))
                                +'/'+(selecteddoc.Passport_Issue_Date__c.month()<=9?'0'+selecteddoc.Passport_Issue_Date__c.month():(''+selecteddoc.Passport_Issue_Date__c.month()))
                                +'/'+selecteddoc.Passport_Issue_Date__c.year();
             if(selecteddoc.Passport_Expiration_Date__c!=null)    
                 pass_expdt=(selecteddoc.Passport_Expiration_Date__c.day()<=9?('0'+selecteddoc.Passport_Expiration_Date__c.day()):(''+selecteddoc.Passport_Expiration_Date__c.day()))
                                +'/'+(selecteddoc.Passport_Expiration_Date__c.month()<=9?'0'+selecteddoc.Passport_Expiration_Date__c.month():(''+selecteddoc.Passport_Expiration_Date__c.month()))
                                +'/'+selecteddoc.Passport_Expiration_Date__c.year();
                                
        }
        if(selecteddoc.Name=='Passport Copy And Data' || selecteddoc.Name=='Second Passport'){
            pasprtfields=true;
        }
        else{
            pasprtfields=false;
        }
        for(Attachment atchmnt:selecteddoc.attachments){
            hisList.add(atchmnt);
        }
        
    }
    public List<SelectOption> getclist(){
        List<SelectOption> options = new List<SelectOption>();
        List<Country__c> cou=[select id,name from country__c where name != '-Did Not Respond-' order by name asc]; // remove -Did Not Respond- country from picklist
        options.add(new SelectOption('','-Select-'));            
        for(integer i=0;i<cou.size();i++){
            options.add(new SelectOption(cou[i].id,cou[i].name));            
        }
        return options;
    } 
  
    public PageReference saveand(){
        PageReference pageRef;
        try{
        string savetype=ApexPages.currentPage().getParameters().get('savetype');
        string home_page=ApexPages.currentPage().getParameters().get('home_page');
        //for Submit Button
        if(home_page=='hme_redct' && selecteddoc==null){
            pageRef = new PageReference('/apex/rotationvisaportal');
            if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
            {
                pageRef.getParameters().put('id',stuid);
                system.debug(stuid);
            }
            pageRef.getParameters().put('doc_pop','true');
            If(pageRef.getParameters().containsKey('Rec')){pageRef.getParameters().remove('Rec');}
            If(pageRef.getParameters().containsKey('Depend')){pageRef.getParameters().remove('Depend');}
            If(pageRef.getParameters().containsKey('accomm')){pageRef.getParameters().remove('accomm');}
            pageRef.setRedirect(true);
        }
        else{
            boolean noerror=true;
            if(pasprtfields){
                if(pass_issudt=='' || pass_expdt=='')
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required fields cannot be blank.'));
                    return null;  
                }
                String myDate=pass_issudt;
                String myDate1=pass_expdt;
                String RE_date= '(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[012])/((19|20)\\d\\d)';
                Pattern MyPattern = Pattern.compile(RE_date);
                Matcher MyMatcher = MyPattern.matcher(myDate);
                Matcher MyMatcher1 = MyPattern.matcher(myDate1);
                if (!MyMatcher.matches() || !MyMatcher1.matches()) {
                    attach.body=null;
                    attach=new Attachment();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the right date format, e.g. 15/07/1998.'));
                    return null; 
                }
                try{
                    if(myDate!=null){
                        String stringDate = myDate.substring(6,10) + '-' + 
                                    myDate.substring(3,5) + '-' +
                                    myDate.substring(0,2);
                        stringDate=stringDate;//+' 00:00:00';
                        Date dt = date.valueOf(stringDate);
                        selecteddoc.Passport_Issue_Date__c=dt;
                    }
                    if(myDate1!=null){
                        String stringDate1 = myDate1.substring(6,10) + '-' + 
                                    myDate1.substring(3,5) + '-' +
                                    myDate1.substring(0,2);
                        stringDate1=stringDate1;//+' 00:00:00';
                        Date dt1 = date.valueOf(stringDate1);
                        selecteddoc.Passport_Expiration_Date__c=dt1;
                    }
                }
                Catch(Exception e){
                    attach.body=null;
                    attach=new Attachment();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the right date format, e.g. 15/07/1998.'));
                    return null; 
                }           
                if(selecteddoc.Passport_issued_country__c==null || selecteddoc.Passport_Number__c==null || selecteddoc.Passport_Issue_Date__c==null ||
                       selecteddoc.Passport_Expiration_Date__c==null || selecteddoc.EXACT_Passport_First_Name__c==null || 
                       selecteddoc.EXACT_Passport_Family_Name__c==null ||selecteddoc.Passport_Type__c==null)
                {
                    attach.body=null;
                    attach=new Attachment();
                    noerror=false;  
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required fields cannot be blank.'));
                    return null;      
                }
            }
            if(noerror)
            {
                if(attach.body==null && !selecteddoc.supplied__c)
                {
                    attach.body=null;
                    attach=new Attachment();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a File to upload.'));
                    return null;
                }    
                
                attach.parentId = selecteddoc.id;
                attach.name = attach.name;
                try 
                {
                    Rotation_Documents__c rtdoc=new Rotation_Documents__c();
                    rtdoc=selecteddoc;
                    //System.Debug('*********************'+selecteddoc);
                    if(attach.body!=null)
                    {   
                        System.debug(rtdoc.attachments.size());
                        /*if(rtdoc.attachments!=null && rtdoc.attachments.size()>=3)
                        {
                            attach.body=null;
                            attach=new Attachment();
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Per document you can upload upto 3 attachments only.'));
                            return null;    
                        }*/
                        if(selecteddoc.Passport_Issue_Date__c!=null && selecteddoc.Passport_Expiration_Date__c!=null &&
                             selecteddoc.Passport_Issue_Date__c>selecteddoc.Passport_Expiration_Date__c)
                        {
                            attach.body=null;
                            attach=new Attachment();
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The Passport Issue Date cannot be earlier than the Passport Expiry Date.'));
                            return null;    
                        }
                        try{
                           // Attachment attach1=new Attachment();
                          //  attach1=attach;
                            Database.insert(attach);
                            rtdoc.supplied__c=true;
                            // attach1=new Attachment();
                        }
                        Catch(Exception e){
                            attach.body=null;
                            attach=new Attachment();
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This file exceeds maximum size limit of 5MB.'));
                            return null;
                        }
                        finally {
                            attach.body=null;
                            attach= new Attachment();
                           
                        }
                    }
                    if(selecteddoc.Passport_Issue_Date__c!=null && selecteddoc.Passport_Expiration_Date__c!=null &&
                         selecteddoc.Passport_Issue_Date__c>selecteddoc.Passport_Expiration_Date__c)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The Passport Issue Date cannot be earlier than the Passport Expiry Date.'));
                        return null;    
                    }
                    upsert rtdoc;
                    if(home_page=='hme_redct'){
                        pageRef = new PageReference('/apex/rotationvisaportal');
                        if(Url.getSalesforceBaseUrl().toexternalform()=='https://c.na12.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs10.visual.force.com' || Url.getSalesforceBaseUrl().toexternalform()=='https://c.cs9.visual.force.com' || Test.isRunningtest())
                        {
                            pageRef.getParameters().put('id',stuid);
                            system.debug(stuid);
                        }
                        pageRef.getParameters().put('doc_pop','true');
                        If(pageRef.getParameters().containsKey('Rec')){pageRef.getParameters().remove('Rec');}
                        If(pageRef.getParameters().containsKey('Depend')){pageRef.getParameters().remove('Depend');}
                        If(pageRef.getParameters().containsKey('accomm')){pageRef.getParameters().remove('accomm');}
                        pageRef.setRedirect(true);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Records Saved Successfully.'));
                        //return null;
                    }
                    
                } 
                catch (DMLException e) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                }
                finally {
                    attach.body = null; 
                    attach= new Attachment();
                    
                    
                }
                ApexPages.currentPage().getParameters().put('doc',selecteddoc.id);
                getrotdocs();
                dispdocs();
            }
            
        }
        }
        Catch(Exception e){}
        return pageRef;
    }

}