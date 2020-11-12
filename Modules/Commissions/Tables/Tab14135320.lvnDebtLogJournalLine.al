table 14135320 lvnDebtLogJournalLine
{
    Caption = 'Debt Log Journal Line';
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
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Identifier Code"; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(13; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(1000; "Debt Log Transaction ID"; Guid)
        {
            Caption = 'Debt Log Transaction ID';
            DataClassification = CustomerContent;
        }
        field(1001; "Debt Log Only Posting"; Boolean)
        {
            Caption = 'Debt Log Only Posting';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Schedule No.", "Profile Code", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        myInt: Integer;
}