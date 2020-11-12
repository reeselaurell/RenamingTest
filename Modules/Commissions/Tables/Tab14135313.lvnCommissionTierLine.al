table 14135313 lvnCommissionTierLine
{
    Caption = 'Commission Tier Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tier Code"; Code[20])
        {
            Caption = 'Tier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionTierHeader.Code;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "From Volume"; Decimal)
        {
            Caption = 'From Volume';
            DataClassification = CustomerContent;
        }
        field(11; "To Volume"; Decimal)
        {
            Caption = 'To Volume';
            DataClassification = CustomerContent;
        }
        field(12; "From Units"; Decimal)
        {
            Caption = 'From Units';
            DataClassification = CustomerContent;
        }
        field(13; "To Units"; Decimal)
        {
            Caption = 'To Units';
            DataClassification = CustomerContent;
        }
        field(20; Rate; Decimal)
        {
            Caption = 'Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(21; Retroactive; Boolean)
        {
            Caption = 'Retroactive';
            DataClassification = CustomerContent;
        }
        field(100; "Spread Amount"; Decimal)
        {
            Caption = 'Spread Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Tier Code", "Line No.") { Clustered = true; }
    }
}