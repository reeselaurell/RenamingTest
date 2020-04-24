table 14135183 lvngReportGeneratorBatch
{
    Caption = 'Report Generator Batch';
    DataClassification = CustomerContent;
    LookupPageId = lvngReportGeneratorBatchList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        ReportGeneratorSequence: Record lvngReportGeneratorSequence;
    begin
        ReportGeneratorSequence.Reset();
        ReportGeneratorSequence.SetRange("Batch Code", Code);
        ReportGeneratorSequence.DeleteAll(true);
    end;
}