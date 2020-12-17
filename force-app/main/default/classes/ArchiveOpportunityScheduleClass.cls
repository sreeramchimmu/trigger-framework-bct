/**
 * Class: ArchiveOpportunityScheduleClass
 *
 * Author: Revathi Saminathan
 *
 * Date Created: 25.08.2020
 *
 * Purpose: The ArchiveOpportunityScheduleClass is responsible for making run schedule the job by weekly bases to update the Archive opportunity object.
 * 
 */
global class ArchiveOpportunityScheduleClass implements Schedulable {
    
    global void execute(SchedulableContext ctx)
    {
        ArchiveOpportunityRecordUpdateBatch updateArchive = new ArchiveOpportunityRecordUpdateBatch();
        database.executebatch(updateArchive,50); 
        ArchiveOpportunityCreationBatch createArchive = new ArchiveOpportunityCreationBatch();
        database.executebatch(createArchive,50); 
        ArchiveOpportunityLineTemCreateBatch opline = new ArchiveOpportunityLineTemCreateBatch();
        database.executebatch(opline,50);
        ArchiveRevenueCreationBatch revBatch = new ArchiveRevenueCreationBatch();
        database.executebatch(revBatch,50);    
    }
}