table 14135182 "lvnPerformanceBandLineInfo"
{
    Caption = 'Performance Band Line Info';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Band No."; Integer)
        {
            Caption = 'Band No.';
            DataClassification = CustomerContent;
        }
        field(10; "Header Description"; Text[50])
        {
            Caption = 'Header Description';
            DataClassification = CustomerContent;
        }
        field(11; "Band Type"; Enum lvnPerformanceBandType)
        {
            Caption = 'Band Type';
            DataClassification = CustomerContent;
        }
        field(12; "Row Formula Code"; Code[20])
        {
            Caption = 'Row Formula Code';
            DataClassification = CustomerContent;
        }
        field(13; "Band Index"; Integer)
        {
            Caption = 'Band Index';
            DataClassification = CustomerContent;
        }
        field(14; "Date From"; Date)
        {
            Caption = 'Date From';
            DataClassification = CustomerContent;
        }
        field(15; "Date To"; Date)
        {
            Caption = 'Date To';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Band No.") { Clustered = true; }
    }
}