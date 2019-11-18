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
                field(lvngLoanNo; "No.")
                {
                    ApplicationArea = All;
                }
                field(lvngWarehouseLineCode; "Warehouse Line Code")
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; Blocked)
                {
                    ApplicationArea = All;
                }


                field(lvngSearchName; "Search Name")
                {
                    ApplicationArea = All;
                }

                field(lvngTitleCustomerNo; "Title Customer No.")
                {
                    ApplicationArea = All;
                }

                field(lvngInvestorCustomerNo; "Investor Customer No.")
                {
                    ApplicationArea = All;
                }
                group(lvngBorrower)
                {
                    Caption = 'Borrower';
                    field(lvngBorrowerCustomerNo; "Borrower Customer No")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngBorrowerFirstName; "Borrower First Name")
                    {
                        ApplicationArea = All;
                    }

                    field(lvngBorrowerMiddleName; "Borrower Middle Name")
                    {
                        ApplicationArea = All;
                    }

                    field(lvngBorrowerLastName; "Borrower Last Name")
                    {
                        ApplicationArea = All;
                    }

                }
                group(lvngCoBorrower)
                {
                    Caption = 'Co-Borrower';

                    field(lvngCoBorrowerFirstName; "Co-Borrower First Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngCoBorrowerMiddleName; "Co-Borrower Middle Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(lvngCoBorrowerLastName; "Co-Borrower Last Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }

                group(lvngAddress)
                {
                    Caption = 'Addresses';
                    field(lvngBorrowerAddress; GetLoanAddress(lvngLoanAddressTypeEnum::Borrower))
                    {
                        Caption = 'Borrower';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::Borrower);
                        end;
                    }
                    field(lvngCoBorrowerAddress; GetLoanAddress(lvngLoanAddressTypeEnum::CoBorrower))
                    {
                        Caption = 'Co-Borrower';
                        Importance = Additional;
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::CoBorrower);
                        end;
                    }
                    field(lvngMailingAddress; GetLoanAddress(lvngLoanAddressTypeEnum::Mailing))
                    {
                        Caption = 'Mailing';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::Mailing);
                        end;
                    }
                    field(lvngPropertyAddress; GetLoanAddress(lvngLoanAddressTypeEnum::Property))
                    {
                        Caption = 'Property';
                        ApplicationArea = All;
                        AssistEdit = true;
                        trigger OnAssistEdit()
                        begin
                            AddressEdit(lvngLoanAddressTypeEnum::Property);
                        end;
                    }
                }
                group(lvngDates)
                {
                    Caption = 'Dates';
                    field(lvngApplicationDate; "Application Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateLocked; "Date Locked")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateClosed; "Date Closed")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngDateFunded; "Date Funded")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngDateSold; "Date Sold")
                    {
                        ApplicationArea = All;
                    }
                    field(lvngCreationDate; "Creation Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field(lvngModifiedDate; "Modified Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';
                    field(lvngBusinessUnitCode; "Business Unit Code")
                    {
                        ApplicationArea = All;
                    }

                    field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible1;
                    }
                    field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible2;
                    }
                    field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible3;
                    }
                    field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible4;
                    }
                    field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible5;
                    }
                    field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible6;
                    }
                    field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible7;
                    }
                    field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible8;
                    }

                }
            }
            group(lvng203K)
            {
                Caption = '203K Information';

                field(lvng203KContractorName; "203K Contractor Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                }
                field(lvng203KInspectorName; "203K Inspector Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

            }
            group(lvngServicing)
            {
                Caption = 'Servicing';
                field(lvngServicingFinished; "Servicing Finished")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanTerm; "Loan Term (Months)")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

                field(lvngInterestRate; "Interest Rate")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }

                field(lvngConstructionInteresTRate; "Constr. Interest Rate")
                {
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; "Monthly Escrow Amount")
                {
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; "Monthly Payment Amount")
                {
                    ApplicationArea = All;
                }

                field(lvngFirstPaymentDue; "First Payment Due")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(lvngNextPaymentdate; "Next Payment Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(lvngFirstPaymentDueToInvestor; "First Payment Due To Investor")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(lvngCommissions)
            {
                Caption = 'Commissions';
                field(lvngCommissionDate; "Commission Date")
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; "Commission Base Amount")
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionBps; "Commission Bps")
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionAmount; "Commission Amount")
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
                SubPageLink = "Loan No." = field("No.");
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
                RunPageLink = "Loan No." = field("No.");
            }
        }
    }

    var
        lvngLoanAddressTypeEnum: Enum lvngAddressType;
        lvngLoanAddressCard: Page lvngLoanAddressCard;
        lvngLoanAddress: Record lvngLoanAddress;
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;


    local procedure AddressEdit(lvngAddressTypeEnum: Enum lvngAddressType)
    begin
        if not lvngLoanAddress.Get("No.", lvngAddressTypeEnum) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.Init();
            lvngLoanAddress."Address Type" := lvngAddressTypeEnum;
            lvngLoanAddress."Loan No." := "No.";
            lvngLoanAddress.Insert(true);
            Commit();
        end;
        lvngLoanAddress.Get("No.", lvngAddressTypeEnum);
        Clear(lvngLoanAddressCard);
        lvngLoanAddressCard.SetRecord(lvngLoanAddress);
        lvngLoanAddressCard.RunModal();
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;



}