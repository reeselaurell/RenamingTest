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
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Style = Attention;
                    StyleExpr = "Error Message" <> '';
                }
                field(lvngBorrowerName; "Borrower Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;

                }
                field(lvngCustomerNo; "Customer No.")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngDateFunded; "Date Funded")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngFirstPaymentDue; "First Payment Due")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngNextPaymentDate; "Next Payment Date")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngFirstPaymentDueToInvestor; "First Payment Due To Investor")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngDateSold; "Date Sold")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                field(lvngInterestAmount; "Interest Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngPrincipalAmount; "Principal Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngEscrowAmount; "Escrow Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngTotalAmount; "Interest Amount" + "Principal Amount" + "Escrow Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';
                }

                field(lvngErrorMessage; "Error Message")
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
                RunPageLink = "No." = field("Loan No.");
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
        CurrPage.lvngEscrows.Page.SetParams("Loan No.");
    end;

    var
        lvngServicingManagement: Codeunit lvngServicingManagement;
        lvngValidationCompletedLbl: Label 'Validation completed';
}