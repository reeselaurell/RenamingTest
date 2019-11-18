page 14135126 "lvngLoanDocumentsList"
{
    Caption = 'Loan Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanDocument;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
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
                field(lvngVoid; Void)
                {
                    ApplicationArea = All;
                }
                field(lvngVoidDocumentNo; "Void Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerSearchName; "Borrower Search Name")
                {
                    ApplicationArea = All;
                }
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
    }

    actions
    {
        area(Processing)
        {
            action(lvngShowDocument)
            {
                Caption = 'Show Document';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    case "Transaction Type" of
                        "Transaction Type"::Funded:
                            begin
                                page.Run(Page::lvngFundedDocument, Rec);
                            end;
                        "Transaction Type"::Sold:
                            begin
                                page.Run(Page::lvngSoldDocument, Rec);
                            end;
                    end;
                end;
            }
            action(lvngPost)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostDocument;

                trigger OnAction()
                var
                    lvngPostLoanDocument: Codeunit lvngPostLoanDocument;
                    PostConfirmationLbl: Label 'Do You want to Post Document?';
                begin
                    if Confirm(PostConfirmationLbl, false) then begin
                        lvngPostLoanDocument.Run(Rec);
                    end;
                end;
            }

            action(lvngBatchPost)
            {
                Caption = 'Post Batch';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostBatch;
                RunObject = report lvngPostLoanDocuments;
            }

            action(lvngPrint)
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