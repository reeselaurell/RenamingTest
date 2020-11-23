table 14135322 "lvnDebtLogWorksheet"
{
    Caption = 'Debt Log Worksheet';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schedule No."; Integer)
        {
            Caption = 'Schedule No.';
            DataClassification = CustomerContent;
        }
        field(2; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionProfile;
        }
        field(10; "Starting Balance"; Decimal)
        {
            Caption = 'Starting Balance';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum(lvnDebtLogValueEntry.Amount where("Profile Code" = field("Profile Code")));
        }
        field(11; "Minimum Advance"; Decimal)
        {
            Caption = 'Minimum Advance';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Minimum Advance" where(Code = field("Profile Code")));
        }
        field(12; "Commission Earned"; Decimal)
        {
            Caption = 'Commission Earned';
            DataClassification = CustomerContent;
        }
        field(13; "Max. Reduction Cap"; Decimal)
        {
            Caption = 'Max. Reduction Cap';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Max. Reduction Cap" where(Code = field("Profile Code")));
        }
        field(14; "Max. Advance Balance"; Decimal)
        {
            Caption = 'Max. Advance Balance';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Max. Advance Balance" where(Code = field("Profile Code")));
        }
        field(15; "Debt Log LO Type"; enum lvnDebtLogLOType)
        {
            Caption = 'Debt Log Loan Officer Type';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Debt Log LO Type" where(Code = field("Profile Code")));
        }
        field(16; "Total Draw/Recovery"; Decimal)
        {
            Caption = 'Total Draw/Recovery';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum(lvnDebtLogJournalLine.Amount where("Schedule No." = field("Schedule No."), "Profile Code" = field("Profile Code")));
        }
        field(100; "Additional Code"; Code[50])
        {
            Caption = 'Additional Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Additional Code" where(Code = field("Profile Code")));
        }
        field(101; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Cost Center Code" where(Code = field("Profile Code")));
        }
    }

    keys
    {
        key(PK; "Schedule No.", "Profile Code")
        {
            Clustered = true;
        }
    }
}