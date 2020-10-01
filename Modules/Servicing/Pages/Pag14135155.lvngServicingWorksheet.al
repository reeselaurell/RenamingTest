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

                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; DrillDown = false; Style = Attention; StyleExpr = Rec."Error Message" <> ''; }
                field("Borrower Name"; Rec."Borrower Name") { ApplicationArea = All; DrillDown = false; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; DrillDown = false; }
                field("Date Funded"; Rec."Date Funded") { ApplicationArea = All; DrillDown = false; }
                field("First Payment Due"; Rec."First Payment Due") { ApplicationArea = All; DrillDown = false; }
                field("Next Payment Date"; Rec."Next Payment Date") { ApplicationArea = All; DrillDown = false; }
                field("First Payment Due To Investor"; Rec."First Payment Due To Investor") { ApplicationArea = All; DrillDown = false; }
                field("Last Servicing Period"; Rec."Last Servicing Period") { ApplicationArea = All; }
                field("Payable to Investor"; Rec."Payable to Investor") { ApplicationArea = All; Editable = false; }
                field("Date Sold"; Rec."Date Sold") { ApplicationArea = All; DrillDown = false; }
                field("Interest Amount"; Rec."Interest Amount") { ApplicationArea = All; Editable = false; }
                field("Principal Amount"; Rec."Principal Amount") { ApplicationArea = All; Editable = false; }
                field("Escrow Amount"; Rec."Escrow Amount") { ApplicationArea = All; Editable = false; }
                field(TotalAmount; Rec."Interest Amount" + Rec."Principal Amount" + Rec."Escrow Amount") { ApplicationArea = All; Editable = false; Caption = 'Total Amount'; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; Editable = false; }
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
        CurrPage.Escrows.Page.SetParams(Rec."Loan No.");
    end;
}