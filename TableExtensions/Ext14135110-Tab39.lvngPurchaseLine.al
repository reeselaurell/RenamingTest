tableextension 14135110 lvngPurchaseLine extends "Purchase Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135102; lvngReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
    }
}