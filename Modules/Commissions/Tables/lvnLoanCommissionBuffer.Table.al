table 14135309 "lvnLoanCommissionBuffer"
{
    Caption = 'Loan Commission Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(11; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
        }
        field(12; "Profile Line No."; Integer)
        {
            Caption = 'Profile Line No.';
            DataClassification = CustomerContent;
        }
        field(13; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(14; "Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
            DataClassification = CustomerContent;
        }
        field(15; Bps; Decimal)
        {
            Caption = 'Bps';
            DataClassification = CustomerContent;
        }
        field(16; "Commission Date"; Date)
        {
            Caption = 'Commission Date';
            DataClassification = CustomerContent;
        }
        field(17; "Value Entry"; Boolean)
        {
            Caption = 'Value Entry';
            DataClassification = CustomerContent;
        }
        field(18; "Calculation Only"; Boolean)
        {
            Caption = 'Calculation Only';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(BufferSorting; "Profile Code", "Commission Date", "Profile Line No.") { SumIndexFields = "Base Amount"; }
    }
}