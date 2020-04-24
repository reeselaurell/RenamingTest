page 14135151 lvngPostedServicingDocuments
{
    Caption = 'Posted Servicing Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngServiceHeader;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Servicing Document Type"; "Servicing Document Type") { ApplicationArea = All; }
                field("No."; "No.") { ApplicationArea = All; }
                field("Borrower Customer No."; "Borrower Customer No.") { ApplicationArea = All; }
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
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
                    if "Servicing Document Type" = "Servicing Document Type"::Invoice then
                        Page.Run(Page::lvngPostedServicingInvoice, Rec);
                    if "Servicing Document Type" = "Servicing Document Type"::"Credit Memo" then
                        Page.Run(Page::lvngPostedServicingCrMemo, Rec);
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