page 14135264 lvngLoanManagerRoleCenter
{
    Caption = 'Loan Manager';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            group(Group)
            {
                part(Headline; lvngLoanManagerHeadline) { ApplicationArea = Basic, Suite; }
                part(DocumentActivities; lvngLoanManagerDocActivities) { ApplicationArea = Basic, Suite; }
                part(LoanManagerWarehouseAct; lvngLoanManagerWarehouseAct) { ApplicationArea = Basic, Suite; }
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

                action(LoanJournalBatch) { Caption = 'Loan Journal Batches'; ApplicationArea = All; RunObject = page lvngLoanJournalBatches; }
                action(GeneralJournal) { Caption = 'General Journal'; ApplicationArea = All; RunObject = page "General Journal"; }
            }

            group(LoanDocuments)
            {
                Caption = 'Loan Documents';

                action(PostedLoanFunded) { Caption = 'Posted Loans Funded'; ApplicationArea = All; RunObject = page lvngPostedFundedDocuments; }
                action(PostedLoanSold) { Caption = 'Posted Loans Sold'; ApplicationArea = All; RunObject = page lvngPostedSoldDocuments; }
                action(ReverseLoanDocuments) { Caption = 'Reverse Loan Documents'; ApplicationArea = All; RunObject = page lvngReverseSalesDocuments; }
            }

            group(Reports)
            {
                Caption = 'Reports';

                action(GLReconcilitaionPage) { Caption = 'G/L Reconciliation'; ApplicationArea = All; RunObject = page lvngGLReconciliation; }
                action(GLEntriesByLoanNo) { Caption = 'G/L Entries by Loan No.'; ApplicationArea = All; RunObject = report lvngGLEntriesByLoanVer2; }
                action(AccountRecByLoan) { Caption = 'Account Rec. by Loan'; ApplicationArea = All; RunObject = report lvngAccountReconByLoan; }
                action(GLReconciliationReport) { Caption = 'G/L Reconciliation Printout'; ApplicationArea = All; RunObject = report lvngGeneralLedgerRecSimplified; }
                action(GLByReasonCode) { Caption = 'General Ledger by Reason Code'; ApplicationArea = All; RunObject = report lvngGeneralLedgerByReasonCode; }
                action(AverageDailyTrialBalance) { Caption = 'Average Daily Trial Balance'; ApplicationArea = All; RunObject = report lvngAverageDailyTrialBalance; }
                action(LoanProfitability) { Caption = 'Loan Profitability'; ApplicationArea = All; RunObject = report lvngLoanProfitability; }
                action(LoanFileReconciliationWorksheetAction) { Caption = 'Loan File Reconciliation Worksheet'; ApplicationArea = All; RunObject = page lvngLoanFileReconWorksheet; }
                action(LoanFeesReport) { Caption = 'Loan Fees Report'; ApplicationArea = All; RunObject = report lvngLoanFeesReport; }
                action(LoanLevelValuesLoanLevel)
                {
                    Caption = 'Loan Level Values';
                    ApplicationArea = All;
                    //NEEDS IMPLEMENTED
                }
            }
        }

        area(Embedding)
        {
            action(LoanList) { Caption = 'Loan List'; ApplicationArea = All; RunObject = page lvngLoanList; }
        }
    }
}