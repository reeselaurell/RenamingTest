table 14135222 lvngPeriodPerfBandSchema
{
    Caption = 'Period Performance Band Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngPeriodPerfBandSchemaList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { Caption = 'Description'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnDelete()
    var
        BandLine: Record lvngPeriodPerfBandSchemaLine;
    begin
        BandLine.Reset();
        BandLine.SetRange("Schema Code", Code);
        BandLine.DeleteAll();
    end;
}