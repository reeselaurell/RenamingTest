pageextension 14135137 "lvnUserSetup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(lvnDefaultPaymentJournalBatch; Rec.lvnDefaultPaymentJournalBatch)
            {
                ApplicationArea = All;
                Caption = 'Default Payment Journal Batch';
            }
        }
    }
}