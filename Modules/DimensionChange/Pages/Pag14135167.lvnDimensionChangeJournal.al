page 14135167 "lvnDimensionChangeJournal"
{
    Caption = 'Dimension Change Journal';
    PageType = List;
    SourceTable = lvnDimensionChangeJnlEntry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("G/L Account No."; Rec."G/L Account No.") { ApplicationArea = All; }
                field(GLAccountName; GLAccountName) { ApplicationArea = All; Editable = false; Caption = 'G/L Account Name'; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Old Dimension 1 Code"; Rec."Old Dimension 1 Code") { ApplicationArea = All; }
                field("New Dimension 1 Code"; Rec."New Dimension 1 Code") { ApplicationArea = All; }
                field("Old Dimension 2 Code"; Rec."Old Dimension 2 Code") { ApplicationArea = All; }
                field("New Dimension 2 Code"; Rec."New Dimension 2 Code") { ApplicationArea = All; }
                field("Old Dimension 3 Code"; Rec."Old Dimension 3 Code") { ApplicationArea = All; }
                field("New Dimension 3 Code"; Rec."New Dimension 3 Code") { ApplicationArea = All; }
                field("Old Dimension 4 Code"; Rec."Old Dimension 4 Code") { ApplicationArea = All; }
                field("New Dimension 4 Code"; Rec."New Dimension 4 Code") { ApplicationArea = All; }
                field("Old Dimension 5 Code"; Rec."Old Dimension 5 Code") { ApplicationArea = All; }
                field("New Dimension 5 Code"; Rec."New Dimension 5 Code") { ApplicationArea = All; }
                field("Old Dimension 6 Code"; Rec."Old Dimension 6 Code") { ApplicationArea = All; }
                field("New Dimension 6 Code"; Rec."New Dimension 6 Code") { ApplicationArea = All; }
                field("Old Dimension 7 Code"; Rec."Old Dimension 7 Code") { ApplicationArea = All; }
                field("New Dimension 7 Code"; Rec."New Dimension 7 Code") { ApplicationArea = All; }
                field("Old Dimension 8 Code"; Rec."Old Dimension 8 Code") { ApplicationArea = All; }
                field("New Dimension 8 Code"; Rec."New Dimension 8 Code") { ApplicationArea = All; }
                field("Old Business Unit Code"; Rec."Old Business Unit Code") { ApplicationArea = All; }
                field("New Business Unit Code"; Rec."New Business Unit Code") { ApplicationArea = All; }
                field("Old Loan No."; Rec."Old Loan No.") { ApplicationArea = All; }
                field("New Loan No."; Rec."New Loan No.") { ApplicationArea = All; }
                field(Change; Rec.Change) { ApplicationArea = All; }
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
                    DimensionChangeSetImport: XmlPort lvnDimensionChangeSetImport;
                begin
                    DimensionChangeSetImport.SetParams(Rec."Change Set ID");
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
                    DimensionLoanChangeSetImport: XmlPort lvnDimensionLoanChangeImport;
                begin
                    DimensionLoanChangeSetImport.SetParams(Rec."Change Set ID");
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
                    DimensionChangeSetImport: Report lvnDimensionChangeSetImport;
                begin
                    DimensionChangeSetImport.SetParams(Rec."Change Set ID");
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
                    DimensionChangeLedgerEntry: Record lvnDimensionChangeLedgerEntry;
                    DimensionChangeLedger: Page lvnDimensionChangeLedger;
                    DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
                    PostDimensionChangeSet: Report lvnPostDimensionChangeSet;
                begin
                    if Rec.Count > 0 then begin
                        DimensionChangeJnlEntry.SetRange("Change Set ID", Rec."Change Set ID");
                        PostDimensionChangeSet.SetTableview(DimensionChangeJnlEntry);
                        PostDimensionChangeSet.RunModal();
                        DimensionChangeLedgerEntry.FilterGroup(2);
                        DimensionChangeLedgerEntry.SetRange("Change Set ID", Rec."Change Set ID");
                        DimensionChangeLedgerEntry.FilterGroup(0);
                        DimensionChangeLedger.SetTableView(DimensionChangeLedgerEntry);
                        DimensionChangeLedger.Run();
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(GLAccountName);
        if GLAccount."No." <> Rec."G/L Account No." then begin
            if GLAccount.Get(Rec."G/L Account No.") then
                GLAccountName := GLAccount.Name;
        end;
    end;

    var
        GLAccount: Record "G/L Account";
        GLAccountName: Text;
}