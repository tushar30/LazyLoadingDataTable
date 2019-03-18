public class DataTableController {
    
    @AuraEnabled
    public static DataTableWrapper initRecords(String ObjectName, String fieldNamesStr, String Orderby, String OrderDir) {
        
        DataTableWrapper dtw = new DataTableWrapper();
        List<LabelDescriptionWrapper> labelList = new List<LabelDescriptionWrapper>();
        List<String> fieldSet = new List<String>();
        Set<String> fieldNameSet = new Set<String>(fieldNamesStr.split(','));
        
        if(Schema.getGlobalDescribe().containsKey(ObjectName) ) {
            sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
            
            //get all the labels for sObject fields and put them in a map, keyed to the field api name
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
            Map<Schema.SObjectField,String> fieldToAPIName = new Map<Schema.SObjectField,String>();
            Map<String, String> apiNameToLabel = new Map<String, String>();
            for(String fieldName :  fieldNameSet){
                if(fieldMap.containsKey(fieldName)) {
                    fieldSet.add(fieldName);
                    labelList.add(new LabelDescriptionWrapper(fieldMap.get(fieldName).getDescribe().getLabel(), fieldName, fieldMap.get(fieldName).getDescribe().getType().name().toLowerCase(), true ));
                }
            }
            
            //call method to query
            List<sObject> sObjectRecords = getsObjectRecords(ObjectName, fieldSet, 50, '', Orderby, OrderDir);
            dtw.ldwList 	= labelList;
            dtw.sobList 	= sObjectRecords;
            dtw.fieldsList 	= fieldSet;
            dtw.totalCount  = Database.countQuery('SELECT count() FROM '+ObjectName);
        }
        return dtw;
    }
    
    @AuraEnabled
    public static List<sObject> getsObjectRecords(String ObjectName, List<String> fieldNameSet, Integer LimitSize, String recId, String Orderby, String OrderDir) {
        
        OrderDir = String.isBlank(OrderDir) ? 'asc' : OrderDir;
        String query = 'SELECT '+String.join(fieldNameSet, ',')+' FROM '+ObjectName;
        if(String.isNotBlank(recId)) {
            recId = String.valueOf(recId);
            query += ' WHERE ID >: recId ';
        }
        
        query += ' ORDER BY '+Orderby+' '+OrderDir+' NULLS LAST';
        
        if(LimitSize != null && Integer.valueOf(LimitSize) > 0) {
            LimitSize = Integer.valueOf(LimitSize);
            query += ' Limit '+LimitSize;
        }
        return Database.query(query);
    }

    public class DataTableWrapper {
        @AuraEnabled
        public List<LabelDescriptionWrapper> ldwList;
        @AuraEnabled
        public List<sObject> sobList;
        @AuraEnabled
        public List<String> fieldsList;
        @AuraEnabled
        public Integer totalCount;
    }
    
    public class LabelDescriptionWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public boolean sortable;
        
        public LabelDescriptionWrapper(String labelTemp, String fieldNameTemp, String typeTemp, boolean sortableTemp) {
            label 	  = labelTemp;
            fieldName = fieldNameTemp;
            type 	  = typeTemp;
            sortable  = sortableTemp;
        }
            
    }
}
