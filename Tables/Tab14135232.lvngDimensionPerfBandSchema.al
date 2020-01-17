table 14135232 lvngDimensionPerfBandSchema
{
    Caption = 'Dimension Performance Band Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngDimPerfBandSchemaList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(2; "Dynamic Layout"; Boolean) { Caption = 'Dynamic Layout'; DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(12; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
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