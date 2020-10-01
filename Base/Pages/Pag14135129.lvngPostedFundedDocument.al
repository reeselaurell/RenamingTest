page 14135129 lvngPostedFundedDocument
{
    Caption = 'Posted Funded Document';
    PageType = Document;
    SourceTable = lvngLoanFundedDocument;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
                field(Void; Rec.Void) { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; }
                field("Borrower Search Name"; Rec."Borrower Search Name") { ApplicationArea = All; }

                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                    field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                    field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                    field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                    field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                    field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                    field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                    field("Business Unit Code"; Rec."Business Unit Code") { ApplicationArea = All; }
                }
            }

            part(PostedFundedDocSubpage; lvngPostedFundedDocSubpage)
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("Document No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateVoidDocument)
            {
                Caption = 'Create Void Document';
                Image = VoidElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    LoanVoidDocument: Codeunit lvngLoanVoidDocument;
                begin
                    LoanVoidDocument.CreateFundedVoidDocument(Rec, true);
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
                    LoanFundedDocumentView: Record lvngLoanFundedDocument;
                    LoanFundedDocumentReport: Report lvngLoanFundedDocument;
                begin
                    LoanFundedDocumentView := Rec;
                    LoanFundedDocumentView.SetRecFilter();
                    LoanFundedDocumentReport.SetTableView(LoanFundedDocumentView);
                    LoanFundedDocumentReport.Run();
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