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

                field(lvngLoanAmount; lvngLoanAmount)
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; lvngApplicationDate)
                {
                    ApplicationArea = All;
                }

                field(lvngDateLocked; lvngDateLocked)
                {
                    ApplicationArea = All;
                }

                field(lvngDateClosed; lvngDateClosed)
                {
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
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; lvngCommissionBaseAmount)
                {
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
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }

                field(lvngCreationDate; lvngCreationDate)
                {
                    ApplicationArea = All;
                }
                field(lvngModificationDate; lvngModifiedDate)
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