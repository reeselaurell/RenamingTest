page 14135139 "lvngLoanJournalLines"
{
    PageType = List;
    Caption = 'Loan Update Journal';
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

                field(lvngTitleCustomerNo; lvngTitleCustomerNo)
                {
                    ApplicationArea = All;
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
                field(lvngLateFee; lvngLateFee)
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
                field(lvngCommissionBps; lvngCommissionBps)
                {
                    ApplicationArea = All;
                }
                field(lvngCommissionAmount; lvngCommissionAmount)
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
                    Visible = DimensionVisible1;
                }
                field(lvngDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field(lvngDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field(lvngDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field(lvngDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field(lvngDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field(lvngDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field(lvngDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
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
                field(lvngDateSold; lvngDateSold)
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
                    lvngValidateLoanJournal: Codeunit lvngValidateLoanJournal;
                    lvngLoanImportSchema: Record lvngLoanImportSchema;
                begin
                    lvngLoanImportSchema.reset;
                    lvngLoanImportSchema.SetRange(lvngLoanJournalBatchType, lvngLoanImportSchema.lvngLoanJournalBatchType::lvngLoan);
                    if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOk then begin
                        Clear(lvngLoanJournalImport);
                        lvngLoanJournalImport.ReadCSVStream(lvngLoanJournalBatchCode, lvngLoanImportSchema);
                        Commit();
                        lvngValidateLoanJournal.ValidateLoanLines(lvngLoanJournalBatchCode);
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
                    lvngValidateLoanJournal: Codeunit lvngValidateLoanJournal;
                begin
                    lvngValidateLoanJournal.ValidateLoanLines(lvngLoanJournalBatchCode);
                    CurrPage.Update(false);
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