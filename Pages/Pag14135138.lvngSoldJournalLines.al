page 14135138 "lvngSoldJournalLines"
{
    PageType = List;
    Caption = 'Sold Journal Lines';
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

                field(lvngInvestorCustomerNo; "Investor Customer No.")
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
                    Visible = False;
                }
                field(lvngCoBorrowerMiddleName; "Co-Borrower Middle Name")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngCoBorrowerLastName; "Co-Borrower Last Name")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvng203KContractorName; "203K Contractor Name")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvng203KInspectorName; "203K Inspector Name")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngLoanAmount; "Loan Amount")
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; "Application Date")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateLocked; "Date Locked")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateClosed; "Date Closed")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateSold; "Date Sold")
                {
                    ApplicationArea = All;
                }

                field(lvngLoanTerm; "Loan Term (Months)")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngInterestRate; "Interest Rate")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngConstructionInteresTRate; "Constr. Interest Rate")
                {
                    ApplicationArea = All;
                    Visible = False;
                }


                field(lvngMonthlyEscrowAmount; "Monthly Escrow Amount")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngMonthlyPaymentAmount; "Monthly Payment Amount")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngFirstPaymentDue; "First Payment Due")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngNextPaymentdate; "Next Payment Date")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngCommissionDate; "Commission Date")
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngCommissionBaseAmount; "Commission Base Amount")
                {
                    ApplicationArea = All;
                    Visible = False;
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
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; "First Payment Due To Investor")
                {
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
                    lvngValidateSoldJournal: Codeunit lvngValidateSoldJournal;
                    lvngLoanImportSchema: Record lvngLoanImportSchema;
                begin
                    lvngLoanImportSchema.reset;
                    lvngLoanImportSchema.SetRange("Loan Journal Batch Type", lvngLoanImportSchema."Loan Journal Batch Type"::Sold);
                    if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOk then begin
                        Clear(lvngLoanJournalImport);
                        lvngLoanJournalImport.ReadCSVStream("Loan Journal Batch Code", lvngLoanImportSchema);
                        Commit();
                        lvngValidateSoldJournal.ValidateSoldLines("Loan Journal Batch Code");
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
                    lvngValidateSoldJournal: Codeunit lvngValidateSoldJournal;
                begin
                    lvngValidateSoldJournal.ValidateSoldLines("Loan Journal Batch Code");
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
                    lvngCreateSoldDocuments: Codeunit lvngCreateSoldDocuments;
                begin
                    lvngCreateSoldDocuments.CreateDocuments("Loan Journal Batch Code");
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

    trigger OnOpenPage()
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Error Exists");
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