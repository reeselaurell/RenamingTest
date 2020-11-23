page 14135165 "lvnDimensionChangeList"
{
    Caption = 'Dimension Change List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnDimensionChangeSet;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Change Set ID"; Rec."Change Set ID")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
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
                ShortcutKey = Return;

                trigger OnAction()
                var
                    DimensionChangeLedgerEntry: Record lvnDimensionChangeLedgerEntry;
                    DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
                    DimensionChangeLedger: Page lvnDimensionChangeLedger;
                    DimensionChangeJournal: Page lvnDimensionChangeJournal;
                begin
                    if Rec.Comment = '' then
                        Error(CommentBlankErr);
                    DimensionChangeLedgerEntry.Reset();
                    DimensionChangeLedgerEntry.FilterGroup(2);
                    DimensionChangeLedgerEntry.SetRange("Change Set ID", Rec."Change Set ID");
                    DimensionChangeLedgerEntry.FilterGroup(0);
                    if not DimensionChangeLedgerEntry.IsEmpty() then begin
                        DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                        DimensionChangeLedger.Run();
                    end else begin
                        DimensionChangeJnlEntry.Reset();
                        DimensionChangeJnlEntry.FilterGroup(2);
                        DimensionChangeJnlEntry.SetRange("Change Set ID", Rec."Change Set ID");
                        DimensionChangeJnlEntry.FilterGroup(0);
                        DimensionChangeJournal.SetTableView(DimensionChangeJnlEntry);
                        DimensionChangeJournal.Run();
                    end;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Image = PostBatch;
                Enabled = HasJournalEntries;

                trigger OnAction()
                var
                    DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
                    DimensionChangeLedgerEntry: Record lvnDimensionChangeLedgerEntry;
                    PostDimensionChangeSet: Report lvnPostDimensionChangeSet;
                    DimensionChangeLedger: Page lvnDimensionChangeLedger;
                begin
                    DimensionChangeJnlEntry.SetRange("Change Set ID", Rec."Change Set ID");
                    PostDimensionChangeSet.SetTableView(DimensionChangeJnlEntry);
                    PostDimensionChangeSet.RunModal();
                    DimensionChangeLedgerEntry.FilterGroup(2);
                    DimensionChangeLedgerEntry.SetRange("Change Set ID", Rec."Change Set ID");
                    DimensionChangeLedgerEntry.FilterGroup(0);
                    DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                    DimensionChangeLedger.Run();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HasJournalEntries := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
    begin
        DimensionChangeJnlEntry.SetRange("Change Set ID", Rec."Change Set ID");
        HasJournalEntries := not DimensionChangeJnlEntry.IsEmpty();
    end;

    var
        [InDataSet]
        HasJournalEntries: Boolean;
        CommentBlankErr: Label 'Comment cannot be blank!';
}