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
                field(lvngCode; Code)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanJournalType; "Loan Journal Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionImportRule; "Dimension Import Rule")
                {
                    ApplicationArea = All;
                }
                field(lvngMapDimensionsUsingHierachy; "Map Dimensions Using Hierachy")
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionHierarchyDate; "Dimension Hierarchy Date")
                {
                    ApplicationArea = All;
                }

                field(lvngDefaultTitleCustomerNo; "Default Title Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultInvestorCustomerNo; "Default Investor Customer No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDefaultReasonCode; "Default Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngDefProcessingSchemaCode; "Def. Processing Schema Code")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanCardUpdateOption; "Loan Card Update Option")
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
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Journal;

                trigger OnAction();
                var
                    lvngFundedJournalLinesPage: Page lvngFundedJournalLines;
                    lvngSoldJournalLinesPage: Page lvngSoldJournalLines;
                    lvngLoanJournalLinesPage: Page lvngLoanJournalLines;
                    lvngLoanJournalLine: Record lvngLoanJournalLine;
                begin
                    case "Loan Journal Type" of
                        "Loan Journal Type"::lvngFunded:
                            begin
                                Clear(lvngFundedJournalLinesPage);
                                lvngLoanJournalLine.Reset();
                                lvngLoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                lvngFundedJournalLinesPage.SetTableView(lvngLoanJournalLine);
                                lvngFundedJournalLinesPage.Run();
                            end;
                        "Loan Journal Type"::lvngSold:
                            begin
                                Clear(lvngSoldJournalLinesPage);
                                lvngLoanJournalLine.Reset();
                                lvngLoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                lvngSoldJournalLinesPage.SetTableView(lvngLoanJournalLine);
                                lvngSoldJournalLinesPage.Run();
                            end;
                        "Loan Journal Type"::lvngLoan:
                            begin
                                Clear(lvngLoanJournalLinesPage);
                                lvngLoanJournalLine.Reset();
                                lvngLoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                lvngLoanJournalLinesPage.SetTableView(lvngLoanJournalLine);
                                lvngLoanJournalLinesPage.Run();
                            end;

                    end;
                end;
            }
            action(lvngPostProcessingLines)
            {
                Caption = 'Post Processing Lines';
                RunObject = page lvngPostProcessingSchemaLines;
                RunPageMode = Edit;
                RunPageLink = "Journal Batch Code" = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                Image = EditLines;
                PromotedCategory = Process;
                ApplicationArea = All;
            }

            action(lvngValidationRules)
            {
                Caption = 'Validation Rules';
                RunObject = page lvngJournalValidationRules;
                RunPageMode = Edit;
                RunPageLink = "Journal Batch Code" = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = BreakRulesOn;
                ApplicationArea = All;
            }

            action(lvngLoanCardUpdateSchema)
            {
                Caption = 'Loan Card Update Schema';
                RunObject = page lvngLoanUpdateSchema;
                RunPageMode = Edit;
                RunPageLink = "Journal Batch Code" = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = UpdateDescription;
                ApplicationArea = All;

            }
        }
    }
}