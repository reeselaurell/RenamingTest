codeunit 14135223 lvngLoanLevelReportManagement
{
    SingleInstance = true;

    var
        LoanLevelFormulaConsumerId: Guid;

    procedure GetLoanLevelFormulaConsumerId(): Guid
    begin
        if IsNullGuid(LoanLevelFormulaConsumerId) then
            Evaluate(LoanLevelFormulaConsumerId, '1473eeaa-2309-4205-9d8d-1c2a61d68355');
        exit(LoanLevelFormulaConsumerId);
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', false, false)]
    local procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
    begin
        if ExpressionHeader."Consumer Id" = GetLoanLevelFormulaConsumerId() then begin
            LoanLevelReportSchemaLine.Reset();
            LoanLevelReportSchemaLine.SetRange("Report Code", ConsumerMetadata);
            LoanLevelReportSchemaLine.SetFilter(Type, '<>%1', LoanLevelReportSchemaLine.Type::lvngFormula);
            if LoanLevelReportSchemaLine.FindSet() then
                repeat
                    Clear(ExpressionBuffer);
                    ExpressionBuffer.Name := 'Col' + Format(LoanLevelReportSchemaLine."Column No.");
                    ExpressionBuffer.Number := LoanLevelReportSchemaLine."Column No.";
                    ExpressionBuffer.Type := 'Decimal';
                    ExpressionBuffer.Insert();
                until LoanLevelReportSchemaLine.Next() = 0;
        end;
    end;
}