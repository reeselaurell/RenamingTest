tableextension 14135128 lvngBankRecLine extends "Bank Rec. Line"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
    }
}