page 14135242 lvngReportGeneratorBatchCard
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
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
            part(Details; lvngRptGeneratorSequencePart)
            {
                ApplicationArea = All;
                SubPageLink = "Batch Code" = field(Code);
            }
        }
    }
}