page 14135264 "lvnLoanManagerRoleCenter"
{
    Caption = 'Loan Manager';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Headline; lvnLoanManagerHeadline)
            {
                ApplicationArea = Basic, Suite;
            }
            part(DocumentActivities; lvnLoanManagerDocActivities)
            {
                ApplicationArea = Basic, Suite;
            }
            part(LoanManagerWarehouseAct; lvnLoanManagerWarehouseAct)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(LoanImports)
            {
                Caption = 'Loan Imports';

                action(LoanJournalBatch)
                {
                    Caption = 'Loan Journal Batches';
                    ApplicationArea = All;
                    RunObject = page lvnLoanJournalBatches;
                }
                action(GeneralJournal)
                {
                    Caption = 'General Journal';
                    ApplicationArea = All;
                    RunObject = page "General Journal";
                }
            }
            group(LoanDocuments)
            {
                Caption = 'Loan Documents';

                action(PostedLoanFunded)
                {
                    Caption = 'Posted Loans Funded';
                    ApplicationArea = All;
                    RunObject = page lvnPostedFundedDocuments;
                }
                action(PostedLoanSold)
                {
                    Caption = 'Posted Loans Sold';
                    ApplicationArea = All;
                    RunObject = page lvnPostedSoldDocuments;
                }
                action(ReverseLoanDocuments)
                {
                    Caption = 'Reverse Loan Documents';
                    ApplicationArea = All;
                    RunObject = page lvnReverseSalesDocuments;
                }
            }
            group(Reports)
            {
                Caption = 'Reports';

                action(GLReconcilitaionPage)
                {
                    Caption = 'G/L Reconciliation';
                    ApplicationArea = All;
                    RunObject = page lvnGLReconciliation;
                }
                action(GLEntriesByLoanNo)
                {
                    Caption = 'G/L Entries by Loan No.';
                    ApplicationArea = All;
                    RunObject = report lvnGLEntriesByLoanVer2;
                }
                action(AccountRecByLoan)
                {
                    Caption = 'Account Rec. by Loan';
                    ApplicationArea = All;
                    RunObject = report lvnAccountReconByLoan;
                }
                action(GLReconciliationReport)
                {
                    Caption = 'G/L Reconciliation Printout';
                    ApplicationArea = All;
                    RunObject = report lvnGeneralLedgerRecSimplified;
                }
                action(GLByReasonCode)
                {
                    Caption = 'General Ledger by Reason Code';
                    ApplicationArea = All;
                    RunObject = report lvnGeneralLedgerByReasonCode;
                }
                action(AverageDailyTrialBalance)
                {
                    Caption = 'Average Daily Trial Balance';
                    ApplicationArea = All;
                    RunObject = report lvnAverageDailyTrialBalance;
                }
                action(LoanProfitability)
                {
                    Caption = 'Loan Profitability';
                    ApplicationArea = All;
                    RunObject = report lvnLoanProfitability;
                }
                action(LoanFileReconciliationWorksheetAction)
                {
                    Caption = 'Loan File Reconciliation Worksheet';
                    ApplicationArea = All;
                    RunObject = page lvnLoanFileReconWorksheet;
                }
                action(LoanFeesReport)
                {
                    Caption = 'Loan Fees Report';
                    ApplicationArea = All;
                    RunObject = report lvnLoanFeesReport;
                }
                action(LoanLevelValuesLoanLevel)
                {
                    Caption = 'Loan Level Worksheet';
                    ApplicationArea = All;
                    RunObject = report lvnLoanLevelWorksheet;
                }
            }
        }
        area(Embedding)
        {
            action(LoanList)
            {
                Caption = 'Loan List';
                ApplicationArea = All;
                RunObject = page lvnLoanList;
            }
        }
    }
}