page 14135107 lvngLoanJournalBatches
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
                field(Code; Code) { ApplicationArea = All; }
                field("Loan Journal Type"; "Loan Journal Type") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Dimension Import Rule"; "Dimension Import Rule") { ApplicationArea = All; }
                field("Map Dimensions Using Hierachy"; "Map Dimensions Using Hierachy") { ApplicationArea = All; }
                field("Dimension Hierarchy Date"; "Dimension Hierarchy Date") { ApplicationArea = All; }
                field("Default Title Customer No."; "Default Title Customer No.") { ApplicationArea = All; }
                field("Default Investor Customer No."; "Default Investor Customer No.") { ApplicationArea = All; }
                field("Default Reason Code"; "Default Reason Code") { ApplicationArea = All; }
                field("Def. Processing Schema Code"; "Def. Processing Schema Code") { ApplicationArea = All; }
                field("Loan Card Update Option"; "Loan Card Update Option") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditJournal)
            {
                Caption = 'Edit Journal';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = Journal;

                trigger OnAction();
                var
                    LoanJournalLine: Record lvngLoanJournalLine;
                    FundedJournalLinesPage: Page lvngFundedJournalLines;
                    SoldJournalLinesPage: Page lvngSoldJournalLines;
                    LoanJournalLinesPage: Page lvngLoanJournalLines;
                begin
                    case "Loan Journal Type" of
                        "Loan Journal Type"::Funded:
                            begin
                                Clear(FundedJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                FundedJournalLinesPage.SetTableView(LoanJournalLine);
                                FundedJournalLinesPage.Run();
                            end;
                        "Loan Journal Type"::Sold:
                            begin
                                Clear(SoldJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                SoldJournalLinesPage.SetTableView(LoanJournalLine);
                                SoldJournalLinesPage.Run();
                            end;
                        "Loan Journal Type"::Loan:
                            begin
                                Clear(LoanJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Code);
                                LoanJournalLinesPage.SetTableView(LoanJournalLine);
                                LoanJournalLinesPage.Run();
                            end;
                    end;
                end;
            }

            action(PostProcessingLines)
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

            action(ValidationRules)
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

            action(LoanCardUpdateSchema)
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