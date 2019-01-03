page 14135107 "lvngLoanJournalBatches"
{
    PageType = List;
    Caption = 'Loan Journals';
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanJournalBatch;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanJournalType; lvngLoanJournalType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionImportRule; lvngDimensionImportRule)
                {
                    ApplicationArea = All;
                }
                field(lvngMapDimensionsUsingHierachy; lvngMapDimensionsUsingHierachy)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionHierarchyDate; lvngDimensionHierarchyDate)
                {
                    ApplicationArea = All;
                }

                field(lvngDefaultTitleCustomerNo; lvngDefaultTitleCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultInvestorCustomerNo; lvngDefaultInvestorCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultReasonCode; lvngDefaultReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDefProcessingSchemaCode; lvngDefProcessingSchemaCode)
                {
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
            action(lvngEditJournal)
            {
                Caption = 'Edit Journal';
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = Journal;

                trigger OnAction();
                var
                    lvngFundedJournalLinesPage: Page lvngFundedJournalLines;
                    lvngLoanJournalLine: Record lvngLoanJournalLine;
                begin
                    case lvngLoanJournalType of
                        lvngLoanJournalType::lvngFunded:
                            begin
                                Clear(lvngFundedJournalLinesPage);
                                lvngLoanJournalLine.Reset();
                                lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngCode);
                                lvngFundedJournalLinesPage.SetTableView(lvngLoanJournalLine);
                                lvngFundedJournalLinesPage.Run();
                            end;
                    end;
                end;
            }
            action(lvngPostProcessingLines)
            {
                Caption = 'Post Processing Lines';
                RunObject = page lvngPostProcessingSchemaLines;
                RunPageMode = Edit;
                RunPageLink = lvngJournalBatchCode = field (lvngCode);
                Promoted = true;
                PromotedIsBig = true;
                Image = EditLines;
                ApplicationArea = All;
            }

            action(lvngValidationRules)
            {
                Caption = 'Validation Rules';
                RunObject = page lvngJournalValidationRules;
                RunPageMode = Edit;
                RunPageLink = lvngJournalBatchCode = field (lvngCode);
                Promoted = true;
                PromotedIsBig = true;
                Image = BreakRulesOn;
                ApplicationArea = All;
            }
        }
    }
}