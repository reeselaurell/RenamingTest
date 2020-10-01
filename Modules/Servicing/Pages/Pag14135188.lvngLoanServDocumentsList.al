page 14135188 lvngLoanServDocumentsList
{
    Caption = 'Loan Servicing Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanDocument;
    SourceTableView = sorting("Transaction Type", "Document No.") where("Transaction Type" = const(Serviced));
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; }
                field("Borrower Search Name"; Rec."Borrower Search Name") { ApplicationArea = All; }
                field("Document Amount"; Rec."Document Amount") { ApplicationArea = All; }
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
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(page::lvngServicedDocument, Rec);
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostDocument;

                trigger OnAction()
                var
                    PostLoanDocument: Codeunit lvngPostLoanDocument;
                    PostConfirmationQst: Label 'Do You want to Post Document?';
                begin
                    if Confirm(PostConfirmationQst, false) then begin
                        PostLoanDocument.Run(Rec);
                    end;
                end;
            }

            action(BatchPost)
            {
                Caption = 'Post Batch';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostBatch;
                RunObject = report lvngPostLoanDocuments;
            }

            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                RunObject = report lvngLoanDocument;
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}