table 14135407 lvngDimensionPerformanceLayout
{
    LookupPageId = lvngDimensionPerfLayouts;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; "Dimension Code"; Code[20])
        {
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Columns: Record lvngDimensionPerfLayoutColumn;
            begin
                Columns.Reset();
                Columns.SetRange("Layout Code", Code);
                if not Columns.IsEmpty() then
                    if Confirm(DeleteLayoutQst) then
                        Columns.DeleteAll()
                    else
                        Error(CanceledErr);
            end;

        }
        field(12; "Dynamic Layout"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        DeleteLayoutQst: Label 'Existing column layout will be deleted. Continue?';
        CanceledErr: Label 'Canceled by user';
}