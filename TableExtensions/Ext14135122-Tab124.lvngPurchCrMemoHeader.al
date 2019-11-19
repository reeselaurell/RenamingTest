tableextension 14135122 lvngPurchCrMemoHeader extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(14135100; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }
    }

}