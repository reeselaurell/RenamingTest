page 14135225 lvngPerformanceColSchemaList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngPerformanceColSchema;
    Caption = 'Performance Column Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; ; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SchemaLines)
            {
                ApplicationArea = All;
                Caption = 'Schema Lines';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngPerformanceColSchemaLines;
                RunPageView = sorting("Schema Code", "Column No.") order(ascending);
                RunPageLink = "Schema Code" = field(Code);
            }
        }
    }
}