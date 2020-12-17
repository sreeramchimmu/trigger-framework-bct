trigger shiftSubsequentRevDates on Revenue_Term__c (after update, after insert ) {
     //   system.debug('Entered shiftSubsequentRevDates Trigger on Revenue_Term__c');
        boolean isActive = false;
        boolean isSubsequentSelected = false;
  
}