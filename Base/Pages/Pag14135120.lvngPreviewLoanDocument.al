page 14135120 lvngPreviewLoanDocument
{
    PageType = Document;
    SourceTable = lvngLoanDocument;
    SourceTableTemporary = true;
    Caption = 'Document Preview';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Transaction Type"; "Transaction Type") { ApplicationArea = All; }
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

            part(Lines; lvngPreviewLoanDocumentLines)
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Editable = false;
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

    procedure SetJournalLine(LoanJournalLine: Record lvngLoanJournalLine)
    var
        LoanDocumentLine: Record lvngLoanDocumentLine temporary;
        CreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
    begin
        CreateFundedDocuments.CreateSingleDocument(LoanJournalLine, Rec, LoanDocumentLine, true);
        CurrPage.Lines.Page.SetLines(LoanDocumentLine);
    end;
}