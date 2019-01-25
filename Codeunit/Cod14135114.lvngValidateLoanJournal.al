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
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngJournalBatchCode);
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
        if lvngLoanJournalLine.lvngLoanNo = '' then
            lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, LoanNoEmptyLbl);

        lvngJournalValidationRule.reset;
        lvngJournalValidationRule.SetRange(lvngJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        if lvngJournalValidationRule.FindSet() then begin
            lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
            repeat
                if not ValidateConditionLine(lvngExpressionValueBuffer, lvngJournalValidationRule.lvngConditionCode) then begin
                    lvngLoanJournalErrorMgmt.AddJournalLineError(lvngLoanJournalLine, lvngJournalValidationRule.lvngErrorMessage);
                end;
            until lvngJournalValidationRule.Next() = 0;
        end;
    end;

    local procedure ValidateConditionLine(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer; lvngConditionCode: Code[20]): Boolean
    var
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
    begin
        GetLoanVisionSetup();
        exit(lvngExpressionEngine.CheckCondition(lvngConditionCode, lvngExpressionValueBuffer, true));
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