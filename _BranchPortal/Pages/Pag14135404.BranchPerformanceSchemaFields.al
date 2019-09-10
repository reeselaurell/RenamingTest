page 14135404 lvngBranchPerfSchemaFields
{
    PageType = List;
    Caption = 'Branch Performance Schema Fields';
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
                    BranchPerfSchemaFieldCard: Page lvngBranchPerfSchemaFieldCard;
                begin
                    Clear(BranchPerfSchemaFieldCard);
                    BranchPerfSchemaFieldCard.SetRecord(Rec);
                    BranchPerfSchemaFieldCard.RunModal();
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