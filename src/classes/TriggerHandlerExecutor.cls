public class TriggerHandlerExecutor {

    // Method to dynamically execute trigger handlers
    public static Object executeTriggerHandlers(SObjectType sobjType) {
        executeTriggerHandlers(sobjType, new Set<String>(), new Set<String>());
    }

    public static Object executeTriggerHandlers(SObjectType sobjType) {
        executeTriggerHandlers(sobjType, new Set<String>(), new Set<String>());
    }

    public static Object executeTriggerHandlers(SObjectType sobjType, Set<String> bypassedThs) {
        executeTriggerHandlers(sobjType, bypassedThs, new Set<String>());
    }

    public static Object executeTriggerHandlers(SObjectType sobjType, Set<String> bypassedThs, Set<String> bypasedSobjectTriggers) {

        List<TriggerHandler> handlers = new List<TriggerHandler>();
        String sobjectTypeName = sobjType.getDescribe().getName();

        for (String bypassedTh : bypassedThs) {
            TriggerHandler.bypassHandlers(bypassedTh);
        }

        for (String bypassedTrigger : bypasedSobjectTriggers) {
            TriggerHandler.bypassTriggers(bypassedTrigger);
        }
        
        for (TriggerHandlerConfig__c config : [
            SELECT HandlerClassName__c 
            FROM TriggerHandlerConfig__c 
            WHERE ObjectName__c = :sobjectTypeName 
                AND IsActive__c = true 
            ORDER BY ExecutionOrder__c ASC
        ]) {
            Type handlerType = Type.forName(config.HandlerClassName__c);
            if (handlerType != null) {
                TriggerHandler handlerInstance = (TriggerHandler)handlerType.newInstance();
                handlers.add(handlerInstance);
            }
            // Error handling for null type
        }

        for(TriggerHandler handler : handlers) {
            handler.run();
        }
    }
}