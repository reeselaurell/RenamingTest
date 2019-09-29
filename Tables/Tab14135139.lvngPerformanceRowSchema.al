table 14135139 lvngPerformanceRowSchema
{
    LookupPageId = lvngPerformanceRowSchemaList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(11; "Schema Type"; Enum lvngPerformanceRowSchemaType) { DataClassification = CustomerContent; }
        field(12; "Column Schema"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColSchema; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        PerformanceSchemaLine: Record lvngPerformanceRowSchemaLine;
    begin
        PerformanceSchemaLine.Reset();
        PerformanceSchemaLine.SetRange("Schema Code", Code);
        PerformanceSchemaLine.DeleteAll();
    end;

}