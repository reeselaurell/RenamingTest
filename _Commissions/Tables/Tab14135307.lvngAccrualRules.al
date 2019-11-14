table 14135307 "lvngAccrualRules"
{
    Caption = 'Commission Accrual Rules';
    DataClassification = CustomerContent;
    LookupPageId = lvngAccrualRules;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; lvngDimension1AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 1 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(21; lvngDimension2AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 2 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(22; lvngDimension3AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 3 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(23; lvngDimension4AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 4 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(24; lvngDimension5AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 5 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(25; lvngDimension6AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 6 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(26; lvngDimension7AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 7 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(27; lvngDimension8AccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Dimension 8 Accrual Option';
            DataClassification = CustomerContent;
        }
        field(28; lvngBusinessUnitAccrualOption; Enum lvngAccrualDimensionOption)
        {
            Caption = 'Business Unit Accrual Option';
            DataClassification = CustomerContent;
        }

        field(30; lvngDefaultDimension1Code; Code[20])
        {
            Caption = 'Default Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(31; lvngDefaultDimension2Code; Code[20])
        {
            Caption = 'Default Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(32; lvngDefaultDimension3Code; Code[20])
        {
            Caption = 'Default Dimension 3 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(33; lvngDefaultDimension4Code; Code[20])
        {
            Caption = 'Default Dimension 4 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(34; lvngDefaultDimension5Code; Code[20])
        {
            Caption = 'Default Dimension 5 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(35; lvngDefaultDimension6Code; Code[20])
        {
            Caption = 'Default Dimension 6 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(36; lvngDefaultDimension7Code; Code[20])
        {
            Caption = 'Default Dimension 7 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(37; lvngDefaultDimension8Code; Code[20])
        {
            Caption = 'Default Dimension 8 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(38; lvngDefaultBusinessUnitCode; Code[20])
        {
            Caption = 'Default Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
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