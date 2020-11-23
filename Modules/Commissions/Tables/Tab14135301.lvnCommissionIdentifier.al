table 14135301 lvnCommissionIdentifier
{
    Caption = 'Commission Identifier';
    DataClassification = CustomerContent;
    LookupPageId = lvnCommissionIdentifiers;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(11; "Payroll G/L Account No."; Code[20])
        {
            Caption = 'Payroll G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting));
        }
        field(12; "Additional Identifier"; Boolean)
        {
            Caption = 'Additional Commission Identifier';
            DataClassification = CustomerContent;
        }
        field(200; "Debt Log Commission Identifier"; Boolean)
        {
            Caption = 'Debt Log Commission Identifier';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name) { }
    }
}