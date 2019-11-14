table 14135313 "lvngCommissionTierLine"
{
    Caption = 'Commission Tier Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionTierHeader.lvngCode;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngFromVolume; Decimal)
        {
            Caption = 'From Volume';
            DataClassification = CustomerContent;
        }
        field(11; lvngToVolume; Decimal)
        {
            Caption = 'To Volume';
            DataClassification = CustomerContent;
        }
        field(12; lvngFromUnits; Decimal)
        {
            Caption = 'From Units';
            DataClassification = CustomerContent;
        }
        field(13; lvngToUnits; Decimal)
        {
            Caption = 'To Units';
            DataClassification = CustomerContent;
        }
        field(20; lvngRate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(21; lvngRetroactive; Boolean)
        {
            Caption = 'Retroactive';
            DataClassification = CustomerContent;
        }
        field(100; lvngSpreadAmount; Decimal)
        {
            Caption = 'Spread Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngCode, lvngLineNo)
        {
            Clustered = true;
        }
    }

}