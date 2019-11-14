page 14135306 "lvngLoanOfficerDimensions"
{
    Caption = 'Loan Officer Dimension Values';
    PageType = List;
    Editable = false;
    SourceTable = "Dimension Value";

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(lvngAdditionalCode; lvngAdditionalCode)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }

            }
        }

    }
}