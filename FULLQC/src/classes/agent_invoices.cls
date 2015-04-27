/*
    Developer : Premanath Reddy
    Date      : 3/4/2015                
    purpose   : To generate the Agent Invioce Page
              
    Test class: 
    coverage  : 
*/
public class agent_invoices {

    public String selctd_yr{ get; set; }
    Public List<Opportunity> opp{get;set;}
    Public Account acc{get;set;}
    Public String curr_id{get;set;}
    public List<commission_cls> comm_lst{get;set;}
    public commission_cls commcls{get;set;}
    public List<Agent_Invoice__c> invioce{get;set;}
    Public List<Attachment> attch_doc{get;set;}
    public List<invioce_cls> inv_lst{get;set;}
    public invioce_cls invcls{get;set;}
    public Decimal comm_total{get;set;}
    public Decimal inv_total{get;set;}
    
    Public agent_invoices(){
        curr_id=Apexpages.currentPage().getParameters().get('Id');
        if(curr_id!=null){
            acc=[Select id,Name from Account where id=:curr_id];
        }
    }
    // Year pick list
    public List<SelectOption> getyears(){
        List<SelectOption> options= new List<SelectOption>();
        options.add(new SelectOption('','-None-'));
        options.add(new SelectOption('2014','2014'));
        options.add(new SelectOption('2015','2015'));
        options.add(new SelectOption('2016','2016'));
        options.add(new SelectOption('2017','2017'));
        options.add(new SelectOption('2018','2018'));
        options.add(new SelectOption('2019','2019'));
        options.add(new SelectOption('2020','2020'));
        return options;
    }
    
    public void commission_method() {
        comm_lst=new List<commission_cls>();
        inv_lst=new List<invioce_cls>();
        if(curr_id!=null){
            //For Commission Section 
            opp=[Select id,Name,Partner__c,Commission_Type__c,Commission__c,Commission_Amount__c,Start_Year__c,Stagename,Matriculated__c
                    from Opportunity where Partner__c=:curr_id and Start_Year__c=:selctd_yr and Stagename='Confirmed' and Matriculated__c=true];
            comm_total=0;
            inv_total=0;
            
            for(Opportunity op:opp){
                commcls=new commission_cls();
                commcls.oppid=op.id;
                commcls.oppname=op.Name;
                commcls.type=op.Commission_Type__c;
                if(op.Commission_Type__c=='Commission')
                    commcls.amount=op.Commission__c;
                else
                    commcls.amount=op.Commission_Amount__c;
                    
                comm_lst.add(new commission_cls(commcls.oppid
                                                ,commcls.oppname
                                                ,commcls.type
                                                ,commcls.amount));
                comm_total=comm_total+commcls.amount;
            }
            //For invioce Marketing Section 
            invioce=[Select id,Name,Partner__c,Amount__c,Start_Year__c,Sub_Type__c,Type__c
                        ,(select id,description,name from attachments)
                        from Agent_Invoice__c where Partner__c=:curr_id and Start_Year__c=:selctd_yr];
                        
            for(Agent_Invoice__c inv:invioce){
                invcls=new invioce_cls();
                invcls.accid=inv.Partner__c;
                invcls.subtype=inv.Sub_Type__c;
                invcls.type=inv.Type__c;
                invcls.amount=inv.Amount__c;
                invcls.attch=inv.attachments;
                if(inv.Sub_Type__c=='Pre-paid commission'){
                    invcls.amount=-inv.Amount__c;
                    comm_lst.add(new commission_cls(invcls.accid
                                                    ,invcls.subtype
                                                    ,invcls.type
                                                    ,invcls.amount));
                    comm_total=comm_total+invcls.amount;
                }
                else{
                    inv_lst.add(new invioce_cls(invcls.accid
                                            ,invcls.subtype
                                            ,invcls.type
                                            ,invcls.amount
                                            ,invcls.attch));
                    inv_total=inv_total+invcls.amount;
                }
                
            }
        }
    }
    
    public class invioce_cls{
        public String accid{get;set;}
        public String subtype{get;set;}
        public String type{get;set;}
        public Decimal amount{get;set;}
        Public List<Attachment> attch{get;set;}
        public invioce_cls(Id Id
                        ,String name
                        ,String type
                        ,Decimal amount,List<Attachment> attch)
        {
            this.accid=id;
            this.subtype=name;
            this.type=type;
            this.amount=amount;
            this.attch=attch;
        }
        public invioce_cls(){}
    }
    
    public class commission_cls{
        public String oppid{get;set;}
        public String oppname{get;set;}
        public String type{get;set;}
        public Decimal amount{get;set;}
        public commission_cls(Id Id
                        ,String name
                        ,String type
                        ,Decimal amount)
        {
            this.oppid=id;
            this.oppname=name;
            this.type=type;
            this.amount=amount;
        }
        public commission_cls(){}
    }
}