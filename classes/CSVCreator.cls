public class CSVCreator  {
	@AuraEnabled public CSVObject csvObj  ;
    
    private static List<String> separateCommas(String input){
        List<String> results = input.split(',');

        for(String result : results) {
            result = result.trim();
        }

        return results;
    }

    @AuraEnabled
    public static CSVObject getCSVObject(String csv_str) {
        List<String> lines_raw = csv_str.split('\n');
        List<String> headers_raw = separateCommas(lines_raw[0]);
        List<List<String>> lines = new List<List<String>>();
        List<CSVHeader> headers = new List<CSVHeader>();

        lines_raw.remove(0);

        //Handling fields with commas

        for(String line : lines_raw) {
            List<String> line_sep = separateCommas(line);
            List<String> fields = new List<String>();
            Boolean makeCompositeField = false;
            String compositeField;
            for(String field : line_sep) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    fields.add(field.trim());
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    fields.add(compositeField.trim());
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    fields.add(field.trim());
                }
            }
            lines.add(fields);
        }

        for(String header : headers_raw) {
            headers.add(new CSVHeader(header));
        }

        CSVObject csvObj= new CSVObject(headers, lines);
        return csvObj;
    }
    @AuraEnabled
    public static List<String> getObjectNames() {
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
            if(describeSObjectResultObj.isCustom())
            {
                String name = objTyp.getDescribe().getName();
                // Exclude all the unwanted Sobjects e.g. History, Share etc.
                if(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
                 !name.containsignorecase('share') && !name.containsignorecase('feed'))
                {
                    SobjectList.add(name);
                }
            }
        }
        system.debug('SObjectList****' + SObjectList);
        return sObjectList;
        
    }
    
    @AuraEnabled
    public static List<Map<String, String>> getFieldNames(String objectName) {
		List<Map<String, String>> items = new List<Map<String, String>>();
		SObjectType addressTypes = Schema.getGlobalDescribe().get(objectName);
		Map<String,Schema.SObjectField> mfields = addressTypes.getDescribe().fields.getMap();
         for (String fieldName : mfields.keySet()){
				Schema.SObjectField fld=mfields.get(fieldName);	
                if(fld.getDescribe().isUpdateable())
					items.add(new Map<String, String>{'value' => fieldName, 'label' => fieldName});             	
        }
        system.debug(items);
        return items;
    }
     @AuraEnabled
    public static void saveAdd(List<String> columntype, List<List<String>> lines) { 
        List<Sobject> addList = new List<address__c>();
        
        String sObjectName = 'address__c';
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName); // obtain sObject description from the schema
 		List<CSV_Field_Map_Address__c> mcs = CSV_Field_Map_Address__c.getall().values();
		Map<String,string> objmap = new Map<String,string>();
        for(CSV_Field_Map_Address__c c:mcs)
            if(c!=null){
                system.debug('Field API: '+c.Field_API__c);
                objmap.put(c.name.tolowercase(),c.Field_API__c);
            }
            	
        System.debug('List of Settings: '+objmap);
        for(integer i=0;i<columntype.size();i++){
            system.debug('Old Value: ' + columntype[i]);
            string ss=columntype[i].tolowercase().trim();
			//CSV_Field_Map_Address__c myCS1 = CSV_Field_Map_Address__c.getValues(columntype[i]);
            columntype[i] = objmap.get(ss);
            system.debug('New Value: ' + columntype[i]);
        }
        
        for(integer i=0;i<lines.size();i++){
            SObject so = t.newSObject();
            integer cnt=0;
            for( String  s:lines[i]) 
            {
	 			 
                    
                if(columntype[cnt]!=null && columntype[cnt]!=''&&columntype[cnt]!=' '){
                    System.debug(columntype[cnt]);
                    String  FieldType='BOOLEAN';//Schema.getGlobalDescribe().get(sObjectName.toLowerCase()).getDescribe().Fields.getMap().get(columntype[cnt]).getDescribe().getType().name();
                    if ( FieldType=='BOOLEAN'&&s=='TRUE'  ){
                        //System.debug('Failing here '+' '+columntype[cnt]+' '+s+' '+so.get(columntype[cnt]));
						so.put(columntype[cnt],  TRUE);
                    }else if( FieldType=='BOOLEAN'&&s=='FALSE' ){
                        so.put(columntype[cnt], FALSE);
                    }else{
                        
						so.put(columntype[cnt], s);
                    }
                    
                }
                    
                	
                cnt++;
            }
            addList.add(so);
        }
        insert addList;
        system.debug(addList[0]);

        
         // create a new instance of that sObject
         // set name
        //insert s; // insert to the related database object
    }
    
    @AuraEnabled
    public static void save(List<String> columntype, List<List<String>> lines,String selectedobj) { 
        List<Sobject> addList = new List<Sobject>();
        
        String sObjectName = selectedobj;
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName); // obtain sObject description from the schema
 		
        for(integer i=0;i<lines.size();i++){
            SObject so = t.newSObject();
            integer cnt=0;
            for( String  s:lines[i]) 
            {
	 			 
                    
                if(columntype[cnt]!=null && columntype[cnt]!=''&&columntype[cnt]!=' '){
                    System.debug(columntype[cnt]);
                    String  FieldType=Schema.getGlobalDescribe().get(sObjectName.toLowerCase()).getDescribe().Fields.getMap().get(columntype[cnt]).getDescribe().getType().name();
                    if ( FieldType=='BOOLEAN'&&s=='TRUE'  ){
                        //System.debug('Failing here '+' '+columntype[cnt]+' '+s+' '+so.get(columntype[cnt]));
						so.put(columntype[cnt],  TRUE);
                    }else if( FieldType=='BOOLEAN'&&s=='FALSE' ){
                        so.put(columntype[cnt], FALSE);
                    }else{
                        
						so.put(columntype[cnt], s);
                    }
                    
                }
                    
                	
                cnt++;
            }
            addList.add(so);
        }
        insert addList;
        system.debug(addList[0]);

        
         // create a new instance of that sObject
         // set name
        //insert s; // insert to the related database object
    }
   

}