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
            action(EditJournal)
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
        }
    }
}