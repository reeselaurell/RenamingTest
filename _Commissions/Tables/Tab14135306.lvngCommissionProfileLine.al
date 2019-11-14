table 14135306 "lvngCommissionProfileLine"
{
    Caption = 'Commission Profile Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngProfileCode; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionProfile;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(9; lvngPeriodIdentifierCode; Code[20])
        {
            Caption = 'Period Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPeriodIdentifier;
        }
        field(10; lvngIdentifierCode; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionIdentifier;
        }
        field(11; lvngLoanOfficerTypeCode; Code[20])
        {
            Caption = 'Loan Officer Type Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanOfficerType;

            trigger OnValidate()
            var
                lvngLoanOfficerType: Record lvngLoanOfficerType;
            begin
                lvngLoanOfficerType.Get(lvngLoanOfficerTypeCode);
                lvngPersonalProduction := lvngLoanOfficerType.lvngCollectLoans;
            end;
        }

        field(12; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(13; lvngLoanCalculationType; Enum lvngLoanCalculationType)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
        }
        field(14; lvngMinCommissionAmount; Decimal)
        {
            Caption = 'Min. Commission Amount';
            DataClassification = CustomerContent;
        }
        field(15; lvngMaxCommissionAmount; Decimal)
        {
            Caption = 'Max. Commission Amount';
            DataClassification = CustomerContent;
        }
        field(16; lvngDefaultAccrualDimensions; Code[20])
        {
            Caption = 'Default Accrual Dimensions';
            DataClassification = CustomerContent;
            TableRelation = lvngAccrualRules;
        }
        field(17; lvngProfileLineType; Enum lvngProfileLineType)
        {
            Caption = 'Profile Line Type';
            DataClassification = CustomerContent;
        }
        field(20; lvngPersonalProduction; Boolean)
        {
            Caption = 'Personal Production';
            DataClassification = CustomerContent;
        }
        field(21; lvngExtendedFilterCode; Code[20])
        {
            Caption = 'Extended Filter Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionExtendedFilter.lvngCode;
        }
        field(22; lvngCalculationOnly; Boolean)
        {
            Caption = 'Calculation Only';
            DataClassification = CustomerContent;
        }
        field(23; lvngYTDStartingVolume; Decimal)
        {
            Caption = 'YTD Starting Volume';
            DataClassification = CustomerContent;
        }
        field(24; lvngYTDStartingUnits; Decimal)
        {
            Caption = 'YTD Starting Units';
            DataClassification = CustomerContent;
        }
        field(25; lvngParameter; Decimal)
        {
            Caption = 'Parameter';
            DataClassification = CustomerContent;
        }
        field(26; lvngTotalsBasedOnLineNo; Integer)
        {
            Caption = 'Totals based on Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionProfileLine.lvngLineNo where(lvngProfileCode = field(lvngProfileCode), lvngProfileLineType = const(lvngLoanLevel));
        }
        field(27; lvngValidFromDate; Date)
        {
            Caption = 'Valid From Date';
            DataClassification = CustomerContent;
        }
        field(28; lvngValidToDate; Date)
        {
            Caption = 'Valid To Date';
            DataClassification = CustomerContent;
        }
        field(29; lvngTierCode; Code[20])
        {
            Caption = 'Tier Code';
            DataClassification = CustomerContent;
            TableRelation = lvngCommissionTierHeader.lvngCode;
        }
        field(30; lvngSplitPercentage; Decimal)
        {
            Caption = 'Split %';
            DataClassification = CustomerContent;
            InitValue = 100;
        }
        field(31; lvngLoanLevelConditionCode; Code[20])
        {
            Caption = 'Condition Code';
            DataClassification = CustomerContent;
        }
        field(32; lvngLoanLevelFunctionCode; Code[20])
        {
            Caption = 'Function Code';
            DataClassification = CustomerContent;
        }
        field(2000; lvngCreationTimestamp; DateTime)
        {
            Caption = 'Creation Date/Time';
            DataClassification = CustomerContent;
        }
        field(2001; lvngModificationTimestamp; DateTime)
        {
            Caption = 'Modification Date/Time';
            DataClassification = CustomerContent;
        }
        field(2002; lvngUpdatedBy; Code[50])
        {
            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngProfileCode, lvngLineNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        lvngCreationTimestamp := CurrentDateTime;
        lvngUpdatedBy := UserId;
    end;

    trigger OnModify()
    begin
        lvngModificationTimestamp := CurrentDateTime;
        lvngUpdatedBy := UserId;
    end;

}