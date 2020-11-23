table 14135310 lvnCommissionValueEntry
{
    Caption = 'Commission Value Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(5; "Schedule No."; Integer)
        {
            Caption = 'Schedule No.';
            DataClassification = CustomerContent;
        }
        field(10; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            TableRelation = lvnCommissionProfile.Code;
            DataClassification = CustomerContent;
        }
        field(11; "Calculation Line No."; Integer)
        {
            Caption = 'Calculation Line No.';
            TableRelation = lvnCommissionProfileLine."Line No." where("Profile Code" = field("Profile Code"));
            DataClassification = CustomerContent;
        }
        field(12; "Period Identifier Code"; Code[20])
        {
            Caption = 'Period Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnPeriodIdentifier;
        }
        field(13; "Profile Line Type"; Enum lvnProfileLineType)
        {
            Caption = 'Profile Line Type';
            DataClassification = CustomerContent;
        }
        field(14; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            TableRelation = lvnLoan;
            DataClassification = CustomerContent;
        }
        field(15; "Manual Adjustment"; Boolean)
        {
            Caption = 'Manual Adjustment';
            DataClassification = CustomerContent;
        }
        field(16; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(17; Bps; Decimal)
        {
            Caption = 'Bps';
            DataClassification = CustomerContent;
        }
        field(18; "Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
            DataClassification = CustomerContent;
        }
        field(19; "Commission Date"; Date)
        {
            Caption = 'Commission Date';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(21; "Identifier Code"; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Schedule; "Schedule No.") { }
        key(Totaling; "Profile Code", "Commission Date", "Period Identifier Code", "Profile Line Type", "Identifier Code") { SumIndexFields = "Commission Amount"; }
    }
}