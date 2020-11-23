table 14135173 "lvnPerformanceValueBuffer"
{
    Caption = 'Performance Value Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Row No."; Integer)
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(2; "Band No."; Integer)
        {
            Caption = 'Band No.';
            DataClassification = CustomerContent;
        }
        field(3; "Column No."; Integer)
        {
            Caption = 'Column No.';
            DataClassification = CustomerContent;
        }
        field(10; Value; Decimal)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(11; Interactive; Boolean)
        {
            Caption = 'Interactive';
            DataClassification = CustomerContent;
        }
        field(12; "Style Code"; Code[20])
        {
            Caption = 'Style Code';
            DataClassification = CustomerContent;
        }
        field(13; "Number Format Code"; Code[20])
        {
            Caption = 'Number Format Code';
            DataClassification = CustomerContent;
        }
        field(14; "Calculation Unit Code"; Code[20])
        {
            Caption = 'Calculation Unit Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Row No.", "Band No.", "Column No.") { Clustered = true; }
        key(CalcUnit; "Calculation Unit Code") { }
    }
}