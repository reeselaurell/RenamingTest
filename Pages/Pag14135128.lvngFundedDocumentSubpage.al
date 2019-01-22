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

            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(lvngTransactionType, lvngTransactionType);
        lvngLoanDocumentLine.SetRange(lvngDocumentNo, lvngDocumentNo);
        if lvngLoanDocumentLine.FindLast() then begin
            lvngLineNo := lvngLoanDocumentLine.lvngLineNo + 100;
        end else begin
            lvngLineNo := 100;
        end;

    end;
}