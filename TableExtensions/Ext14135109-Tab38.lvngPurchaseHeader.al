tableextension 14135109 lvngPurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; "Document Total (Check)"; Decimal) { Caption = 'Document Total (Check)'; DataClassification = CustomerContent; BlankZero = true; }
    }

}