tableextension 14135117 "lvngSalesCrMemoLine" extends "Sales Cr.Memo Line" //MyTargetTableId
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