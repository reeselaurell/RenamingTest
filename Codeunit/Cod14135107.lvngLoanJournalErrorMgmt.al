codeunit 14135107 lvngLoanJournalErrorMgmt
{
    procedure ClearJournalLineErrors(lvngLoanJournalLine: Record lvngLoanJournalLine)
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        lvngLoanImportErrorLine.DeleteAll();
    end;

    procedure AddJournalLineError(lvngLoanJournalLine: Record lvngLoanJournalLine; lvngErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngErrorLineNo := 100;
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        if lvngLoanImportErrorLine.FindLast() then
            lvngErrorLineNo := lvngLoanImportErrorLine.lvngErrorLineNo + 100;
        Clear(lvngLoanImportErrorLine);
        lvngLoanImportErrorLine.Init();
        lvngLoanImportErrorLine.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
        lvngLoanImportErrorLine.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
        lvngLoanImportErrorLine.lvngErrorLineNo := lvngErrorLineNo;
        lvngLoanImportErrorLine.lvngDescription := CopyStr(lvngErrorText, 1, MaxStrLen(lvngLoanImportErrorLine.lvngDescription));
        lvngLoanImportErrorLine.Insert;
    end;

    procedure HasError(lvngLoanJournalLine: Record lvngLoanJournalLine): Boolean
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        if lvngLoanImportErrorLine.IsEmpty() then
            exit(false);
        exit(true);
    end;

    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
}