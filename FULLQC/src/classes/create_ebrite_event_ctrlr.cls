public with sharing class create_ebrite_event_ctrlr 
{
    public boolean publish{get;set;}
    public Campaign campain{get;set;}
    public Event_Brite_Account__c ebacc{get;set;}
    public create_ebrite_event_ctrlr(ApexPages.StandardController controller) 
    {
        campain=new Campaign();
        ebacc=new Event_Brite_Account__c();
    }
    
    public pagereference back()
    {
        string ret='701';        
        if(ApexPages.currentPage().getParameters().get('id')!=null)
        {
            ret=ApexPages.currentPage().getParameters().get('id');
        }
        return new pagereference('/'+ret);
    }
    public pagereference create_Event()
    {
        List<campaign> camp=[select id,Name,Description,StartDate,EndDate,CurrencyIsoCode,Event_Brite_Id__c from Campaign where id=:ApexPages.currentPage().getParameters().get('id')];
        List<Event_Brite_Account__c> eba=[select id,Name,Access_Code__c,Access_Token__c,Client_Id__c,Client_Secret__c from Event_Brite_Account__c where id='a67J00000004Ja7'];
        if(!camp.IsEmpty() && !eba.IsEmpty())
        {
            campain=camp[0];
            ebacc=eba[0];
            if(camp[0].Event_Brite_Id__c!=null)
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Error : This Campaign Already Synced with Event Brite. EventBrite Id:'+camp[0].Event_Brite_Id__c));
                return null;
            }
            
            if(camp[0].StartDate==null || camp[0].EndDate==null)
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Error : Campaign StartDate & EndDate shouldnot be blank'));
                return null;
            }    
            string url='https://www.eventbriteapi.com/v3/events/';
            string sdate=camp[0].StartDate.year()+'-'+camp[0].StartDate.Month()+'-'+camp[0].StartDate.Day()+'T00:00:00Z';
            string edate=camp[0].EndDate.year()+'-'+camp[0].EndDate.Month()+'-'+camp[0].EndDate.Day()+'T23:59:50Z';
            string body='event.name.html='+EncodingUtil.urlEncode(camp[0].Name+'', 'UTF-8')+
                        '&event.description.html='+EncodingUtil.urlEncode(''+camp[0].Description, 'UTF-8')+
                        '&event.organizer_id='+EncodingUtil.urlEncode('7767974839', 'UTF-8')+          
                        '&event.start.utc='+EncodingUtil.urlEncode(sdate, 'UTF-8')+
                        '&event.start.timezone='+EncodingUtil.urlEncode(''+UserInfo.getTimeZone(), 'UTF-8')+
                        '&event.end.utc='+EncodingUtil.urlEncode(edate, 'UTF-8')+
                        '&event.end.timezone='+EncodingUtil.urlEncode(''+UserInfo.getTimeZone(), 'UTF-8')+
                        '&event.currency='+EncodingUtil.urlEncode(camp[0].CurrencyIsoCode, 'UTF-8')+
                        '&event.venue_id='+EncodingUtil.urlEncode('9191859', 'UTF-8')+
                        
                        '&event.logo.id='+EncodingUtil.urlEncode('', 'UTF-8')+
                        '&event.category_id='+EncodingUtil.urlEncode('', 'UTF-8')+
                        '&event.subcategory_id='+EncodingUtil.urlEncode('', 'UTF-8')+
                        '&event.format_id='+EncodingUtil.urlEncode('', 'UTF-8')+
                        '&event.password='+EncodingUtil.urlEncode('', 'UTF-8')+
                        '&event.listed='+EncodingUtil.urlEncode('true', 'UTF-8')+
                        '&event.capacity='+EncodingUtil.urlEncode('', 'UTF-8');
                        /*'&event.online_event='+EncodingUtil.urlEncode('false', 'UTF-8')+
                        '&event.listed='+EncodingUtil.urlEncode('true', 'UTF-8')+
                        '&event.logo.id='+EncodingUtil.urlEncode('11719173', 'UTF-8')+
                        '&event.category_id='+EncodingUtil.urlEncode('115', 'UTF-8')+
                        '&event.subcategory_id='+EncodingUtil.urlEncode('15001', 'UTF-8')+
                        '&event.format_id='+EncodingUtil.urlEncode('100', 'UTF-8')+
                        '&event.shareable='+EncodingUtil.urlEncode('true', 'UTF-8')+
                        '&event.invite_only='+EncodingUtil.urlEncode('false', 'UTF-8')+
                        // '&event.password='+EncodingUtil.urlEncode('1234', 'UTF-8')+
                        '&event.capacity='+EncodingUtil.urlEncode('10', 'UTF-8')+       
                        '&event.show_remaining='+EncodingUtil.urlEncode('true', 'UTF-8');
           // 
                    */
       
            Http h=new Http();    
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setBody(body);
            
            req.setHeader('Content-type','application/x-www-form-urlencoded');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode(eba[0].Access_Token__c, 'UTF-8'));
            System.debug(url);
            req.setMethod('POST');        
            HttpResponse res; 
            res = h.send(req);
            //string resp_string=res.getBody();
            Map<String, Object> resp_output = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            system.debug(resp_output);
            if(res.getstatuscode()==200)
            {
                string camp_id=resp_output.ContainsKey('id')?String.Valueof(resp_output.get('id')):'';
                if(resp_output.ContainsKey('id'))
                {
                    camp[0].Event_Brite_id__c=(string)resp_output.get('id');
                    try{update camp[0];
                    }catch(Exception e)
                    {
                        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, 'Event Succesfully created with ID = '+camp_id+'   --- and error while updating campaign  ->'+e));    
                    }
                }
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, 'Event Succesfully created with ID = '+camp_id));
                
            }
            else
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, res.getstatuscode()+'--'+res.getstatus()+'---'+resp_output));
            }
        }
        else
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No campaign or Event Brite Account Selected.'));
        }
        
        return null;
    }
    
    public void create_ticket()
    {
        if(campain!=null)
        {
            if(campain.Event_Brite_id__c!=null)
            {    
                string url='https://www.eventbriteapi.com/v3/events/'+campain.Event_Brite_id__c+'/ticket_classes/';
                
                string body='ticket_class.name='+EncodingUtil.urlEncode(campain.Name+' - For Ticket', 'UTF-8')+
                        '&ticket_class.description='+EncodingUtil.urlEncode(campain.Description+' - For Ticket', 'UTF-8')+
                        '&ticket_class.quantity_total='+EncodingUtil.urlEncode('1000', 'UTF-8')+          
                        //'&ticket_class.cost.currency='+EncodingUtil.urlEncode(campain.CurrencyIsoCode, 'UTF-8')+
                        '&ticket_class.cost.value='+EncodingUtil.urlEncode('0', 'UTF-8')+
//                        '&ticket_class.donation='+EncodingUtil.urlEncode('0', 'UTF-8')+
                        '&ticket_class.free='+EncodingUtil.urlEncode('true', 'UTF-8')+
                        '&ticket_class.include_fee='+EncodingUtil.urlEncode('false', 'UTF-8')+
                        '&ticket_class.split_fee='+EncodingUtil.urlEncode('false', 'UTF-8')+
                        '&ticket_class.hide_description='+EncodingUtil.urlEncode('false', 'UTF-8')+
                        '&ticket_class.minimum_quantity='+EncodingUtil.urlEncode('1', 'UTF-8');
                        
                        system.debug('-------'+body);
                Httpresponse resp= Event_Brite_API.callout(url,'POST',body,ebacc.Access_Token__c);      
                ApexPages.addMessage(new Apexpages.Message(resp.getstatuscode()==200?ApexPages.Severity.CONFIRM:ApexPages.Severity.Error, 'Value = '+resp+'----'+resp.getBody()));
            }
            else
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No Event Brite Id exist for this campaign'));
            }
        }
    }
    
    public void Publish_event()
    {
        if(campain!=null)
        {
            if(campain.Event_Brite_id__c!=null)
            {    
                string url='https://www.eventbriteapi.com/v3/events/'+campain.Event_Brite_id__c+'/publish/';
                
                string body='';
                        
                        system.debug('-------'+body);
                Httpresponse resp= Event_Brite_API.callout(url,'POST',body,ebacc.Access_Token__c);      
                ApexPages.addMessage(new Apexpages.Message(resp.getstatuscode()==200?ApexPages.Severity.CONFIRM:ApexPages.Severity.Error, 'Value = '+resp+'----'+resp.getBody()));
            }
            else
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No Event Brite Id exist for this campaign'));
            }
        }
    }
    
    
    public void Sync_Attendees()
    {
        if(campain!=null)
        {
            if(campain.Event_Brite_id__c!=null)
            {    
                string url='https://www.eventbriteapi.com/v3/events/'+campain.Event_Brite_id__c+'/attendees/';
                
                Httpresponse resp= Event_Brite_API.callout(url,'GET','',ebacc.Access_Token__c);      
                ApexPages.addMessage(new Apexpages.Message(resp.getstatuscode()==200?ApexPages.Severity.CONFIRM:ApexPages.Severity.Error, 'Value = '+resp+'----'+resp.getBody()));
            }
            else
            {
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No Event Brite Id exist for this campaign'));
            }
        }
    }
    
}