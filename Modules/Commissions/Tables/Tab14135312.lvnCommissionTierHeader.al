table 14135312 lvnCommissionTierHeader
{
    Caption = 'Commission Tier Header';
    DataClassification = CustomerContent;
    LookupPageId = lvnCommissionTiers;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Tier Type"; Enum lvnTierType)
        {
            Caption = 'Tier Type';
            DataClassification = CustomerContent;
        }
        field(12; "Tier Return Value"; enum lvnTierReturnValue)
        {
            Caption = 'Tier Return Value';
            DataClassification = CustomerContent;
        }
        field(20; "Tier Payout Type"; Enum lvnTierPayoutType)
        {
            Caption = 'Tier Payout Type';
            DataClassification = CustomerContent;
        }
        field(21; "Payout Condition Code"; Code[20])
        {
            Caption = 'Payout Condition Code';
            DataClassification = CustomerContent;
        }
        field(22; "Payout Compare Value"; Text[250])
        {
            Caption = 'Payout Compare Value';
            DataClassification = CustomerContent;
        }
        field(23; "Payout Field No."; Integer)
        {
            Caption = 'Payout Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanFieldsConfiguration."Field No.";
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description, "Tier Type") { }
    }

    trigger OnDelete()
    var
        CommissionTierLine: Record lvnCommissionTierLine;
    begin
        CommissionTierLine.Reset();
        CommissionTierLine.SetRange("Tier Code", Code);
        CommissionTierLine.DeleteAll(true);
    end;
}