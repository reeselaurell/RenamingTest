page 14135302 "lvngLoanOfficerTypes"
{
    Caption = 'Loan Officer Types';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanOfficerType;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngName; lvngName)
                {
                    ApplicationArea = All;
                }
                field(lvngCollectLoans; lvngCollectLoans)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}