table 14135452 lvngSystemCalculationFilter
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Integer) { DataClassification = SystemMetadata; }
        field(10; "Business Unit"; Text[250]) { DataClassification = SystemMetadata; }
        field(11; "Shortcut Dimension 1"; Text[250]) { DataClassification = SystemMetadata; }
        field(12; "Shortcut Dimension 2"; Text[250]) { DataClassification = SystemMetadata; }
        field(13; "Shortcut Dimension 3"; Text[250]) { DataClassification = SystemMetadata; }
        field(14; "Shortcut Dimension 4"; Text[250]) { DataClassification = SystemMetadata; }
        field(15; "Shortcut Dimension 5"; Text[250]) { DataClassification = SystemMetadata; }
        field(16; "Shortcut Dimension 6"; Text[250]) { DataClassification = SystemMetadata; }
        field(17; "Shortcut Dimension 7"; Text[250]) { DataClassification = SystemMetadata; }
        field(18; "Shortcut Dimension 8"; Text[250]) { DataClassification = SystemMetadata; }
        field(19; "Date From"; Date) { DataClassification = SystemMetadata; }
        field(20; "Date To"; Date) { DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}