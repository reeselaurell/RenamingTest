page 14135147 "lvngSalesLinesImportSchema"
{
    PageType = Card;
    SourceTable = lvngFileImportSchema;
    Caption = 'Sales Journal Import';

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
                group(lvngAccounts)
                {
                    Caption = 'Accounts Management';

                    field(lvngAccountMappingType; lvngAccountMappingType)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDefaultAccountNo; lvngDefaultAccountNo)
                    {
                        ApplicationArea = All;
                    }
                }
                group(lvngMisc)
                {
                    Caption = 'Misc.';
                    field(lvngReasonCode; lvngReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLoanNoValidationRule; lvngLoanNoValidationRule)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngReverseAmountSign; lvngReverseAmountSign)
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(lvngDimensions)
            {
                Caption = 'Dimensions';

                field(lvngDimensionValidationRule; lvngDimensionValidationRule)
                {
                    ApplicationArea = All;
                }
                field(lvngUseDimensionHierarchy; lvngUseDimensionHierarchy)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1MappingType; lvngDimension1MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1Mandatory; lvngDimension1Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension1Code; lvngDefaultDimension1Code)
                {
                    ApplicationArea = All;
                }

                field(lvngDimension2MappingType; lvngDimension2MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension2Mandatory; lvngDimension2Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension2Code; lvngDefaultDimension2Code)
                {
                    ApplicationArea = All;
                }

                field(lvngDimension3MappingType; lvngDimension3MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension3Mandatory; lvngDimension3Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension3Code; lvngDefaultDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4MappingType; lvngDimension4MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4Mandatory; lvngDimension4Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension4Code; lvngDefaultDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5MappingType; lvngDimension5MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5Mandatory; lvngDimension5Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension5Code; lvngDefaultDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6MappingType; lvngDimension6MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6Mandatory; lvngDimension6Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension6Code; lvngDefaultDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7MappingType; lvngDimension7MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7Mandatory; lvngDimension7Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension7Code; lvngDefaultDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8MappingType; lvngDimension8MappingType)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8Mandatory; lvngDimension8Mandatory)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultDimension8Code; lvngDefaultDimension8Code)
                {
                    ApplicationArea = All;
                }
            }
            part(lvngSalesImportSchemaLines; lvngSalesImportSchemaLines)
            {
                Caption = 'Columns Mapping';
                SubPageLink = lvngCode = field (lvngCode);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                trigger OnAction()
                begin

                end;
            }
        }
    }
}