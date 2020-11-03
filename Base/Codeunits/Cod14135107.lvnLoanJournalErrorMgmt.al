codeunit 14135107 "lvnLoanJournalErrorMgmt"
{
    var
        LoanImportErrorLine: Record lvnLoanImportErrorLine;

    procedure ClearJournalLineErrors(LoanJournalLine: Record lvnLoanJournalLine)
    begin
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        LoanImportErrorLine.DeleteAll();
    end;

    procedure AddJournalLineError(LoanJournalLine: Record lvnLoanJournalLine; ErrorText: Text)
    var
        ErrorLineNo: Integer;
    begin
        ErrorLineNo := 100;
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        LoanImportErrorLine.SetLoadFields("Error Line No.");
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

    procedure HasError(LoanJournalLine: Record lvnLoanJournalLine): Boolean
    begin
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", LoanJournalLine."Line No.");
        exit(not LoanImportErrorLine.IsEmpty());
    end;
}