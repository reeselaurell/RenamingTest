table 14135223 lvngPeriodPerfBandSchemaLine
{
    Caption = 'Period Performance Band Schema Line';
    DataClassification = CustomerContent;
    LookupPageId = lvngPeriodPerfBandSchemaLines;

    fields
    {
        field(1; "Schema Code"; Code[20]) { Caption = 'Schema Code'; DataClassification = CustomerContent; TableRelation = lvngPeriodPerfBandSchema.Code; }
        field(2; "Band No."; Integer)
        {
            Caption = 'Band No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Band No." <= 0 then
                    Error(ShouldBePositiveNumberErr, FieldCaption("Band No."));
            end;
        }
        field(10; "Period Type"; Enum lvngPerformancePeriodType) { Caption = 'Period Type'; DataClassification = CustomerContent; }
        field(11; "Period Offset"; Integer) { Caption = 'Period Offset'; DataClassification = CustomerContent; }
        field(12; "Period Length Formula"; DateFormula) { Caption = 'Period Length Formula'; DataClassification = CustomerContent; }
        field(13; "Header Description"; Text[50]) { Caption = 'Header Description'; DataClassification = CustomerContent; }
        field(14; "Dynamic Date Description"; Boolean) { Caption = 'Dynamic Date Description'; DataClassification = CustomerContent; }
        field(18; "Date From"; Date) { Caption = 'Date From'; DataClassification = CustomerContent; }
        field(19; "Date To"; Date) { Caption = 'Date To'; DataClassification = CustomerContent; }
        field(20; "Band Type"; Enum lvngPerformanceBandType) { Caption = 'Band Type'; DataClassification = CustomerContent; }
        field(21; "Row Formula Code"; Code[20]) { Caption = 'Row Formula Code'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Schema Code", "Band No.") { Clustered = true; }
    }

    var
        ShouldBePositiveNumberErr: Label '%1 should be positive number';
}