page 14135136 "lvngSoldDocument"
{
    Caption = 'Sold Document';
    PageType = Card;
    SourceTable = lvngLoanDocument;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
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
            part(lvngSoldDocumentSubpage; lvngSoldDocumentSubpage)
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
            action(lvngPost)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
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
            action(lvngPrint)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                trigger OnAction()
                var
                    lvngLoanDocumentReport: Report lvngLoanDocument;
                    lvngLoanDocumentView: Record lvngLoanDocument;
                begin
                    lvngLoanDocumentView := Rec;
                    lvngLoanDocumentView.SetRecFilter();
                    lvngLoanDocumentReport.SetTableView(lvngLoanDocumentView);
                    lvngLoanDocumentReport.Run();
                end;
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