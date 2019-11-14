page 14135149 "lvngDepositImportSchema"
{
    PageType = Card;
    SourceTable = lvngFileImportSchema;
    Caption = 'Deposit Import';

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

                    field(lvngGenJnlAccountType; "Gen. Jnl. Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngAccountMappingType; "Account Mapping Type")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDefaultAccountNo; "Default Account No.")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngSubsGLWithBankAcc; "Subs. G/L With Bank Acc.")
                    {
                        ApplicationArea = All;
                    }
                }
                group(lvngDocumentNo)
                {
                    Caption = 'Document No. Management';
                    field(lvngDepositDocumentType; "Deposit Document Type")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDocumentTypeOption; "Document Type Option")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDocumentNoSeries; "Document No. Series")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDocumentNoFilling; "Document No. Filling")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDocumentNoPrefix; "Document No. Prefix")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngUseSingleDocumentNo; "Use Single Document No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group(lvngMisc)
                {
                    Caption = 'Misc.';
                    field(lvngReasonCode; "Reason Code")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngLoanNoValidationRule; "Loan No. Validation Rule")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngAppliesToDocType; "Applies-To Doc. Type")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngReverseAmountSign; "Reverse Amount Sign")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(lvngDimensions)
            {
                Caption = 'Dimensions';

                field(lvngDimensionValidationRule; "Dimension Validation Rule")
                {
                    ApplicationArea = All;
                }
                field(lvngUseDimensionHierarchy; "Use Dimension Hierarchy")
                {
                    ApplicationArea = All;
                }
                field(lvngDimension1MappingType; "Dimension 1 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension1Mandatory; "Dimension 1 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDefaultDimension1Code; "Default Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }

                field(lvngDimension2MappingType; "Dimension 2 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension2Mandatory; "Dimension 2 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDefaultDimension2Code; "Default Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }

                field(lvngDimension3MappingType; "Dimension 3 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension3Mandatory; "Dimension 3 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDefaultDimension3Code; "Default Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4MappingType; "Dimension 4 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension4Mandatory; "Dimension 4 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDefaultDimension4Code; "Default Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5MappingType; "Dimension 5 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension5Mandatory; "Dimension 5 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDefaultDimension5Code; "Default Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6MappingType; "Dimension 6 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension6Mandatory; "Dimension 6 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDefaultDimension6Code; "Default Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7MappingType; "Dimension 7 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension7Mandatory; "Dimension 7 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDefaultDimension7Code; "Default Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8MappingType; "Dimension 8 Mapping Type")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngDimension8Mandatory; "Dimension 8 Mandatory")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field(lvngDefaultDimension8Code; "Default Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
            }
            part(lvngDepositImportSchemaLines; lvngDepositImportSchemaLines)
            {
                Caption = 'Columns Mapping';
                SubPageLink = Code = field(Code);
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