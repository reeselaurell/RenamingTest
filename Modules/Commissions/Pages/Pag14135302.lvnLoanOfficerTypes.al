page 14135302 lvnLoanOfficerTypes
{
    Caption = 'Loan Officer Types';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnLoanOfficerType;

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(CollectLoans; Rec."Collect Loans")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}