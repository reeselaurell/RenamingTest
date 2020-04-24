codeunit 14135114 lvngValidateLoanJournal
{
    var
        LoanNoEmptyErr: Label 'Loan No. can not be blank';
        LoanNoDoesNotMatchPatternErr: Label 'Loan No. does not match any of defined patterns';
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        LoanMgmt: Codeunit lvngLoanManagement;

    procedure ValidateLoanLines(JournalBatchCode: Code[20])
    var
        LoanJournalLine: Record lvngLoanJournalLine;
    begin
        LoanVisionSetup.Get();
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code", JournalBatchCode);
        LoanJournalLine.FindSet();
        repeat
            LoanJournalErrorMgmt.ClearJournalLineErrors(LoanJournalLine);
            ValidateSingleJournalLine(LoanJournalLine);
        until LoanJournalLine.Next() = 0;
    end;

    local procedure ValidateSingleJournalLine(var LoanJournalLine: record lvngLoanJournalLine)
    var
        JournalValidationRule: Record lvngJournalValidationRule;
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        FieldSequenceNo: Integer;
    begin
        if LoanJournalLine."Loan No." = '' then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, LoanNoEmptyErr);
        if not LoanMgmt.IsValidLoanNo(LoanJournalLine."Loan No.") then
            LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, LoanNoDoesNotMatchPatternErr);
        if LoanJournalLine."Search Name" = '' then begin
            LoanJournalLine."Search Name" := StrSubstNo(LoanVisionSetup."Search Name Template", LoanJournalLine."Borrower First Name", LoanJournalLine."Borrower Last Name", LoanJournalLine."Borrower Middle Name");
            LoanJournalLine.Modify();
        end;
        JournalValidationRule.Reset();
        JournalValidationRule.SetRange("Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        if JournalValidationRule.FindSet() then begin
            ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine, FieldSequenceNo);
            repeat
                if not ValidateConditionLine(ExpressionValueBuffer, JournalValidationRule."Condition Code") then
                    LoanJournalErrorMgmt.AddJournalLineError(LoanJournalLine, JournalValidationRule."Error Message");
            until JournalValidationRule.Next() = 0;
        end;
    end;

    local procedure ValidateConditionLine(var ExpressionValueBuffer: Record lvngExpressionValueBuffer; ConditionCode: Code[20]): Boolean
    var
        ExpressionEngine: Codeunit lvngExpressionEngine;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        ExpressionHeader.Get(ConditionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer));
    end;
}