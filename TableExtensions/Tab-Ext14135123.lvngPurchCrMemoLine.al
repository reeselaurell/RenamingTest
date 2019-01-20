tableextension 14135123 "lvngPurchCrMemoLine" extends "Purch. Cr. Memo Line" //MyTargetTableId
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