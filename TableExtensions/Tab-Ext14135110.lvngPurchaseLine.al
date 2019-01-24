tableextension 14135110 "lvngPurchaseLine" extends "Purchase Line" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }
        field(200; lvngServicingType; enum lvngServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
    }

}