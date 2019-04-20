page 14135104 "lvngLoanCard"
{
    PageType = Card;
    SourceTable = lvngLoan;
    Caption = 'Loan Card';

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngWarehouseLineCode; lvngWarehouseLineCode)
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }


                field(lvngSearchName; lvngSearchName)
                {
                    ApplicationArea = All;
                }

                field(lvngTitleCustomerNo; lvngTitleCustomerNo)
                {
                    ApplicationArea = All;
                }

                field(lvngInvestorCustomerNo; lvngInvestorCustomerNo)
                {
                    ApplicationArea = All;
                }
                group(lvngBorrower)
                {
                    Caption = 'Borrower';
                    field(lvngBorrowerCustomerNo; lvngBorrowerCustomerNo)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngBorrowerFirstName; lvngBorrowerFirstName)
                    {
                        ApplicationArea = All;
                    }

                    field(lvngBorrowerMiddleName; lvngBorrowerMiddleName)
                    {
                        ApplicationArea = All;
                    }

                    field(lvngBorrowerLastName; lvngBorrowerLastName)
                    {
                        ApplicationArea = All;
                    }

                }
                group(lvngCoBorrower)
                {
                    Caption = 'Co-Borrower';

                    field(lvngCoBorrowerFirstName; lvngCoBorrowerFirstName)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngCoBorrowerMiddleName; lvngCoBorrowerMiddleName)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngCoBorrowerLastName; lvngCoBorrowerLastName)
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }

                group(lvngAddress)
                {
                    Caption = 'Addresses';
                    field(lvngBorrowerAddress; GetLoanAddress(lvngLoanAddressTypeEnum::lvngBorrower))
                    {
                        Caption = 'Borrower';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::lvngBorrower);
                        end;
                    }
                    field(lvngCoBorrowerAddress; GetLoanAddress(lvngLoanAddressTypeEnum::lvngCoBorrower))
                    {
                        Caption = 'Co-Borrower';
                        Importance = Additional;
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::lvngCoBorrower);
                        end;
                    }
                    field(lvngMailingAddress; GetLoanAddress(lvngLoanAddressTypeEnum::lvngMailing))
                    {
                        Caption = 'Mailing';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::lvngMailing);
                        end;
                    }
                    field(lvngPropertyAddress; GetLoanAddress(lvngLoanAddressTypeEnum::lvngProperty))
                    {
                        Caption = 'Property';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::lvngProperty);
                        end;
                    }
                }
                group(lvngDates)
                {
                    Caption = 'Dates';
                    field(lvngApplicationDate; lvngApplicationDate)
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateLocked; lvngDateLocked)
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateClosed; lvngDateClosed)
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateFunded; lvngDateFunded)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDateSold; lvngDateSold)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngCreationDate; lvngCreationDate)
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngModifiedDate; lvngModifiedDate)
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';
                    field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                    {
                        ApplicationArea = All;
                    }

                    field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                    {
                        Visible = Dimension1Visible;
                        ApplicationArea = All;
                    }
                    field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                    {
                        Visible = Dimension2Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                    {
                        Visible = Dimension3Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                    {
                        Visible = Dimension4Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                    {
                        Visible = Dimension5Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                    {
                        Visible = Dimension6Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                    {
                        Visible = Dimension7Visible;
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                    {
                        Visible = Dimension8Visible;
                        ApplicationArea = All;
                    }

                }
            }
            group(lvng203K)
            {
                Caption = '203K Information';

                field(lvng203KContractorName; lvng203KContractorName)
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                }
                field(lvng203KInspectorName; lvng203KInspectorName)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

            }
            group(lvngServicing)
            {
                Caption = 'Servicing';
                field(lvngServicingFinished; lvngServicingFinished)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanTerm; lvngLoanTermMonths)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

                field(lvngInterestRate; lvngInterestRate)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

                field(lvngConstructionInteresTRate; lvngConstrInterestRate)
                {
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; lvngMonthlyEscrowAmount)
                {
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; lvngMonthlyPaymentAmount)
                {
                    ApplicationArea = All;
                }

                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(lvngNextPaymentdate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(lvngCommissions)
            {
                Caption = 'Commissions';
                field(lvngCommissionDate; lvngCommissionDate)
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; lvngCommissionBaseAmount)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
            part(lvngValues; lvngLoanCardValuesPart)
            {
                Caption = 'Values';
                ApplicationArea = All;
                SubPageLink = lvngLoanNo = field (lvngLoanNo);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = lvngLoanNo = field (lvngLoanNo);
            }
        }
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GeneralLedgerSetupRetrieved: Boolean;
        Dimension1Visible: Boolean;
        Dimension2Visible: Boolean;
        Dimension3Visible: Boolean;
        Dimension4Visible: Boolean;
        Dimension5Visible: Boolean;
        Dimension6Visible: Boolean;
        Dimension7Visible: Boolean;
        Dimension8Visible: Boolean;
        lvngLoanAddressTypeEnum: Enum lvngAddressType;
        lvngLoanAddressCard: Page lvngLoanAddressCard;
        lvngLoanAddress: Record lvngLoanAddress;

    trigger OnOpenPage()
    begin
        VisibleDimensions();
    end;

    local procedure AddressEdit(lvngAddressTypeEnum: Enum lvngAddressType)
    begin
        if not lvngLoanAddress.Get(lvngLoanNo, lvngAddressTypeEnum) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.Init();
            lvngLoanAddress.lvngAddressType := lvngAddressTypeEnum;
            lvngLoanAddress.lvngLoanNo := lvngLoanNo;
            lvngLoanAddress.Insert(true);
            Commit();
        end;
        lvngLoanAddress.Get(lvngLoanNo, lvngAddressTypeEnum);
        Clear(lvngLoanAddressCard);
        lvngLoanAddressCard.SetRecord(lvngLoanAddress);
        lvngLoanAddressCard.RunModal();
        CurrPage.Update(false);
    end;

    local procedure VisibleDimensions()
    begin
        GetGLSetup();
        Dimension1Visible := GeneralLedgerSetup."Shortcut Dimension 1 Code" <> '';
        Dimension2Visible := GeneralLedgerSetup."Shortcut Dimension 2 Code" <> '';
        Dimension3Visible := GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '';
        Dimension4Visible := GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '';
        Dimension5Visible := GeneralLedgerSetup."Shortcut Dimension 5 Code" <> '';
        Dimension6Visible := GeneralLedgerSetup."Shortcut Dimension 6 Code" <> '';
        Dimension7Visible := GeneralLedgerSetup."Shortcut Dimension 7 Code" <> '';
        Dimension8Visible := GeneralLedgerSetup."Shortcut Dimension 8 Code" <> '';
    end;

    local procedure GetGLSetup()
    begin
        if not GeneralLedgerSetupRetrieved then begin
            GeneralLedgerSetup.get;
            GeneralLedgerSetupRetrieved := true;
        end;
    end;
}