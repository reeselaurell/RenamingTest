page 14135129 "lvngPostedFundedDocuments"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanFundedDocument;
    Caption = 'Posted Funded Documents';
    CardPageId = lvngPostedFundedDocument;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
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
                field(lvngCustomerNo; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(lvngVoid; Void)
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
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngCreateVoidDocument)
            {
                Caption = 'Create Void Document';
                Image = VoidElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    lvngLoanVoidDocument: Codeunit lvngLoanVoidDocument;
                begin
                    lvngLoanVoidDocument.CreateFundedVoidDocument(Rec, true);
                end;
            }
            action(lvngCreateVoidMultipleDocument)
            {
                Caption = 'Create Multiple Void Documents';
                Image = VoidAllElectronicDocuments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = report lvngVoidPostedFundDocuments;
            }
            action(lvngPrint)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                RunObject = report lvngLoanFundedDocument;
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