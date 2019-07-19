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
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngLoanList)
            {
                ApplicationArea = All;
                Caption = 'Loan List';
                ToolTip = 'Loan List';
                Image = Loaners;
                RunObject = page lvngLoanList;
                RunPageMode = View;
            }
            action(lvngLoansProcessing)
            {
                RunPageMode = Edit;
                Caption = 'Loan Journal Batches';
                ToolTip = 'Import and Process Loans Data';
                Image = DataEntry;
                RunObject = page lvngLoanJournalBatches;
                ApplicationArea = All;
            }
            action(lvngFundedDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Funded Documents';
                ToolTip = 'Edit and Post Funded Documents';
                Image = Documents;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting (lvngDocumentNo) where (lvngTransactionType = const (lvngFunded));
                ApplicationArea = All;
            }
            action(lvngServicingWorksheet)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Worksheet';
                ToolTip = 'Prepare Loans For Servicing';
                Image = ProjectToolsProjectMaintenance;
                RunObject = page lvngServicingWorksheet;
                ApplicationArea = All;
            }
            action(lvngSoldDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Sold Documents';
                ToolTip = 'Edit and Post Sold Documents';
                Image = DocumentEdit;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting (lvngDocumentNo) where (lvngTransactionType = const (lvngSold));
                ApplicationArea = All;
            }

            action(lvngLoanVisionSetup)
            {
                Caption = 'Loan Vision Setup';
                ToolTip = 'Loan Vision Setup';
                RunObject = Page lvngLoanVisionSetup;
                ApplicationArea = All;
            }
            action(lvngLoanServicingSetup)
            {
                Caption = 'Loan Servicing Setup';
                ToolTip = 'Loan Servicing Setup';
                RunObject = Page lvngLoanServicingSetup;
                ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                action(lvngLoanFieldsConfiguration)
                {
                    Caption = 'Loan Fields Configuration';
                    ToolTip = 'Loan Fields Configuration';
                    RunObject = Page lvngLoanFieldsConfiguration;
                    ApplicationArea = All;
                }
                action(lvngDimensionHierarchy)
                {
                    Caption = 'Dimension Hierarchy';
                    ToolTip = 'Setup Dimension Hierarchy';
                    RunObject = page lvngDimensionsHierarchy;
                    ApplicationArea = All;
                }

                action(lvngImportSchema)
                {
                    Caption = 'Loan Journal Import Schemas';
                    ToolTip = 'Configure Loan Journal Import Schemas';
                    RunObject = page lvngLoanImportSchemaList;
                    ApplicationArea = All;
                }
                action(lvngProcessingSchemas)
                {
                    Caption = 'Processing Schemas';
                    ToolTip = 'Configrue Processing Schemas';
                    RunObject = page lvngLoanProcessingSchema;
                    ApplicationArea = All;
                }
                action(lvngEscrowFieldsMapping)
                {
                    Caption = 'Escrow Fields Mapping';
                    ToolTip = 'Setup Servicing Escrow Fields Mapping';
                    RunObject = page lvngEscrowFieldsMapping;
                    ApplicationArea = All;
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