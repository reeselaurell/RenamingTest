page 14135151 "lvngServicingDocuments"
{
    Caption = 'Servicing Documents';
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
            repeater(lvngRepeater)
            {
                field(lvngServicingDocumentType; "Servicing Document Type")
                {
                    ApplicationArea = All;
                }
                field(lvngNo; "No.")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerCustomerNo; "Borrower Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; "Due Date")
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
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
            action(lvngEdit)
            {
                Caption = 'Edit';
                Image = Edit;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if "Servicing Document Type" = "Servicing Document Type"::Invoice then
                        Page.Run(Page::lvngServicingInvoice, Rec);
                    if "Servicing Document Type" = "Servicing Document Type"::"Credit Memo" then
                        Page.Run(Page::lvngServicingCrMemo, Rec);
                end;
            }
            action(lvngPost)
            {
                Caption = 'Post';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Message('a');
                end;
            }
        }
    }
}