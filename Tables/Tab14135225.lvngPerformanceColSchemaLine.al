table 14135225 lvngPerformanceColSchemaLine
{
    Caption = 'Performance Column Schema Line';
    DataClassification = CustomerContent;
    LookupPageId = lvngPerformanceColSchemaLines;

    fields
    {
        field(1; "Schema Code"; Code[20]) { Caption = 'Schema Code'; DataClassification = CustomerContent; TableRelation = lvngPerformanceColSchema.Code; }
        field(2; "Column No."; Integer) { Caption = 'Column No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Primary Caption"; Text[50]) { Caption = 'Primary Caption'; DataClassification = CustomerContent; }
        field(12; "Secondary Caption"; Text[50]) { Caption = 'Secondary Caption'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Column No.") { }
    }

    trigger OnInsert()
    var
        ColLine: Record lvngPerformanceColSchemaLine;
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", "Schema Code");
        if ColLine.FindLast() then
            "Column No." := ColLine."Column No." + 1
        else
            "Column No." := 1;
    end;

    trigger OnDelete()
    var
        ColLine: Record lvngPerformanceColSchemaLine;
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", "Schema Code");
        ColLine.FindLast();
        if ColLine."Column No." > "Column No." then
            Error(OnlyLastLineErr);
    end;

    var
        OnlyLastLineErr: Label 'Only last schema line may be deleted!';
}