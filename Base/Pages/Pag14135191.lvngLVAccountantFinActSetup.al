page 14135191 lvngLVAccountantFinActSetup
{
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = lvngLVAccountantFinActSetup;
    Caption = 'Activities Setup';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Loans Held, for Sale Accounts"; "Loans Held, for Sale Accounts") { Caption = 'Loans Held, for Sale Accounts'; ApplicationArea = All; }
                field("Accounts Payable Accounts"; "Accounts Payable Accounts") { Caption = 'Accounts Payable Accounts'; ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}