codeunit 14135127 "lvnLoanLevelReportManagement"
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

    [EventSubscriber(ObjectType::Page, Page::lvnExpressionList, 'FillBuffer', '', false, false)]
    local procedure OnFillBuffer(
        ExpressionHeader: Record lvnExpressionHeader;
        ConsumerMetadata: Text;
        var ExpressionBuffer: Record lvnExpressionValueBuffer)
    var
        LoanLevelReportSchemaLine: Record lvnLoanLevelReportSchemaLine;
    begin
        if ExpressionHeader."Consumer Id" = GetLoanLevelFormulaConsumerId() then begin
            LoanLevelReportSchemaLine.Reset();
            LoanLevelReportSchemaLine.SetRange("Report Code", ConsumerMetadata);
            LoanLevelReportSchemaLine.SetFilter(Type, '<>%1', LoanLevelReportSchemaLine.Type::Formula);
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