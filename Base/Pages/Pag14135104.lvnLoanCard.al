page 14135104 "lvnLoanCard"
{
    PageType = Card;
    SourceTable = lvnLoan;
    Caption = 'Loan Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Alternative Loan No."; Rec."Alternative Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Warehouse Line Code"; Rec."Warehouse Line Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Title Customer No."; Rec."Title Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Investor Customer No."; Rec."Investor Customer No.")
                {
                    ApplicationArea = All;
                }
                group(Borrower)
                {
                    Caption = 'Borrower';

                    field("Borrower Customer No"; Rec."Borrower Customer No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Borrower First Name"; Rec."Borrower First Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Borrower Middle Name"; Rec."Borrower Middle Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Borrower Last Name"; Rec."Borrower Last Name")
                    {
                        ApplicationArea = All;
                    }
                }
                group(CoBorrower)
                {
                    Caption = 'Co-Borrower';

                    field("Co-Borrower First Name"; Rec."Co-Borrower First Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Co-Borrower Middle Name"; Rec."Co-Borrower Middle Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Co-Borrower Last Name"; Rec."Co-Borrower Last Name")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }
                group(Address)
                {
                    Caption = 'Addresses';

                    field(BorrowerAddress; Rec.GetLoanAddress(LoanAddressType::Borrower))
                    {
                        Caption = 'Borrower';
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::Borrower);
                        end;
                    }
                    field(CoBorrowerAddress; Rec.GetLoanAddress(LoanAddressType::CoBorrower))
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
                    field(MailingAddress; Rec.GetLoanAddress(LoanAddressType::Mailing))
                    {
                        Caption = 'Mailing';
                        ApplicationArea = All;
                        AssistEdit = true;

                        trigger OnAssistEdit()
                        begin
                            AddressEdit(LoanAddressType::Mailing);
                        end;
                    }
                    field(PropertyAddress; Rec.GetLoanAddress(LoanAddressType::Property))
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

                    field("Application Date"; Rec."Application Date")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Date Locked"; Rec."Date Locked")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Date Closed"; Rec."Date Closed")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Date Funded"; Rec."Date Funded")
                    {
                        ApplicationArea = All;
                    }
                    field("Date Sold"; Rec."Date Sold")
                    {
                        ApplicationArea = All;
                    }
                    field("Creation Date"; Rec."Creation Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                    field("Modified Date"; Rec."Modified Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Importance = Additional;
                    }
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';

                    field("Business Unit Code"; Rec."Business Unit Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible1;
                    }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible2;
                    }
                    field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible3;
                    }
                    field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible4;
                    }
                    field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible5;
                    }
                    field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible6;
                    }
                    field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible7;
                    }
                    field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                    {
                        ApplicationArea = All;
                        Visible = DimensionVisible8;
                    }
                }
            }
            group("203K")
            {
                Caption = '203K Information';

                field("203K Contractor Name"; Rec."203K Contractor Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("203K Inspector Name"; Rec."203K Inspector Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(Servicing)
            {
                Caption = 'Servicing';

                field("Servicing Finished"; Rec."Servicing Finished")
                {
                    ApplicationArea = All;
                }
                field("Loan Term (Months)"; Rec."Loan Term (Months)")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Constr. Interest Rate"; Rec."Constr. Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Monthly Escrow Amount"; Rec."Monthly Escrow Amount")
                {
                    ApplicationArea = All;
                }
                field("Monthly Payment Amount"; Rec."Monthly Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("First Payment Due"; Rec."First Payment Due")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Next Payment Date"; Rec."Next Payment Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("First Payment Due To Investor"; Rec."First Payment Due To Investor")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(Commissions)
            {
                Caption = 'Commissions';

                field("Commission Date"; Rec."Commission Date")
                {
                    ApplicationArea = All;
                }
                field("Commission Base Amount"; Rec."Commission Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Commission Bps"; Rec."Commission Bps")
                {
                    ApplicationArea = All;
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
            part(Values; lvnLoanCardValuesPart)
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
                RunObject = page lvnLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvnDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvnDocumentGuid);
    end;

    var
        LoanAddressType: Enum lvnAddressType;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    local procedure AddressEdit(AddressType: Enum lvnAddressType)
    var
        LoanAddress: Record lvnLoanAddress;
        LoanAddressCard: Page lvnLoanAddressCard;
    begin
        if not LoanAddress.Get(Rec."No.", AddressType) then begin
            Clear(LoanAddress);
            LoanAddress.Init();
            LoanAddress."Address Type" := AddressType;
            LoanAddress."Loan No." := Rec."No.";
            LoanAddress.Insert(true);
            Commit();
        end;
        Clear(LoanAddressCard);
        LoanAddressCard.SetRecord(LoanAddress);
        LoanAddressCard.RunModal();
        CurrPage.Update(false);
    end;
}