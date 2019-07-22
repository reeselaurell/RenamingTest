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
                    DrillDown = false;
                }
                field(lvngCustomerNo; lvngCustomerNo)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngBorrowerName; lvngBorrowerName)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngDateFunded; lvngDateFunded)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngNextPaymentDate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngDateSold; lvngDateSold)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngInterestAmount; lvngInterestAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngPrincipalAmount; lvngPrincipalAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngEscrowAmount; lvngEscrowAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngErrorMessage; lvngErrorMessage)
                {
                    ApplicationArea = All;
                    Editable = false;
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
            part(lvngEscrows; lvngLoanEscrowFields)
            {
                Caption = 'Escrows Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngLoanCard)
            {
                Caption = 'Loan Card';
                ApplicationArea = All;
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page lvngLoanCard;
                RunPageLink = lvngLoanNo = field (lvngLoanNo);
            }
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

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.lvngEscrows.Page.SetParams(lvngLoanNo);
    end;
}