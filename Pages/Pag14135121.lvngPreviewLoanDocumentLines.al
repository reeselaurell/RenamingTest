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
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountType; lvngAccountType)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; lvngAccountNo)
                {
                    ApplicationArea = All;
                }
                field(lvngBalancingEntry; lvngBalancingEntry)
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
                field(lvngReasonCode; lvngReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = all;
                }
                field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                {
                    ApplicationArea = All;
                }
                field(lvngProcessingSchemaCode; lvngProcessingSchemaCode)
                {
                    ApplicationArea = All;
                }
                field(lvngProcessingSchemaLineNo; lvngProcessingSchemaLineNo)
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
}