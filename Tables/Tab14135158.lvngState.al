table 14135158 lvngState
{
    Caption = 'State';
    DataClassification = CustomerContent;
    LookupPageId = lvngStates;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(100; "Tax Rate"; Decimal)
        {
            Caption = 'Tax Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;

        }
        field(101; "Tax Payment Frequency"; enum lvngTaxFrequency)
        {
            Caption = 'Tax Payment Frequency';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}