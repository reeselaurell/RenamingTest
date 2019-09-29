page 14135166 lvngPerformanceColSchemaLines
{
    PageType = List;
    SourceTable = lvngPerformanceColSchemaLine;
    Caption = 'Performance Column Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Column No."; "Column No.") { Editable = false; ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }
}