table 14135141 lvngPeriodPerfBandSchema
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
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
        BandLine.SetRange("Band Code", Code);
        BandLine.DeleteAll();
    end;
}