table 14135310 "lvngCommissionValueEntry"
{
    Caption = 'Commission Value Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngEntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }

        field(5; lvngScheduleNo; Integer)
        {
            Caption = 'Schedule No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngProfileCode; Code[20])
        {
            Caption = 'Profile Code';
            TableRelation = lvngCommissionProfile.lvngCode;
            DataClassification = CustomerContent;
        }
        field(11; lvngCalculationLineNo; Integer)
        {
            Caption = 'Profile Line No.';
            TableRelation = lvngCommissionProfileLine.lvngLineNo where(lvngProfileCode = field(lvngProfileCode));
            DataClassification = CustomerContent;
        }
        field(12; lvngPeriodIdentifierCode; Code[20])
        {
            Caption = 'Period Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPeriodIdentifier;
        }
        field(13; lvngProfileLineType; Enum lvngProfileLineType)
        {
            Caption = 'Profile Line Type';
            DataClassification = CustomerContent;
        }
        field(14; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            TableRelation = lvngLoan;
            DataClassification = CustomerContent;
        }
        field(15; lvngManualAdjustment; Boolean)
        {
            Caption = 'Manual Adjustment';
            DataClassification = CustomerContent;
        }
        field(16; lvngBaseAmount; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(17; lvngBps; Decimal)
        {
            Caption = 'Bps';
            DataClassification = CustomerContent;
        }
        field(18; lvngCommissionAmount; Decimal)
        {
            Caption = 'Commission Amount';
            DataClassification = CustomerContent;
        }
        field(19; lvngCommissionDate; Date)
        {
            Caption = 'Commission Date';
            DataClassification = CustomerContent;
        }
        field(20; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(21; lvngIdentifierCode; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionIdentifier;
        }
    }

    keys
    {
        key(PK; lvngEntryNo)
        {
            Clustered = true;
        }
        key(""; lvngProfileCode, lvngCommissionDate, lvngPeriodIdentifierCode, lvngProfileLineType, lvngIdentifierCode)
        {
            SumIndexFields = lvngCommissionAmount;
        }
    }

}