page 14135189 "lvnLoanProcessorRolecenter"
{
    PageType = RoleCenter;
    Caption = 'Loan Processor';

    layout
    {
        area(RoleCenter)
        {
            part(WarehouseLineActivities; lvnLoanActivities)
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
                RunObject = page lvnLoanList;
                RunPageMode = View;
            }
            action(LoansProcessing)
            {
                RunPageMode = Edit;
                Caption = 'Loan Journal Batches';
                ToolTip = 'Import and Process Loans Data';
                Image = DataEntry;
                RunObject = page lvnLoanJournalBatches;
                ApplicationArea = All;
            }
            action(FundedDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Funded Documents';
                ToolTip = 'Edit and Post Funded Documents';
                Image = Documents;
                RunObject = page lvnLoanDocumentsList;
                RunPageView = sorting("Document No.") where("Transaction Type" = const(Funded));
                ApplicationArea = All;
            }
            action(ServicingWorksheet)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Worksheet';
                ToolTip = 'Prepare Loans For Servicing';
                Image = ProjectToolsProjectMaintenance;
                RunObject = page lvnServicingWorksheet;
                ApplicationArea = All;
            }
            action(ServicingDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Servicing Documents';
                ToolTip = 'Edit and Post Servicing Documents';
                Image = DocumentEdit;
                RunObject = page lvnLoanServDocumentsList;
                ApplicationArea = All;
            }
            action(SoldDocuments)
            {
                RunPageMode = Edit;
                Caption = 'Sold Documents';
                ToolTip = 'Edit and Post Sold Documents';
                Image = DocumentEdit;
                RunObject = page lvnLoanDocumentsList;
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
                    RunObject = Page lvnWarehouseLines;
                    ApplicationArea = All;
                }
                action(LoanFieldsConfiguration)
                {
                    Caption = 'Loan Fields Configuration';
                    ToolTip = 'Loan Fields Configuration';
                    RunPageMode = Edit;
                    RunObject = Page lvnLoanFieldsConfiguration;
                    ApplicationArea = All;
                }
                action(DimensionHierarchy)
                {
                    Caption = 'Dimension Hierarchy';
                    ToolTip = 'Setup Dimension Hierarchy';
                    RunPageMode = Edit;
                    RunObject = page lvnDimensionsHierarchy;
                    ApplicationArea = All;
                }
                action(ImportSchema)
                {
                    Caption = 'Loan Journal Import Schemas';
                    ToolTip = 'Configure Loan Journal Import Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvnLoanImportSchemaList;
                    ApplicationArea = All;
                }
                action(ProcessingSchemas)
                {
                    Caption = 'Processing Schemas';
                    ToolTip = 'Configrue Processing Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvnLoanProcessingSchema;
                    ApplicationArea = All;
                }
                action(EscrowFieldsMapping)
                {
                    Caption = 'Escrow Fields Mapping';
                    ToolTip = 'Setup Servicing Escrow Fields Mapping';
                    RunPageMode = Edit;
                    RunObject = page lvnEscrowFieldsMapping;
                    ApplicationArea = All;
                }
                action(ImportDimensionsMapping)
                {
                    Caption = 'Import Dimensions Mapping';
                    ToolTip = 'Configure Import Dimensions Mapping';
                    RunPageMode = Edit;
                    RunObject = page lvnImportDimensionMapping;
                    ApplicationArea = all;
                }
                action(FileImportSchemas)
                {
                    Caption = 'File Import Schemas';
                    ToolTip = 'Configure File Import Schemas';
                    RunPageMode = Edit;
                    RunObject = page lvnFileImportSchemas;
                    ApplicationArea = All;
                }
                action(LoanVisionSetup)
                {
                    Caption = 'Loan Vision Setup';
                    ToolTip = 'Loan Vision Setup';
                    RunPageMode = Edit;
                    Image = Setup;
                    RunObject = Page lvnLoanVisionSetup;
                    ApplicationArea = All;
                }
                action(LoanServicingSetup)
                {
                    Caption = 'Loan Servicing Setup';
                    ToolTip = 'Loan Servicing Setup';
                    RunPageMode = Edit;
                    Image = Setup;
                    RunObject = Page lvnLoanServicingSetup;
                    ApplicationArea = All;
                }
            }
        }
    }

}
