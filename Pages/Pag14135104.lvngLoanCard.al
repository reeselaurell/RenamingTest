page 14135104 "lvngLoanCard"
{
    PageType = Card;
    SourceTable = lvngLoan;
    Caption = 'Loan Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }

                field(lvngSearchName; lvngSearchName)
                {
                    ApplicationArea = All;
                }

                field(lvngBorrowerFirstName; lvngBorrowerFirstName)
                {
                    ApplicationArea = All;
                }

                field(lvngMiddleName; lvngBorrowerMiddleName)
                {
                    ApplicationArea = All;
                }

                field(lvngBorrowerLastName; lvngBorrowerLastName)
                {
                    ApplicationArea = All;
                }
                group(Dates)
                {
                    Caption = 'Dates';
                    field(lvngApplicationDate; lvngApplicationDate)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDateClosed; lvngDateClosed)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDateFunded; lvngDateFunded)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDateSold; lvngDateSold)
                    {
                        ApplicationArea = All;
                    }
                }




            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}