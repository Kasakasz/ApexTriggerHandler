// example implementation
trigger AccountTrigger on Account (before insert, after insert, before update, after update) {

    // Calling the executor.
    new TriggerHandlerExecutor().executeTriggerHandlers(Account.getSObjectType());
}