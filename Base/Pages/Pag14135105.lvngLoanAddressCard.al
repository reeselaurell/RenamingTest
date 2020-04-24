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

                field("Address Type"; "Address Type") { Editable = false; }
                field(Address; Address) { ApplicationArea = All; }
                field("Address 2"; "Address 2") { ApplicationArea = All; }
                field(City; City) { ApplicationArea = All; }
                field("ZIP Code"; "ZIP Code") { ApplicationArea = All; }
                field(State; State) { ApplicationArea = All; }
            }
        }
    }
}