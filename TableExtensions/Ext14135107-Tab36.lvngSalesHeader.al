tableextension 14135107 lvngSalesHeader extends "Sales Header"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}