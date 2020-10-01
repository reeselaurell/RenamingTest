page 14135221 lvngReportGeneratorBatchCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngReportGeneratorBatch;
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
            part(Details; lvngRptGeneratorSequencePart)
            {
                ApplicationArea = All;
                SubPageLink = "Batch Code" = field(Code);
            }
        }
    }
}