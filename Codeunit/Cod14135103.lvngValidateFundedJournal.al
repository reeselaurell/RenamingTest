codeunit 14135103 "lvngValidateFundedJournal"
{
    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;

    procedure ValidateFundedLines(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
    begin
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngJournalBatchCode);
        lvngLoanJournalLine.FindSet();
        repeat
            ClearJournalLineErrors(lvngLoanJournalLine);
            ValidateSingleJournalLine(lvngLoanJournalLine);
        until lvngLoanJournalLine.Next() = 0;

    end;

    local procedure ValidateSingleJournalLine(var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
    begin
        if lvngLoanJournalLine.lvngLoanNo = '' then
            AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);

    end;

    local procedure ClearJournalLineErrors(lvngLoanJournalLine: Record lvngLoanJournalLine)
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        lvngLoanImportErrorLine.DeleteAll();
    end;

    local procedure AddJournalLineError(lvngLoanJournalLine: Record lvngLoanJournalLine; lvngErrorText: Text)
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
        ;
        lvngLoanImportErrorLine.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
        lvngLoanImportErrorLine.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
        lvngLoanImportErrorLine.lvngErrorLineNo := lvngErrorLineNo;
        lvngLoanImportErrorLine.lvngDescription := CopyStr(lvngErrorText, 1, MaxStrLen(lvngLoanImportErrorLine.lvngDescription));
        lvngLoanImportErrorLine.Insert;
    end;

}