pageextension 14135137 lvngUserSetup extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngDefaultPaymentJournalBatch; lvngDefaultPaymentJournalBatch) { ApplicationArea = All; Caption = 'Default Payment Journal Batch'; }
        }
    }
}