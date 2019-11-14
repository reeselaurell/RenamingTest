table 14135312 "lvngCommissionTierHeader"
{
    Caption = 'Commission Tier Header';
    DataClassification = CustomerContent;
    LookupPageId = lvngCommissionTiers;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; lvngTierType; Enum lvngTierType)
        {
            Caption = 'Tier Type';
            DataClassification = CustomerContent;
        }
        field(12; lvngTierReturnValue; enum lvngTierReturnValue)
        {
            Caption = 'Return Value';
            DataClassification = CustomerContent;
        }
        field(20; lvngPayoutOption; Enum lvngTierPayoutType)
        {
            Caption = 'Payout Option';
            DataClassification = CustomerContent;
        }
        field(21; lvngPayoutConditionCode; Code[20])
        {
            Caption = 'Payout Condition Code';
            DataClassification = CustomerContent;

        }
        field(22; lvngPayoutCompareValue; Text[250])
        {
            Caption = 'Payout Compare Value';
            DataClassification = CustomerContent;
        }
        field(23; lvngPayoutFieldNo; Integer)
        {
            Caption = 'Payout Field No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanFieldsConfiguration."Field No.";
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
        fieldgroup(DropDown; lvngCode, lvngDescription, lvngTierType) { }
    }

    trigger OnDelete()
    begin
        lvngCommissionTierLine.reset;
        lvngCommissionTierLine.SetRange(lvngCode, lvngCode);
        lvngCommissionTierLine.DeleteAll(true);
    end;

    var
        lvngCommissionTierLine: Record lvngCommissionTierLine;

}