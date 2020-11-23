table 14135307 "lvnAccrualRules"
{
    Caption = 'Commission Accrual Rules';
    DataClassification = CustomerContent;
    LookupPageId = lvnAccrualRules;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; "Dimension 1 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 1 Accrual Option';
            CaptionClass = '14135307,1,1';
            DataClassification = CustomerContent;
        }
        field(21; "Dimension 2 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 2 Accrual Option';
            CaptionClass = '14135307,1,2';
            DataClassification = CustomerContent;
        }
        field(22; "Dimension 3 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 3 Accrual Option';
            CaptionClass = '14135307,1,3';
            DataClassification = CustomerContent;
        }
        field(23; "Dimension 4 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 4 Accrual Option';
            CaptionClass = '14135307,1,4';
            DataClassification = CustomerContent;
        }
        field(24; "Dimension 5 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 5 Accrual Option';
            CaptionClass = '14135307,1,5';
            DataClassification = CustomerContent;
        }
        field(25; "Dimension 6 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 6 Accrual Option';
            CaptionClass = '14135307,1,6';
            DataClassification = CustomerContent;
        }
        field(26; "Dimension 7 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 7 Accrual Option';
            CaptionClass = '14135307,1,7';
            DataClassification = CustomerContent;
        }
        field(27; "Dimension 8 Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Dimension 8 Accrual Option';
            CaptionClass = '14135307,1,8';
            DataClassification = CustomerContent;
        }
        field(28; "Business Unit Accrual Option"; Enum lvnAccrualDimensionOption)
        {
            Caption = 'Business Unit Accrual Option';
            DataClassification = CustomerContent;
        }
        field(30; "Default Dimension 1 Code"; Code[20])
        {
            Caption = 'Default Dimension 1 Code';
            CaptionClass = '14135307,2,1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(31; "Default Dimension 2 Code"; Code[20])
        {
            Caption = 'Default Dimension 2 Code';
            CaptionClass = '14135307,2,2';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(32; "Default Dimension 3 Code"; Code[20])
        {
            Caption = 'Default Dimension 3 Code';
            CaptionClass = '14135307,2,3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(33; "Default Dimension 4 Code"; Code[20])
        {
            Caption = 'Default Dimension 4 Code';
            CaptionClass = '14135307,2,4';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(34; "Default Dimension 5 Code"; Code[20])
        {
            Caption = 'Default Dimension 5 Code';
            CaptionClass = '14135307,2,5';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(35; "Default Dimension 6 Code"; Code[20])
        {
            Caption = 'Default Dimension 6 Code';
            CaptionClass = '14135307,2,6';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(36; "Default Dimension 7 Code"; Code[20])
        {
            Caption = 'Default Dimension 7 Code';
            CaptionClass = '14135307,2,7';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(37; "Default Dimension 8 Code"; Code[20])
        {
            Caption = 'Default Dimension 8 Code';
            CaptionClass = '14135307,2,8';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(38; "Default Business Unit Code"; Code[20])
        {
            Caption = 'Default Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}