tableextension 14135123 lvngPurchCrMemoLine extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135102; lvngReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(14135109; lvngDeliveryState; Code[20]) { Caption = 'Delivery State'; DataClassification = CustomerContent; TableRelation = lvngState; }
        field(14135116; lvngUseSalesTax; Boolean) { Caption = 'Use Sales Tax'; DataClassification = CustomerContent; }
    }
}