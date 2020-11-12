page 14135305 lvnCommissionScheduleList
{
    Caption = 'Commission Schedules';
    PageType = List;
    SourceTable = lvnCommissionSchedule;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(PeriodIdentifierCode; Rec."Period Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(PeriodName; Rec."Period Name")
                {
                    ApplicationArea = All;
                }
                field(PeriodStartDate; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                }
                field(PeriodEndDate; Rec."Period End Date")
                {
                    ApplicationArea = All;
                }
                field(PeriodPosted; Rec."Period Posted")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}