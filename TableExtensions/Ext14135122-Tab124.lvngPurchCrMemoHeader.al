tableextension 14135122 lvngPurchCrMemoHeader extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}