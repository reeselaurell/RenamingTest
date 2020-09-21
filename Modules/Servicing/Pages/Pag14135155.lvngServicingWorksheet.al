page 14135155 lvngServicingWorksheet
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
            repeater(Group)
            {
                FreezeColumn = "Borrower Name";

                field("Loan No."; "Loan No.") { ApplicationArea = All; DrillDown = false; Style = Attention; StyleExpr = "Error Message" <> ''; }
                field("Borrower Name"; "Borrower Name") { ApplicationArea = All; DrillDown = false; }
                field("Customer No."; "Customer No.") { ApplicationArea = All; DrillDown = false; }
                field("Date Funded"; "Date Funded") { ApplicationArea = All; DrillDown = false; }
                field("First Payment Due"; "First Payment Due") { ApplicationArea = All; DrillDown = false; }
                field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; DrillDown = false; }
                field("First Payment Due To Investor"; "First Payment Due To Investor") { ApplicationArea = All; DrillDown = false; }
                field("Last Servicing Period"; "Last Servicing Period") { ApplicationArea = All; }
                field("Payable to Investor"; "Payable to Investor") { ApplicationArea = All; Editable = false; }
                field("Date Sold"; "Date Sold") { ApplicationArea = All; DrillDown = false; }
                field("Interest Amount"; "Interest Amount") { ApplicationArea = All; Editable = false; }
                field("Principal Amount"; "Principal Amount") { ApplicationArea = All; Editable = false; }
                field("Escrow Amount"; "Escrow Amount") { ApplicationArea = All; Editable = false; }
                field(TotalAmount; "Interest Amount" + "Principal Amount" + "Escrow Amount") { ApplicationArea = All; Editable = false; Caption = 'Total Amount'; }
                field("Error Message"; "Error Message") { ApplicationArea = All; Editable = false; }
            }
        }

        area(Factboxes)
        {
            part(Escrows; lvngLoanEscrowFields)
            {
                Caption = 'Escrows Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoanCard)
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

            action(RetrieveLoansForServicing)
            {
                Caption = 'Retrieve Loans for Servicing';
                ApplicationArea = All;
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report lvngPrepareServicingDocuments;
            }

            action(ValidateLines)
            {
                Caption = 'Validate Lines';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ValidationCompletedMsg: Label 'Validation completed';
                begin
                    ServicingManagement.ValidateServicingWorksheet();
                    Message(ValidationCompletedMsg);
                end;
            }
            action(CreateBorrowerCustomers)
            {
                Caption = 'Create Borrower Customers';
                ApplicationArea = All;
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BorrowerCustomersCreatedlbl: Label 'Borrower Customers Created';
                begin
                    ServicingManagement.CreateBorrowerCustomers();
                    ServicingManagement.ValidateServicingWorksheet();
                    Message(BorrowerCustomersCreatedlbl);
                    CurrPage.Update(false);
                end;
            }
            action(CreateServicingDocuments)
            {
                Caption = 'Create Servicing Documents';
                ApplicationArea = All;
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ServicingDocumentsCreatedLbl: Label 'Servicing Documents Created';
                    DeleteWorksheetDataLbl: Label 'Do You want to remove worksheet entries?';
                begin
                    ServicingManagement.CreateServicingDocuments();
                    Message(ServicingDocumentsCreatedLbl);
                    Commit();
                    if Confirm(DeleteWorksheetDataLbl) then begin
                        Rec.Reset();
                        Rec.DeleteAll(true);
                    end;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        ServicingManagement: Codeunit lvngServicingManagement;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Escrows.Page.SetParams("Loan No.");
    end;
}