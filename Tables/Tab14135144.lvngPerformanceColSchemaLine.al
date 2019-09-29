table 14135144 lvngPerformanceColSchemaLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceColSchema.Code; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
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