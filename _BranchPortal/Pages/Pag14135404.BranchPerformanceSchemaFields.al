page 14135404 lvngBranchPerfSchemaFields
{
    PageType = List;
    Caption = 'Performance Schema Fields';
    SourceTable = lvngPerformanceSchemaLine;
    DelayedInsert = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Details)
            {
                Image = FiledOverview;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PerfSchemaFieldCard: Page lvngBranchPerfSchemaFieldCard;
                begin
                    Clear(PerfSchemaFieldCard);
                    PerfSchemaFieldCard.SetRecord(Rec);
                    PerfSchemaFieldCard.RunModal();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PerformanceSchemaLine: Record lvngPerformanceSchemaLine;
    begin
        PerformanceSchemaLine.Reset();
        PerformanceSchemaLine.SetRange("Performance Schema Code", "Performance Schema Code");
        if PerformanceSchemaLine.FindLast() then
            "Line No." := PerformanceSchemaLine."Line No." + 10
        else
            "Line No." := 10;
    end;
}