pageextension 14135138 lvngPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(content)
        {
            group(LoanVision)
            {
                Caption = 'Loan Vision';

                field(lvngQuickPayDefaultBatch; Rec.lvngQuickPayDefaultBatch) { ApplicationArea = All; Caption = 'Quick Pay Default Batch'; }
                field(lvngQuickPayBatchSelection; Rec.lvngQuickPayBatchSelection) { ApplicationArea = All; Caption = 'Quick Pay Batch Selection'; }
            }
        }
    }
}