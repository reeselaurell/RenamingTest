table 14135168 "lvnPeriodPerfBandSchema"
{
    Caption = 'Period Performance Band Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvnPeriodPerfBandSchemaList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
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
        BandLine: Record lvnPeriodPerfBandSchemaLine;
    begin
        BandLine.Reset();
        BandLine.SetRange("Schema Code", Code);
        BandLine.DeleteAll();
    end;
}