page 14135221 "lvnReportGeneratorBatchCard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnReportGeneratorBatch;
    Caption = 'Report Generator Batch';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
            part(Details; lvnRptGeneratorSequencePart)
            {
                ApplicationArea = All;
                SubPageLink = "Batch Code" = field(Code);
            }
        }
    }
}