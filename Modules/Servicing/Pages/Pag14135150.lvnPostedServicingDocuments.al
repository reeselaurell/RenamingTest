page 14135150 "lvnPostedServicingDocuments"
{
    Caption = 'Posted Servicing Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnServiceHeader;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Servicing Document Type"; Rec."Servicing Document Type") { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Borrower Customer No."; Rec."Borrower Customer No.") { ApplicationArea = All; }
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                Caption = 'Edit';
                Image = Edit;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec."Servicing Document Type" = Rec."Servicing Document Type"::Invoice then
                        Page.Run(Page::lvnPostedServicingInvoice, Rec);
                    if Rec."Servicing Document Type" = Rec."Servicing Document Type"::"Credit Memo" then
                        Page.Run(Page::lvnPostedServicingCrMemo, Rec);
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Error('Not Implemented');
                end;
            }
        }
    }
}