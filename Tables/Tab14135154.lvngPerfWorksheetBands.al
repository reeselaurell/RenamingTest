table 14135154 "lvngPerfWorksheetBands"
{
    Caption = 'Performance Worksheet Bands';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        lvngPerfworksheetColumnBand: Record lvngPerfWorksheetColumnBand;
    begin
        lvngPerfworksheetColumnBand.Reset();
        lvngPerfworksheetColumnBand.SetRange(lvngCode, lvngCode);
        lvngPerfworksheetColumnBand.DeleteAll(true);
    end;

}