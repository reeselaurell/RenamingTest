page 14135205 lvngPerformanceColSchemaLines
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
                field("Column No."; Rec."Column No.") { Editable = false; ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Primary Caption"; Rec."Primary Caption") { ApplicationArea = All; }
                field("Secondary Caption"; Rec."Secondary Caption") { ApplicationArea = All; }
            }
        }
    }
}