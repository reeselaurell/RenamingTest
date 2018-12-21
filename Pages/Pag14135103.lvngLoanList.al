page 14135103 "lvngLoanList"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoan;
    Caption = 'Loan List';
    DeleteAllowed = false;
    InsertAllowed = false;
    CardPageId = lvngLoanCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(LoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }

                field(SearchName; lvngSearchName)
                {
                    ApplicationArea = All;
                }

                field(LoanAmount; lvngLoanAmount)
                {
                    ApplicationArea = All;
                }


                field(ApplicationDate; lvngApplicationDate)
                {
                    ApplicationArea = All;
                }

                field(DateLocked; lvngDateLocked)
                {
                    ApplicationArea = All;
                }

                field(DateClosed; lvngDateClosed)
                {
                    ApplicationArea = All;
                }

                field(DateFunded; lvngDateFunded)
                {
                    ApplicationArea = All;
                }

                field(DateSold; lvngDateSold)
                {
                    ApplicationArea = All;
                }

                field(LoanTerm; lvngLoanTermMonths)
                {
                    ApplicationArea = All;
                }

                field(InterestRate; lvngInterestRate)
                {
                    ApplicationArea = All;
                }

                field(ConstructionInteresTRate; lvngConstrInterestRate)
                {
                    ApplicationArea = All;
                }


                field(MonthlyEscrowAmount; lvngMonthlyEscrowAmount)
                {
                    ApplicationArea = All;
                }

                field(MonthlyPaymentAmount; lvngMonthlyPaymentAmount)
                {
                    ApplicationArea = All;
                }

                field(FirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                }
                field(NextPaymentdate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                }
                field(FirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    ApplicationArea = All;
                }
                field(CommissionDate; lvngCommissionDate)
                {
                    ApplicationArea = All;
                }

                field(CommissionBaseAmount; lvngCommissionBaseAmount)
                {
                    ApplicationArea = All;
                }

                field(Blocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }

                field(WarehouseLineCode; lvngWarehouseLineCode)
                {
                    ApplicationArea = All;
                }

                field(BusinessUnitCode; lvngBusinessUnitCode)
                {
                    ApplicationArea = All;
                }

                field(Dimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(Dimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }

                field(CreationDate; lvngCreationDate)
                {
                    ApplicationArea = All;
                }
                field(ModificationDate; lvngModifiedDate)
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