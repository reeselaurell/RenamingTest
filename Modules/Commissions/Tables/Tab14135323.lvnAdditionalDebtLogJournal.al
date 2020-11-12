table 14135323 lvnAdditionalDebtLogJournal
{
    Caption = 'Additional Debt Log Journal';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionProfile;
        }
        field(11; "Identifier Code"; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(12; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(13; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}