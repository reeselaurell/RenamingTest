tableextension 14135116 lvngSalesCrMemoHeader extends "Sales Cr.Memo Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}