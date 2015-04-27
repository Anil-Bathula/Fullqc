/**********************************************
Class:leadSource_QS_MBA(GMASS SCORING)
Developer:Anil.B
Purpose: This class is to calculate gmass score
and send back the values to lead scoring trigger on lead object
***********************************************/


public class leadSource_QS_MBA{

     public class  lead_score_respone{ 
        //Gmass Response   
         public Decimal GMASS_MBA_probx{get;set;}
         public Decimal GMASS_MBA_Total{get;set;}
         public String  GMASS_lead_score{get;set;}
         
        //QS MBA WORLD tour Response
         public Decimal QS_MBA_probx{get;set;}
         public Decimal QS_MBA_Total{get;set;}
         public String  QS_lead_score{get;set;}
          
     }      
   
    
/*********************GMASS_MODEL********************************************/

    public lead_score_respone gmass_Model(String Worldregion,String country
                                        ,String degreeobjective,String workload,string regions,Integer worldregionid,String Region){
        /****This is return value for Worldregion*****/ 
        String region_val=(region==null||region=='')?'':((region.trim()==''||region.trim()==null)?'':region.trim().toLowerCase());
        String regionname=(Worldregion==null||Worldregion=='')?'':((Worldregion.trim()==''||Worldregion.trim()==null)?'':Worldregion.trim().toLowerCase());
        Integer africa=0;
        Integer asia=0;
        Integer australia=0;
        Integer casia=0;
        Integer eeurope=0;
        Integer weurope=0;
        Integer latam =0;
        Integer middlee=0; 
        if(regionname!=NULL||regionname!=''){
            if(regionname=='africa'){
                africa=1;
            }
            else if(regionname=='asia'){
                asia=1;
            }
            else if(regionname=='australia and the pacific islands'){
                australia=1;
            }
            else if(regionname=='central asia'){
                casia=1;
            } 
            else if(regionname=='europe, eastern'){
                eeurope=1;
            }
            else if(regionname=='europe, western'){
                weurope=1;
            } 
            else if(regionname=='mexico, the caribbean, and latin america'){
                latam=1;
            }
            else if(regionname=='middle east'){
                middlee=1;
            }
        }  
        
        /****This is return value for WorldRegion ID*****/
       Integer regionID=(Worldregionid!=null)?Worldregionid:22;
       
        /****This is return value for Contry*****/ 
        String ctryname=(country==null||country=='')?'':((country.trim()==''||country.trim()==null)?'':country.trim().toLowerCase());
        Integer nigeria=0;
        Integer china=0;
        if(ctryname!=NULL||ctryname!=''){
            if(ctryname=='nigeria'){
                nigeria=1;
            }
            else if(ctryname=='china'){
                china=1;
            }
        }  
        
        /****This is return value for degreeobjective*****/ 
        String degreeobj=(degreeobjective==null||degreeobjective=='')?'':((degreeobjective.trim()==''||degreeobjective.trim()==null)?'':degreeobjective.trim().toLowerCase());
        Integer objmba=0;
        Integer objmabus=0;
        if(degreeobj!=NULL||degreeobj!=''){
            if(degreeobj=='master\'s in business administration (mba)'){
                objmba=1;
            }
            if(degreeobj=='master\'s in business (ms, msc, ma)'){
                objmabus=1;
            }
        }  
        
        /****This is return value for Work load*****/ 
        String wrklodtime=(workload==null||workload=='')?'':((workload.trim()==''||workload.trim()==null)?'':workload.trim().toLowerCase());
        Integer fulltime=0;
        Integer parttime=0;
        if(wrklodtime!=NULL||wrklodtime!='' ){
            if(wrklodtime=='full-time student'){
                fulltime=1;
            }
            if(wrklodtime=='part-time student'){
                parttime=1;
            }
        }                                
        list<String> regvals=new list<String>();
        if(regions!=null)
            regvals= regions.split('\\;');
        system.debug(regvals.size());    
        String regionval1=(regvals!=null && !regvals.isempty() && regvals.size()>=1)?((regvals[0]==null||regvals[0]=='')?'':((regvals[0].trim()==''||regvals[0].trim()==null)?'':regvals[0].trim().toLowerCase())):''; 
        String regionval2=(regvals!=null && !regvals.isempty() && regvals.size()>=2)?((regvals[1]==null||regvals[1]=='')?'':((regvals[1].trim()==''||regvals[1].trim()==null)?'':regvals[1].trim().toLowerCase())):'';
        String regionval3=(regvals!=null && !regvals.isempty() && regvals.size()>=3)?((regvals[2]==null||regvals[2]=='')?'':((regvals[2].trim()==''||regvals[2].trim()==null)?'':regvals[2].trim().toLowerCase())):'';
        String regionval4=(regvals!=null && !regvals.isempty() && regvals.size()>=4)?((regvals[3]==null||regvals[3]=='')?'':((regvals[3].trim()==''||regvals[3].trim()==null)?'':regvals[3].trim().toLowerCase())):'';
        String regionval5=(regvals!=null && !regvals.isempty() && regvals.size()>=5)?((regvals[4]==null||regvals[4]=='')?'':((regvals[4].trim()==''||regvals[4].trim()==null)?'':regvals[4].trim().toLowerCase())):'';
        String regionval6=(regvals!=null && !regvals.isempty() && regvals.size()>=6)?((regvals[5]==null||regvals[5]=='')?'':((regvals[5].trim()==''||regvals[5].trim()==null)?'':regvals[5].trim().toLowerCase())):'';
        /*String regionval1=(regionvalue1==null||regionvalue1=='')?'':((regionvalue1.trim()==''||regionvalue1.trim()==null)?'':regionvalue1.trim().toLowerCase());
        String regionval2=(regionvalue2==null||regionvalue2=='')?'':((regionvalue2.trim()==''||regionvalue2.trim()==null)?'':regionvalue2.trim().toLowerCase());
        String regionval3=(regionvalue3==null||regionvalue3=='')?'':((regionvalue3.trim()==''||regionvalue3.trim()==null)?'':regionvalue3.trim().toLowerCase());
        String regionval4=(regionvalue4==null||regionvalue4=='')?'':((regionvalue4.trim()==''||regionvalue4.trim()==null)?'':regionvalue4.trim().toLowerCase());
        String regionval5=(regionvalue5==null||regionvalue5=='')?'':((regionvalue5.trim()==''||regionvalue5.trim()==null)?'':regionvalue5.trim().toLowerCase());
        String regionval6=(regionvalue6==null||regionvalue6=='')?'':((regionvalue6.trim()==''||regionvalue6.trim()==null)?'':regionvalue6.trim().toLowerCase());*/
        
        Map<String,Integer> regionvalmap=new Map<String,Integer>{'united states'=>8,'...northeast (ct, ma, me, nh, nj, ny, ri, vt)'=>8
                                                        ,'...southwest (az, co, nm, ok, tx)'=>8,'undecided'=>0
                                                        ,'...midwest (ia, il, in, ks, mi, mn, mo, nd, ne, oh, sd, wi)'=>8
                                                        ,'...middle atlantic (dc, de, md, pa va, wv)'=>8
                                                        ,'...west (ak, ca, hi, id, mt, nv, or ut, wa, wy)'=>8,'...south (al, ar, fl, ga, ky, la, ms, nc, sc, tn)'=>8
                                                        ,'europe, western'=>9,'asia'=>2,'australia and the pacific islands'=>3
                                                        ,'canada'=>8,'...undecided (us)'=>8,'middle east'=>7,'europe, eastern'=>5
                                                        ,'africa'=>1,'mexico, the caribbean, and latin america'=>6
                                                        ,'central asia'=>4};
        Integer regmatch1=0;
        Integer regmatch2=0;
        Integer regmatch3=0;
        Integer regmatch4=0;
        Integer regmatch5=0;
        Integer regmatch6=0;
        if(regionvalmap.containsKey(regionval1) && regionvalmap.get(regionval1)==regionID){
            regmatch1=1;
        }
        if(regionvalmap.containsKey(regionval2) && regionvalmap.get(regionval2)==regionID){
            regmatch2=1;
        }
        if(regionvalmap.containsKey(regionval3) && regionvalmap.get(regionval3)==regionID){
            regmatch3=1;
        }
        if(regionvalmap.containsKey(regionval4) && regionvalmap.get(regionval4)==regionID){
            regmatch4=1;
        }
        if(regionvalmap.containsKey(regionval5) && regionvalmap.get(regionval5)==regionID){
            regmatch5=1;
        }
        if(regionvalmap.containsKey(regionval6) && regionvalmap.get(regionval6)==regionID){
            regmatch6=1;
        }
        
        Integer regmatchsum= regmatch1+regmatch2+regmatch3+regmatch4+regmatch5+regmatch6;
        
        
        Integer reg1exist = 1;
        Integer reg2exist = 1;
        Integer reg3exist = 1;
        Integer reg4exist = 1;
        Integer reg5exist = 1;
        Integer reg6exist = 1;
        if(regionval1=='undecided'||regionval1==''||regionval1==NULL){
            reg1exist =0;
        }
        if(regionval2=='undecided'||regionval2==''||regionval2==NULL){
            reg2exist =0;
        }
        if(regionval3=='undecided'||regionval3==''||regionval3==NULL){
            reg3exist =0;
        }
        if(regionval4=='undecided'||regionval4==''||regionval4==NULL){
            reg4exist =0;
        }
        if(regionval5=='undecided'||regionval5==''||regionval5==NULL){
            reg5exist =0;
        }
        if(regionval6=='undecided'||regionval6==''||regionval6==NULL){
            reg6exist =0;
        }
        
        Double regionsum =reg1exist+reg2exist+reg3exist+reg4exist+reg5exist+reg6exist;
        
        Decimal regmatchproport =99; 
        try{
             regmatchproport =regmatchsum/regionsum;
           System.debug('==regmatchproport==>'+regmatchproport+'<==>'+regmatchsum+'<==>'+regionsum);
        }catch (exception e){
             System.debug('An Error occurred : ' + e.getMessage());
        }
        
        
        Integer regproportcat;
        if(regmatchproport == 99){
            regproportcat=1;
        }else if(regmatchproport == 1){
            regproportcat=2;
        }
        else if(regmatchproport==0){
            regproportcat=3;
        }
        else if(regmatchproport>0 && regmatchproport<1){
            regproportcat=4;
        }
        
        Integer nomatch = 0;
        if (regproportcat == 3){
            nomatch = 1;
        }
        
        Integer allmatch=0;
        if (regproportcat == 2){
            allmatch = 1;
        }
        
        Decimal x=(1.152 * africa)+
                   (0.3386 * asia)+ 
                   (-0.5195 * australia) + 
                   (-0.1094 * casia) + 
                   (1.138 * eeurope) + 
                   (1.318 * weurope)+ 
                   (1.543 * latam) + 
                   (1.188 * middlee) +
                   (-1.321 * china) + 
                   (0.4442 * nigeria) + 
                   (0.354 * objmba) + 
                   (0.5678 * objmabus) + 
                   (0.4619 * fulltime) + 
                   (-1.403 * parttime) + 
                   (-0.8426 * allmatch) + 
                   (0.2081 * nomatch) + 
                   (-5.591) ;

        Decimal probx=(1/(1+Math.exp(-x)));
        
             list<Decimal> africa_val=new list<Decimal>{0.03184,0.01967,0.01256,0.00931,0.00688,0.00493,0.00352,0.00235,0.00149,0};
             list<Decimal> asia_val=new list<Decimal>{0.00931,0.00508,0.00321,0.00212,0.00147,0.00129,0.00072,0.00047,0.00026,0};
             list<Decimal> lat_am_val=new list<Decimal>{0.02875,0.01471,0.00895,0.00551,0.00352,0.00231,0.00158,0.00091,0.00044,0};
             List<Decimal> lon_eur_val=new list<Decimal>{0.02694,0.01736,0.01375,0.00986,0.00658,0.00498,0.00316,0.00217,0.00144,0};
             List<Decimal> luz_eur_val=new list<Decimal>{0.02062,0.01376,0.01078,0.0078,0.00571,0.00415,0.00297,0.00199,0.00144,0};
             List<Decimal> middle_east_val=new list<Decimal>{0.01859,0.01256,0.01051,0.00753,0.00518,0.00336,0.0021,0.00158,0.00099,0};
             List<Decimal> north_am_val=new list<Decimal>{0.00589,0.00372,0.00255,0.00188,0.00104,0.00056,0.00053,0.00044,0.00028,0};
             List<Decimal> south_asia_val=new list<Decimal>{0.01067,0.00923,0.00728,0.00584,0.0041,0.00333,0.00208,0.00106,0.00077,0};
             Map<String,list<Decimal>> Region_list=new Map<String,list<Decimal>>{'africa'=>africa_val,'asia'=>asia_val,'lat am'=>lat_am_val,'lon eur'=>lon_eur_val,
                                                                            'luz eur'=>luz_eur_val,'middle east'=>middle_east_val,'north am'=>north_am_val,
                                                                            'north am sfo'=>north_am_val,'north am bos'=>north_am_val,'south asia'=>south_asia_val};
        
           lead_score_respone lp=new lead_score_respone();
           lp.GMASS_MBA_probx=probx*100;
          // lp.GMASS_MBA_Total=x;
           
           if(probx>0.01375){
               lp.GMASS_MBA_Total=1;
           }else if(probx>0.00837){
               lp.GMASS_MBA_Total=2;
           }else if(probx>0.00528){
               lp.GMASS_MBA_Total=3;
           }else if(probx>0.00362){
               lp.GMASS_MBA_Total=4;
           }else if(probx>0.00245){
               lp.GMASS_MBA_Total=5;
           }else if(probx>0.00159){
               lp.GMASS_MBA_Total=6;
           }else if(probx>0.001){
               lp.GMASS_MBA_Total=7;
           }else if(probx>0.00056){
               lp.GMASS_MBA_Total=8;
           }else if(probx>0.00037){
               lp.GMASS_MBA_Total=9;
           }else{
               lp.GMASS_MBA_Total=10;
           }
       
        
           map<Integer,string>lead_score = new map<Integer,string>{0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',9=>'J'};
           
            if(Region_list.containsKey(region_val)){
               integer i=0;
               for(Decimal D:region_list.get(region_val)){
                   if(probx>d){
                      lp.GMASS_Lead_score=lead_score.containskey(i)?lead_score.get(i):'';
                      break; 
                   }i++;                   
               }            
            }
            
        System.debug('=====================(1.152 *'+africa+')+(0.3386 * '+asia+')+ (-0.5195 * '+australia+')+(-0.1094 * '+casia+')+ (1.138 * '+eeurope+')+(1.318 * '+weurope+')+(1.543 * '+latam+') +(1.188 * '+middlee+') +(-1.321 * '+china+') + (0.4442 * '+nigeria+') +(0.354 * '+objmba+') +(0.5678 * '+objmabus+') +(0.4619 * '+fulltime+') +(-1.403 * '+parttime+') + (-0.8426 * '+allmatch+') + (0.2081 * '+nomatch+') +(-5.591)');
        
        System.debug('=====================***regionsum->'+regionsum);
        System.debug('=======================***regmatchsum->'+regmatchsum);
        System.debug('======================***regmatchproport ->'+regmatchproport);
        System.debug('===================***x->'+x);
        System.debug('=====================***probx->'+probx);      
        System.debug('================='+lp.GMASS_MBA_probx);
         
       return lp;   
        
    }   
    
       
  /******************--LEADSCORE_QS_MBA-----with four parameters Gmail,Typefull,candidatecountry and years of experience)*/
  
    public  lead_score_respone leadSource_QS_MBA(String gmail,String typeful,string ccountry,String yrofexp,String region){
     
        decimal experlev;   
        decimal countryval;
        
        String region_val=(region==null||region=='')?'':((region.trim()==''||region.trim()==null)?'':region.trim().toLowerCase());
        
        /****This is return value for gmail*****/   
        Integer isnotgmail=1;
            if((gmail!=null && gmail!='') && gmail.trim()!=null && gmail.endswith('@gmail.com')){
                isnotgmail=0;
                system.debug('==g=>'+isnotgmail);
             }
        
        /****This is return value for Type full*****/ 
        Integer isnotfulltime=1;
            if(typeful!=NULL||typeful!='' && typeful=='Full-time'||typeful=='Full-Time'){
                isnotfulltime=0;
                system.debug('==f=>'+isnotfulltime);
            }
         
         /****This is return value for candidate country*****/      
         String ctryname=(ccountry==null||ccountry=='')?'':ccountry.toLowerCase();     
         Map<String,Integer> ccat=new Map<String,Integer>{'india'=>1,'united states'=>2,'usa - northeast'=>2,'usa - west'=>2,
                                                          'usa - mid-atlantic'=>2,'usa - midwest'=>2,'usa - south'=>2,
                                                          'usa - southwest'=>2,'united arab emirates'=>3,'china'=>4,
                                                          'canada'=>5,'united kingdom'=>6,'germany'=>7,'france'=>8,'russia'=>9,
                                                          ''=> 10,'kenya'=>11,'nigeria'=>12};
                                                          
         Map<Integer,Decimal>ccatval=new Map<Integer,Decimal>{0=>0.012114814256271,1=>0.00907983612003101,2 => 0.00801710315339391,
                                                            3 => 0.00990731863215085,4 => 0.00598404255319149, 5 => 0.00729394602479942,
                                                            6 => 0.0141670737664875, 7 => 0.0157600406710727, 8 => 0.0220905172413793,
                                                            9 => 0.0134078212290503, 10 => 0.0134847409510291, 11 => 0.0032599837000815,
                                                            12 => 0.0129421915444349};
                                        
          countryval=ccatval.get(ccat.containsKey(ctryname)?ccat.get(ctryname):0);
          system.debug('--->'+countryval);
           
          
          /****This is return value for Years of experience*****/
          String yr=(yrofexp==null||yrofexp=='')?yrofexp:yrofexp.toLowerCase();     
          
           Map<String,Integer> Exprs=new Map<String,Integer>{'less than a year'=>1,'1 - 3 years'=>2,'1 to 3 years'=>2,'3-4 years'=>3,
                                                            '4 - 5 years'=>4,'6 - 10 years'=>5,'11 - 14 years'=>6,'11 to 14 years'=>6,
                                                            'more than 15 years'=>7};
         
          
            Map<Integer,Decimal>clev=new Map<Integer,Decimal>{0=>0.0105379922351636,1=>0.00667396061269146,2 => 0.0101704879482657,
                                                              3 => 0.015,4 => 0.0102937010104826, 5 => 0.0140207262910389,
                                                              6 => 0.0177111716621253, 7 => 0.00686106346483705}; 
                      
            experlev=clev.get(exprs.ContainsKey(yr)?exprs.get(yr):0);
            
            
            
             list<Decimal> africa_val=new list<Decimal>{0.03184,0.01967,0.01256,0.00931,0.00688,0.00493,0.00352,0.00235,0.00149,0};
             list<Decimal> asia_val=new list<Decimal>{0.00931,0.00508,0.00321,0.00212,0.00147,0.00129,0.00072,0.00047,0.00026,0};
             list<Decimal> lat_am_val=new list<Decimal>{0.02875,0.01471,0.00895,0.00551,0.00352,0.00231,0.00158,0.00091,0.00044,0};
             List<Decimal> lon_eur_val=new list<Decimal>{0.02694,0.01736,0.01375,0.00986,0.00658,0.00498,0.00316,0.00217,0.00144,0};
             List<Decimal> luz_eur_val=new list<Decimal>{0.02062,0.01376,0.01078,0.0078,0.00571,0.00415,0.00297,0.00199,0.00144,0};
             List<Decimal> middle_east_val=new list<Decimal>{0.01859,0.01256,0.01051,0.00753,0.00518,0.00336,0.0021,0.00158,0.00099,0};
             List<Decimal> north_am_val=new list<Decimal>{0.00589,0.00372,0.00255,0.00188,0.00104,0.00056,0.00053,0.00044,0.00028,0};
             List<Decimal> south_asia_val=new list<Decimal>{0.01067,0.00923,0.00728,0.00584,0.0041,0.00333,0.00208,0.00106,0.00077,0};
             Map<String,list<Decimal>> Region_list=new Map<String,list<Decimal>>{'africa'=>africa_val,'asia'=>asia_val,'lat am'=>lat_am_val,'lon eur'=>lon_eur_val,
                                                                            'luz eur'=>luz_eur_val,'middle east'=>middle_east_val,'north am'=>north_am_val,'south asia'=>south_asia_val};
            
            
            
           /***** This is to calculate Sub total*************/        
            decimal x=(-0.7816*isnotfulltime)+
                             (-0.2395*isnotgmail) + 
                             (90.06*countryval) + 
                             (102.3*experlev)-6.029;
              System.debug('===========QS_MBA==========>>>(-0.7816 *'+isnotfulltime+')+(-0.2395* '+isnotgmail+')+ (90.06* '+countryval+')+(102.3* '+experlev+')+(-6.029)');
                            
                             
              System.debug('=====***isnotfulltime->'+isnotfulltime);
              System.debug('=====***isnotgmail->'+isnotgmail);
              System.debug('=====***countrylev->'+countryval);
              System.debug('=====***experlev->'+experlev);
              System.debug('=====***subtotal->'+x);
              
              
          /***** This is to calculate total*************/                       
          Decimal probx=(1/(1+Math.exp(-x)));
          System.debug('=====***>'+probx);
          //return probx;  
          
       lead_score_respone lp=new lead_score_respone();
       lp.QS_MBA_probx=probx*100;
       
       System.debug('================='+lp.QS_MBA_probx); 
       if(probx>0.01375){
               lp.QS_MBA_Total=1;
           }else if(probx>0.00837){
               lp.QS_MBA_Total=2;
           }else if(probx>0.00528){
               lp.QS_MBA_Total=3;
           }else if(probx>0.00362){
               lp.QS_MBA_Total=4;
           }else if(probx>0.00245){
               lp.QS_MBA_Total=5;
           }else if(probx>0.00159){
               lp.QS_MBA_Total=6;
           }else if(probx>0.001){
               lp.QS_MBA_Total=7;
           }else if(probx>0.00056){
               lp.QS_MBA_Total=8;
           }else if(probx>0.00037){
               lp.QS_MBA_Total=9;
           }else{
               lp.QS_MBA_Total=10;
           }
       
        System.debug('================='+lp.QS_MBA_Total);
        
        
           map<Integer,string>lead_score = new map<Integer,string>{0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',9=>'J'};
           
           if(Region_list.containsKey(region_val)){
               integer i=0;
               for(Decimal D:region_list.get(region_val)){
                   if(probx>d){
                      lp.QS_Lead_score=lead_score.containskey(i)?lead_score.get(i):'';
                      break; 
                   }i++;                   
               }            
            }
       System.debug('================='+lp.QS_Lead_score); 
       return lp;   
                 
    }

/***********************QS_MA_Model***********************************************************************/
    /*--------------------- QS MA MODEL (JIRA NO:692)------------------------------*/
    public static Decimal QS_MA_model(string pgmstart,string subject,string nationality,string study_mode,string studylevel,string region1,string region2,string region3,string region4,string region5,string greregion)
    {
        Map<String,Integer> Pgm_start_map=new Map<String,Integer>{'within 6 months'=>1,'6 months to one year'=>2,'more than one year'=>3,
                                                              'under 6 months'=>1,'within 1 year'=>2,'within 2 years'=>3};
        integer subjcat = 0;
        Map<String,Integer> Subject_Area_map=new Map<String,Integer>{'business/management'=>1,'computing/information technology'=>2,
                                                                 'finance/accounting'=>3,'law/legal studies'=>4,
                                                                 'economics'=>5,'electronic/electrical engineering'=>6,
                                                                 'marketing'=>7,''=>8};
                                                                 
        Map<Integer,Decimal> Subject_Area_actual_map=new Map<Integer,Decimal>{0=>0.00242956086593901,1=>0.00914694770332074,2=>0.000386100386100386,
                                                                    3=>0.00498960498960499,4=>0.000562113546936481,
                                                                    5=>0.00256904303147078,6=>0.000711237553342817,
                                                                    7=>0.00369549150036955,8=>0.00300036927621861};                                                           
        Integer nationcat =0; 
        Map<String,Integer> nationality_map=new Map<String,Integer>{'india'=>1,'colombia'=>2,'greece'=>3,'peru'=>4,'russia'=>5,
                                                                'ecuador'=>6,'italy'=>7,'united kingdom'=>8,'unspecified'=>9};
        
        Map<Integer,Decimal> nationality_actual_map=new Map<Integer,Decimal>{0=>0.00458288311785089,1=>0.00208539128525958,2=>0.00172711571675302,
                                                                    3=>0.00095625149414296,4=>0.00197795987567109,
                                                                    5=>0.00458565345561743,6=>0.000333444481493831,
                                                                    7=>0.00535654502845665,8=>0.00191717791411043,9=>0.000323310701584222};
        
        Map<String,Integer> mode_of_Study_map=new Map<String,Integer>{'ft'=>1,'pt'=>2,'dl'=>3};
        
        Map<String,Integer> level_of_Study_map=new Map<String,Integer>{'masters'=>1,'doctoral'=>2,'diploma'=>3,'phd'=>2,''=>4};
        
        Map<String,Integer> regioncode_map=new Map<String,Integer>{'asia'=>1,'australia and new ze'=>1,'australia and new zeland'=>1,'europe'=>2,'latin america'=>3,
                                                                'middle east and africa'=>2,'north america'=>4,'us and canada'=>4};
        
        Map<String,Integer> grecode_map=new Map<String,Integer>{'asia'=>1,'australia & oceania'=>1,'africa'=>2,'europe'=>2,'central america'=>3,
                                                                'south america'=>3,'canada'=>4,'united states of america'=>4,'usa'=>4};
        //*****Start_program section****
        string pgmval=(pgmstart==null||pgmstart=='')?'':(pgmstart.trim()==null?null:pgmstart.trim().toLowerCase());
        integer pgm_startval=Pgm_start_map.containskey(pgmval)?Pgm_start_map.get(pgmval):0;
        
        integer pgm_startval0=pgm_startval==0?1:0;
        integer pgm_startval1=pgm_startval==1?1:0;
        integer pgm_startval2=pgm_startval==2?1:0;
        
        //*****Subject Area section****
        string sub=(subject==null||subject=='')?'':(subject.trim()==null?null:subject.trim().toLowerCase());
        subjcat=Subject_Area_map.ContainsKey(sub)?Subject_Area_map.get(sub):0; 
        Decimal subject_val=Subject_Area_actual_map.get(subjcat);
        
        //*****Nationality Area section****
        string nat=(nationality==null||nationality=='')?'Unspecified':(nationality.trim()==null?'Unspecified':subject.trim().toLowerCase());
        nationcat=nationality_map.ContainsKey(nat)?nationality_map.get(nat):0; 
        Decimal nationality_val=nationality_actual_map.get(nationcat);
        
        //*****Study Mode section****
        string smode=(study_mode==null||study_mode=='')?'':(study_mode.trim()==null?null:study_mode.trim().toLowerCase());
        integer study_mode_val=mode_of_Study_map.containskey(smode)?mode_of_Study_map.get(smode):0;
        
        integer study_mode_val0=study_mode_val==0?1:0;
        integer study_mode_val1=study_mode_val==1?1:0;
        integer study_mode_val2=study_mode_val==2?1:0;
        
        //*****Study Level section****
        string study=(studylevel==null||studylevel=='')?'':(studylevel.trim()==null?null:studylevel.trim().toLowerCase());
        integer studylevelval=level_of_Study_map.containskey(study)?level_of_Study_map.get(study):0;
        
        integer studylevelval0=studylevelval==0?1:0;
        integer studylevelval1=studylevelval==1?1:0;
        integer studylevelval2=studylevelval==2?1:0;
        integer studylevelval3=studylevelval==3?1:0;
        
        //*****Region section****
        string reg1=(region1==null||region1=='')?'':(region1.trim()==null?null:region1.trim().toLowerCase());
        string reg2=(region2==null||region2=='')?'':(region2.trim()==null?null:region2.trim().toLowerCase());
        string reg3=(region3==null||region3=='')?'':(region3.trim()==null?null:region3.trim().toLowerCase());
        string reg4=(region4==null||region4=='')?'':(region4.trim()==null?null:region4.trim().toLowerCase());
        string reg5=(region5==null||region5=='')?'':(region5.trim()==null?null:region5.trim().toLowerCase());
        
        integer regioncode1=regioncode_map.containskey(reg1)?regioncode_map.get(reg1):5;
        integer regioncode2=regioncode_map.containskey(reg2)?regioncode_map.get(reg2):5;
        integer regioncode3=regioncode_map.containskey(reg3)?regioncode_map.get(reg3):5;
        integer regioncode4=regioncode_map.containskey(reg4)?regioncode_map.get(reg4):5;
        integer regioncode5=regioncode_map.containskey(reg5)?regioncode_map.get(reg5):5; 
        
        
        integer region5exist=(regioncode5 >0 && regioncode5 < 5)?1:0;
        integer region4exist=(regioncode4 >0 && regioncode5 < 4)?1:0;
        integer region3exist=(regioncode3 >0 && regioncode5 < 3)?1:0;
        integer region2exist=(regioncode2 >0 && regioncode5 < 2)?1:0;
        integer region1exist=(regioncode1 >0 && regioncode5 < 1)?1:0;
        
        integer regionsum =region1exist + region2exist + region3exist + region4exist + region5exist;
        
        string grereg=( greregion ==null || greregion =='')?'':(greregion.trim()==null?null:greregion.trim().toLowerCase()) ;
        integer grecode=grecode_map.containskey(grereg)?grecode_map.get(grereg):5;
        
        integer regmatch1 =(regioncode1 == grecode)?1:0;
        integer regmatch2 =(regioncode2 == grecode)?1:0;
        integer regmatch3 =(regioncode3 == grecode)?1:0;
        integer regmatch4 =(regioncode4 == grecode)?1:0;
        integer regmatch5 =(regioncode5 == grecode)?1:0;
        
        integer regmatchsum =regmatch1 + regmatch2 + regmatch3 + regmatch4 + regmatch5; 
        
        decimal regmatchproport =99;
        try
        {
            regmatchproport =regmatchsum/regionsum;
        }
        catch(Exception e)
        {
            system.debug(e);
            regmatchproport =99;
        }
        
        /*
        recode regmatchproport
         (sysmis = 99).
        execute.        
        */
        
        integer regproportcat = (regmatchproport == 99)?1:(regmatchproport == 1?2:(regmatchproport == 0?3:((regmatchproport > 0 && regmatchproport < 1)?4:0)));
                
        integer grecode1  =grecode==1?1:0;
        integer grecode2  =grecode==2?1:0;
        integer grecode3  =grecode==3?1:0;
        integer grecode4  =grecode==4?1:0;
        
        integer regproportcat1 =regproportcat ==1?1:0;
        integer regproportcat2 =regproportcat ==2?1:0;
        integer regproportcat3 =regproportcat ==3?1:0;
                
        Decimal total =   (0.7194*pgm_startval0) +(1.135*pgm_startval1) +(0.8611*pgm_startval2) +
                            (270.7*nationality_val) +(203.9*subject_val) +
                            (18.34*study_mode_val0) +(18.02*study_mode_val1) +(17.36*study_mode_val2) +
                            (0.4861*studylevelval0) +(1.644*studylevelval1) +(0.513*studylevelval2) +(0.3664*studylevelval3) +
                            (0.7978*grecode1) +(1.265* grecode2) +(0.153*grecode3) +(0.4764*grecode4) +
                            (-0.3774*regproportcat1) +(-1.222*regproportcat2) +(-0.4812*regproportcat3) + -27.62;
    
        Decimal probx=(1/(1+Math.exp(-total)));
        
        System.debug('===================***regionsum->'+regionsum);
        System.debug('=====================***regmatchsum->'+regmatchsum);
        System.debug('======================***regmatchproport->'+regmatchproport);
        System.debug('======================***total ->'+total);
        System.debug('======================***probx->'+probx);
        
        return probx;
    }
    
    
/**********************************SAT_Model**************************************************************/
    public static Decimal SAT_model(String Countries,String Yahoo,String age,String Region,Integer Major1,Integer Major2,Integer Major3,Integer Major4,Integer Major5){
    
        Decimal countryval;
        Integer agecat;
        Decimal regionval;
        Integer bizmajcat0=0;
        Integer bizmajcat1=0;
        Integer agecat1 = 0;
        Integer agecat2 = 0;
        Integer agecat3 = 0;
        Integer agecat4 = 0;
        Integer agecat5 = 0;
        
         /*********return value of Country***********/
        String ctryname=(Countries==null||Countries=='')?'':Countries.toLowerCase();   
        Map<String,Integer> ccat=new Map<string,Integer>{'united states'=>1,'india'=>2,'china'=>3,
                                                'egypt'=>4,'thailand'=>5,'united arab emirates'=>6,
                                                'lebanon'=>7,'saudi arabia'=>8,'singapore'=>9,
                                                'mexico'=>10,'korea south (rok)'=>11,'indonesia'=>12,
                                                'pakistan'=>13};
                                                
        Map<Integer,Decimal>ccatval=new Map<Integer,Decimal>{1=>0.000587335409495711,2 => 0.00239200787955537,
                                                    3 => 0.000592417061611374,4 => 0.00522594528127882, 5 => 0.00189465706707086,
                                                    6 => 0.00323101777059774, 7 => 0.000590318772136954, 8 => 0.00525624178712221,
                                                    9 => 0.00285714285714286, 10 => 0.00480384307445957, 11 => 0.0037243947858473,
                                                    12 => 0.004739336492891,13=>0.00689655172413793,14=>0.00766632713236477};
        
        countryval=ccatval.get(ccat.containsKey(ctryname)?ccat.get(ctryname):14);
        //Need to set a default value to countryval
        
        /*********return value of yahoo***********/
        Integer y=0;
            if((yahoo!=null&&yahoo!='') &&yahoo.trim()!=null && yahoo.tolowercase().endswith('@yahoo.com')){
                y=1;
                system.debug('==g=>'+yahoo);
            }
        
        
        /*********return value of age***********/
        Integer i=(age!=null&&age!='')?Integer.valueOf(age):0;
            if(i<=16){
                agecat=1;
                agecat1=1;
            }else if(i==17){
                agecat=2;
                agecat2=1;
            }else if(i==18){
                agecat=3;
                agecat3=1;
            }else if(i==19){
                agecat=4;
                agecat4=1;
            }else if(i==20){
                agecat=5;
                agecat5=1;
            }else{
                agecat=6;
            }
           
       
            
            
       /*************return region values**********/
       String cregion=(Region==null||Region=='')?'':Region.toLowerCase(); 
        
        
        Map<String,String>cty_region=new Map<String,String>{'algeria'=>'african region','angola'=>'african region','benin'=>'african region',
                                                    'botswana'=>'african region','burkina faso'=>'african region','burundi'=>'african region','cameroon'=>'african region',
                                                    'cape verde'=>'african region','central african republic'=>'african region','chad'=>'african region','comoros'=>'african region',
                                                    'congo'=>'african region','congo, democratic republic of the'=>'african region','cote d\'ivoire'=>'african region',
                                                    'djibouti'=>'african region','equatorial guinea'=>'african region','eritrea'=>'african region','ethiopia'=>'african region',
                                                    'gabon'=>'african region','gambia'=>'african region','ghana'=>'african region','guinea'=>'african region','guinea-bissau'=>'african region',
                                                    'ivory coast'=>'african region','kenya'=>'african region','lesotho'=>'african region','liberia'=>'african region','libya'=>'african region',
                                                    'madagascar'=>'african region','malawi'=>'african region','mali'=>'african region','mauritania'=>'african region','mauritius'=>'african region',
                                                    'morocco'=>'african region','mozambique'=>'african region','namibia'=>'african region','niger'=>'african region','nigeria'=>'african region',
                                                    'reunion'=>'african region','rwanda'=>'african region','sao tome and principe'=>'african region','senegal'=>'african region',
                                                    'seychelles'=>'african region','sierra leone'=>'african region','somalia'=>'african region','south africa'=>'african region',
                                                    'sudan'=>'african region','swaziland'=>'african region','tanzania'=>'african region','togo'=>'african region',
                                                    'tunisia'=>'african region','uganda'=>'african region','zambia'=>'african region','zimbabwe'=>'african region',
                                                    'australia'=>'asia and pacific rim region','bhutan'=>'asia and pacific rim region','brunei darussalam'=>'asia and pacific rim region',
                                                    'burma (myanmar)'=>'asia and pacific rim region','cambodia'=>'asia and pacific rim region','china'=>'asia and pacific rim region',
                                                    'cook islands'=>'asia and pacific rim region','fiji'=>'asia and pacific rim region','french polynesia'=>'asia and pacific rim region',
                                                    'guadeloupe'=>'asia and pacific rim region','hong kong'=>'asia and pacific rim region','indonesia'=>'asia and pacific rim region',
                                                    'japan'=>'asia and pacific rim region','kiribati'=>'asia and pacific rim region','korea, north (dpr)'=>'asia and pacific rim region',
                                                    'korea, south (rok)'=>'asia and pacific rim region','laos'=>'asia and pacific rim region','macao'=>'asia and pacific rim region',
                                                    'malaysia'=>'asia and pacific rim region','midway islands'=>'asia and pacific rim region','mongolia'=>'asia and pacific rim region',
                                                    'myanmar'=>'asia and pacific rim region','nauru'=>'asia and pacific rim region','new caledonia'=>'asia and pacific rim region',
                                                    'new zealand'=>'asia and pacific rim region','niue'=>'asia and pacific rim region','northern mariana islands'=>'asia and pacific rim region',
                                                    'palau'=>'asia and pacific rim region','papua new guinea'=>'asia and pacific rim region','philippines'=>'asia and pacific rim region',
                                                    'samoa'=>'asia and pacific rim region','singapore'=>'asia and pacific rim region','solomon islands'=>'asia and pacific rim region',
                                                    'taiwan'=>'asia and pacific rim region','thailand'=>'asia and pacific rim region','tonga'=>'asia and pacific rim region',
                                                    'tuvalu'=>'asia and pacific rim region','vanuatu'=>'asia and pacific rim region','vietnam'=>'asia and pacific rim region',
                                                    'alberta, canada'=>'canadian region','british columbia, canada'=>'canadian region','manitoba, canada'=>'canadian region',
                                                    'new brunswick, canada'=>'canadian region','newfoundland, canada'=>'canadian region','northwest territory, canada'=>'canadian region',
                                                    'nova scotia, canada'=>'canadian region','nunavut, canada'=>'canadian region','ontario, canada'=>'canadian region',
                                                    'prince edward island, canada'=>'canadian region','quebec, canada'=>'canadian region','saskatchewan, canada'=>'canadian region',
                                                    'yukon territory, canada'=>'canadian region','anguilla'=>'caribbean region','antigua & barbuda'=>'caribbean region',
                                                    'aruba'=>'caribbean region','bahamas'=>'caribbean region','barbados'=>'caribbean region','bermuda'=>'caribbean region',
                                                    'cayman islands'=>'caribbean region','cuba'=>'caribbean region','dominica'=>'caribbean region','dominican republic'=>'caribbean region',
                                                    'grenada'=>'caribbean region','haiti'=>'caribbean region','jamaica'=>'caribbean region','martinique'=>'caribbean region',
                                                    'montserrat'=>'caribbean region','netherlands antilles'=>'caribbean region','saint kitts and nevis'=>'caribbean region',
                                                    'saint lucia'=>'caribbean region','saint vincent and the grenadines'=>'caribbean region','trinidad and tobago'=>'caribbean region',
                                                    'turks and caicos islands'=>'caribbean region','virgin islands, british'=>'caribbean region','virgin islands, u.s.'=>'caribbean region',
                                                    'belize'=>'central american region','costa rica'=>'central american region','el salvador'=>'central american region',
                                                    'guatemala'=>'central american region','honduras'=>'central american region','mexico'=>'central american region',
                                                    'nicaragua'=>'central american region','panama'=>'central american region','albania'=>'central and eastern european region',
                                                    'belarus'=>'central and eastern european region','bosnia & herzegovina'=>'central and eastern european region',
                                                    'bulgaria'=>'central and eastern european region','croatia'=>'central and eastern european region',
                                                    'czech republic'=>'central and eastern european region','estonia'=>'central and eastern european region',
                                                    'hungary'=>'central and eastern european region','kazakhstan'=>'central and eastern european region',
                                                    'latvia'=>'central and eastern european region','lithuania'=>'central and eastern european region',
                                                    'macedonia (f.y.r.o.m.)'=>'central and eastern european region','moldova'=>'central and eastern european region',
                                                    'montenegro'=>'central and eastern european region','romania'=>'central and eastern european region',
                                                    'russia'=>'central and eastern european region','serbia'=>'central and eastern european region',
                                                    'slovakia'=>'central and eastern european region','slovenia'=>'central and eastern european region',
                                                    'ukraine'=>'central and eastern european region','uzbekistan'=>'central and eastern european region',
                                                    'afghanistan'=>'middle east and southern asia region','armenia'=>'middle east and southern asia region',
                                                    'azerbaijan'=>'middle east and southern asia region','bahrain'=>'middle east and southern asia region',
                                                    'bangladesh'=>'middle east and southern asia region','egypt'=>'middle east and southern asia region',
                                                    'georgia'=>'middle east and southern asia region','india'=>'middle east and southern asia region',
                                                    'iran'=>'middle east and southern asia region','iraq'=>'middle east and southern asia region',
                                                    'israel'=>'middle east and southern asia region','jordan'=>'middle east and southern asia region',
                                                    'kuwait'=>'middle east and southern asia region','kyrgyzstan'=>'middle east and southern asia region',
                                                    'lebanon'=>'middle east and southern asia region','maldives'=>'middle east and southern asia region',
                                                    'nepal'=>'middle east and southern asia region','oman'=>'middle east and southern asia region',
                                                    'pakistan'=>'middle east and southern asia region','palestinian territories'=>'middle east and southern asia region',
                                                    'qatar'=>'middle east and southern asia region','saudi arabia'=>'middle east and southern asia region',
                                                    'sri lanka'=>'middle east and southern asia region','syria'=>'middle east and southern asia region',
                                                    'tajikistan'=>'middle east and southern asia region','turkmenistan'=>'middle east and southern asia region',
                                                    'united arab emirates'=>'middle east and southern asia region','yemen'=>'middle east and southern asia region',
                                                    'argentina'=>'south american region','bolivia'=>'south american region','brazil'=>'south american region',
                                                    'chile'=>'south american region','colombia'=>'south american region','ecuador'=>'south american region',
                                                    'french guiana'=>'south american region','guyana'=>'south american region','paraguay'=>'south american region',
                                                    'peru'=>'south american region','suriname'=>'south american region','uruguay'=>'south american region',
                                                    'venezuela'=>'south american region','aaland islands'=>'western european region','andorra'=>'western european region',
                                                    'austria'=>'western european region','belgium'=>'western european region','cyprus'=>'western european region',
                                                    'denmark'=>'western european region','england'=>'western european region','faroe islands'=>'western european region',
                                                    'finland'=>'western european region','france'=>'western european region','germany'=>'western european region',
                                                    'gibraltar'=>'western european region','greece'=>'western european region','greenland'=>'western european region',
                                                    'holy see (vatican city)'=>'western european region','iceland'=>'western european region','ireland'=>'western european region',
                                                    'isle of man'=>'western european region','italy'=>'western european region','liechtenstein'=>'western european region',
                                                    'luxembourg'=>'western european region','malta'=>'western european region','monaco'=>'western european region',
                                                    'netherlands'=>'western european region','northern ireland'=>'western european region','norway'=>'western european region',
                                                    'poland'=>'western european region','portugal'=>'western european region','san marino'=>'western european region',
                                                    'scotland'=>'western european region','spain'=>'western european region','sweden'=>'western european region',
                                                    'switzerland'=>'western european region','turkey'=>'western european region','wales'=>'western european region',
                                                    'united states'=>'usregion','korea south (rok)'=>'asia and pacific rim region','burma (myanmar)'=>'middle east and southern asia region',
                                                    'macedonia (f.y.r.o.m.)'=>'central and eastern european region','congo democratic republic of'=>'african region',
                                                    'virgin islands british'=>'caribbean region','saint vincent and the grenadi'=>'caribbean region',
                                                    'united kingdom'=>'western european region','trinidad and tobago'=>'caribbean region',
                                                    'russian federation'=>'central and eastern european region','macedonia the former yugoslavia'=>'central and eastern european region',
                                                    'canada'=>'usregion','tanzania united republic of'=>'african region','bosnia and herzegovina'=>'central and eastern european region',
                                                    'korea south (rok)'=>'asia and pacific rim region','viet nam'=>'asia and pacific rim region','united states'=>'usregion'};

                                                    
        Map<String,Decimal>cty_val=new Map<String,Decimal>{'central and eastern european region'=> 0.0125786163522013,'western european region'=> 0.0116102978293791,
                                        'south american region'=> 0.0102511532547412,'african region'=> 0.00849256900212314,
                                        'caribbean region'=> 0.0066079295154185,'central american region'=> 0.00516674495068107,
                                        'middle east and southern asia region'=> 0.00372999015697042,'asia and pacific rim region'=> 0.00186477382098171,
                                        'usregion'=> 0.000587335409495711};
        
        regionval=cty_val.get(cty_region.containsKey(cregion)?cty_region.get(cregion):'');    
        //Need to set a default value to regional value. 
        
        /**************Major Values**********************/  
        
        Set<Integer>major_val=new set<Integer>{200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,225,230,235};
        
            Integer bizmaj1=Major_val.contains(Major1)?1:0;
            Integer bizmaj2=Major_val.contains(Major2)?1:0;
            Integer bizmaj3=Major_val.contains(Major3)?1:0;
            Integer bizmaj4=Major_val.contains(Major4)?1:0;
            Integer bizmaj5=Major_val.contains(Major5)?1:0;
        
        Integer bizmajorchoice = (bizmaj1==1|| bizmaj2==1|| bizmaj3==1|| bizmaj4==1|| bizmaj5==1)?1:0;
        
        Integer bizmajcat = 0;
            if(bizmaj1==1){
            bizmajcat=1;
        }
        if(bizmaj1==0 && bizmajorchoice==1){
            bizmajcat=2;
        }
        
        
        bizmajcat0= bizmajcat==0?1:0;
        bizmajcat1= bizmajcat==1?1:0;
        
        
        System.debug('=====***countryval->'+countryval);
        System.debug('=====***regionval->'+regionval);
        System.debug('=====***bizmajcat0->'+bizmajcat0);
        System.debug('=====***bizmajcat1->'+bizmajcat1);
        System.debug('=====***agecat1->'+agecat1);
        System.debug('=====***agecat2->'+agecat2);
        System.debug('=====***agecat3->'+agecat3);
        System.debug('=====***agecat4->'+agecat4);
        System.debug('=====***agecat5->'+agecat5);
        
        /***** This is to calculate x value*************/ 
        
        Decimal x=(240.0*countryval)+
                    (67.17*regionval)+
                    (-0.678 * bizmajcat0) + 
                    (0.8592 * bizmajcat1) + 
                    (-2.136 * agecat1) + 
                    (-0.6103 * agecat2) + 
                    (-0.3404 * agecat3) + 
                    (-0.1245 * agecat4) + 
                    (-0.2857 * agecat5) + 
                    (-0.6481 * y) - 6.707;
        
        
        System.debug('=====***y->'+y);
        System.debug('=====***x->'+x);
        
        /***** This is to calculate Probability value*************/
        
        Decimal probx=(1/(1+Math.exp(-x)));  
         System.debug('=====***x->'+probx);      
        return probx;
        
    } 
 
    
    
}