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
                field(lvngServicingDocumentType; lvngServicingDocumentType)
                {
                    ApplicationArea = All;
                }
                field(lvngNo; lvngNo)
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerCustomerNo; lvngBorrowerCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; lvngPostingDate)
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; lvngDueDate)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; lvngReasonCode)
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
                    if lvngServicingDocumentType = lvngServicingDocumentType::lvngInvoice then
                        Page.Run(Page::lvngServicingInvoice, Rec);
                    if lvngServicingDocumentType = lvngServicingDocumentType::lvngCreditMemo then
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