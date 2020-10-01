page 14135220 lvngReportGeneratorBatchList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngReportGeneratorBatch;
    Caption = 'Report Generator Batches';
    CardPageId = lvngReportGeneratorBatchCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExecuteBatch)
            {
                ApplicationArea = All;
                Caption = 'Execute';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = ExecuteBatch;

                trigger OnAction();
                var
                    Report: Report lvngRptGeneratorBatchProcess;
                begin
                    Report.SetParams(Rec.Code);
                    Report.Run();
                end;
            }
        }
    }
}