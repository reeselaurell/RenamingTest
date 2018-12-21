tableextension 14135101 "lvngGenJnlLine" extends "Gen. Journal Line" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }

        field(14135500; lvngImportID; Guid)
        {
            Caption = 'Import ID';
            DataClassification = CustomerContent;
        }
    }
}