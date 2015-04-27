/*
Author          : Premanath Reddy
Created Date    : 13 Dec 2013
Purpose         : SFSUP-688 :: When a New task button is clicked in the Account related list, then they can select only following task record types(in picklist).
                    Presentation,Counselors meeting,Lunch table,Send Email,Log a Call. If Account Record type :: other than "Educational institution".
*/
public class Account_rectype {
    public List<Account> acc{get;set;}
    public string acc_recname{get;set;}
    public string accid{get;set;}
    public string retn{get;set;}
    public string actvname{get;set;}
    public List<RecordType> rectypes{get;set;}
    public string selctdrec{get;set;}
    public List<showdesc> descvals{get;set;}
    Set<String> eitsklst=new Set<String>{'ei.Call','ei.Meeting'};
    Set<String> patnrtsklst=new Set<String>{'partner.Call','partner.Meeting'};
    Set<String> eievntlst=new Set<String>{'ei.Presentation','ei.Lunch Table','ei.Counselors Meeting','School Tour','ei.Drop In Visit','ei.School Fair'};
    Set<String> patnrevntlst=new Set<String>{'partner.Candidate Interviews','partner.Presentation','partner.Fair','partner.Open-Day',
                                            'partner.Email Blast','partner.Visit to School/University','partner.List Upload',
                                            'partner.(Hult) Training Day','partner.(Hult) VIP Invitation','partner.(Hult) Campus Visit',
                                            'partner.(Hult) Staff Dinner'};
   
    Map<String,String> aliasname=new Map<String,String>{'partner.Candidate Interviews'=>'Candidate Interviews','partner.Presentation'=>'Presentation'
                                                        ,'partner.Fair'=>'Fair','partner.Open-Day'=>'Open-Day'
                                                        ,'partner.Email Blast'=>'Email Blast','partner.Visit to School/University'=>'Visit to School/University'
                                                        ,'partner.List Upload'=>'List Upload','partner.(Hult) Training Day'=>'Training Day'
                                                        ,'partner.(Hult) VIP Invitation'=>'VIP Invitation','partner.(Hult) Campus Visit'=>'Campus Visit'
                                                        ,'partner.(Hult) Staff Dinner'=>'Staff Dinner','ei.Presentation'=>'Presentation'
                                                        ,'ei.Lunch Table'=>'Lunch Table','ei.Counselors Meeting'=>'Counselors Meeting'
                                                        ,'ei.Call'=>'Call','ei.Meeting'=>'Meeting','partner.Call'=>'Call','partner.Meeting'=>'Meeting'
                                                        ,'School Tour'=>'School Tour','ei.Drop In Visit'=>'Drop In Visit'
                                                        ,'ei.School Fair'=>'School Fair'};
                                                        
    Map<String,Set<String>> tskmap=new Map<String,Set<String>>{'Educational Institution'=>eitsklst,'Partner'=>patnrtsklst};
    Map<String,Set<String>> evntmap=new Map<String,Set<String>>{'Educational Institution'=>eievntlst,'Partner'=>patnrevntlst};
    
    public Account_rectype(ApexPages.StandardController controller) {
        try{
            accid=Apexpages.Currentpage().getParameters().get('what_id');
            retn=Apexpages.Currentpage().getParameters().get('retURL');
            actvname=Apexpages.Currentpage().getParameters().get('objname');
            if(accid!=null){
                acc=[Select Name,Id,RecordType.Name,RecordTypeId From Account where id=:accid];
                rectypes= [Select Id,Name,Description,SobjectType From RecordType Where (SobjectType = 'Task' OR SobjectType = 'Event') and isActive=true];
                acc_recname=acc[0].RecordType.Name;
                getrect();
            }
        }
        Catch(Exception e){System.Debug(e);}
    }
    public Class showdesc{
        Public String recName{get;set;}
        Public String recdesc{get;set;}
        public showdesc(String recName,String recdesc){
            this.recName=recName;
            this.recdesc=recdesc;
        }
    }
    public List<SelectOption> getrect() 
    {
        descvals=new List<showdesc>();
        List<SelectOption> options = new List<SelectOption>();
       // try{
        for(RecordType rr:rectypes)
        {
            string rec_name=rr.Name;
            //System.Debug(rr.SobjectType+'================='+actvname);
            if(rr.SobjectType=='Task' && actvname=='Task')
            { 
                if(acc_recname=='Educational Institution' || acc_recname=='Partner' )
                {
                    if(tskmap.get(acc_recname).contains(rec_name))
                    {
                        if(aliasname.containskey(rec_name))
                            rec_name=aliasname.get(rec_name);
                        options.add(new SelectOption(rr.id,rec_name));    
                        descvals.add(new showdesc(rec_name,rr.Description));
                    }
                }
                else{
                    options.add(new SelectOption(rr.id,rec_name));
                    descvals.add(new showdesc(rec_name,rr.Description));
                }
            }
            else if(rr.SobjectType=='Event' && actvname=='Event')
            {
                if(acc_recname=='Educational Institution' || acc_recname=='Partner' )
                {
                    if(evntmap.get(acc_recname).contains(rec_name))
                    {
                        if(aliasname.containskey(rec_name))
                            rec_name=aliasname.get(rec_name);
                        options.add(new SelectOption(rr.id,rec_name));  
                        descvals.add(new showdesc(rec_name,rr.Description));  
                    }
                }
                else
                {
                    options.add(new SelectOption(rr.id,rec_name));  
                    descvals.add(new showdesc(rec_name,rr.Description));  
                }
            }
        }
        //}
       // Catch(Exception e){}
        return options;
    }
    
    public pagereference cusContinue(){
        PageReference pageRef;
        Date myDate = System.Today();
        String myDateStr = myDate.format();
        try{
            if(retn!=null){
                if(actvname=='Task'){
                    pageRef = new PageReference('/00T/e?what_id='+accid+'&retURL='+retn+'&RecordType='+selctdrec+'&ent=Task&tsk4='+myDateStr+'&tsk5='+RecordTypeHelper.getRecordTypeName(selctdrec));
                }
                else if(actvname=='Event'){
                    pageRef = new PageReference('/00U/e?what_id='+accid+'&retURL='+retn+'&RecordType='+selctdrec+'&ent=Event&evt5='+RecordTypeHelper.getRecordTypeName(selctdrec));
                }
            }
            pageRef.setRedirect(true);
        }
        Catch(Exception e){}
        return pageRef;
        
    }
    
    public pagereference cusCancel(){
        PageReference pageRef;
        if(retn!=null){
            pageRef = new PageReference(''+retn);
        }
        return pageRef;
    }
    
}