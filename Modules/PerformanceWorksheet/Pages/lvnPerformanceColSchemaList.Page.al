page 14135204 "lvnPerformanceColSchemaList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnPerformanceColSchema;
    Caption = 'Performance Column Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
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
                RunObject = page lvnPerformanceColSchemaLines;
                RunPageView = sorting("Schema Code", "Column No.") order(ascending);
                RunPageLink = "Schema Code" = field(Code);
            }
        }
    }
}