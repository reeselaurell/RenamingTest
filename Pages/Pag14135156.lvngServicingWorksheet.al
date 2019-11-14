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
                FreezeColumn = lvngBorrowerName;
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Style = Attention;
                    StyleExpr = lvngErrorMessage <> '';
                }
                field(lvngBorrowerName; lvngBorrowerName)
                {
                    ApplicationArea = All;
                    DrillDown = false;

                }
                field(lvngCustomerNo; lvngCustomerNo)
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
                field(lvngTotalAmount; lvngInterestAmount + lvngPrincipalAmount + lvngEscrowAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';
                }

                field(lvngErrorMessage; lvngErrorMessage)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                RunPageLink = "Loan No." = field(lvngLoanNo);
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
            action(lvngValidateLines)
            {
                Caption = 'Validate Lines';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    lvngServicingManagement.ValidateServicingWorksheet();
                    Message(lvngValidationCompletedLbl);
                end;
            }
            action(lvngCreateBorrowerCustomers)
            {
                Caption = 'Create Borrower Customers';
                ApplicationArea = All;
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    lvngServicingManagement.CreateBorrowerCustomers();
                    lvngServicingManagement.ValidateServicingWorksheet();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.lvngEscrows.Page.SetParams(lvngLoanNo);
    end;

    var
        lvngServicingManagement: Codeunit lvngServicingManagement;
        lvngValidationCompletedLbl: Label 'Validation completed';
}