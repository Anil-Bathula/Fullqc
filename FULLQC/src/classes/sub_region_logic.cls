/*
    Developer : Harsha Simha
    Date      : 09/12/2014                
    purpose   : This class returns the subregion value based on its Region,Country Of Residence and Program.
    Test Class: lcomments_Test(85%)
    Modified By :Anil.B 19/2/2015 ---changed "Lat Am" to "LatAm"
    Modified By :Anil.B 24/02/2015--Changed LatAm to LON EUR for Program EMBA and
    All LatAm + North AM Bos + North AM SFO Region + NorthAM base on mail: Updated Sub-region Matrix
*/
public with sharing class sub_region_logic 
{
    public static string get_Subregion(string region,string COR,string program)
    {
        region=region==null?'no_reg':region;
        program= program==null?'no_pgm':program;
        COR= COR==null?'no_cor':cor;
        
        string subregion;
        
        if(region.equalsIgnoreCase('Africa'))
        {   //Africa Region
            subregion='MEA';            
        }
        else if(region.equalsIgnoreCase('Asia'))
        {   //Asia Region
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='Greater China';
            }
            else
            {
                if(cor.equalsIgnoreCase('China')||cor.equalsIgnoreCase('Taiwan')||cor.equalsIgnoreCase('Hong Kong')||cor.equalsIgnoreCase('Macau') )
                {
                    subregion='Greater China';
                }
                else if(cor.equalsIgnoreCase('Japan')||cor.equalsIgnoreCase('Korea')
                        || cor.equalsIgnoreCase('Korea (North)')||cor.equalsIgnoreCase('Korea (South)'))
                {
                    subregion='JP/KR';
                }
                else
                {
                    subregion='SEA';
                }
            }
        }
        else if(region.equalsIgnoreCase('South Asia'))
        {   //South Asia Region
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='MEA';
            }
            else{
                subregion='South Asia';
            }
        }
        else if(region.equalsIgnoreCase('Lat Am'))       
        {   //LatAm Region
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='LON EUR';
            }
            else
            {
                if(cor.equalsIgnoreCase('Brazil'))
                {
                    subregion='Brazil';
                }
                else
                {
                    subregion='LatAm';
                }
            }
        }
        else if(region.equalsIgnoreCase('LON EUR'))
        {   //London Region
            subregion='LON EUR';
        }
        else if(region.equalsIgnoreCase('LUZ EUR'))
        {   ///Swiss Region
            subregion='LUZ EUR';
        }
        else if(region.equalsIgnoreCase('Middle East'))
        {   //MEA Region
            subregion='MEA';
        }
        else if(region.equalsIgnoreCase('North Am'))
        {   //North america Region
            if(program.equalsIgnoreCase('BBA'))
            {
                if(cor.equalsIgnoreCase('Puerto Rico')||cor.equalsIgnoreCase('British Columbia')||cor.equalsIgnoreCase('California')||
                cor.equalsIgnoreCase('Hawaii')||cor.equalsIgnoreCase('Nevada')||cor.equalsIgnoreCase('Arizona')||cor.equalsIgnoreCase('Alaska')||
                cor.equalsIgnoreCase('Oregon')||cor.equalsIgnoreCase('Washington'))
                {
                    subregion='North Am SFO';                   
                }
                else
                {
                    subregion='North Am BOS';
                }
            }
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='LON EUR';
            }
        }
        else if(region.equalsIgnoreCase('North Am BOS'))
        {   //North america Region
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='LON EUR';
            }
            else
            {   
                subregion='North Am BOS';
            }
        }
        else if(region.equalsIgnoreCase('North Am SFO'))
        {   //North america Region
            if(program.equalsIgnoreCase('EMBA'))
            {
                subregion='LON EUR';
            }
            else
            {
                subregion='North Am SFO';
            }
        }
        
        return subregion;
    }
}