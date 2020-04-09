table 14135220 lvngPerformanceRowSchema
{
    Caption = 'Performance Row Schema';
    LookupPageId = lvngPerformanceRowSchemaList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Schema Type"; Enum lvngPerformanceRowSchemaType) { Caption = 'Schema Type'; DataClassification = CustomerContent; }
        field(12; "Column Schema"; Code[20]) { Caption = 'Column Schema'; DataClassification = CustomerContent; TableRelation = lvngPerformanceColSchema; }
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