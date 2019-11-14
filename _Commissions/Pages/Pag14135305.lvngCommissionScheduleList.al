page 14135305 "lvngCommissionScheduleList"
{
    Caption = 'Commission Schedules';
    PageType = List;
    SourceTable = lvngCommissionSchedule;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngNo; lvngNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodIdentifier; lvngPeriodIdentifier)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodName; lvngPeriodName)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodStartDate; lvngPeriodStartDate)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodEndDate; lvngPeriodEndDate)
                {
                    ApplicationArea = All;
                }
                field(lvngPeriodPosted; lvngPeriodPosted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}