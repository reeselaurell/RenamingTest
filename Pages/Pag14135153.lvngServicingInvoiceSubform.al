page 14135153 "lvngServicingInvoiceSubform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = lvngServiceLine;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngAccountNo; "Account No.")
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
                field(lvngServicingType; "Servicing Type")
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitCode; "Business Unit Code")
                {
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Code; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Code; "Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Code; "Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Code; "Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Code; "Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Code; "Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }



    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lvngServiceLine: Record lvngServiceLine;
    begin
        lvngServiceLine.reset;
        lvngServiceLine.SetRange("Servicing Document Type", "Servicing Document Type");
        lvngServiceLine.SetRange("Document No.", "Document No.");
        if lvngServiceLine.FindLast() then
            "Line No." := lvngServiceLine."Line No.";
        "Line No." := "Line No." + 100;

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