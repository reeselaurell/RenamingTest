table 14135237 lvngReportGeneratorBatch
{
    DataClassification = CustomerContent;
    LookupPageId = lvngReportGeneratorBatchList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { DataClassification = CustomerContent; }
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