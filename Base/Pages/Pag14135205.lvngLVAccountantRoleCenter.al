page 14135205 lvngLVAccountantRoleCenter
{
    PageType = RoleCenter;
    Caption = 'Loan Vision Accountant Role Center';
    RefreshOnActivate = true;

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC Accountant") { ApplicationArea = Basic, Suite; }
            part(GeneralActivities; lvngLVAccountantFinanceAct) { ApplicationArea = Basic, Suite; }
            part(LoanActivitites; lvngLVAccountantLoanActivities) { ApplicationArea = Basic, Suite; }
            part(CloseManagerActivities; lvngCloseManagerActivities) { ApplicationArea = Basic, Suite; }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Finance)
            {
                action(ChartOfAccounts) { Caption = 'Chart of Accounts'; ApplicationArea = All; RunObject = page "Chart of Accounts"; }
                action(GLAccountCategories) { Caption = 'G/L Account Categories'; ApplicationArea = All; RunObject = page "G/L Account Categories"; }
                action(Dimensions) { Caption = 'Dimensions'; ApplicationArea = All; RunObject = page Dimensions; }
                group(Consolidation)
                {
                    action(ImportConsolidation) { Caption = 'Import Consolidation from Database'; ApplicationArea = All; RunObject = report "Import Consolidation from DB"; }
                    action(ExportConsolidation) { Caption = 'Export Consolidation'; ApplicationArea = All; RunObject = report "Export Consolidation"; }
                }

                action(GeneralJournal) { Caption = 'General Journal'; ApplicationArea = All; RunObject = page "General Journal"; }
            }
            group(CashManagement)
            {
                Caption = 'Cash Management';

                action(PaymentJournal) { Caption = 'Payment Journal'; ApplicationArea = All; RunObject = page "Payment Journal"; }
                action(CashReceiptJournal) { Caption = 'Cash Receipt Journal'; ApplicationArea = All; RunObject = page "Cash Receipt Journal"; }
                action(BankAccStatements) { Caption = 'Bank Acc. Statements'; ApplicationArea = All; RunObject = page "Bank Account Statement List"; }
                action(Deposit) { Caption = 'Deposit'; ApplicationArea = All; RunObject = page Deposit; }
                action(BankAccounts) { Caption = 'Bank Accounts'; ApplicationArea = All; RunObject = page "Bank Account List"; }
                action(BankAccReconciliation) { Caption = 'Bank Account Reconciliation'; ApplicationArea = All; RunObject = page "Bank Acc. Reconciliation List"; }
            }

            group(Payables)
            {
                action(PaymentJournalPayables) { Caption = 'Payment Journal'; ApplicationArea = All; RunObject = page "Payment Journal"; }
                action(PurchaseJournal) { Caption = 'Purchase Journal'; ApplicationArea = All; RunObject = page "Purchase Journal"; }
                action(PurchaseCrMemo) { Caption = 'Purchase Cr. Memo'; ApplicationArea = All; RunObject = page "Purchase Credit Memo"; RunPageMode = Create; }
                action(PurchaseInvoice) { Caption = 'Purchase Invoice'; ApplicationArea = All; RunPageMode = Create; RunObject = page "Purchase Invoice"; }
                action(PostedPurchCrMemos) { Caption = 'Posted Purchase Cr. Memos'; ApplicationArea = All; RunObject = page "Posted Purchase Credit Memos"; }
                action(PostedPurchInvoices) { Caption = 'Posted Purchase Invoices'; ApplicationArea = All; RunObject = page "Posted Purchase Invoices"; }
            }

            group(LoanManagement)
            {
                Caption = 'Loan Management';

                action(LoanList) { Caption = 'Loan List'; ApplicationArea = All; RunObject = page lvngLoanList; }
                action(LoanJournals) { Caption = 'Loan Journals'; ApplicationArea = All; RunObject = page lvngLoanJournalBatches; }
                action(ReverseSalesDocument) { Caption = 'Reverse Sales Document'; ApplicationArea = All; RunObject = page lvngReverseSalesDocuments; }
                action(ReversePurchaseDocuments) { Caption = 'Reverse Purchase Documents'; ApplicationArea = All; RunObject = page lvngReversePurchaseDocuments; }
                action(QuickTrace) { Caption = 'Quick Trace'; ApplicationArea = All; RunObject = page lvngQuickTrace; }
                action(LoanFileReconciliationWorksheet) { Caption = 'Loan File Reconciliation Worksheet'; ApplicationArea = All; RunObject = page lvngLoanFileReconWorksheet; }
            }

            group(Reports)
            {
                group(FinancialReports)
                {
                    Caption = 'Financial Reports';

                    action(IncomeStatement) { Caption = 'Income Statement'; ApplicationArea = All; RunObject = report "Income Statement"; }
                    action(BalanceSheet) { Caption = 'Balance Sheet'; ApplicationArea = All; RunObject = report "Balance Sheet"; }
                    action(AccountSchedules) { Caption = 'Account Schedules'; ApplicationArea = All; RunObject = report "Account Schedule"; }
                    action(AnalysisByDimension) { Caption = 'Analysis By Dimension'; ApplicationArea = All; RunObject = page "Analysis by Dimensions"; }
                    action(LoanLevelReportbyPeriod)
                    {
                        Caption = 'Loan Level Report by Period';
                        ApplicationArea = All;
                        //NEEDS IMPLEMENTED
                    }
                    action(LoanLevelReportByPeriodNoBps)
                    {
                        Caption = 'Loan Level Report By Period No Bps';
                        ApplicationArea = All;
                        //NEEDS IMPLEMENTED 
                    }
                    action(LoanLevelValuesFinancial)
                    {
                        Caption = 'Loan Level Values';
                        ApplicationArea = All;
                        //NEEDS IMPLEMENTED
                    }
                    action(TrialBalanceDetailSummary) { Caption = 'Trail Balance Detail/Summary'; ApplicationArea = All; RunObject = report "Trial Balance Detail/Summary"; }
                    action(TrialBalanceByPeriod) { Caption = 'Trial Balance by Period'; ApplicationArea = All; RunObject = report "Trial Balance by Period"; }
                    action(ReportGeneratorBatchList) { Caption = 'Report Generator Batch List'; ApplicationArea = All; RunObject = page lvngReportGeneratorBatchList; }
                }

                group(LoanLevelReports)
                {
                    Caption = 'Loan Level Reports';

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

                group(PayablesReports)
                {
                    Caption = 'Payables Reports';

                    action(VendorTrialBalance) { Caption = 'Vendor Trial Balance'; ApplicationArea = All; RunObject = report "Vendor - Trial Balance"; }
                    action(AgedAccountsPayable) { Caption = 'Aged Accounts Payable'; ApplicationArea = All; RunObject = report "Aged Accounts Payable"; }
                    action(OpenVendorEntries) { Caption = 'Open Vendor Entries'; ApplicationArea = All; RunObject = report "Open Vendor Entries"; }
                    action(ProjectedCashPayments) { Caption = 'Projected Cash Payments'; ApplicationArea = All; RunObject = report "Projected Cash Payments"; }
                    action(VendorAccountDetail) { Caption = 'Vendor Account Detail'; ApplicationArea = All; RunObject = report "Vendor Account Detail"; }
                    action(Vendor1099Information) { Caption = 'Vendor 1099 Information'; ApplicationArea = All; RunObject = report "Vendor 1099 Information"; }
                    action(UseTaxPayable) { Caption = 'Use Tax Payable'; ApplicationArea = All; RunObject = report lvngUseTaxPayableReport; }
                    action(LoanLevelValuesPayables)
                    {
                        Caption = 'Loan Level Values';
                        ApplicationArea = All;
                        //NEEDS IMPLEMENTED
                    }
                    action(CashReqByDueDate) { Caption = 'Cash Requirement by Due Date'; ApplicationArea = All; RunObject = report "Cash Requirements by Due Date"; }
                    action(VendorCheckApplication) { Caption = 'Vendor Check Application Report'; ApplicationArea = All; RunObject = report lvngVendCheckApplicationReport; }
                }
            }
        }
    }
}