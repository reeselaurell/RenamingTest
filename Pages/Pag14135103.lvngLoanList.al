page 14135103 "lvngLoanList"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoan;
    Caption = 'Loan List';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    CardPageId = lvngLoanCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }

                field(lvngSearchName; lvngSearchName)
                {
                    ApplicationArea = All;
                }

                field(lvngBorrowerFirstName; lvngBorrowerFirstName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngMiddleName; lvngBorrowerMiddleName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngBorrowerLastName; lvngBorrowerLastName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngCoBorrowerFirstName; lvngCoBorrowerFirstName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerMiddleName; lvngCoBorrowerMiddleName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerLastName; lvngCoBorrowerLastName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvng203KContractorName; lvng203KContractorName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvng203KInspectorName; lvng203KInspectorName)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngLoanAmount; lvngLoanAmount)
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; lvngApplicationDate)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateLocked; lvngDateLocked)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateClosed; lvngDateClosed)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateFunded; lvngDateFunded)
                {
                    ApplicationArea = All;
                }

                field(lvngDateSold; lvngDateSold)
                {
                    ApplicationArea = All;
                }
                field(lvngServicingFinished; lvngServicingFinished)
                {
                    ApplicationArea = All;
                }

                field(lvngLoanTerm; lvngLoanTermMonths)
                {
                    ApplicationArea = All;
                }

                field(lvngInterestRate; lvngInterestRate)
                {
                    ApplicationArea = All;
                }

                field(lvngConstructionInteresTRate; lvngConstrInterestRate)
                {
                    Visible = false;
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; lvngMonthlyEscrowAmount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; lvngMonthlyPaymentAmount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                }
                field(lvngNextPaymentdate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionDate; lvngCommissionDate)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; lvngCommissionBaseAmount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngBlocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }

                field(lvngWarehouseLineCode; lvngWarehouseLineCode)
                {
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension1Visible;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension2Visible;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension3Visible;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension4Visible;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension5Visible;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension6Visible;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension7Visible;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = Dimension8Visible;
                }

                field(lvngCreationDate; lvngCreationDate)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngModificationDate; lvngModifiedDate)
                {
                    Visible = false;
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

    trigger OnOpenPage()
    begin
        VisibleDimensions();
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