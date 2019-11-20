page 14135136 lvngSoldDocument
{
    Caption = 'Sold Document';
    PageType = Card;
    SourceTable = lvngLoanDocument;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document Type"; "Document Type") { ApplicationArea = All; }
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field(Void; Void) { ApplicationArea = All; }
                field("Void Document No."; "Void Document No.") { ApplicationArea = All; }
                field("Customer No."; "Customer No.") { ApplicationArea = All; }
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Warehouse Line Code"; "Warehouse Line Code") { ApplicationArea = All; }
                field("Borrower Search Name"; "Borrower Search Name") { ApplicationArea = All; }

                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                    field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                    field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                    field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                    field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                    field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                    field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                    field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                    field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                }
            }

            part(SoldDocumentSubpage; lvngSoldDocumentSubpage)
            {
                Caption = 'Lines';
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No." = field("Document No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    PostLoanDocument: Codeunit lvngPostLoanDocument;
                    PostConfirmationQst: Label 'Do You want to Post Document?';
                begin
                    if Confirm(PostConfirmationQst, false) then
                        PostLoanDocument.Run(Rec);
                end;
            }

            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;

                trigger OnAction()
                var
                    LoanDocumentReport: Report lvngLoanDocument;
                    LoanDocumentView: Record lvngLoanDocument;
                begin
                    LoanDocumentView := Rec;
                    LoanDocumentView.SetRecFilter();
                    LoanDocumentReport.SetTableView(LoanDocumentView);
                    LoanDocumentReport.Run();
                end;
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