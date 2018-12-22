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
                field(lvngAddressType; lvngAddressType)
                {
                    Editable = false;
                }
                field(lvngAddress; lvngAddress)
                {
                    ApplicationArea = All;
                }
                field(lvngAddress2; lvngAddress2)
                {
                    ApplicationArea = All;
                }
                field(lvngCity; lvngCity)
                {
                    ApplicationArea = All;
                }
                field(lvngZIPCode; lvngZIPCode)
                {
                    ApplicationArea = All;
                }
                field(lvngState; lvngState)
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