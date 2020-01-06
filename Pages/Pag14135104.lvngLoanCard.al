page 14135104 lvngLoanCard
{
    PageType = Card;
    SourceTable = lvngLoan;
    Caption = 'Loan Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; "No.") { ApplicationArea = All; }
                field("Alternative Loan No."; "Alternative Loan No.") { ApplicationArea = All; }
                field("Warehouse Line Code"; "Warehouse Line Code") { ApplicationArea = All; }
                field(Blocked; Blocked) { ApplicationArea = All; }
                field("Search Name"; "Search Name") { ApplicationArea = All; }
                field("Title Customer No."; "Title Customer No.") { ApplicationArea = All; }
                field("Investor Customer No."; "Investor Customer No.") { ApplicationArea = All; }

                group(Borrower)
                {
                    Caption = 'Borrower';

                    field("Borrower Customer No"; "Borrower Customer No") { ApplicationArea = All; }
                    field("Borrower First Name"; "Borrower First Name") { ApplicationArea = All; }
                    field("Borrower Middle Name"; "Borrower Middle Name") { ApplicationArea = All; }
                    field("Borrower Last Name"; "Borrower Last Name") { ApplicationArea = All; }
                }

                group(CoBorrower)
                {
                    Caption = 'Co-Borrower';

                    field("Co-Borrower First Name"; "Co-Borrower First Name") { Importance = Additional; ApplicationArea = All; }
                    field("Co-Borrower Middle Name"; "Co-Borrower Middle Name") { Importance = Additional; ApplicationArea = All; }
                    field("Co-Borrower Last Name"; "Co-Borrower Last Name") { Importance = Additional; ApplicationArea = All; }
                }

                group(Address)
                {
                    Caption = 'Addresses';

                    field(BorrowerAddress; GetLoanAddress(LoanAddressType::Borrower))
                    {
                        Caption = 'Borrower';
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::Borrower);
                        end;
                    }
                    field(CoBorrowerAddress; GetLoanAddress(LoanAddressType::CoBorrower))
                    {
                        Caption = 'Co-Borrower';
                        Importance = Additional;
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::CoBorrower);
                        end;
                    }
                    field(MailingAddress; GetLoanAddress(LoanAddressType::Mailing))
                    {
                        Caption = 'Mailing';
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::Mailing);
                        end;
                    }
                    field(PropertyAddress; GetLoanAddress(LoanAddressType::Property))
                    {
                        Caption = 'Property';
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::Property);
                        end;
                    }
                }

                group(Dates)
                {
                    Caption = 'Dates';

                    field("Application Date"; "Application Date") { ApplicationArea = All; Importance = Additional; }
                    field("Date Locked"; "Date Locked") { ApplicationArea = All; Importance = Additional; }
                    field("Date Closed"; "Date Closed") { ApplicationArea = All; Importance = Additional; }
                    field("Date Funded"; "Date Funded") { ApplicationArea = All; }
                    field("Date Sold"; "Date Sold") { ApplicationArea = All; }
                    field("Creation Date"; "Creation Date") { Editable = false; ApplicationArea = All; Importance = Additional; }
                    field("Modified Date"; "Modified Date") { Editable = false; ApplicationArea = All; Importance = Additional; }
                }

                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                    field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                    field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                    field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                    field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                    field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                    field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                    field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                    field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                }
            }

            group("203K")
            {
                Caption = '203K Information';

                field("203K Contractor Name"; "203K Contractor Name") { ApplicationArea = All; Importance = Promoted; }
                field("203K Inspector Name"; "203K Inspector Name") { ApplicationArea = All; Importance = Promoted; }
            }

            group(Servicing)
            {
                Caption = 'Servicing';

                field("Servicing Finished"; "Servicing Finished") { ApplicationArea = All; }
                field("Loan Term (Months)"; "Loan Term (Months)") { ApplicationArea = All; Importance = Promoted; }
                field("Interest Rate"; "Interest Rate") { ApplicationArea = All; Importance = Promoted; }
                field("Constr. Interest Rate"; "Constr. Interest Rate") { ApplicationArea = All; }
                field("Monthly Escrow Amount"; "Monthly Escrow Amount") { ApplicationArea = All; }
                field("Monthly Payment Amount"; "Monthly Payment Amount") { ApplicationArea = All; }
                field("First Payment Due"; "First Payment Due") { ApplicationArea = All; Importance = Promoted; }
                field("Next Payment Date"; "Next Payment Date") { ApplicationArea = All; Importance = Promoted; }
                field("First Payment Due To Investor"; "First Payment Due To Investor") { ApplicationArea = All; Importance = Promoted; }
            }

            group(Commissions)
            {
                Caption = 'Commissions';

                field("Commission Date"; "Commission Date") { ApplicationArea = All; }
                field("Commission Base Amount"; "Commission Base Amount") { ApplicationArea = All; }
                field("Commission Bps"; "Commission Bps") { ApplicationArea = All; }
                field("Commission Amount"; "Commission Amount") { ApplicationArea = All; }
            }
        }

        area(Factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
            part(Values; lvngLoanCardValuesPart)
            {
                Caption = 'Values';
                ApplicationArea = All;
                SubPageLink = "Loan No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan No." = field("No.");
            }
        }
    }

    var
        LoanAddressType: Enum lvngAddressType;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(lvngDocumentGuid);
    end;

    local procedure AddressEdit(AddressType: Enum lvngAddressType)
    var
        LoanAddressCard: Page lvngLoanAddressCard;
        LoanAddress: Record lvngLoanAddress;
    begin
        if not LoanAddress.Get("No.", AddressType) then begin
            Clear(LoanAddress);
            LoanAddress.Init();
            LoanAddress."Address Type" := AddressType;
            LoanAddress."Loan No." := "No.";
            LoanAddress.Insert(true);
            Commit();
        end;
        Clear(LoanAddressCard);
        LoanAddressCard.SetRecord(LoanAddress);
        LoanAddressCard.RunModal();
        CurrPage.Update(false);
    end;
}