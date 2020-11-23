table 14135321 "lvnDebtLogValueEntry"
{
    Caption = 'Debt Log Value Entry';
    DataClassification = CustomerContent;
    LookupPageId = lvnDebtLogValueEntries;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Schedule No."; Integer)
        {
            Caption = 'Schedule No.';
            DataClassification = CustomerContent;
        }
        field(11; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionProfile;
        }
        field(12; "Identifier Code"; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(14; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(15; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(16; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(200; "Additional Code"; Code[50])
        {
            Caption = 'Additional Code';
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Additional Code" where(Code = field("Profile Code")));
            Editable = false;
        }
        field(201; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCommissionProfile."Cost Center Code" where(Code = field("Profile Code")));
            Editable = false;
        }
        field(1000; "Debt Log Transaction ID"; Guid)
        {
            Caption = 'Debt Log Transaction ID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ProfileCodeSum; "Profile Code")
        {
            SumIndexFields = Amount;
        }
    }
}