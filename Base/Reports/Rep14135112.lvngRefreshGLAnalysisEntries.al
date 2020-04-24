report 14135112 lvngRefreshGLAnalysisEntries
{
    Caption = 'Refresh G/L Analysis Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(CompleteRefresh; CompleteRefresh) { Caption = 'Complete Refresh'; ApplicationArea = All; ToolTip = 'Complete Refresh. Might take long time to refresh'; }
            }
        }
    }

    var
        GroupedGLEntry: Record lvngGroupedGLEntry;
        GroupedLoanGLEntry: Record lvngGroupedLoanGLEntry;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLEntry: Record "G/L Entry";
        GLEntryGroupedEntriesQuery: Query lvngGLEntryGroupedEntries;
        CompleteRefresh: Boolean;
        Counter: Integer;
        LastEntryNo: Integer;
        ProgressDialog: Dialog;
        ProcessingGLEntriesLbl: Label 'Processing entry #1#############';

    trigger OnPreReport()
    var
        ConfirmContinueMsg: Label 'This procedure will erase previously generated G/L Analysis entries. Do you want to continue?';
    begin
        LoanVisionSetup.Get();
        if CompleteRefresh and GuiAllowed() then
            if Confirm(ConfirmContinueMsg, false) then begin
                GroupedGLEntry.Reset();
                GroupedGLEntry.DeleteAll();
                GroupedLoanGLEntry.Reset();
                GroupedLoanGLEntry.DeleteAll();
                LoanVisionSetup."Last Analysis Entry No." := 0;
            end;
        GLEntry.Reset();
        GLEntry.FindLast();
        LastEntryNo := GLEntry."Entry No.";
        if LastEntryNo > LoanVisionSetup."Last Analysis Entry No." then begin
            GLEntryGroupedEntriesQuery.Open();
            GLEntryGroupedEntriesQuery.SetRange(EntryNo, LoanVisionSetup."Last Analysis Entry No." + 1, LastEntryNo);
            if GuiAllowed() then
                ProgressDialog.Open(ProcessingGLEntriesLbl);
            while GLEntryGroupedEntriesQuery.Read() do begin
                Counter := Counter + 1;
                if GuiAllowed() then
                    ProgressDialog.Update(1, Counter);
                if GroupedGLEntry.Get(
                        GLEntryGroupedEntriesQuery.Posting_Date,
                        GLEntryGroupedEntriesQuery.GLAccountNo,
                        GLEntryGroupedEntriesQuery.GlobalDimension1Code,
                        GLEntryGroupedEntriesQuery.GlobalDimension2Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension3Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension4Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension5Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension6Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension7Code,
                        GLEntryGroupedEntriesQuery.ShortcutDimension8Code,
                        GLEntryGroupedEntriesQuery.BusinessUnitCode) then begin
                    GroupedGLEntry.Amount := GroupedGLEntry.Amount + GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry."Debit Amount" := GroupedGLEntry."Debit Amount" + GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry."Credit Amount" := GroupedGLEntry."Credit Amount" + GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry.Modify();
                end else begin
                    Clear(GroupedGLEntry);
                    GroupedGLEntry."Posting Date" := GLEntryGroupedEntriesQuery.Posting_Date;
                    GroupedGLEntry."Global Dimension 1 Code" := GLEntryGroupedEntriesQuery.GlobalDimension1Code;
                    GroupedGLEntry."Global Dimension 2 Code" := GLEntryGroupedEntriesQuery.GlobalDimension2Code;
                    GroupedGLEntry."Shortcut Dimension 3 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension3Code;
                    GroupedGLEntry."Shortcut Dimension 4 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension4Code;
                    GroupedGLEntry."Shortcut Dimension 5 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension5Code;
                    GroupedGLEntry."Shortcut Dimension 6 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension6Code;
                    GroupedGLEntry."Shortcut Dimension 7 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension7Code;
                    GroupedGLEntry."Shortcut Dimension 8 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension8Code;
                    GroupedGLEntry."Business Unit Code" := GLEntryGroupedEntriesQuery.BusinessUnitCode;
                    GroupedGLEntry."G/L Account No." := GLEntryGroupedEntriesQuery.GLAccountNo;
                    GroupedGLEntry.Amount := GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry."Debit Amount" := GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry."Credit Amount" := GLEntryGroupedEntriesQuery.Amount;
                    GroupedGLEntry.Insert();
                end;
                if GLEntryGroupedEntriesQuery.lvngLoanNo <> '' then begin
                    if GroupedLoanGLEntry.Get(
                            GLEntryGroupedEntriesQuery.Posting_Date,
                            GLEntryGroupedEntriesQuery.GLAccountNo,
                            GLEntryGroupedEntriesQuery.GlobalDimension1Code,
                            GLEntryGroupedEntriesQuery.GlobalDimension2Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension3Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension4Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension5Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension6Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension7Code,
                            GLEntryGroupedEntriesQuery.ShortcutDimension8Code,
                            GLEntryGroupedEntriesQuery.BusinessUnitCode,
                            GLEntryGroupedEntriesQuery.lvngLoanNo) then begin
                        GroupedLoanGLEntry.Amount := GroupedLoanGLEntry.Amount + GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry."Debit Amount" := GroupedLoanGLEntry."Debit Amount" + GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry."Credit Amount" := GroupedLoanGLEntry."Credit Amount" + GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry.Modify();
                    end else begin
                        Clear(GroupedLoanGLEntry);
                        GroupedLoanGLEntry."Posting Date" := GLEntryGroupedEntriesQuery.Posting_Date;
                        GroupedLoanGLEntry."Global Dimension 1 Code" := GLEntryGroupedEntriesQuery.GlobalDimension1Code;
                        GroupedLoanGLEntry."Global Dimension 2 Code" := GLEntryGroupedEntriesQuery.GlobalDimension2Code;
                        GroupedLoanGLEntry."Shortcut Dimension 3 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension3Code;
                        GroupedLoanGLEntry."Shortcut Dimension 4 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension4Code;
                        GroupedLoanGLEntry."Shortcut Dimension 5 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension5Code;
                        GroupedLoanGLEntry."Shortcut Dimension 6 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension6Code;
                        GroupedLoanGLEntry."Shortcut Dimension 7 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension7Code;
                        GroupedLoanGLEntry."Shortcut Dimension 8 Code" := GLEntryGroupedEntriesQuery.ShortcutDimension8Code;
                        GroupedLoanGLEntry."Business Unit Code" := GLEntryGroupedEntriesQuery.BusinessUnitCode;
                        GroupedLoanGLEntry."G/L Account No." := GLEntryGroupedEntriesQuery.GLAccountNo;
                        GroupedLoanGLEntry."Loan No." := GLEntryGroupedEntriesQuery.lvngLoanNo;
                        GroupedLoanGLEntry.Amount := GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry."Debit Amount" := GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry."Credit Amount" := GLEntryGroupedEntriesQuery.Amount;
                        GroupedLoanGLEntry.Insert();
                    end;
                end;
            end;
            GLEntryGroupedEntriesQuery.Close();
            if GuiAllowed() then
                ProgressDialog.Close();
            LoanVisionSetup."Last Analysis Entry No." := LastEntryNo;
            LoanVisionSetup.Modify();
        end;
    end;

}