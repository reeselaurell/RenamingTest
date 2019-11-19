tableextension 14135120 lvngPurchInvHeader extends "Purch. Inv. Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}