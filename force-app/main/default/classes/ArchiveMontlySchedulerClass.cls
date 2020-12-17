/**
* Class: ArchiveOpportunityScheduleClass
*
* Author: Revathi Saminathan
*
* Date Created: 29.10.2020
*
* Purpose: The ArchiveMontlySchedulerClass is responsible for making run schedule the job by Monthly bases to update the Archive opportunity object.
* 
*/
global class ArchiveMontlySchedulerClass implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        ArchiveOpportunityBatch monBatch = new ArchiveOpportunityBatch();
        database.executebatch(monBatch,50); 
    }
}