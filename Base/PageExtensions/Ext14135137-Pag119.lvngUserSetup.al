pageextension 14135137 lvngUserSetup extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngDefaultPaymentJournalBatch; Rec.lvngDefaultPaymentJournalBatch) { ApplicationArea = All; Caption = 'Default Payment Journal Batch'; }
        }
    }
}