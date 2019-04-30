page 14135200 "lvngLoanProcessorRolecenter"
{
    PageType = RoleCenter;
    Caption = 'Loan Processor';

    layout
    {
        area(RoleCenter)
        {
            part(lvngWarehouseLineActivities; lvngLoanActivities)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(lvngLoansProcessing)
            {
                RunPageMode = Create;
                Caption = 'Loan Journal Batches';
                ToolTip = 'Import and Process Loans Data';
                Image = New;
                RunObject = page lvngLoanJournalBatches;
                ApplicationArea = Basic, Suite;
            }
            action(lvngFundedDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Funded Documents';
                ToolTip = 'Edit and Post Funded Documents';
                Image = New;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting (lvngDocumentNo) where (lvngTransactionType = const (lvngFunded));
                ApplicationArea = Basic, Suite;
            }
            action(lvngServicingWorksheet)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Worksheet';
                ToolTip = 'Prepare Loans For Servicing';
                Image = ProjectToolsProjectMaintenance;
                RunObject = page lvngServicingWorksheet;
                ApplicationArea = Basic, Suite;
            }
            action(lvngSoldDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Sold Documents';
                ToolTip = 'Edit and Post Sold Documents';
                Image = New;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting (lvngDocumentNo) where (lvngTransactionType = const (lvngSold));
                ApplicationArea = Basic, Suite;
            }

            action(lvngLoanVisionSetup)
            {
                Caption = 'Loan Vision Setup';
                ToolTip = 'Loan Vision Setup';
                RunObject = Page lvngLoanVisionSetup;
                ApplicationArea = Basic, Suite;
            }
            action(lvngLoanServicingSetup)
            {
                Caption = 'Loan Servicing Setup';
                ToolTip = 'Loan Servicing Setup';
                RunObject = Page lvngLoanServicingSetup;
                ApplicationArea = Basic, Suite;
            }
        }

        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setup';
                ToolTip = 'Overview and change system and application settings, and manage extensions and services';
                Image = Setup;

                action(lvngWarehouseLines)
                {
                    Caption = 'Warehouse Lines';
                    ToolTip = 'Warehouse Lines';
                    RunObject = Page lvngWarehouseLines;
                    ApplicationArea = Basic, Suite;
                }
                action(lvngLoanFieldsConfiguration)
                {
                    Caption = 'Loan Fields Configuration';
                    ToolTip = 'Loan Fields Configuration';
                    RunObject = Page lvngLoanFieldsConfiguration;
                    ApplicationArea = Basic, Suite;
                }
                action(lvngDimensionHierarchy)
                {
                    Caption = 'Dimension Hierarchy';
                    ToolTip = 'Setup Dimension Hierarchy';
                    RunObject = page lvngDimensionsHierarchy;
                    ApplicationArea = Basic, Suite;
                }
                action(lvngProcessingSchemas)
                {
                    Caption = 'Processing Schemas';
                    ToolTip = 'Configrue Processing Schemas';
                    RunObject = page lvngLoanProcessingSchema;
                    ApplicationArea = Basic, Suite;
                }
                action(lvngEscrowFieldsMapping)
                {
                    Caption = 'Escrow Fields Mapping';
                    ToolTip = 'Setup Servicing Escrow Fields Mapping';
                    RunObject = page lvngEscrowFieldsMapping;
                    ApplicationArea = Basic, Suite;
                }

            }
        }
    }

}

profile "Loan Processor"
{

    Description = 'Loan Processor';
    RoleCenter = lvngLoanProcessorRolecenter;
}