page 14135121 "lvngPreviewLoanDocumentLines"
{
    Caption = 'Preview Loan Document Lines';
    PageType = ListPart;
    SourceTable = lvngLoanDocumentLine;
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
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
                field(lvngProcessingSchemaCode; "Processing Schema Code")
                {
                    ApplicationArea = All;
                }
                field(lvngProcessingSchemaLineNo; "Processing Schema Line No.")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    procedure SetLines(var lvngLoanDocumentLine: Record lvngLoanDocumentLine)
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.FindSet();
        repeat
            Clear(Rec);
            Rec := lvngLoanDocumentLine;
            Rec.Insert();
        until lvngLoanDocumentLine.Next() = 0;
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