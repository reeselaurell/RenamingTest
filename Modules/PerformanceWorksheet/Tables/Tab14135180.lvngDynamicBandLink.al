table 14135180 lvngDynamicBandLink
{
    Caption = 'Dynamic Band Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dimension Code"; Code[20]) { Caption = 'Dimension Code'; DataClassification = CustomerContent; TableRelation = Dimension; }
        field(2; "Dimension Value Code"; Code[20]) { Caption = 'Dimension Value Code'; DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code")); }
        field(10; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
        field(11; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
        field(12; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(13; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14; "Business Unit Code"; Code[20]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit".Code; }
    }

    keys
    {
        key(PK; "Dimension Code", "Dimension Value Code") { Clustered = true; }
    }
}