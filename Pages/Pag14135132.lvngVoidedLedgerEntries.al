page 14135132 "lvngVoidedLedgerEntries"
{
    Caption = 'Voided Ledger Entries';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLedgerVoidEntry;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngTableID; lvngTableID)
                {
                    ApplicationArea = All;
                }
                field(lvngEntryNo; lvngEntryNo)
                {
                    ApplicationArea = All;
                }
                field(lvngChangeNo; lvngChangeNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDate; lvngDate)
                {
                    ApplicationArea = All;
                }
                field(lvngTime; lvngTime)
                {
                    ApplicationArea = All;
                }
                field(lvngUserID; lvngUserID)
                {
                    ApplicationArea = All;
                }
                field(lvngTransactionNo; lvngTransactionNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; lvngDocumentNo)
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
                field(lvngLoanNo; lvngLoanNo)
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}