tableextension 14135107 "lvngSalesHeader" extends "Sales Header" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }
    }

}