table 14135238 lvngReportGeneratorSequence
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Batch Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngReportGeneratorBatch; }
        field(2; "Sequence No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { DataClassification = CustomerContent; }
        field(11; "Row Layout"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceRowSchema.Code where("Schema Type" = const(Period)); }
        field(12; "Band Layout"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColSchema.Code; }
        field(13; "Expand Filter"; Enum lvngReportGeneratorFilterExpansion) { DataClassification = CustomerContent; }
        field(14; "Business Unit Filter"; Text[250]) { DataClassification = CustomerContent; TableRelation = "Business Unit".Code; ValidateTableRelation = false; }
        field(15; "Dimension 1 Filter"; Text[250]) { DataClassification = CustomerContent; CaptionClass = '1,4,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); ValidateTableRelation = false; }
        field(16; "Dimension 2 Filter"; Text[250]) { DataClassification = CustomerContent; CaptionClass = '1,4,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); ValidateTableRelation = false; }
        field(17; "Dimension 3 Filter"; Text[250]) { DataClassification = CustomerContent; CaptionClass = '1,4,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); ValidateTableRelation = false; }
        field(18; "Dimension 4 Filter"; Text[250]) { DataClassification = CustomerContent; CaptionClass = '1,4,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); ValidateTableRelation = false; }
    }

    keys
    {
        key(PK; "Batch Code", "Sequence No.") { Clustered = true; }
    }
}