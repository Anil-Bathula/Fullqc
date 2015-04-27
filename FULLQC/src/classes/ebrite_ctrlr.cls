public with sharing class ebrite_ctrlr 
{
    string eb_url='https://www.eventbrite.com';
    string eb_api_url='https://www.eventbriteapi.com';
    public ebrite_ctrlr()
    {
        
    }
    
   
    Public pagereference authen()
    {
        string url=eb_url+'/oauth/authorize';

        string red_url='https://c.cs10.visual.force.com/apex/capture_oauth_ebrite';
        string appkey='5FX2N3B52ITIQ6J446';
        string params='response_type=code&client_id='+appkey+'&redirect_uri='+red_url+'?for='+appkey;
        Http h=new Http();    
        HttpRequest req = new HttpRequest();
        url+='?'+params;
        req.setEndpoint(url);
        System.debug(url);
        req.setMethod('GET');        
        HttpResponse res; 
        String resURL; 
        system.Debug(req);
        res = h.send(req); 
         system.debug(''+res);
        return new pagereference(url); 
    }
    
    public String resp_string{get;set;}
    public void gettoken()
    {
        string code='LM45XEJU6ZJ5TCW3TXZW';//access code
        string client_secret='XATMBDSUYIAS5C642WEMP7ZEG72PKCQGANBXOAUZZC2ZNWOMYK';
        string client_id='5FX2N3B52ITIQ6J446';//app key
        string grant_type='authorization_code';
        string url=eb_url+'/oauth/token';
        
        string params='code='+EncodingUtil.urlEncode(code, 'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(client_secret, 'UTF-8')+'&client_id='+EncodingUtil.urlEncode(client_id, 'UTF-8')+'&grant_type='+EncodingUtil.urlEncode(grant_type, 'UTF-8');//authorization_code';//
        
        Http h=new Http();    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
       
        req.setBody(params);
        req.setHeader('Content-type','application/x-www-form-urlencoded');
       // req.setHeader('Authorization', 'Basic 7RJ4Cd29rirWtsY7Zaktlg');
        System.debug(url);
     
        req.setMethod('POST');        
        HttpResponse res; 
        
        system.Debug(req);
        res = h.send(req); 
        resp_string=url+'----'+res;
        system.debug(url+'==='+res +'=========='+res.getBody());
        resp_string=res.getStatusCode()==200?res.getBody():res+'';
        
    }
    
    public void current_user()
    {
        string url=eb_api_url+'/v3/users/me/';                //--?format=json';//?token=LRVCMZ62TKHY2VK3AOTA';
        
        
        Http h=new Http();    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
       
        
        //req.setHeader('Content-type','application/x-www-form-urlencoded');
//        req.setHeader('format','json');
      req.setHeader('Accept','application/json');
       req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode('5T6RULFTCBQKV4G32GQW', 'UTF-8'));
        System.debug(url);
     
        req.setMethod('GET');        
        HttpResponse res; 
        String resURL; 
        system.Debug(req);
        res = h.send(req); 
        resp_string=res.getStatusCode()==200?res.getBody():res+'';
        system.debug(res.getXmlStreamReader());
        system.debug(url+'==='+res +'=========='+res.getBody());
    }

    public void check_event()
    {
        string url=eb_api_url+'/v3/events/14597795399/'; //?format=json';//?token=LRVCMZ62TKHY2VK3AOTA';
        
        
        Http h=new Http();    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        
        req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode('5T6RULFTCBQKV4G32GQW', 'UTF-8'));
        req.setHeader('Accept','application/json');
        System.debug(url);
     
        req.setMethod('GET');        
        HttpResponse res; 
        String resURL; 
        system.Debug(req);
        res = h.send(req); 
        resp_string=res.getStatusCode()==200?res.getBody():res+'';
        system.debug(res.getXmlStreamReader());
        system.debug(url+'==='+res +'=========='+res.getBody());
    }
   
    public void Event_info()
    {
       
        string url=eb_api_url+'/v3/events/?format=json';
        
       
        Http h=new Http();    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
       
        req.setBody(get_eventbody());
        req.setHeader('Content-type','application/x-www-form-urlencoded');
        req.setHeader('Accept','application/json');//: '',
        req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode('5T6RULFTCBQKV4G32GQW', 'UTF-8'));
        System.debug(url);
     
        req.setMethod('POST');        
        HttpResponse res; 
        
        system.Debug(req);
        res = h.send(req); 
        resp_string=url+'----'+res;
        system.debug(url+'==='+res +'=========='+res.getBody());
        resp_string=res.getStatusCode()==200?res.getBody():res+'';
    } 
    
    
    public string get_eventbody()
    {
    string params= 'event.name.html='+EncodingUtil.urlEncode(' Name of the event - test', 'UTF-8')+
                    'event.start.utc='+EncodingUtil.urlEncode(system.now().addDays(2).format('YYYY-MM-DD HH:MM:SS'), 'UTF-8')+
                    'event.end.utc='+EncodingUtil.urlEncode(system.now().addDays(7).format('YYYY-MM-DD HH:MM:SS'), 'UTF-8')+
                    'event.listed=' +EncodingUtil.urlEncode('1', 'UTF-8')+
                    'event.start.timezone='+EncodingUtil.urlEncode(''+UserInfo.getTimeZone(), 'UTF-8')+
                    'event.end.timezone='+EncodingUtil.urlEncode(''+UserInfo.getTimeZone(), 'UTF-8');
    
                     /*'title='+EncodingUtil.urlEncode(' Name of the event - test', 'UTF-8')+
                    'start_date='+EncodingUtil.urlEncode(system.now().addDays(2).format('YYYY-MM-DD HH:MM:SS'), 'UTF-8')+
                    'end_date='+EncodingUtil.urlEncode(system.now().addDays(7).format('YYYY-MM-DD HH:MM:SS'), 'UTF-8')+
                    'privacy=' +EncodingUtil.urlEncode('1', 'UTF-8')+
                    'timezone='+EncodingUtil.urlEncode(''+UserInfo.getTimeZone(), 'UTF-8');*/
                    /*'event.name.html='+EncodingUtil.urlEncode(' Name of the event - test', 'UTF-8')+'';YYYY-MM-DD HH:MM:SS
                    'event.organizer_id ='+EncodingUtil.urlEncode('ID of the organizer this event', 'UTF-8')+
                    'event.start.utc='+EncodingUtil.urlEncode('Start time of the event', 'UTF-8')+
                    'event.start.timezone='+EncodingUtil.urlEncode('Start time timezone (Olson format)', 'UTF-8')+
                    'event.end.utc='+EncodingUtil.urlEncode('End time of the event', 'UTF-8')+
                    'event.end.timezone='+EncodingUtil.urlEncode('End time timezone (Olson format)', 'UTF-8')+
                    'event.currency='+EncodingUtil.urlEncode('Event Currency (3 letter code)', 'UTF-8')+
                    'event.venue_id='+EncodingUtil.urlEncode('ID of the venue (this or online_event is required)', 'UTF-8')+
                    'event.online_event='+EncodingUtil.urlEncode('Is the event online-only (no venue)?', 'UTF-8')+
                    'event.listed='+EncodingUtil.urlEncode('If the event is publicly listed and searchable', 'UTF-8')+
                    'event.logo.id='+EncodingUtil.urlEncode('The logo for the event', 'UTF-8')+
                    'event.category_id='+EncodingUtil.urlEncode('The category for the event', 'UTF-8')+
                    'event.subcategory_id='+EncodingUtil.urlEncode('The subcategory for the event', 'UTF-8')+
                    'event.format_id='+EncodingUtil.urlEncode('The format for the event', 'UTF-8')+
                    'event.shareable='+EncodingUtil.urlEncode('If an event is shareable via social media', 'UTF-8')+
                    'event.invite_only='+EncodingUtil.urlEncode('Only invited users can see the event page', 'UTF-8')+
                    'event.password='+EncodingUtil.urlEncode('Password needed to see the event in unlisted mode', 'UTF-8')+
                    'event.capacity='+EncodingUtil.urlEncode('Set specific capacity (if omitted, sums ticket capacities)', 'UTF-8')+
                    'event.show_remaining='+EncodingUtil.urlEncode('If the remaining number of tickets is publicly visible on the event page', 'UTF-8');
                    */
                    return params;
    
    }
}