/*
Class Name:-       formatedphone
Author:-           Premanath Reddy
Created Date:-     Sep-05-2012
Usage:-            Wrapper class for Five9 Formated Phone number 
                   Calling from formatedPhone_Lead Trigger and formatedPhone_Contact Trigger.
Note:-             
*/

public class formatedphone{
    public class phnresp{
        public string fphone{get;set;}
        public string ccode{get;set;}
        public integer msnnum{get;set;}
        public string fphcode{get;set;}
        public Boolean selected{get;set;}
    }
    //This method works for four parameters phonenumber,Country code,Msn and Boolean(Prefix 011 not required for five9)
     public phnresp formatedphone(String phonenumber,String code,integer msn,Boolean selected){
        String formatedph='';
        String inc='011';
        //Eliminating Special Characters and Alphabets from phonenumber and country code
        phonenumber=phonenumber.toLowerCase();
        String specialChars = 'abcdefghijklmnopqrstuvwxyz+-&|^|@() *_!$%=?.,<>;;{}[]|#/\\';        
        for(integer i=0; i<specialChars.split('|').size(); i++){
        phonenumber= phonenumber.replace(specialChars.split('|')[i], ''); 
        code=code.replace(specialChars.split('|')[i],''); 
        }
        System.debug('Special-chars free string is --------> ' + code); 
        //Eliminating Leading zero's from phonenumber and Country code
        String str= phonenumber.trim().replaceAll('^0+(?!$)','');
        code=code.trim().replaceAll('^0+(?!$)','');                
        String str1;
        String str2;
        String str3;
        //Eliminating Leading country code from phonenumber 
        if(str.startsWith(code)){
                 str1=str.trim().replaceFirst(code,'');                 
         }
        else{
                 str1=str;    
         }
       //If (Prefix 011 not required for five9 -> value is False)
       if(selected!=true){
           
            str2= str1.trim().replaceAll('^0+(?!$)','');
            str3=str2;
            //Checking Msn Number and make it exact phonenumber
            if(msn<str2.length()){
                 integer num=str2.length()-msn;
                 str2=str2.substring(num);                 
                 /*for(integer i=0; i<num+1; i++){
                    str2= str2.replaceFirst(str3.split('|')[i],'');                 
                  }*/
             }
            formatedph=inc+code+str2;
           // System.debug('complte formated phone number --------> ' + formatedph);
        }
         //If (Prefix 011 not required for five9 -> value is True)
        else{
             code= code.trim().replaceAll('^1+(?!$)','');
             if(str.startsWith(code)){
                 str1=str1.trim().replaceFirst(code,'');
             }  
             str2= str1.trim().replaceAll('^0+(?!$)','');
             str3=str2;
             //Checking Msn Number and make it exact phonenumber
             if(msn<str2.length()){
                   integer num=str2.length()-msn;
                   str2=str2.substring(num);                                      
                   /*for(integer i=0; i<num+1; i++){
                      str2= str2.replaceFirst(str3.split('|')[i],'');                 
                    }*/
             }   
             formatedph=code+str2;
             code='1'+code;
            // System.debug('complte formated phone number --------> ' + formatedph);
        }
        phnresp p=new phnresp();
        p.fphone=str2;       
        p.ccode=code;
        p.msnnum=msn;
        p.fphcode=formatedph;
        return p;           
    }
    //Test Method for this wrapper class
    static testmethod void methodname(){
        String i,j;
        formatedphone ph=new formatedphone();
        formatedphone.phnresp pc=new formatedphone.phnresp();
        pc=ph.formatedphone('+(268)-00268218919821012345','1268',10,true);
        i=pc.fphcode;
        j='2689821012345';
        System.assertEquals(i,j);
        pc=ph.formatedphone('+(1268)-00218919821012345','1268',10,false);
        i=pc.fphcode;
        j='01112689821012345';
        System.assertEquals(i,j);
    } 
}