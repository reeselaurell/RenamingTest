page 14135105 "lvngLoanAddressCard"
{
    PageType = Card;
    SourceTable = lvngLoanAddress;
    Caption = 'Loan Address';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(lvngAddressType; "Address Type")
                {
                    Editable = false;
                }
                field(lvngAddress; Address)
                {
                    ApplicationArea = All;
                }
                field(lvngAddress2; "Address 2")
                {
                    ApplicationArea = All;
                }
                field(lvngCity; City)
                {
                    ApplicationArea = All;
                }
                field(lvngZIPCode; "ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(lvngState; State)
                {
                    ApplicationArea = All;
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