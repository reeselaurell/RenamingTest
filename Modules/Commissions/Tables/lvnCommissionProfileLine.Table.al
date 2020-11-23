table 14135306 "lvnCommissionProfileLine"
{
    Caption = 'Commission Profile Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Profile Code"; Code[20])
        {
            Caption = 'Profile Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionProfile;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(9; "Period Identifier Code"; Code[20])
        {
            Caption = 'Period Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnPeriodIdentifier;
        }
        field(10; "Identifier Code"; Code[20])
        {
            Caption = 'Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionIdentifier;
        }
        field(11; "Loan Officer Type Code"; Code[20])
        {
            Caption = 'Loan Officer Type Code';
            DataClassification = CustomerContent;
            TableRelation = lvnLoanOfficerType;

            trigger OnValidate()
            var
                LoanOfficerType: Record lvnLoanOfficerType;
            begin
                LoanOfficerType.Get("Loan Officer Type Code");
                "Personal Production" := LoanOfficerType."Collect Loans";
            end;
        }
        field(12; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(13; "Loan Calculation Type"; Enum lvnLoanCalculationType)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
        }
        field(14; "Min. Commission Amount"; Decimal)
        {
            Caption = 'Min. Commission Amount';
            DataClassification = CustomerContent;
        }
        field(15; "Max. Commission Amount"; Decimal)
        {
            Caption = 'Max. Commission Amount';
            DataClassification = CustomerContent;
        }
        field(16; "Def. Accrual Dimensions Code"; Code[20])
        {
            Caption = 'Default Accrual Dimensions Code';
            DataClassification = CustomerContent;
            TableRelation = lvnAccrualRules;
        }
        field(17; "Profile Line Type"; Enum lvnProfileLineType)
        {
            Caption = 'Profile Line Type';
            DataClassification = CustomerContent;
        }
        field(20; "Personal Production"; Boolean)
        {
            Caption = 'Personal Production';
            DataClassification = CustomerContent;
        }
        field(21; "Extended Filter Code"; Code[20])
        {
            Caption = 'Extended Filter Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionExtendedFilter.Code;
        }
        field(22; "Calculation Only"; Boolean)
        {
            Caption = 'Calculation Only';
            DataClassification = CustomerContent;
        }
        field(23; "YTD Starting Volume"; Decimal)
        {
            Caption = 'YTD Starting Volume';
            DataClassification = CustomerContent;
        }
        field(24; "YTD Starting Units"; Integer)
        {
            Caption = 'YTD Starting Units';
            DataClassification = CustomerContent;
        }
        field(25; Parameter; Decimal)
        {
            Caption = 'Parameter';
            DataClassification = CustomerContent;
        }
        field(26; "Totals Based On Line No."; Integer)
        {
            Caption = 'Totals Based On Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionProfileLine."Line No." where("Profile Code" = field("Profile Code"), "Profile Line Type" = const("Loan Level"));
        }
        field(27; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
            DataClassification = CustomerContent;
        }
        field(28; "Valid To Date"; Date)
        {
            Caption = 'Valid To Date';
            DataClassification = CustomerContent;
        }
        field(29; "Tier Code"; Code[20])
        {
            Caption = 'Tier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCommissionTierHeader.Code;
        }
        field(30; "Split Percentage"; Decimal)
        {
            Caption = 'Split %';
            DataClassification = CustomerContent;
            InitValue = 100;
        }
        field(31; "Loan Level Condition Code"; Code[20])
        {
            Caption = 'Condition Code';
            DataClassification = CustomerContent;
        }
        field(32; "Loan Level Function Code"; Code[20])
        {
            Caption = 'Function Code';
            DataClassification = CustomerContent;
        }
        field(33; "Period Level Condition Code"; Code[20])
        {
            Caption = 'Condition Code';
            DataClassification = CustomerContent;
        }
        field(34; "Period Level Function Code"; Code[20])
        {
            Caption = 'Function Code';
            DataClassification = CustomerContent;
        }
        field(35; "Period Calculation Type"; Enum lvnPeriodCalculationType)
        {
            Caption = 'Calculation Type';
            DataClassification = CustomerContent;
        }
        field(36; "Period Type"; Enum lvnPeriodType)
        {
            Caption = 'Period Type';
            DataClassification = CustomerContent;
        }
        field(37; Tag; Text[250])
        {
            Caption = 'Tag';
            DataClassification = CustomerContent;
        }
        field(2000; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation Date/Time';
            DataClassification = CustomerContent;
        }
        field(2001; "Modification DateTime"; DateTime)
        {
            Caption = 'Modification Date/Time';
            DataClassification = CustomerContent;
        }
        field(2002; "Updated By"; Code[50])
        {
            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Profile Code", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Creation DateTime" := CurrentDateTime;
        "Modification DateTime" := "Creation DateTime";
        "Updated By" := UserId;
    end;

    trigger OnModify()
    begin
        "Modification DateTime" := CurrentDateTime;
        "Updated By" := UserId;
    end;
}