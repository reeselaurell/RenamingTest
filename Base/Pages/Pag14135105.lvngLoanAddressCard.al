page 14135105 lvngLoanAddressCard
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
                Caption = 'General';

                field("Address Type"; Rec."Address Type") { Editable = false; }
                field(Address; Rec.Address) { ApplicationArea = All; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = All; }
                field(City; Rec.City) { ApplicationArea = All; }
                field("ZIP Code"; Rec."ZIP Code") { ApplicationArea = All; }
                field(State; Rec.State) { ApplicationArea = All; }
            }
        }
    }
}