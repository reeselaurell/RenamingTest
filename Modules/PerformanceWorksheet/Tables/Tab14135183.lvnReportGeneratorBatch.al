table 14135183 "lvnReportGeneratorBatch"
{
    Caption = 'Report Generator Batch';
    DataClassification = CustomerContent;
    LookupPageId = lvnReportGeneratorBatchList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        ReportGeneratorSequence: Record lvnReportGeneratorSequence;
    begin
        ReportGeneratorSequence.Reset();
        ReportGeneratorSequence.SetRange("Batch Code", Code);
        ReportGeneratorSequence.DeleteAll(true);
    end;
}