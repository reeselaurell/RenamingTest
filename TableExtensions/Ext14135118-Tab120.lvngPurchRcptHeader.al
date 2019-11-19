tableextension 14135118 lvngPurchRcptHeader extends "Purch. Rcpt. Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}