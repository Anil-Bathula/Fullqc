global class FinStatementBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    private   Id             m_NonBBAId;
    private   Id             m_BBAId ;
    private   FinStatementExtract__c m_FinStatementExtract;
    private   List<id>       errorIds =  new List<id> ();
    private   Id             m_FolderId;
    private   String         m_FolderName;
    private   String         m_Query;
    
    public String Query {
        get  { return m_Query; }
        set  { m_Query = value; }
    }
    
    public Id NonBBAId {
        get  { return m_NonBBAId; }
        set  { m_NonBBAId = value; }
    }

    public Id BBAId {
        get  { return m_BBAId; }
        set  { m_BBAId = value; }
    }

    public Id FolderId {
        get  { return m_FolderId; }
        set  { m_FolderId = value; }
    }


    public String FolderName {
        get  { return m_FolderName; }
        set  { m_FolderName = value; }
    }
 
    @testVisible
    private FinStatementBatch() {
        //use static run() method
    }

    public database.querylocator start( Database.BatchableContext BC )  {
        // Status
        m_FinStatementExtract = new FinStatementExtract__c(Status__c = 'Start');
        insert m_FinStatementExtract;
        
        return Database.getQueryLocator( this.query );
    }

    public void execute( Database.BatchableContext BC, List<Opportunity_Finance__c> opportunityFinances ) {
        Id contactId = opportunityFinances[0].Opportunity__r.Contact__c;
        Id recordTypeId = opportunityFinances[0].recordTypeId; 
        Boolean nonBbaUnlock = opportunityFinances[0].Unlock_Student_Financial_Information__c;
        String studentName = opportunityFinances[0].Opportunity__r.Contact__r.Name;
        studentName = cleanName(studentName);
        String studentId = opportunityFinances[0].Opportunity__r.Contact__r.Student_ID__c;
        String programName = opportunityFinances[0].Campus_Program__c;
        programName = cleanName(programName);
        
        List<Map<String,Object>> calloutInstances = new List<Map<String,Object>>();
        
        // 1. BBA
        if (recordTypeId == this.BBAId) {
            Integer year = 1;
            while (year <= 5) {
                Map<String,Object> keyToValue = new Map<String,Object>{
                    'ContactId' => contactId,
                    'Url' => Page.Fin_Statement_bba.getUrl() + '?contactId=' + contactId + '&buttn=bba_yr' + year,
                    'Year' => 'Year' + year,
                    'Type' => 'BBA',
                    'FileId' => null,
                    'FinStatementRef' => null,
                    'Data'  => null
                };
                
                if (opportunityFinances[0].BBA_Unlock_Student_Financial_Information__c.contains('Year'+year)) { 
                    calloutInstances.add(keyToValue);
                }
                year++;
            }
        }
         
        
        // 2. non BBA
        if (recordTypeId == this.NonBBAId) {
        //    if (opportunityFinances[0].Unlock_Student_Financial_Information__c ) {
                Map<String,Object> keyToValue = new Map<String,Object>{
                    'ContactId' => contactId,
                    'Url' =>  Page.Fin_Statement_3page.getUrl() + '?contactid=' + contactId,
                    'Year' => 'NONBBA' ,
                    'Type' => 'NONBBA',
                    'FileId' => null,
                    'FinStatementRef' => null,
                    'Data'  => null
                };
                calloutInstances.add(keyToValue);
      ///      }
        }
        
        // 3. callout
        for (Map<String,Object> calloutInstance : calloutInstances) {
            String url = (String) calloutInstance.get('Url');
            
            Blob data =Blob.valueOf('Test Blob');
            if (!Test.isRunningTest()) {
                BatchPdf.PageReference pr = new BatchPdf.PageReference(url);
                data = pr.getContentAsPdf();  
            }
            calloutInstance.put('Data' , data);
        }
        
        // 4. persist ( SOQL IN LOOP - (5 x 4) = 20  so no worries )
        for (Map<String,Object> calloutInstance : calloutInstances) {
            Blob  data = (Blob) calloutInstance.get('Data');
            
            FinStatementRef__c finStatementRef = new FinStatementRef__c(FinStatementExtract__c = m_FinStatementExtract.Id);
            insert finStatementRef;
            finStatementRef = [SELECT Id, Name FROM FinStatementRef__c WHERE Id = :finStatementRef.Id LIMIT 1];
            
            String theYear  = (String) calloutInstance.get('Year');
            theYear = theYear.toUpperCase();
            String theType  = (String) calloutInstance.get('Type');
            
            
			String name = finStatementRef.NAme.replace('-','') ;
            String developerName = name + '_' + studentName + '_' + studentId + '_' + programName + '_' + theYear;
            String description = developerName;
            
            Document document = new Document(
                Name =  developerName  + '.pdf',   
                Description = developerName,
                DeveloperName = developerName,
                Body = data,
                FolderId = this.FolderId // [SELECT Id FROM Folder WHERE Name = 'BatchPDF'].Id
            );
            insert document;

            finStatementRef.FileId__c = document.Id; //'015J0000000MERkIAO'; ///document.Id;
            update finStatementRef;       
        }
    }


    public void finish( Database.BatchableContext BC ) {
        // Status
        m_FinStatementExtract.Status__c = 'Finish';
        update m_FinStatementExtract;
    }


    global static void run(  String query ) {
        //find existing jobs
        List<AsyncApexJob> existingJobs = [
            SELECT ApexClassId, JobType, Status, ExtendedStatus, JobItemsProcessed, TotalJobItems, LastProcessed
            FROM AsyncApexJob
            WHERE ApexClass.Name = :FinStatementBatch.class.getName()
            AND JobType IN ('BatchApex', 'ScheduledApex')
            AND Status IN ('Queued', 'Processing', 'Preparing')
        ];
        
        if (! Test.isRunningTest()) {
        	if (!existingJobs.isEmpty()) {System.assert(false, 'Batch already running!');}
        }
        
        Map<String, Id> graduateRecordTypeNameToGraduateRecordTypeId = getGraduateRecordTypeNameToGraduateRecordTypeId();

         
         FinStatementBatch batch  = new FinStatementBatch();
         batch.NonBBAId          = graduateRecordTypeNameToGraduateRecordTypeId.get('Non_BBA_Finance'); // TODO
         batch.BBAId             = graduateRecordTypeNameToGraduateRecordTypeId.get('BBA_Finance'); // TODO
         batch.FolderName        = 'BatchPDF';
         batch.FolderId          = getFolderId(batch.FolderName);
         batch.Query             = query;
        if (! Test.isRunningTest()) {
			ID batchId = Database.executeBatch( batch, 1 );    
        }
    }



    public static Boolean tooManyRunning() {
        Integer jobs = [Select
        count()
        From AsyncApexJob
        Where JobType = 'BatchApex'
        and ( Status = 'Queued' or Status = 'Processing' )];

        return (jobs > 4 ) ;
    }
    
    @testVisible
    private  static Id getFolderId(String folderName) {
        List<Folder> folders = [SELECT Id FROM Folder WHERE Name = :folderName LIMIT 1];
        if (folders.isEmpty()) System.assert(false,'Folder with Name=['+folderName+'] does not exist');
         return folders[0].Id;
    }

 
    public static Map<String, Id> getGraduateRecordTypeNameToGraduateRecordTypeId () {
        List<RecordType> graduateRecordTypes = [
            SELECT Id, Name, DeveloperName
            FROM RecordType
            WHERE DeveloperNAme IN ( 'Non_BBA_Finance' , 'BBA_Finance')
        ];
        Map<String, Id> graduateRecordTypeNameToGraduateRecordTypeId = new Map<String, Id>();
        for (RecordType  graduateRecordType : graduateRecordTypes) {
            graduateRecordTypeNameToGraduateRecordTypeId.put(graduateRecordType.DeveloperName, graduateRecordType.Id);
        }
        return graduateRecordTypeNameToGraduateRecordTypeId;
    }
    
    @testVisible
	private static String cleanName(string nameIn) {
        nameIn = String.IsBlank(nameIn) ? '' : nameIn;
        Set<String> validChars = new Set<String>{
            'A',
            'B',
            'C',
            'D',
            'E',
            'F',
            'G',
            'H',
            'I',
            'J',
            'K',
            'L',
            'M',
            'N',
            'O',
            'P',
            'Q',
            'R',
            'S',
            'T',
            'U',
            'V',
            'W',
            'X',
            'Y',
            'Z',
            '-',
            ' '};
        nameIn = nameIn.toUpperCase();
        Integer len = nameIn.length();
        Integer i = 0;
        String nameOut = '';
        while (i <= (len-1)) {
            String v = nameIn.substring(i, i+1);
            if (validChars.contains(v)) {
             	nameOut = nameOut + v;   
            }
            i++;    
        } 
        
        if (nameOut.trim().length() == 0) nameOut = 'UNKNOWN';
		nameOut = nameOut.replaceAll(' ','_'); 
        nameOut = nameOut.replaceAll('-','_');
        return nameOut;
    }  
}