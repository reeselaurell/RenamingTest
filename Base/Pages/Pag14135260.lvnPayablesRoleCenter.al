page 14135260 "lvnPayablesRoleCenter"
{
    Caption = 'Payables';
    PageType = RoleCenter;

    layout
    {
        area(Rolecenter)
        {
            part(Headline; lvnPayablesHeadline)
            {
                ApplicationArea = Basic, Suite;
            }
            part(PayablesFinanceAct; lvnPayablesFinanceActivites)
            {
                ApplicationArea = All;
            }
            part(PayablesApprovalActivities; lvnPayablesApprovalActivities)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Invoices)
            {
                Caption = 'Invoices';

                action(PurchaseInvoices)
                {
                    Caption = 'Purchase Invoices';
                    ApplicationArea = All;
                    RunObject = page "Purchase Invoices";
                }
                action(PostedPurchaseInvoice)
                {
                    Caption = 'Posted Purchase Invoices';
                    ApplicationArea = All;
                    RunObject = page "Posted Purchase Invoices";
                }
            }
            group(CrMemos)
            {
                Caption = 'Cr. Memos';

                action(PurchaseCrMemos)
                {
                    Caption = 'Purchase Cr. Memos';
                    ApplicationArea = All;
                    RunObject = page "Purchase Credit Memos";
                }
                action(PostedCrMemos)
                {
                    Caption = 'Posted Purchase Cr. Memos';
                    ApplicationArea = All;
                    RunObject = page "Posted Purchase Credit Memos";
                }
            }
            group(Journals)
            {
                action(PaymentJournal)
                {
                    Caption = 'Payment Journal';
                    ApplicationArea = All;
                    RunObject = page "Payment Journal";
                }
                action(PurchaseJournal)
                {
                    Caption = 'Purchase Journal';
                    ApplicationArea = All;
                    RunObject = page "Purchase Journal";
                }
            }
            group(Reports)
            {
                action(VendorTrialBalance)
                {
                    Caption = 'Vendor Trial Balance';
                    ApplicationArea = All;
                    RunObject = report "Vendor - Trial Balance";
                }
                action(AgedAccountsPayable)
                {
                    Caption = 'Aged Accounts Payable';
                    ApplicationArea = All;
                    RunObject = report "Aged Accounts Payable";
                }
                action(OpenVendorEntries)
                {
                    Caption = 'Open Vendor Entries';
                    ApplicationArea = All;
                    RunObject = report "Open Vendor Entries";
                }
                action(TopVendorList)
                {
                    Caption = 'Top Vendor List';
                    ApplicationArea = All;
                    RunObject = report "Top __ Vendor List";
                }
                action(VendorAccountDetail)
                {
                    Caption = 'Vendor Account Detail';
                    ApplicationArea = All;
                    RunObject = report "Vendor Account Detail";
                }
                group(Vendor1099Reports)
                {
                    Caption = 'Vendor 1099 Reports';

                    action(Vendor1099Div)
                    {
                        Caption = 'Vendor 1099 Div';
                        ApplicationArea = All;
                        RunObject = report "Vendor 1099 Div";
                    }
                    action(Vendor1099Information)
                    {
                        Caption = 'Vendor 1099 Information';
                        ApplicationArea = All;
                        RunObject = report "Vendor 1099 Information";
                    }
                    action(Vendor1099Int)
                    {
                        Caption = 'Vendor 1099 Int';
                        ApplicationArea = All;
                        RunObject = report "Vendor 1099 Int";
                    }
                    action(Vendor1099MagneticMedia)
                    {
                        Caption = 'Vendor 1099 Magnetic Media';
                        ApplicationArea = All;
                        RunObject = report "Vendor 1099 Magnetic Media";
                    }
                    action(Vendor1099Misc)
                    {
                        Caption = 'Vendor 1099 Misc';
                        ApplicationArea = All;
                        RunObject = report "Vendor 1099 Misc";
                    }
                }
                action(CheckApplication)
                {
                    Caption = 'Check Application';
                    ApplicationArea = All;
                    RunObject = report lvnVendCheckApplicationReport;
                }
                action(UseTax)
                {
                    Caption = 'Use Tax';
                    ApplicationArea = All;
                    RunObject = report lvnUseTaxPayableReport;
                }
                action(DisbursementDataExport)
                {
                    Caption = 'Disbursement Data Export';
                    ApplicationArea = All;
                    RunObject = report lvnDisbursementDataExport;
                }
            }
            group(Setup)
            {
                action(PurchaseAndPayableSetup)
                {
                    Caption = 'Purchases & Payables Setup';
                    ApplicationArea = All;
                    RunObject = page "Purchases & Payables Setup";
                }
            }
        }
        area(Embedding)
        {
            action(VendorList)
            {
                Caption = 'Vendors';
                ApplicationArea = All;
                RunObject = page "Vendor List";
            }
            action(QuickPay)
            {
                Caption = 'Quick Pay';
                ApplicationArea = All;
                RunObject = page lvnQuickPayWorksheet;
            }
        }
    }
}