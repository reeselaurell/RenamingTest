page 14135120 "lvngPreviewLoanDocument"
{
    PageType = Card;
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
            group(lvngGeneral)
            {
                Caption = 'General';
                field(lvngTransactionType; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentType; "Document Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngVoid; Void)
                {
                    ApplicationArea = All;
                }
                field(lvngVoidDocumentNo; "Void Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvngCustomerNo; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(lvngWarehouseLineCode; "Warehouse Line Code")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerSearchName; "Borrower Search Name")
                {
                    ApplicationArea = All;
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';
                    field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible1;
                    }
                    field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible2;
                    }
                    field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible3;
                    }
                    field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible4;
                    }
                    field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible5;
                    }
                    field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible6;
                    }
                    field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible7;
                    }
                    field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible8;
                    }
                    field(lvngBusinessUnitCode; "Business Unit Code")
                    {
                        ApplicationArea = All;
                    }
                }

            }
            part(lvngLines; lvngPreviewLoanDocumentLines)
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Editable = false;
            }
        }
    }

    procedure SetJournalLine(lvngLoanJournalLine: Record lvngLoanJournalLine)
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        lvngCreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
    begin
        lvngCreateFundedDocuments.CreateSingleDocument(lvngLoanJournalLine, Rec, lvngLoanDocumentLine, true);
        CurrPage.lvngLines.Page.SetLines(lvngLoanDocumentLine);
    end;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}