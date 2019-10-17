page 14135145 "lvngPurchaseLinesImportSchema"
{
    PageType = Card;
    SourceTable = lvngFileImportSchema;
    Caption = 'Purchase Journal Import';

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
                    Visible = DimensionVisible1;
                }
                field(lvngDimension1Mandatory; lvngDimension1Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDefaultDimension1Code; lvngDefaultDimension1Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }

                field(lvngDimension2MappingType; lvngDimension2MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension2Mandatory; lvngDimension2Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDefaultDimension2Code; lvngDefaultDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }

                field(lvngDimension3MappingType; lvngDimension3MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension3Mandatory; lvngDimension3Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDefaultDimension3Code; lvngDefaultDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4MappingType; lvngDimension4MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension4Mandatory; lvngDimension4Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDefaultDimension4Code; lvngDefaultDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5MappingType; lvngDimension5MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension5Mandatory; lvngDimension5Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDefaultDimension5Code; lvngDefaultDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6MappingType; lvngDimension6MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension6Mandatory; lvngDimension6Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDefaultDimension6Code; lvngDefaultDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7MappingType; lvngDimension7MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension7Mandatory; lvngDimension7Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDefaultDimension7Code; lvngDefaultDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8MappingType; lvngDimension8MappingType)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngDimension8Mandatory; lvngDimension8Mandatory)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngDefaultDimension8Code; lvngDefaultDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
            }
            part(lvngPurchaseImportSchemaLines; lvngPurchaseImportSchemaLines)
            {
                Caption = 'Columns Mapping';
                SubPageLink = lvngCode = field(lvngCode);
                ApplicationArea = All;
            }
        }
    }

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