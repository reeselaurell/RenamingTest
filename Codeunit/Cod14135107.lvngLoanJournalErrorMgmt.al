codeunit 14135107 lvngLoanJournalErrorMgmt
{
    procedure ClearJournalLineErrors(lvngLoanJournalLine: Record lvngLoanJournalLine)
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange("Loan Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        lvngLoanImportErrorLine.SetRange("Line No.", lvngLoanJournalLine."Line No.");
        lvngLoanImportErrorLine.DeleteAll();
    end;

    procedure AddJournalLineError(lvngLoanJournalLine: Record lvngLoanJournalLine; lvngErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngErrorLineNo := 100;
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange("Loan Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        lvngLoanImportErrorLine.SetRange("Line No.", lvngLoanJournalLine."Line No.");
        if lvngLoanImportErrorLine.FindLast() then
            lvngErrorLineNo := lvngLoanImportErrorLine."Error Line No." + 100;
        Clear(lvngLoanImportErrorLine);
        lvngLoanImportErrorLine.Init();
        lvngLoanImportErrorLine."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
        lvngLoanImportErrorLine."Line No." := lvngLoanJournalLine."Line No.";
        lvngLoanImportErrorLine."Error Line No." := lvngErrorLineNo;
        lvngLoanImportErrorLine.Description := CopyStr(lvngErrorText, 1, MaxStrLen(lvngLoanImportErrorLine.Description));
        lvngLoanImportErrorLine.Insert;
    end;

    procedure HasError(lvngLoanJournalLine: Record lvngLoanJournalLine): Boolean
    begin
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange("Loan Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        lvngLoanImportErrorLine.SetRange("Line No.", lvngLoanJournalLine."Line No.");
        if lvngLoanImportErrorLine.IsEmpty() then
            exit(false);
        exit(true);
    end;

    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
}