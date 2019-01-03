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
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }

                field(lvngTitleCustomerNo; lvngTitleCustomerNo)
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
                }
                field(lvngCoBorrowerMiddleName; lvngCoBorrowerMiddleName)
                {
                    ApplicationArea = All;
                }
                field(lvngCoBorrowerLastName; lvngCoBorrowerLastName)
                {
                    ApplicationArea = All;
                }
                field(lvng203KContractorName; lvng203KContractorName)
                {
                    ApplicationArea = All;
                }
                field(lvng203KInspectorName; lvng203KInspectorName)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanAmount; lvngLoanAmount)
                {
                    ApplicationArea = All;
                }


                field(lvngApplicationDate; lvngApplicationDate)
                {
                    ApplicationArea = All;
                }

                field(lvngDateLocked; lvngDateLocked)
                {
                    ApplicationArea = All;
                }

                field(lvngDateClosed; lvngDateClosed)
                {
                    ApplicationArea = All;
                }

                field(lvngDateFunded; lvngDateFunded)
                {
                    ApplicationArea = All;
                }

                field(lvngLoanTerm; lvngLoanTermMonths)
                {
                    ApplicationArea = All;
                }

                field(lvngInterestRate; lvngInterestRate)
                {
                    ApplicationArea = All;
                }

                field(lvngConstructionInteresTRate; lvngConstrInterestRate)
                {
                    ApplicationArea = All;
                }


                field(lvngMonthlyEscrowAmount; lvngMonthlyEscrowAmount)
                {
                    ApplicationArea = All;
                }

                field(lvngMonthlyPaymentAmount; lvngMonthlyPaymentAmount)
                {
                    ApplicationArea = All;
                }

                field(lvngFirstPaymentDue; lvngFirstPaymentDue)
                {
                    ApplicationArea = All;
                }
                field(lvngNextPaymentdate; lvngNextPaymentDate)
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionDate; lvngCommissionDate)
                {
                    ApplicationArea = All;
                }

                field(lvngCommissionBaseAmount; lvngCommissionBaseAmount)
                {
                    ApplicationArea = All;
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
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngFirstPaymentDueToInvestor; lvngFirstPaymentDueToInvestor)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(lvngDateSold; lvngDateSold)
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
                    lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
                    lvngLoanImportSchema: Record lvngLoanImportSchema;
                begin
                    lvngLoanImportSchema.reset;
                    lvngLoanImportSchema.SetRange(lvngLoanJournalBatchType, lvngLoanImportSchema.lvngLoanJournalBatchType::lvngFunded);
                    if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOk then begin
                        Clear(lvngLoanJournalImport);
                        lvngLoanJournalImport.ReadCSVStream(lvngLoanJournalBatchCode, lvngLoanImportSchema);
                        Commit();
                        lvngValidateFundedJournal.ValidateFundedLines(lvngLoanJournalBatchCode);
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
                    lvngValidateFundedJournal.ValidateFundedLines(lvngLoanJournalBatchCode);
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
        }
    }
}