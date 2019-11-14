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
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }

                field(lvngSearchName; "Search Name")
                {
                    ApplicationArea = All;
                    Width = 50;
                }

                field(lvngBorrowerFirstName; "Borrower First Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngMiddleName; "Borrower Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngBorrowerLastName; "Borrower Last Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngCoBorrowerFirstName; "Co-Borrower First Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerMiddleName; "Co-Borrower Middle Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerLastName; "Co-Borrower Last Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvng203KContractorName; "203K Contractor Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvng203KInspectorName; "203K Inspector Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngLoanAmount; "Loan Amount")
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; "Application Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateLocked; "Date Locked")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateClosed; "Date Closed")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDateFunded; "Date Funded")
                {
                    ApplicationArea = All;
                }

                field(lvngDateSold; "Date Sold")
                {
                    ApplicationArea = All;
                }
                field(lvngServicingFinished; "Servicing Finished")
                {
                    ApplicationArea = All;
                }

                field(lvngLoanTerm; "Loan Term (Months)")
                {
                    ApplicationArea = All;
                }

                field(lvngInterestRate; "Interest Rate")
                {
                    ApplicationArea = All;
                }

                field(lvngConstructionInteresTRate; "Constr. Interest Rate")
                {
                    Visible = false;
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; "Monthly Escrow Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; "Monthly Payment Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngFirstPaymentDue; "First Payment Due")
                {
                    ApplicationArea = All;
                }
                field(lvngNextPaymentdate; "Next Payment Date")
                {
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; "First Payment Due To Investor")
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionDate; "Commission Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; "Commission Base Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngBlocked; Blocked)
                {
                    ApplicationArea = All;
                }

                field(lvngWarehouseLineCode; "Warehouse Line Code")
                {
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; "Business Unit Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Code; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Code; "Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Code; "Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Code; "Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Code; "Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Code; "Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }

                field(lvngCreationDate; "Creation Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngModificationDate; "Modified Date")
                {
                    Visible = false;
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
            action(lvngShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanCardValuesEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan No." = field("Loan No.");
            }
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

}