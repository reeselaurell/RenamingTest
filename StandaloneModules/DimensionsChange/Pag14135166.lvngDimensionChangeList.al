page 14135166 lvngDimensionChangeList
{
    Caption = 'Dimension Change List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngDimensionChangeSet;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Change Set ID"; "Change Set ID") { ApplicationArea = All; }
                field(Date; Date) { ApplicationArea = All; }
                field("User ID"; "User ID") { ApplicationArea = All; }
                field(Comment; Comment) { ApplicationArea = All; }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowChanges)
            {
                Caption = 'Show Changes';
                ApplicationArea = All;
                Image = ChangeBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortcutKey = Return;

                trigger OnAction()
                var
                    DimensionChangeLedgerEntry: Record lvngDimensionChangeLedgerEntry;
                    DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
                    DimensionChangeLedger: Page lvngDimensionChangeLedger;
                    DimensionChangeJournal: Page lvngDimensionChangeJournal;
                begin
                    if Comment = '' then
                        Error(CommentBlankErr);
                    DimensionChangeLedgerEntry.Reset();
                    DimensionChangeLedgerEntry.FilterGroup(2);
                    DimensionChangeLedgerEntry.SetRange("Change Set ID", "Change Set ID");
                    DimensionChangeLedgerEntry.FilterGroup(0);
                    if not DimensionChangeLedgerEntry.IsEmpty() then begin
                        DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                        DimensionChangeLedger.Run();
                    end else begin
                        DimensionChangeJnlEntry.Reset();
                        DimensionChangeJnlEntry.FilterGroup(2);
                        DimensionChangeJnlEntry.SetRange("Change Set ID", "Change Set ID");
                        DimensionChangeJnlEntry.FilterGroup(0);
                        DimensionChangeJournal.SetTableView(DimensionChangeJnlEntry);
                        DimensionChangeJournal.Run();
                    end;
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = HasJournalEntries;

                trigger OnAction()
                var
                    DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
                    DimensionChangeLedgerEntry: Record lvngDimensionChangeLedgerEntry;
                    DimensionChangeLedger: Page lvngDimensionChangeLedger;
                    PostDimensionChangeSet: Report lvngPostDimensionChangeSet;
                begin
                    DimensionChangeJnlEntry.SetRange("Change Set ID", "Change Set ID");
                    PostDimensionChangeSet.SetTableView(DimensionChangeJnlEntry);
                    PostDimensionChangeSet.RunModal();
                    DimensionChangeLedgerEntry.FilterGroup(2);
                    DimensionChangeLedgerEntry.SetRange("Change Set ID", "Change Set ID");
                    DimensionChangeLedgerEntry.FilterGroup(0);
                    DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                    DimensionChangeLedger.Run();
                end;
            }
        }
    }

    var
        CommentBlankErr: Label 'Comment cannot be blank!';
        [InDataSet]
        HasJournalEntries: Boolean;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HasJournalEntries := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
    begin
        DimensionChangeJnlEntry.SetRange("Change Set ID", "Change Set ID");
        HasJournalEntries := not DimensionChangeJnlEntry.IsEmpty();
    end;
}