table 14135405 lvngBranchPerfSchemaMapping
{
    fields
    {
        field(1; "User ID"; Code[50]) { DataClassification = CustomerContent; }
        field(2; "Row Schema Code"; Code[20])
        {
            TableRelation = lvngPerformanceRowSchema.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PerformanceRowSchema: Record lvngPerformanceRowSchema;
            begin
                PerformanceRowSchema.Get("Row Schema Code");
                "Based On" := PerformanceRowSchema."Schema Type";
                "Band Schema Code" := '';
            end;
        }
        field(3; "Band Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = if ("Based On" = const(lvngPeriod)) lvngPeriodPerfBandSchema.Code else lvngDimensionPerfBandSchema.Code; }
        field(10; Sequence; Integer) { DataClassification = CustomerContent; }
        field(11; "Based On"; Enum lvngPerformanceRowSchemaType) { DataClassification = CustomerContent; Editable = false; }
        field(12; Description; Text[100]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID", "Row Schema Code", "Band Schema Code") { Clustered = true; }
        key(Sequence; Sequence) { }
    }
}