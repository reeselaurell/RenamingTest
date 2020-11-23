table 14135304 "lvnCommissionSchedule"
{
    Caption = 'Commission Schedule';
    DataClassification = CustomerContent;
    LookupPageId = lvnCommissionScheduleList;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; "Period Identifier Code"; Code[20])
        {
            Caption = 'Period Identifier Code';
            DataClassification = CustomerContent;
            TableRelation = lvnPeriodIdentifier;
        }
        field(11; "Period Name"; Code[50])
        {
            Caption = 'Period Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(12; "Period Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(13; "Period End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(14; "Month End Calculation"; Boolean)
        {
            Caption = 'Month End Calculation';
            DataClassification = CustomerContent;
        }
        field(50; "Quarter Calculation"; Boolean)
        {
            Caption = 'Quarter Calculation';
            DataClassification = CustomerContent;
        }
        field(51; "Quarter Start Date"; Date)
        {
            Caption = 'Quarter Start Date';
            DataClassification = CustomerContent;
        }
        field(52; "Quarter End Date"; Date)
        {
            Caption = 'Quarter End Date';
            DataClassification = CustomerContent;
        }
        field(100; "Period Posted"; Boolean)
        {
            Caption = 'Period Posted';
            DataClassification = CustomerContent;
        }
        field(2000; "Calculation DateTime"; DateTime)
        {
            Caption = 'Calculation Date/Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Period Identifier Code", "Period Name") { }
    }

    trigger OnDelete()
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", "No.");
        CommissionJournalLine.DeleteAll(true);
    end;
}