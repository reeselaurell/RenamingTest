page 14135191 "lvnLVAccountantFinActSetup"
{
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = lvnLVAccountantFinActSetup;
    Caption = 'Activities Setup';

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Loans Held, for Sale Accounts"; Rec."Loans Held, for Sale Accounts")
                {
                    Caption = 'Loans Held, for Sale Accounts';
                    ApplicationArea = All;
                }
                field("Accounts Payable Accounts"; Rec."Accounts Payable Accounts")
                {
                    Caption = 'Accounts Payable Accounts';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}