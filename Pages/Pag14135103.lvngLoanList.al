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
                    Width = 50;
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
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
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
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

}