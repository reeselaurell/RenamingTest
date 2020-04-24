table 14135233 lvngDimPerfBandSchemaLine
{
    Caption = 'Dimension Performance Band Schema Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { Caption = 'Schema Code'; DataClassification = CustomerContent; TableRelation = lvngDimensionPerfBandSchema.Code; }
        field(2; "Band No."; Integer)
        {
            Caption = 'Band No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Band No." <= 0 then
                    Error(ShouldBePositiveErr, FieldCaption("Band No."));
            end;
        }
        field(10; "Dimension Filter"; Code[20]) { Caption = 'Dimension Filter'; DataClassification = CustomerContent; }
        field(11; "Header Description"; Text[100]) { Caption = 'Header Description'; DataClassification = CustomerContent; }
        field(12; "Band Type"; Enum lvngPerformanceBandType) { Caption = 'Band Type'; DataClassification = CustomerContent; }
        field(13; "Row Formula Code"; Code[20]) { Caption = 'Row Formula Code'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Band No.") { Clustered = true; }
    }

    var
        ShouldBePositiveErr: Label '%1 should be positive number';
}