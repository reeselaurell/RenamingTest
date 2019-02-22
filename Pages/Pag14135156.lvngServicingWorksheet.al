page 14135156 "lvngServicingWorksheet"
{
    Caption = 'Servicing Worksheet';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngServicingWorksheet;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngCustomerNo; lvngCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerName; lvngBorrowerName)
                {
                    ApplicationArea = All;
                }
                field(lvngDateFunded; lvngDateFunded)
                {
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                }
                field(lvngNextPaymentDate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    ApplicationArea = All;
                }
                field(lvngDateSold; lvngDateSold)
                {
                    ApplicationArea = All;
                }
                field(lvngInterestAmount; lvngInterestAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngPrincipalAmount; lvngPrincipalAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngEscrowAmount; lvngEscrowAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngTotalAmount; lvngInterestAmount + lvngPrincipalAmount + lvngEscrowAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';
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
            action(lvngRetrieveLoansForServicing)
            {
                Caption = 'Retrieve Loans for Servicing';
                ApplicationArea = All;
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report lvngPrepareServicingDocuments;

            }
        }
    }
}