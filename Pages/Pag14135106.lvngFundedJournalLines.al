page 14135106 "lvngFundedJournalLines"
{
    PageType = List;
    Caption = 'Funded Journal Lines';
    SourceTable = lvngLoanJournalLine;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(lvngGrid)
            {
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = "Error Exists";
                }

                field(lvngTitleCustomerNo; "Title Customer No.")
                {
                    ApplicationArea = All;
                }

                field(lvngSearchName; "Search Name")
                {
                    Width = 50;
                    ApplicationArea = All;
                }
                field(lvngBorrowerFirstName; "Borrower First Name")
                {
                    Width = 30;
                    ApplicationArea = All;
                }

                field(lvngMiddleName; "Borrower Middle Name")
                {
                    Width = 10;
                    ApplicationArea = All;
                }

                field(lvngBorrowerLastName; "Borrower Last Name")
                {
                    Width = 30;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerFirstName; "Co-Borrower First Name")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerMiddleName; "Co-Borrower Middle Name")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerLastName; "Co-Borrower Last Name")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerAddress; "Borrower Address")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerAddress2; "Borrower Address 2")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerCity; "Borrower City")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerState; "Borrower State")
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerZIPCode; "Borrower ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerAddress; "Co-Borrower Address")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerAddress2; lvngCoBorrowerAddress2)
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerCity; "Co-Borrower City")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerState; "Co-Borrower State")
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerZIPCode; "Co-Borrower ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(lvngMailingAddress; "Mailing Address")
                {
                    ApplicationArea = All;
                }
                field(lvngMailingAddress2; "Mailing Address 2")
                {
                    ApplicationArea = All;
                }
                field(lvngMailingCity; "Mailing City")
                {
                    ApplicationArea = All;
                }
                field(lvngMailingState; "Mailing State")
                {
                    ApplicationArea = All;
                }
                field(lvngMailingZIPCode; "Mailing ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(lvngPropertyAddress; "Property Address")
                {
                    ApplicationArea = All;
                }
                field(lvngPropertyAddress2; "Property Address 2")
                {
                    ApplicationArea = All;
                }
                field(lvngPropertyCity; "Property City")
                {
                    ApplicationArea = All;
                }
                field(lvngPropertyState; "Property State")
                {
                    ApplicationArea = All;
                }
                field(lvngPropertyZIPCode; "Property ZIP Code")
                {
                    ApplicationArea = All;
                }
                field(lvng203KContractorName; "203K Contractor Name")
                {
                    ApplicationArea = All;
                }
                field(lvng203KInspectorName; "203K Inspector Name")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanAmount; "Loan Amount")
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; "Application Date")
                {
                    ApplicationArea = All;
                }

                field(lvngDateLocked; "Date Locked")
                {
                    ApplicationArea = All;
                }

                field(lvngDateClosed; "Date Closed")
                {
                    ApplicationArea = All;
                }

                field(lvngDateFunded; "Date Funded")
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
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; "Monthly Escrow Amount")
                {
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; "Monthly Payment Amount")
                {
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
                field(lvngLateFee; "Late Fee")
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionDate; "Commission Date")
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; "Commission Base Amount")
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionBps; "Commission Bps")
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionAmount; "Commission Amount")
                {
                    ApplicationArea = All;
                }
                field(lvngWarehouseLineCode; "Warehouse Line Code")
                {
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; "Business Unit Code")
                {
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
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }

                field(lvngProcessingSchemaCode; "Processing Schema Code")
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngCalculatedDocumentAmount; "Calculated Document Amount")
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; Blocked)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; "First Payment Due To Investor")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngDateSold; "Date Sold")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
            part(lvngErrors; lvngLoanJournalErrors)
            {
                Caption = 'Errors';
                ApplicationArea = All;
                SubPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }
            part(lvngValues; lvngLoanImportValuePart)
            {
                Caption = 'Values';
                ApplicationArea = All;
                SubPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngImport)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    lvngLoanJournalImport: Codeunit lvngLoanJournalImport;
                    lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
                    lvngLoanImportSchema: Record lvngLoanImportSchema;
                begin
                    lvngLoanImportSchema.reset;
                    lvngLoanImportSchema.SetRange("Loan Journal Batch Type", lvngLoanImportSchema."Loan Journal Batch Type"::Funded);
                    if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOk then begin
                        Clear(lvngLoanJournalImport);
                        lvngLoanJournalImport.ReadCSVStream("Loan Journal Batch Code", lvngLoanImportSchema);
                        Commit();
                        lvngValidateFundedJournal.ValidateFundedLines("Loan Journal Batch Code");
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(lvngValidateLines)
            {
                Caption = 'Validate Lines';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
                begin
                    lvngValidateFundedJournal.ValidateFundedLines("Loan Journal Batch Code");
                    CurrPage.Update(false);
                end;
            }

            action(lvngPreviewDocument)
            {
                Caption = 'Preview Document';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PreviewChecks;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lvngPreviewLoanDocument: Page lvngPreviewLoanDocument;
                begin
                    lvngPreviewLoanDocument.SetJournalLine(Rec);
                    lvngPreviewLoanDocument.Run();
                end;
            }

            action(lvngCreateDocuments)
            {
                Caption = 'Create Documents';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CreateDocuments;
                trigger OnAction()
                var
                    lvngCreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
                begin
                    lvngCreateFundedDocuments.CreateDocuments("Loan Journal Batch Code");
                end;
            }
            action(lvngCreateLoanCards)
            {
                Caption = 'Create Loan Cards';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CreateForm;
                trigger OnAction()
                var
                    lvngLoanManagement: Codeunit lvngLoanManagement;
                begin
                    lvngLoanManagement.UpdateLoans("Loan Journal Batch Code");
                end;
            }

            action(lvngShowLoanValues)
            {
                ApplicationArea = All;
                Caption = 'Edit Loan Values';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page lvngLoanImportValueEdit;
                RunPageMode = Edit;
                RunPageLink = "Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No.");
            }

            action(lvngShowErrorLinesOnly)
            {
                ApplicationArea = All;
                Caption = 'Show Error Lines';
                Image = ErrorLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetRange("Error Exists", true);
                    CurrPage.Update(false);
                end;
            }

            action(lvngShowAllLines)
            {
                ApplicationArea = All;
                Caption = 'Show All Lines';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetRange("Error Exists");
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Error Exists");
    end;

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

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
}