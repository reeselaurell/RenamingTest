tableextension 14135129 "lvnPostedBankRecLine" extends "Posted Bank Rec. Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(14135101; lvnReasonCode; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
    }
}