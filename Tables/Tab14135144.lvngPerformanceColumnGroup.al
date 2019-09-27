table 14135144 lvngPerformanceColumnGroup
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
        ColumnGroupLine: Record lvngPerformanceColumnGroupLine;
    begin
        ColumnGroupLine.Reset();
        ColumnGroupLine.SetRange("Group Code", Code);
        ColumnGroupLine.DeleteAll();
    end;
}