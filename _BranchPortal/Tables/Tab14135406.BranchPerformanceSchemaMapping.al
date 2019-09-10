table 14135406 lvngBranchPerfSchemaMapping
{
    fields
    {
        field(1; "User ID"; Code[50]) { DataClassification = CustomerContent; }
        field(2; "Schema Code"; Code[20])
        {
            TableRelation = lvngPerformanceSchema.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PerformanceSchema: Record lvngPerformanceSchema;
            begin
                PerformanceSchema.Get();
                "Based On" := PerformanceSchema."Based On";
                "Layout Code" := '';
            end;
        }
        field(3; "Layout Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = if ("Based On" = const (Periods)) lvngPeriodPerformanceLayout.Code else if ("Based On" = const (Dimensions)) lvngDimensionPerformanceLayout.Code; }
        field(4; "Column Grouping Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColumnGroup.Code; }
        field(10; "Unique ID"; Integer) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(11; Sequence; Integer) { DataClassification = CustomerContent; }
        field(12; "Based On"; Enum lvngPerformanceSchemaBase) { DataClassification = CustomerContent; Editable = false; }
        field(13; Description; Text[50]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "User ID", "Schema Code", "Layout Code", "Column Grouping Code") { Clustered = true; }
        key(Sequence; Sequence) { }
    }
}