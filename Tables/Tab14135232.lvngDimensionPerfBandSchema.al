table 14135232 lvngDimensionPerfBandSchema
{
    DataClassification = CustomerContent;
    LookupPageId = lvngDimPerfBandSchemaList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Dynamic Layout"; Boolean) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(12; "Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Dimension.Code;

            trigger OnValidate()
            var
                BandLine: Record lvngDimPerfBandSchemaLine;
            begin
                BandLine.Reset();
                BandLine.SetRange("Schema Code", Code);
                if not BandLine.IsEmpty then
                    if Confirm(DeleteExistingSchemaQst) then
                        BandLine.DeleteAll()
                    else
                        Error(CanceledByUserErr);
            end;
        }
    }

    keys
    {
        key(PK; Code, "Dynamic Layout") { Clustered = true; }
    }

    var
        DeleteExistingSchemaQst: Label 'Existing schema lines will be deleted. Continue?';
        CanceledByUserErr: Label 'Canceled by user';

    trigger OnDelete()
    var
        BandLine: Record lvngDimPerfBandSchemaLine;
    begin
        BandLine.Reset();
        BandLine.SetRange("Schema Code", Code);
        BandLine.DeleteAll();
    end;
}