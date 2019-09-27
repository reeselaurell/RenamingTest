table 14135139 lvngRowPerformanceSchema
{
    LookupPageId = lvngPerformanceSchema;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(20; "Schema Type"; Enum lvngRowPerformanceSchemaType) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        PerformanceSchemaLine: Record lvngPerformanceSchemaLine;
    begin
        PerformanceSchemaLine.Reset();
        PerformanceSchemaLine.SetRange("Performance Schema Code", Code);
        PerformanceSchemaLine.DeleteAll();
    end;

}