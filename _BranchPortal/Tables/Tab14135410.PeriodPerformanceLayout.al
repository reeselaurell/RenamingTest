table 14135410 lvngPeriodPerformanceLayout
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        SchemaColumn: Record lvngPeriodPerfLayoutColumn;
    begin
        SchemaColumn.Reset();
        SchemaColumn.SetRange("Layout Code", Code);
        SchemaColumn.DeleteAll();
    end;
}