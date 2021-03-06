page 14135188 "lvnLoanServDocumentsList"
{
    Caption = 'Loan Servicing Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnLoanDocument;
    SourceTableView = sorting("Transaction Type", "Document No.") where("Transaction Type" = const(Serviced));
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Borrower Search Name"; Rec."Borrower Search Name")
                {
                    ApplicationArea = All;
                }
                field("Document Amount"; Rec."Document Amount")
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
            action(ShowDocument)
            {
                Caption = 'Show Document';
                Image = DocumentEdit;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(Page::lvnServicedDocument, Rec);
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Image = PostDocument;

                trigger OnAction()
                var
                    PostLoanDocument: Codeunit lvnPostLoanDocument;
                    PostConfirmationQst: Label 'Do You want to Post Document?';
                begin
                    if Confirm(PostConfirmationQst, false) then
                        PostLoanDocument.Run(Rec);
                end;
            }
            action(BatchPost)
            {
                Caption = 'Post Batch';
                ApplicationArea = All;
                Image = PostBatch;
                RunObject = report lvnPostLoanDocuments;
            }
            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Image = Print;
                RunObject = report lvnLoanDocument;
            }
        }
    }

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}