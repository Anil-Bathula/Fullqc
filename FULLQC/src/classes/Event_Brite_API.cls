public with sharing class Event_Brite_API 
{
	public static final string ebrite_api_url='https://www.eventbriteapi.com';
	public class venue
	{
		public string id{get;set;} 
		public string name{get;set;} 
		public string address_1{get;set;} 
		public string address_2{get;set;} 
		public string city{get;set;}
		public string region{get;set;} 
		public string postal_code{get;set;} 
		public string country{get;set;} 
		public string latitude{get;set;} 
		public  string longitude{get;set;}
	}
	
	public static HttpResponse getVenue(venue ven)
	{
		 string url=ebrite_api_url+'/v3/users/me/venues/';		 
		 Http h=new Http();    
         HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setHeader('Content-type','application/x-www-form-urlencoded');
         req.setHeader('Accept','application/json');
         req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode('5T6RULFTCBQKV4G32GQW', 'UTF-8'));
         System.debug(url);
         req.setMethod('GET');        
         HttpResponse res; 
         res = h.send(req);         
         Map<String, Object> resp_output = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
         	//how to check venue already exist? need to come up with an idea.
		return null;
	}
	
	public static venue createtVenue(venue ven)
	{
		 string url=ebrite_api_url+'/v3/users/me/venues/';		 
		 Http h=new Http();    
		 HttpRequest req = new HttpRequest();
         
         string body='venue.name='+EncodingUtil.urlEncode(ven.Name+'', 'UTF-8')+
         			 'venue.address.address_1='+EncodingUtil.urlEncode(ven.address_1+'', 'UTF-8')+
         			 'venue.address.address_2='+EncodingUtil.urlEncode(ven.address_2+'', 'UTF-8')+
         			 'venue.address.city='+EncodingUtil.urlEncode(ven.city+'', 'UTF-8')+
         			 'venue.address.region='+EncodingUtil.urlEncode(ven.region+'', 'UTF-8')+
         			 'venue.address.postal_code='+EncodingUtil.urlEncode(ven.postal_code+'', 'UTF-8')+
         			 'venue.address.country='+EncodingUtil.urlEncode(ven.country+'', 'UTF-8')+
         			 'venue.address.latitude='+EncodingUtil.urlEncode(ven.latitude+'', 'UTF-8')+
         			 'venue.address.longitude='+EncodingUtil.urlEncode(ven.longitude+'', 'UTF-8');	
         
         req.setEndpoint(url);
         req.setHeader('Content-type','application/x-www-form-urlencoded');
         req.setHeader('Accept','application/json');
         req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode('5T6RULFTCBQKV4G32GQW', 'UTF-8'));
         System.debug(url);
         req.setMethod('POST');        
         HttpResponse res; 
         res = h.send(req);         
         Map<String, Object> resp_output = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
         System.debug(resp_output);
         	//how to check venue already exist? need to come up with an idea.
         if(resp_output.containsKey('venues'))	
		 {
		 	List<Map<string,object>> venues_list=(List<Map<String, Object>>)resp_output.get('venues');
		 	for(integer i=0;i<venues_list.size();i++)
		 	{
		 		Map<string,object> venue_map=(map<string,object>)venues_list[i];
		 		if(venue_map.containskey('id'))
		 		{
		 			ven.id=(String)venue_map.get('id');
		 		}
		 	}
		 }
		 
		 return ven;
	}
	
	Public static Httpresponse callout(string url,string method,string body,string token)
	{
		//string url=ebrite_api_url+'/v3/users/me/venues/';		 
		 Http h=new Http();    
		 HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setHeader('Content-type','application/x-www-form-urlencoded');
         req.setHeader('Accept','application/json');
         req.setHeader('Authorization', 'Bearer '+EncodingUtil.urlEncode(token, 'UTF-8'));//'5T6RULFTCBQKV4G32GQW'
         System.debug(url);
         	if(method=='post')
         	{	
         		req.setBody(body);
         	}
         req.setMethod(method);        
         HttpResponse res; 
         res = h.send(req);
         return res;
	}
}