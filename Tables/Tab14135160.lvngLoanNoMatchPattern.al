table 14135160 "lvngLoanNoMatchPattern"
{
    DataClassification = CustomerContent;
    Caption = 'Loan No. Match Pattern';
    LookupPageId = lvngLoanNoMatchPatterns;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(10; lvngDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; lvngMinFieldLength; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Min. Field Length';
        }
        field(12; lvngMaxFieldLength; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Field Length';
        }
        field(13; lvngMatchPattern; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Match Pattern';
        }
    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }
}