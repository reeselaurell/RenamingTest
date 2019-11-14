codeunit 14135114 "lvngValidateLoanJournal"
{
    var
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanVisionSetupRetrieved: Boolean;

    procedure ValidateLoanLines(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
    begin
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngJournalBatchCode);
        lvngLoanJournalLine.FindSet();
        repeat
            lvngLoanJournalErrorMgmt.ClearJournalLineErrors(lvngLoanJournalLine);
            ValidateSingleJournalLine(lvngLoanJournalLine);
        until lvngLoanJournalLine.Next() = 0;

    end;

    local procedure ValidateSingleJournalLine(var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngJournalValidationRule: Record lvngJournalValidationRule;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        LoanNoEmptyLbl: Label 'Loan No. can not be blank';
    begin
        GetLoanVisionSetup();
        if lvngLoanJournalLine."Loan No." = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);
        if lvngLoanJournalLine."Search Name" = '' then begin
            lvngLoanJournalLine."Search Name" := StrSubstNo(lvngLoanVisionSetup."Search Name Template", lvngLoanJournalLine."Borrower First Name", lvngLoanJournalLine."Borrower Last Name", lvngLoanJournalLine."Borrower Middle Name");
            lvngLoanJournalLine.Modify();
        end;
        lvngJournalValidationRule.reset;
        lvngJournalValidationRule.SetRange("Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        if lvngJournalValidationRule.FindSet() then begin
            lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
            repeat
                if not ValidateConditionLine(lvngExpressionValueBuffer, lvngJournalValidationRule."Condition Code") then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, lvngJournalValidationRule."Error Message");
                end;
            until lvngJournalValidationRule.Next() = 0;
        end;
    end;

    local procedure ValidateConditionLine(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer; lvngConditionCode: Code[20]): Boolean
    var
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        GetLoanVisionSetup();
        ExpressionHeader.Get(lvngConditionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(lvngExpressionEngine.CheckCondition(ExpressionHeader, lvngExpressionValueBuffer));
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;

}