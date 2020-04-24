codeunit 14135107 lvngLoanJournalErrorMgmt
{
    var
        LoanImportErrorLine: Record lvngLoanImportErrorLine;

    procedure ClearJournalLineErrors(LoanJournalLine: Record lvngLoanJournalLine)
    begin
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        LoanImportErrorLine.DeleteAll();
    end;

    procedure AddJournalLineError(LoanJournalLine: Record lvngLoanJournalLine; ErrorText: Text)
    var
        ErrorLineNo: Integer;
    begin
        ErrorLineNo := 100;
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        if LoanImportErrorLine.FindLast() then
            ErrorLineNo := LoanImportErrorLine."Error Line No." + 100;
        Clear(LoanImportErrorLine);
        LoanImportErrorLine.Init();
        LoanImportErrorLine."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
        LoanImportErrorLine."Line No." := LoanJournalLine."Line No.";
        LoanImportErrorLine."Error Line No." := ErrorLineNo;
        LoanImportErrorLine.Description := CopyStr(ErrorText, 1, MaxStrLen(LoanImportErrorLine.Description));
        LoanImportErrorLine.Insert();
    end;

    procedure HasError(LoanJournalLine: Record lvngLoanJournalLine): Boolean
    begin
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        exit(not LoanImportErrorLine.IsEmpty());
    end;
}