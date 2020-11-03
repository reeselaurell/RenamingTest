tableextension 14135119 "lvnPurchRcptLine" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(14135102; lvnReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(14135110; lvnComment; Text[250]) { Caption = 'Comment'; DataClassification = CustomerContent; }
    }
}