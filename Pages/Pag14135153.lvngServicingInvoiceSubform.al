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
                field(lvngAccountNo; lvngAccountNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngAmount; lvngAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngServicingType; lvngServicingType)
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                {
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }
                field(lvngLineNo; lvngLineNo)
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
        lvngServiceLine.SetRange(lvngServicingDocumentType, lvngServicingDocumentType);
        lvngServiceLine.SetRange(lvngDocumentNo, lvngDocumentNo);
        if lvngServiceLine.FindLast() then
            lvngLineNo := lvngServiceLine.lvngLineNo;
        lvngLineNo := lvngLineNo + 100;

    end;


}