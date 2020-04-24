pageextension 14135138 lvngPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(content)
        {
            group(LoanVision)
            {
                Caption = 'Loan Vision';

                field(lvngQuickPayDefaultBatch; lvngQuickPayDefaultBatch) { ApplicationArea = All; Caption = 'Quick Pay Default Batch'; }
                field(lvngQuickPayBatchSelection; lvngQuickPayBatchSelection) { ApplicationArea = All; Caption = 'Quick Pay Batch Selection'; }
            }
        }
    }
}