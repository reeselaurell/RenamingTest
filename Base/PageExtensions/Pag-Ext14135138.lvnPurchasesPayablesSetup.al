pageextension 14135138 "lvnPurchasesPayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(content)
        {
            group(LoanVision)
            {
                Caption = 'Loan Vision';

                field(lvnQuickPayDefaultBatch; Rec.lvnQuickPayDefaultBatch) { ApplicationArea = All; Caption = 'Quick Pay Default Batch'; }
                field(lvnQuickPayBatchSelection; Rec.lvnQuickPayBatchSelection) { ApplicationArea = All; Caption = 'Quick Pay Batch Selection'; }
            }
        }
    }
}