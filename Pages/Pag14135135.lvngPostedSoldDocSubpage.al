page 14135135 "lvngPostedSoldDocSubpage"
{

    Caption = 'Posted Sold Document Subpage';
    PageType = ListPart;
    SourceTable = lvngLoanSoldDocumentLine;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

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
                field(lvngServicingType; lvngServicingType)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

}
