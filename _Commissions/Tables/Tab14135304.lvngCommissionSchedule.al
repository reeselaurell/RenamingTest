table 14135304 "lvngCommissionSchedule"
{
    Caption = 'Commission Schedule';
    DataClassification = CustomerContent;
    LookupPageId = lvngCommissionScheduleList;

    fields
    {
        field(1; lvngNo; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }

        field(10; lvngPeriodIdentifier; Code[20])
        {
            Caption = 'Period Identifier';
            DataClassification = CustomerContent;
            TableRelation = lvngPeriodIdentifier;
        }

        field(11; lvngPeriodName; Code[50])
        {
            Caption = 'Period Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(12; lvngPeriodStartDate; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(13; lvngPeriodEndDate; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(50; lvngQuarterCalculation; Boolean)
        {
            Caption = 'Quarter Calculation';
            DataClassification = CustomerContent;
        }
        field(51; lvngQuarterStartDate; Date)
        {
            Caption = 'Quarter Start Date';
            DataClassification = CustomerContent;
        }
        field(52; lvngQuarterEndDate; Date)
        {
            Caption = 'Quarter End Date';
            DataClassification = CustomerContent;
        }

        field(100; lvngPeriodPosted; Boolean)
        {
            Caption = 'Period Posted';
            DataClassification = CustomerContent;
        }

        field(2000; lvngCalculationDateTime; DateTime)
        {
            Caption = 'Calculation Date/Time';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; lvngNo, lvngPeriodIdentifier, lvngPeriodName) { }
    }

}