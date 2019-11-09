table 14135226 lvngSystemCalculationFilter
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { DataClassification = CustomerContent; }
        field(11; "Shortcut Dimension 1"; Text[250]) { DataClassification = CustomerContent; }
        field(12; "Shortcut Dimension 2"; Text[250]) { DataClassification = CustomerContent; }
        field(13; "Shortcut Dimension 3"; Text[250]) { DataClassification = CustomerContent; }
        field(14; "Shortcut Dimension 4"; Text[250]) { DataClassification = CustomerContent; }
        field(15; "Shortcut Dimension 5"; Text[250]) { DataClassification = CustomerContent; }
        field(16; "Shortcut Dimension 6"; Text[250]) { DataClassification = CustomerContent; }
        field(17; "Shortcut Dimension 7"; Text[250]) { DataClassification = CustomerContent; }
        field(18; "Shortcut Dimension 8"; Text[250]) { DataClassification = CustomerContent; }
        field(19; "Business Unit"; Text[250]) { DataClassification = CustomerContent; }
        field(20; "As Of Date"; Date) { DataClassification = CustomerContent; }
        field(21; "Date Filter"; Text[50]) { DataClassification = CustomerContent; }
        field(22; "Block Data From Date"; Date) { DataClassification = CustomerContent; }
        field(23; "Block Data To Date"; Date) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    var
        InvalidOperationErr: Label 'System Calculation Filter table is not designed to store values';

    trigger OnInsert()
    begin
        Error(InvalidOperationErr);
    end;
}