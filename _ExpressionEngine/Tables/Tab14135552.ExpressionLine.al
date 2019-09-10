table 14135552 lvngExpressionLine
{
    fields
    {
        field(1; "Expression Code"; Code[20]) { NotBlank = true; DataClassification = CustomerContent; }
        field(2; "Line No."; Integer) { NotBlank = true; DataClassification = CustomerContent; }
        field(3; "Split No."; Integer) { DataClassification = CustomerContent; }
        field(10; "Left Side"; Text[250]) { DataClassification = CustomerContent; }
        field(11; Comparison; Enum lvngComparison) { DataClassification = CustomerContent; }
        field(12; "Right Side"; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Expression Code", "Line No.", "Split No.") { Clustered = true; }
    }
}