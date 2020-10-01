page 14135198 lvngLoanFileReconWorksheet
{
    Caption = 'Loan File Reconciliation';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = lvngLoanReconciliationBuffer;
    SourceTableTemporary = true;
    InsertAllowed = false;
    SourceTableView = sorting("Loan No.", "G/L Account No.");

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; Editable = false; }
                field(Reclass; Rec.Reclass) { ApplicationArea = All; }
                field("G/L Account No."; Rec."G/L Account No.") { ApplicationArea = All; Editable = false; }
                field("Date Closed"; Rec."Date Closed") { ApplicationArea = All; Editable = false; }
                field("Application Date"; Rec."Application Date") { ApplicationArea = All; Editable = false; }
                field("Bank Account No."; Rec."Bank Account No.") { ApplicationArea = All; Editable = false; }
                field("Date Funded"; Rec."Date Funded") { ApplicationArea = All; Editable = false; }
                field("Date Sold"; Rec."Date Sold") { ApplicationArea = All; Editable = false; }
                field("Borrower First Name"; Rec."Borrower First Name") { ApplicationArea = All; Editable = false; }
                field("Borrower Middle Name"; Rec."Borrower Middle Name") { ApplicationArea = All; Editable = false; }
                field("Borrower Last Name"; Rec."Borrower Last Name") { ApplicationArea = All; Editable = false; }
                field("Warehouse Line Code"; Rec."Warehouse Line Code") { ApplicationArea = All; Editable = false; }
                field("Loan Amount"; Rec."Loan Amount") { ApplicationArea = All; Editable = false; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; Editable = false; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; Editable = false; }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; Editable = false; }
                field("Business Unit Code"; Rec."Business Unit Code") { ApplicationArea = All; Editable = false; }
                field("Debit Amount"; Rec."Debit Amount") { ApplicationArea = All; Editable = false; }
                field("Credit Amount"; Rec."Credit Amount") { ApplicationArea = All; Editable = false; }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.Reset();
                        GLEntry.CopyFilters(TempGLFilter);
                        GLEntry.SetRange(lvngLoanNo, Rec."Loan No.");
                        GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
                        if Rec."G/L Account No." <> '' then
                            GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
                        Page.Run(0, GLEntry);
                    end;
                }
                field("File Amount"; Rec."File Amount") { ApplicationArea = All; Editable = false; }
                field(Difference; Rec.Difference) { ApplicationArea = All; Editable = false; }
                field(Unbalanced; Rec.Unbalanced) { ApplicationArea = All; Editable = false; }
            }

            group(Totals)
            {
                field(EntriesCount; EntriesCount) { Caption = 'Entries Count'; ApplicationArea = All; }
                field(LoanCount; LoanCount) { Caption = 'Loans Count'; ApplicationArea = All; }
                field(DebitAmount; Amounts[1]) { Caption = 'Debit Amount'; ApplicationArea = All; }
                field(CreditAmount; Amounts[2]) { Caption = 'Credit Amount'; ApplicationArea = All; }
                field(AmountTtl; Amounts[3]) { Caption = 'Amount'; ApplicationArea = All; }
                field(FileAmount; Amounts[4]) { Caption = 'File Amount'; ApplicationArea = All; }
                field(DifferenceTtl; Amounts[5]) { Caption = 'Difference'; ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportLoanFile)
            {
                Caption = 'Import from File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LoanFileImport: XmlPort lvngLoanReconImport;
                begin
                    TempLoanReconBuffer.Reset();
                    TempLoanReconBuffer.DeleteAll();
                    Rec.Reset();
                    Rec.DeleteAll();
                    Clear(LoanFileImport);
                    LoanFileImport.Run();
                    LoanFileImport.GetData(Rec);
                    LoanFileImport.GetData(TempLoanReconBuffer);
                    LoanFileImport.GetFilters(TempGLFilter);
                    Rec.Reset();
                    CalculateTotals();
                end;
            }
            action(ReclassEntries)
            {
                Caption = 'Reclass Entries';
                ApplicationArea = All;
                Image = Reconcile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReclassLoanGLEntries: Report lvngReclassLoanGLEntries;
                begin
                    Clear(ReclassLoanGLEntries);
                    ReclassLoanGLEntries.SetEntries(Rec);
                    ReclassLoanGLEntries.Run();
                end;
            }
            action(MarkAllToReclass)
            {
                Caption = 'Mark All to Reclass';
                ApplicationArea = All;
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.ModifyAll(Reclass, true);
                    CurrPage.Update(false);
                end;
            }
            action(ClearMarks)
            {
                Caption = 'Clear Marks';
                ApplicationArea = All;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.ModifyAll(Reclass, false);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        TempLoanReconBuffer: Record lvngLoanReconciliationBuffer temporary;
        TempGLFilter: Record "G/L Entry" temporary;
        Amounts: array[5] of Decimal;
        EntriesCount: Integer;
        LoanCount: Integer;

    trigger OnDeleteRecord(): Boolean
    begin
        TempLoanReconBuffer.Get(Rec."Loan No.", Rec."G/L Account No.");
        TempLoanReconBuffer.Delete();
        CalculateTotals();
        CurrPage.Update(false);
    end;

    local procedure CalculateTotals()
    var
        TempLoan: Record lvngLoan temporary;
    begin
        Clear(Amounts);
        EntriesCount := 0;
        LoanCount := 0;
        TempLoanReconBuffer.Reset();
        if TempLoanReconBuffer.FindSet() then
            repeat
                EntriesCount := EntriesCount + 1;
                Amounts[1] := Amounts[1] + TempLoanReconBuffer."Debit Amount";
                Amounts[2] := Amounts[2] + TempLoanReconBuffer."Credit Amount";
                Amounts[4] := Amounts[4] + TempLoanReconBuffer."File Amount";
                Amounts[3] := Amounts[3] + TempLoanReconBuffer.Amount;
                Amounts[5] := Amounts[5] + TempLoanReconBuffer.Difference;
                Clear(TempLoan);
                TempLoan."No." := TempLoanReconBuffer."Loan No.";
                if TempLoan.Insert() then;
            until TempLoanReconBuffer.Next() = 0;
        LoanCount := TempLoan.Count();
    end;
}