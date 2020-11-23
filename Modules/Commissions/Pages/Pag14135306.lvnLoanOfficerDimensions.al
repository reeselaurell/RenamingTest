page 14135306 lvnLoanOfficerDimensions
{
    Caption = 'Loan Officer Dimension Values';
    PageType = List;
    Editable = false;
    SourceTable = "Dimension Value";

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(AdditionalCode; Rec.lvnAdditionalCode)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}