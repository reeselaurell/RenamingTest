page 14135200 lvngLoanProcessorRolecenter
{
    PageType = RoleCenter;
    Caption = 'Loan Processor';

    layout
    {
        area(RoleCenter)
        {
            part(WarehouseLineActivities; lvngLoanActivities)
            {
                Caption = 'Loan Activities';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoanList)
            {
                ApplicationArea = All;
                Caption = 'Loan List';
                ToolTip = 'Loan List';
                Image = Loaners;
                RunObject = page lvngLoanList;
                RunPageMode = View;
            }
            action(LoansProcessing)
            {
                RunPageMode = Edit;
                Caption = 'Loan Journal Batches';
                ToolTip = 'Import and Process Loans Data';
                Image = DataEntry;
                RunObject = page lvngLoanJournalBatches;
                ApplicationArea = All;
            }
            action(FundedDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Funded Documents';
                ToolTip = 'Edit and Post Funded Documents';
                Image = Documents;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting("Document No.") where("Transaction Type" = const(Funded));
                ApplicationArea = All;
            }
            action(ServicingWorksheet)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Worksheet';
                ToolTip = 'Prepare Loans For Servicing';
                Image = ProjectToolsProjectMaintenance;
                RunObject = page lvngServicingWorksheet;
                ApplicationArea = All;
            }
            action(ServicingDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Documents';
                ToolTip = 'Edit and Post Servicing Documents';
                Image = DocumentEdit;
                RunObject = page lvngLoanServDocumentsList;
                ApplicationArea = All;
            }
            action(SoldDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Sold Documents';
                ToolTip = 'Edit and Post Sold Documents';
                Image = DocumentEdit;
                RunObject = page lvngLoanDocumentsList;
                RunPageView = sorting("Document No.") where("Transaction Type" = const(Sold));
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

                action(WarehouseLines)
                {
                    Caption = 'Warehouse Lines';
                    ToolTip = 'Warehouse Lines';
                    RunPageMode = Edit;
                    RunObject = Page lvngWarehouseLines;
                    ApplicationArea = All;
                }
                action(LoanFieldsConfiguration)
                {
                    Caption = 'Loan Fields Configuration';
                    ToolTip = 'Loan Fields Configuration';
                    RunPageMode = Edit;
                    RunObject = Page lvngLoanFieldsConfiguration;
                    ApplicationArea = All;
                }
                action(DimensionHierarchy)
                {
                    Caption = 'Dimension Hierarchy';
                    ToolTip = 'Setup Dimension Hierarchy';
                    RunPageMode = Edit;
                    RunObject = page lvngDimensionsHierarchy;
                    ApplicationArea = All;
                }
                action(ImportSchema)
                {
                    Caption = 'Loan Journal Import Schemas';
                    ToolTip = 'Configure Loan Journal Import Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvngLoanImportSchemaList;
                    ApplicationArea = All;
                }
                action(ProcessingSchemas)
                {
                    Caption = 'Processing Schemas';
                    ToolTip = 'Configrue Processing Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvngLoanProcessingSchema;
                    ApplicationArea = All;
                }
                action(EscrowFieldsMapping)
                {
                    Caption = 'Escrow Fields Mapping';
                    ToolTip = 'Setup Servicing Escrow Fields Mapping';
                    RunPageMode = Edit;
                    RunObject = page lvngEscrowFieldsMapping;
                    ApplicationArea = All;
                }
                action(ImportDimensionsMapping)
                {
                    Caption = 'Import Dimensions Mapping';
                    ToolTip = 'Configure Import Dimensions Mapping';
                    RunPageMode = Edit;
                    RunObject = page lvngImportDimensionMapping;
                    ApplicationArea = all;
                }
                action(FileImportSchemas)
                {
                    Caption = 'File Import Schemas';
                    ToolTip = 'Configure File Import Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvngFileImportSchemas;
                    ApplicationArea = All;
                }
                action(LoanVisionSetup)
                {
                    Caption = 'Loan Vision Setup';
                    ToolTip = 'Loan Vision Setup';
                    RunPageMode = Edit;
                    Image = Setup;
                    RunObject = Page lvngLoanVisionSetup;
                    ApplicationArea = All;
                }
                action(LoanServicingSetup)
                {
                    Caption = 'Loan Servicing Setup';
                    ToolTip = 'Loan Servicing Setup';
                    RunPageMode = Edit;
                    Image = Setup;
                    RunObject = Page lvngLoanServicingSetup;
                    ApplicationArea = All;
                }
            }
        }
    }

}
