page 14135167 lvngDimensionChangeJournal
{
    Caption = 'Dimension Change Journal';
    PageType = List;
    SourceTable = lvngDimensionChangeJnlEntry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Old Dimension 1 Code"; "Old Dimension 1 Code") { ApplicationArea = All; }
                field("New Dimension 1 Code"; "New Dimension 1 Code") { ApplicationArea = All; }
                field("Old Dimension 2 Code"; "Old Dimension 2 Code") { ApplicationArea = All; }
                field("New Dimension 2 Code"; "New Dimension 2 Code") { ApplicationArea = All; }
                field("Old Dimension 3 Code"; "Old Dimension 3 Code") { ApplicationArea = All; }
                field("New Dimension 3 Code"; "New Dimension 3 Code") { ApplicationArea = All; }
                field("Old Dimension 4 Code"; "Old Dimension 4 Code") { ApplicationArea = All; }
                field("New Dimension 4 Code"; "New Dimension 4 Code") { ApplicationArea = All; }
                field("Old Dimension 5 Code"; "Old Dimension 5 Code") { ApplicationArea = All; }
                field("New Dimension 5 Code"; "New Dimension 5 Code") { ApplicationArea = All; }
                field("Old Dimension 6 Code"; "Old Dimension 6 Code") { ApplicationArea = All; }
                field("New Dimension 6 Code"; "New Dimension 6 Code") { ApplicationArea = All; }
                field("Old Dimension 7 Code"; "Old Dimension 7 Code") { ApplicationArea = All; }
                field("New Dimension 7 Code"; "New Dimension 7 Code") { ApplicationArea = All; }
                field("Old Dimension 8 Code"; "Old Dimension 8 Code") { ApplicationArea = All; }
                field("New Dimension 8 Code"; "New Dimension 8 Code") { ApplicationArea = All; }
                field("Old Business Unit Code"; "Old Business Unit Code") { ApplicationArea = All; }
                field("New Business Unit Code"; "New Business Unit Code") { ApplicationArea = All; }
                field("Old Loan No."; "Old Loan No.") { ApplicationArea = All; }
                field("New Loan No."; "New Loan No.") { ApplicationArea = All; }
                field(Change; Change) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportFromFile)
            {
                Caption = 'Import From File';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DimensionChangeSetImport: XmlPort lvngDimensionChangeSetImport;
                begin
                    DimensionChangeSetImport.SetParams("Change Set ID");
                    DimensionChangeSetImport.Run();
                    CurrPage.Update(false);
                end;
            }

            action(ImportFromLoanListFile)
            {
                Caption = 'Import From Loan List File';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DimensionLoanChangeSetImport: XmlPort lvngDimensionLoanChangeImport;
                begin
                    DimensionLoanChangeSetImport.SetParams("Change Set ID");
                    DimensionLoanChangeSetImport.Run();
                    CurrPage.Update(false);
                end;
            }

            action(ImportFromGL)
            {
                Caption = 'Import From G/L';
                ApplicationArea = All;
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DimensionChangeSetImport: Report lvngDimensionChangeSetImport;
                begin
                    DimensionChangeSetImport.SetParams("Change Set ID");
                    DimensionChangeSetImport.Run();
                    CurrPage.Update(false);
                end;
            }

            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DimensionChangeLedgerEntry: Record lvngDimensionChangeLedgerEntry;
                    DimensionChangeLedger: Page lvngDimensionChangeLedger;
                    DimensionChangeJnlEntry: Record lvngDimensionChangeJnlEntry;
                    PostDimensionChangeSet: Report lvngPostDimensionChangeSet;
                begin
                    if Count > 0 then begin
                        DimensionChangeJnlEntry.SetRange("Change Set ID", "Change Set ID");
                        PostDimensionChangeSet.SetTableview(DimensionChangeJnlEntry);
                        PostDimensionChangeSet.RunModal();
                        DimensionChangeLedgerEntry.FilterGroup(2);
                        DimensionChangeLedgerEntry.SetRange("Change Set ID", "Change Set ID");
                        DimensionChangeLedgerEntry.FilterGroup(0);
                        DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                        DimensionChangeLedger.Run();
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }
}