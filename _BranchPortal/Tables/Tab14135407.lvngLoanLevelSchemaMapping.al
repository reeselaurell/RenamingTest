table 14135407 lvngLoanLevelSchemaMapping
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50]) { DataClassification = CustomerContent; }
        field(2; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoanLevelReportSchema.Code; }
        field(10; Description; Text[250]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoanLevelReportSchema.Description where(Code = field("Schema Code"))); }
        field(11; Sequence; Integer) { DataClassification = CustomerContent; }
        field(12; "Base Date"; Enum lvngLoanLevelReportBaseDate) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID", "Schema Code") { Clustered = true; }
        key(Sequence; Sequence) { }
    }
}