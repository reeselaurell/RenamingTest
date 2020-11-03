page 14135107 "lvnLoanJournalBatches"
{
    PageType = List;
    Caption = 'Loan Journals';
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnLoanJournalBatch;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field("Loan Journal Type"; Rec."Loan Journal Type") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Dimension Import Rule"; Rec."Dimension Import Rule") { ApplicationArea = All; }
                field("Map Dimensions Using Hierachy"; Rec."Map Dimensions Using Hierachy") { ApplicationArea = All; }
                field("Dimension Hierarchy Date"; Rec."Dimension Hierarchy Date") { ApplicationArea = All; }
                field("Default Title Customer No."; Rec."Default Title Customer No.") { ApplicationArea = All; }
                field("Default Investor Customer No."; Rec."Default Investor Customer No.") { ApplicationArea = All; }
                field("Default Reason Code"; Rec."Default Reason Code") { ApplicationArea = All; }
                field("Def. Processing Schema Code"; Rec."Def. Processing Schema Code") { ApplicationArea = All; }
                field("Loan Card Update Option"; Rec."Loan Card Update Option") { ApplicationArea = All; }
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
                    LoanJournalLine: Record lvnLoanJournalLine;
                    FundedJournalLinesPage: Page lvnFundedJournalLines;
                    SoldJournalLinesPage: Page lvnSoldJournalLines;
                    LoanJournalLinesPage: Page lvnLoanJournalLines;
                begin
                    case Rec."Loan Journal Type" of
                        Rec."Loan Journal Type"::Funded:
                            begin
                                Clear(FundedJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Rec.Code);
                                FundedJournalLinesPage.SetTableView(LoanJournalLine);
                                FundedJournalLinesPage.Run();
                            end;
                        Rec."Loan Journal Type"::Sold:
                            begin
                                Clear(SoldJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Rec.Code);
                                SoldJournalLinesPage.SetTableView(LoanJournalLine);
                                SoldJournalLinesPage.Run();
                            end;
                        Rec."Loan Journal Type"::Loan:
                            begin
                                Clear(LoanJournalLinesPage);
                                LoanJournalLine.Reset();
                                LoanJournalLine.SetRange("Loan Journal Batch Code", Rec.Code);
                                LoanJournalLinesPage.SetTableView(LoanJournalLine);
                                LoanJournalLinesPage.Run();
                            end;
                    end;
                end;
            }

            action(PostProcessingLines)
            {
                Caption = 'Post Processing Lines';
                RunObject = page lvnPostProcessingSchemaLines;
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
                RunObject = page lvnJournalValidationRules;
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
                RunObject = page lvnLoanUpdateSchema;
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