table 14135138 lvngGroupedGLEntry
{
    Caption = 'Grouped G/L Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Posting Date"; Date) { Caption = 'Posting Date'; DataClassification = CustomerContent; }
        field(2; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(3; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(4; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(5; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(6; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(7; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(8; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(9; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(10; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(11; "G/L Account No."; Code[20]) { Caption = 'G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(100; Amount; Decimal) { Caption = 'Amount'; DataClassification = CustomerContent; }
        field(101; "Debit Amount"; Decimal) { Caption = 'Debit Amount'; DataClassification = CustomerContent; }
        field(102; "Credit Amount"; Decimal) { Caption = 'Credit Amount'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Posting Date", "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code", "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code", "Business Unit Code") { Clustered = true; }
    }

}