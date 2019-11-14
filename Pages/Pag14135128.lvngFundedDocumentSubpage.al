page 14135128 "lvngFundedDocumentSubpage"
{
    Caption = 'Funded Document Lines';
    PageType = ListPart;
    SourceTable = lvngLoanDocumentLine;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngAccountType; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; "Account No.")
                {
                    ApplicationArea = All;
                }
                field(lvngBalancingEntry; "Balancing Entry")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngAmount; Amount)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
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
                field(lvngServicingType; "Servicing Type")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange("Transaction Type", "Transaction Type");
        lvngLoanDocumentLine.SetRange("Document No.", "Document No.");
        if lvngLoanDocumentLine.FindLast() then begin
            "Line No." := lvngLoanDocumentLine."Line No." + 100;
        end else begin
            "Line No." := 100;
        end;
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