page 14135105 "lvnLoanAddressCard"
{
    PageType = Card;
    SourceTable = lvnLoanAddress;
    Caption = 'Loan Address';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Address Type"; Rec."Address Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("ZIP Code"; Rec."ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}