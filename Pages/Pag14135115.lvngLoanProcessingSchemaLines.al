page 14135115 "lvngLoanProcessingSchemaLines"
{
    PageType = List;
    SourceTable = lvngLoanProcessingSchemaLine;
    Caption = 'Loan Processing Schema Lines';

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
                field(lvngProcessingSourceType; lvngProcessingSourceType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngConditionCode; lvngConditionCode)
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
                field(lvngAccountNoSwitchCode; lvngAccountNoSwitchCode)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                }
                field(lvngFunctionCode; lvngFunctionCode)
                {
                    ApplicationArea = All;
                }

                field(lvngOverrideReasonCode; lvngOverrideReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngReverseSign; lvngReverseSign)
                {
                    ApplicationArea = All;
                }

                field(lvngBalancingEntry; lvngBalancingEntry)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1Rule; lvngDimension1Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension2Rule; lvngDimension2Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension3Rule; lvngDimension3Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4Rule; lvngDimension4Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5Rule; lvngDimension5Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6Rule; lvngDimension6Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7Rule; lvngDimension7Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8Rule; lvngDimension8Rule)
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitRule; lvngBusinessUnitRule)
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
                    ApplicationArea = All;
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

}