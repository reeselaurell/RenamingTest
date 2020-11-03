page 14135220 "lvnReportGeneratorBatchList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnReportGeneratorBatch;
    Caption = 'Report Generator Batches';
    CardPageId = lvnReportGeneratorBatchCard;

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
                    Report: Report lvnRptGeneratorBatchProcess;
                begin
                    Report.SetParams(Rec.Code);
                    Report.Run();
                end;
            }
        }
    }
}