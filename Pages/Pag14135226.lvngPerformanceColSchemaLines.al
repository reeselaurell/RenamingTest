page 14135226 lvngPerformanceColSchemaLines
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
                field("Primary Caption"; "Primary Caption") { ApplicationArea = All; }
                field("Secondary Caption"; "Secondary Caption") { ApplicationArea = All; }
            }
        }
    }
}