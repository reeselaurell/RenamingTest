table 14135230 lvngNumberFormat
{
    DataClassification = CustomerContent;
    LookupPageId = lvngNumberFormatList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { }
        field(11; "Value Type"; Enum lvngPerformanceValueType) { DataClassification = CustomerContent; }
        field(12; Rounding; Enum lvngRounding) { DataClassification = CustomerContent; }
        field(13; "Blank Zero"; Enum lvngBlankZero) { DataClassification = SystemMetadata; }
        field(14; "Negative Formatting"; Enum lvngNegativeFormatting) { DataClassification = CustomerContent; }
        field(15; "Suppress Thousand Separator"; Boolean) { DataClassification = CustomerContent; }
        field(16; "Invert Sign"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}