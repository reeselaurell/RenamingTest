tableextension 14135127 "lvnReturnRcptLine" extends "Return Receipt Line"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(14135101; lvnServicingType; enum lvnServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
        field(14135110; lvnComment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
    }
}