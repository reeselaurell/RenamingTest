table 14135301 "lvngCommissionIdentifier"
{
    Caption = 'Commission Identifier';
    DataClassification = CustomerContent;
    LookupPageId = lvngCommissionIdentifiers;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(10; lvngName; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }

        field(11; "lvngPayrollGLAccountNo"; Code[20])
        {
            Caption = 'Payroll G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
        }
        field(12; lvngAdditionalIdentifier; Boolean)
        {
            Caption = 'Additional Commission Identifier';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; lvngCode, lvngName) { }
    }


}