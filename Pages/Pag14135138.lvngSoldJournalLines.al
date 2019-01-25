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
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = lvngErrorExists;
                }

                field(lvngInvestorCustomerNo; lvngInvestorCustomerNo)
                {
                    ApplicationArea = All;
                }

                field(lvngSearchName; lvngSearchName)
                {
                    Width = 50;
                    ApplicationArea = All;
                }
                field(lvngBorrowerFirstName; lvngBorrowerFirstName)
                {
                    Width = 30;
                    ApplicationArea = All;
                }

                field(lvngMiddleName; lvngBorrowerMiddleName)
                {
                    Width = 10;
                    ApplicationArea = All;
                }

                field(lvngBorrowerLastName; lvngBorrowerLastName)
                {
                    Width = 30;
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerFirstName; lvngCoBorrowerFirstName)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngCoBorrowerMiddleName; lvngCoBorrowerMiddleName)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngCoBorrowerLastName; lvngCoBorrowerLastName)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvng203KContractorName; lvng203KContractorName)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvng203KInspectorName; lvng203KInspectorName)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngLoanAmount; lvngLoanAmount)
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; lvngApplicationDate)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateLocked; lvngDateLocked)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateClosed; lvngDateClosed)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngDateSold; lvngDateSold)
                {
                    ApplicationArea = All;
                }

                field(lvngLoanTerm; lvngLoanTermMonths)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngInterestRate; lvngInterestRate)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngConstructionInteresTRate; lvngConstrInterestRate)
                {
                    ApplicationArea = All;
                    Visible = False;
                }


                field(lvngMonthlyEscrowAmount; lvngMonthlyEscrowAmount)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngMonthlyPaymentAmount; lvngMonthlyPaymentAmount)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field(lvngNextPaymentdate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngCommissionDate; lvngCommissionDate)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngCommissionBaseAmount; lvngCommissionBaseAmount)
                {
                    ApplicationArea = All;
                    Visible = False;
                }

                field(lvngWarehouseLineCode; lvngWarehouseLineCode)
                {
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                {
                    ApplicationArea = All;
                }

                field(lvngDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }

                field(lvngProcessingSchemaCode; lvngProcessingSchemaCode)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; lvngReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngCalculatedDocumentAmount; lvngCalculatedDocumentAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
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
                SubPageLink = lvngLoanJournalBatchCode = field (lvngLoanJournalBatchCode), lvngLineNo = field (lvngLineNo);
            }
            part(lvngValues; lvngLoanImportValuePart)
            {
                Caption = 'Values';
                ApplicationArea = All;
                SubPageLink = lvngLoanJournalBatchCode = field (lvngLoanJournalBatchCode), lvngLineNo = field (lvngLineNo);
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
                    lvngLoanImportSchema.SetRange(lvngLoanJournalBatchType, lvngLoanImportSchema.lvngLoanJournalBatchType::lvngSold);
                    if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOk then begin
                        Clear(lvngLoanJournalImport);
                        lvngLoanJournalImport.ReadCSVStream(lvngLoanJournalBatchCode, lvngLoanImportSchema);
                        Commit();
                        lvngValidateSoldJournal.ValidateSoldLines(lvngLoanJournalBatchCode);
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
                    lvngValidateSoldJournal.ValidateSoldLines(lvngLoanJournalBatchCode);
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
                    lvngCreateSoldDocuments.CreateDocuments(lvngLoanJournalBatchCode);
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
                    lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
                begin
                    lvngLoanCardManagement.UpdateLoanCards(lvngLoanJournalBatchCode);
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
                RunPageLink = lvngLoanJournalBatchCode = field (lvngLoanJournalBatchCode), lvngLineNo = field (lvngLineNo);
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
                    SetRange(lvngErrorExists, true);
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
                    SetRange(lvngErrorExists);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(lvngErrorExists);
    end;
}