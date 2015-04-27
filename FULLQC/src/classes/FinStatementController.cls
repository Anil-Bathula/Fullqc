global class FinStatementController {
	private static final String nonBBA = 'non-bba';
     
    @testVisible
    public string ThePreviewMessage {get; set;}
    
    public string TheTerm {get; set;}
    public string TheStage  {get; set;}
    public String TheProgramName  {get; set;}
   // public Boolean IsNonBBA  {get; set;}
    public List<SelectOption> AllStages {get; set; }
    public List<SelectOption> SelectedStages { get; set; }
    public List<SelectOption> AllBbaUnLockedYears {get; set; }
    public List<SelectOption> SelectedBbaUnLockedYears { get; set; }
    @testVisible
    public String  TheManifestContent {get; set;}
    @testVisible
    public List<FinStatementExtract__c> FinStatementExtracts {get; set;}

    public FinStatementController() {
    // TODO ::      getGraduateRecordTypeNameToGraduateRecordTypeId.KeySet(); ==> Non_BBA_Finance' , 'BBA_Finance
        this.AllStages = getStagesAsSelectOptions();
        this.SelectedStages = new List<SelectOption>();
        this.AllBbaUnLockedYears = getBbaUnLockedYearsAsSelectOptions();
        this.SelectedBbaUnLockedYears = new List<SelectOption>();
      //  this.IsNonBBA = true;
        doFinStatementExtracts();
    }

    public  void fetch() {
        Id extractId = Apexpages.currentpage().getparameters().get('Id');
        List<FinStatementRef__c> finStatementRefs = [
            SELECT FileId__c
            FROM FinStatementRef__c
            WHERE FinStatementExtract__c = :extractId
        ];
        Set<Id> documentIds = new Set<Id>();
        for (FinStatementRef__c finStatementRef : finStatementRefs) {
            documentIds.add(finStatementRef.FileId__c);
        }
        List<Document> documents = new List<Document>([
            SELECT DeveloperName, FolderId, Id
            FROM Document
            WHERE Id IN :documentIds
        ]);
        Set<Id> folderIds = new Set<Id>();
        for (Document document : documents) {
            folderIds.add(document.FolderId);
        }
        Map<Id, Folder> folderIdToFolder = new Map<Id, Folder>([
            SELECT Id, DeveloperName
            FROM Folder
            WHERE Id IN :folderIds
        ]);

        List<String> members = new List<String>();
        members.add('<?xml version="1.0" encoding="UTF-8"?>');
        members.add('<Package xmlns="http://soap.sforce.com/2006/04/metadata">');
        members.add('<types>');
        members.add('<name>Document</name>');
        for (Document document : documents) {
            String folderName = folderIdToFolder.get(document.FolderId).DeveloperName;
            String developerName = document.DeveloperName;
            members.add(
                String.format('<members>{0}/{1}.pdf</members>',new List<String>{folderName,developerName})
            );
        }
        members.add('</types>');
        members.add('<version>32.0</version>');
        members.add('</Package>');

        this.TheManifestContent  = String.join(members,'\n');
    }

    public void doFinStatementExtracts() {
        this.FinStatementExtracts = [
            SELECT Id, Name, CreatedDate, Status__c
            FROM FinStatementExtract__c
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];
    }

    public  List<SelectOption> getTerms() {
        return getTermsAsSelectOptions();
    }


    public  List<SelectOption> getProgramNames()  {
        return getProgramNamesAsSelectOptions();
    }

    public  List<SelectOption> getStages()  {
        return getStagesAsSelectOptions();
    }


    public  List<SelectOption> getBbaUnLockedYears()  {
        return getBbaUnLockedYearsAsSelectOptions();
    }


    @testVisible
    private List<SelectOption> getStagesAsSelectOptions() {
        List<SelectOption> optionList = new List<SelectOption>();
        
       Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple) {
           optionList.add(new SelectOption(f.getLabel(), f.getValue()));
       }
        
       //// optionList.add(new SelectOption('Qualified Lead', 'Qualified Lead'));
       //// optionList.add(new SelectOption('In Progress', 'In Progress'));
       //// optionList.add(new SelectOption('Partial Application', 'Partial Application'));
       //// optionList.add(new SelectOption('Waiting for Review', 'Waiting for Review'));
       //// optionList.add(new SelectOption('Accepted', 'Accepted'));
       //// optionList.add(new SelectOption('Conditionally Accepted', 'Conditionally Accepted'));
       //// optionList.add(new SelectOption('Rejected', 'Rejected'));
       //// optionList.add(new SelectOption('Soft Rejected', 'Soft Rejected'));
       //// optionList.add(new SelectOption('Withdrawn', 'Withdrawn'));
       //// optionList.add(new SelectOption('Confirmed', 'Confirmed'));
       //// optionList.add(new SelectOption('Conditionally Confirmed', 'Conditionally Confirmed'));
       //// optionList.add(new SelectOption('Soft Rejected Confirmed', 'Soft Rejected Confirmed'));
       //// optionList.add(new SelectOption('Cancellation', 'Cancellation'));
       //// optionList.add(new SelectOption('Deferral', 'Deferral'));
       //// optionList.add(new SelectOption('Accommodation Chosen', 'Accommodation Chosen'));
       //// optionList.add(new SelectOption('Deposit Paid', 'Deposit Paid'));
       //// optionList.add(new SelectOption('Fee Fully Paid', 'Fee Fully Paid'));
       //// optionList.add(new SelectOption('Waitlisted', 'Waitlisted'));
    
        return optionList;
    }
    
    @testVisible
    private List<SelectOption> getBbaUnLockedYearsAsSelectOptions() {
        //// https://c.cs21....&buttn=bba_yr3
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption(nonBBA, nonBBA));
        optionList.add(new SelectOption('Year1', 'Year1'));
        optionList.add(new SelectOption('Year2', 'Year2'));
        optionList.add(new SelectOption('Year3', 'Year3'));
        optionList.add(new SelectOption('Year4', 'Year4'));
        optionList.add(new SelectOption('Year5', 'Year5'));
        return optionList;
    }

    @testVisible
    private List<SelectOption> getTermsAsSelectOptions() {
        // Opportunity == Application
        List<SelectOption> optionList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Start_Term__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            optionList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //// optionList.add(new SelectOption('January 2013', 'January 2013'));
        //// optionList.add(new SelectOption('January 2014', 'January 2014'));
        //// optionList.add(new SelectOption('September 2014', 'September 2014'));
        //// optionList.add(new SelectOption('January 2015', 'January 2015'));
        //// optionList.add(new SelectOption('September 2015', 'September 2015'));
        //// optionList.add(new SelectOption('January 2016', 'January 2016'));
        //// optionList.add(new SelectOption('September 2016', 'September 2016'));
        //// optionList.add(new SelectOption('January 2017', 'January 2017'));
        //// optionList.add(new SelectOption('September 2017', 'September 2017'));
        //// optionList.add(new SelectOption('January 2018', 'January 2018'));
        //// optionList.add(new SelectOption('September 2018', 'September 2018'));
        //// optionList.add(new SelectOption('September 2013', 'September 2013'));
        //// optionList.add(new SelectOption('January 2012', 'January 2012'));
        //// optionList.add(new SelectOption('September 2012', 'September 2012'));
        //// optionList.add(new SelectOption('September 2011', 'September 2011'));
        
        return optionList;
    }

    @testVisible
    private List<SelectOption> getProgramNamesAsSelectOptions() {
        List<SelectOption> optionList = new List<SelectOption>();
        
         Schema.DescribeFieldResult fieldResult = Opportunity_Finance__c.Campus_Program__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry f : ple) {
             optionList.add(new SelectOption(f.getLabel(), f.getValue()));
         }

        ///// optionList.add(new SelectOption('Boston-MBA', 'Boston-MBA'));
        ///// optionList.add(new SelectOption('San Francisco-MBA', 'San Francisco-MBA'));
        ///// optionList.add(new SelectOption('Dubai-MBA', 'Dubai-MBA'));
        ///// optionList.add(new SelectOption('London-MBA', 'London-MBA'));
        ///// optionList.add(new SelectOption('Shanghai-MBA', 'Shanghai-MBA'));
        ///// optionList.add(new SelectOption('Dubai-EMBA', 'Dubai-EMBA'));
        ///// optionList.add(new SelectOption('London-EMBA', 'London-EMBA'));
        ///// optionList.add(new SelectOption('Shanghai-EMBA', 'Shanghai-EMBA'));
        ///// optionList.add(new SelectOption('Boston-MIB', 'Boston-MIB'));
        ///// optionList.add(new SelectOption('Dubai-MIB', 'Dubai-MIB'));
        ///// optionList.add(new SelectOption('San Francisco-MIB', 'San Francisco-MIB'));
        ///// optionList.add(new SelectOption('London-MIB', 'London-MIB'));
        ///// optionList.add(new SelectOption('Shanghai-MIB', 'Shanghai-MIB'));
        ///// optionList.add(new SelectOption('Boston-MIM', 'Boston-MIM'));
        ///// optionList.add(new SelectOption('London-MIM', 'London-MIM'));
        ///// optionList.add(new SelectOption('San Francisco-MIM', 'San Francisco-MIM'));
        ///// optionList.add(new SelectOption('London-MFIN', 'London-MFIN'));
        ///// optionList.add(new SelectOption('San Francisco-MFIN', 'San Francisco-MFIN'));
        ///// optionList.add(new SelectOption('San Francisco-MSE', 'San Francisco-MSE'));
        ///// optionList.add(new SelectOption('London-BBA', 'London-BBA'));
        ///// optionList.add(new SelectOption('San Francisco-BBA', 'San Francisco-BBA'));
        ///// optionList.add(new SelectOption('Dubai-EMBAm', 'Dubai-EMBAm'));
        ///// optionList.add(new SelectOption('Shanghai-EMBAm', 'Shanghai-EMBAm'));
        ///// optionList.add(new SelectOption('London-EMBAm', 'London-EMBAm'));
        ///// optionList.add(new SelectOption('London-Accommodation', 'London-Accommodation'));
        ///// optionList.add(new SelectOption('San Francisco-Accommodation', 'San Francisco-Accommodation'));
        ///// optionList.add(new SelectOption('Miami-EMBAm', 'Miami-EMBAm'));
    
        return optionList;
    }
 
    global static void deleteAllFinStatementExtract ( ) {
        for (FinStatementExtract__c finStatementExtract :[SELECT Id  FROM  FinStatementExtract__c]) {
        	deleteFinStatementExtract (finStatementExtract.Id);      
        }  
    }
            
    global static void deleteFinStatementExtract (Id finStatementExtractId ) {
        List<FinStatementRef__c> finStatementRefs = [SELECT Id, FileId__c  FROM  FinStatementRef__c  WHERE FinStatementExtract__c = :finStatementExtractId];
        List<Id> documentIds = new List<Id>();
        for (FinStatementRef__c finStatementRef : finStatementRefs) {
            documentIds.add((ID)finStatementRef.FileId__c);
        }
        List<Document> documents = [SELECT Id  FROM  Document  WHERE Id IN :documentIds];
        List<FinStatementExtract__c> finStatementExtract = [SELECT Id  FROM  FinStatementExtract__c  WHERE Id   = :finStatementExtractId];
        delete  documents ;
        delete  finStatementRefs ;
        delete  finStatementExtract ;
    }
    
     
    
    public void Preview() {
        List<String> stages = new List<String>();
        for (SelectOption selectedStage :  this.SelectedStages) {
           stages.add(selectedStage.getValue());
        }
        List<String> bbaUnLockedYears = new List<String>();
        Boolean isNonBBA =  false;
        for (SelectOption selectedBbaUnLockedYear :  this.selectedBbaUnLockedYears) {
            if (selectedBbaUnLockedYear.getValue() != nonBBA) {
            	bbaUnLockedYears.add(selectedBbaUnLockedYear.getValue());    
            }
            if (selectedBbaUnLockedYear.getValue() == nonBBA) {
            	isNonBBA =  true;   
            }    
        }

       this.ThePreviewMessage  = getQuery(
           stages, 
           bbaUnLockedYears, 
           isNonBBA, 
           this.theTerm, 
           this.theProgramName
       );
 
    }
    

    public void Extract() {
        List<String> stages = new List<String>();
        for (SelectOption selectedStage :  this.SelectedStages) {
           stages.add(selectedStage.getValue());
        }
        List<String> bbaUnLockedYears = new List<String>();
        Boolean isNonBBA =  false;
        for (SelectOption selectedBbaUnLockedYear :  this.selectedBbaUnLockedYears) {
            if (selectedBbaUnLockedYear.getValue() != nonBBA) {
            	bbaUnLockedYears.add(selectedBbaUnLockedYear.getValue());    
            }
            if (selectedBbaUnLockedYear.getValue() == nonBBA) {
            	isNonBBA =  true;   
            }    
        }

       String query = getQuery(
           stages, 
           bbaUnLockedYears, 
           isNonBBA, 
           this.theTerm, 
           this.theProgramName
       );
        
		FinStatementBatch.run( query);
    }

   @testVisible
   private static String getQuery(
       List<String> stages, 
       List<String> bbaUnLockedYears, 
       Boolean isNonBBA, 
       String theTerm, 
       String theProgramName
   ){
       	// record type ids
        Map<String, Id> graduateRecordTypeNameToGraduateRecordTypeId =  
            FinStatementBatch.getGraduateRecordTypeNameToGraduateRecordTypeId();
		Id nonBBAId = graduateRecordTypeNameToGraduateRecordTypeId.get('Non_BBA_Finance');
 		Id bbaId    = graduateRecordTypeNameToGraduateRecordTypeId.get('BBA_Finance');
       
        List<String> bbaMatriculatedYears = new List<String>();
        for (String bbaUnLockedYear  : bbaUnLockedYears) {
        	bbaMatriculatedYears.add(bbaUnLockedYear.replace('Year','Year ')); // wtf !!! 
        }
        boolean isBba     = (bbaUnLockedYears.size() > 0);
        
		string bbaUnlockedYearsClause  = ' \'' + String.join(bbaUnLockedYears,'\',\'') + '\' ';
		string bbaMatriculatedYearsClause  = ' \'' + String.join(bbaMatriculatedYears,'\',\'') + '\' ';  
       
        string bbaClause  = ' BBA_Unlock_Student_Financial_Information__c  INCLUDES (' + bbaUnlockedYearsClause + ' ) ' +
                            ' AND ' +
                            ' BBA_Matriculated_Years_1_to_4__c  INCLUDES (' + bbaMatriculatedYearsClause + ' ) ' +
                            ' AND ' +
                            ' RecordTypeId =  '  + '\'' + bbaId + '\' ';
 
        String nonBbaClause = '  Unlock_Student_Financial_Information__c   = true ' + 
                              '  AND ' +
                              '  RecordTypeId =  '  + '\'' + nonBBAId + '\' ';
        
        String extraClause = '';
        if (isBba && isNonBba) {
           extraClause = ' AND  ( ( ' + bbaClause + ' ) OR ( '  + nonBbaClause + ' ) ) '; 
        }
        if (isBba && !isNonBba) {
           extraClause = ' AND   ( ' + bbaClause + ' )  '; 
        }
        if (!isBba && isNonBba) {
           extraClause = ' AND   ( ' + nonBbaClause + ' )  '; 
        }
        if (!isBba && !isNonBba) {
          // no work
        }

       string stagesClause = ' \'' + String.join(stages,'\',\'') + '\' ';
       stagesClause = (stages.size() > 0 ) ? ' AND Stage__c IN  (' + stagesClause + ' ) ' : '';
       
       
        string query  = ' SELECT Opportunity__r.Contact__r.Name, Opportunity__r.Contact__r.Student_ID__c, ' +
                        '        Campus_Program__c, BBA_Unlock_Student_Financial_Information__c, BBA_Matriculated_Years_1_to_4__c, ' +
                        '        Unlock_Student_Financial_Information__c, Start_Term__c, RecordTypeId, Stage__c   ' +
                        ' FROM Opportunity_Finance__c  ' +
                        ' WHERE ' + 
                        '   Start_Term__c = ' + '\'' + theTerm + '\'' +
                        ' AND  Campus_Program__c = ' + '\'' + theProgramName + '\'' +
                                  + stagesClause +
                                  + extraClause  +
                        ' ';           ///-- TESTING ONLY : ' LIMIT 20 ';

        return   query  ;
    }

}