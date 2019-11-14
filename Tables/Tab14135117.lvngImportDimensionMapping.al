table 14135117 lvngImportDimensionMapping
{
    Caption = 'Import Dimension Mapping';
    DataClassification = CustomerContent;
    LookupPageId = lvngImportDimensionMapping;

    fields
    {
        field(1; "Dimension Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = Dimension.Code; }
        field(2; "Mapping Value"; Code[50]) { DataClassification = CustomerContent; }
        field(10; "Dimension Value Code"; code[20]) { DataClassification = CustomerContent; TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code")); }
    }

    keys
    {
        key(PK; "Dimension Code", "Mapping Value") { Clustered = true; }
    }
}