codeunit 14135301 "lvnCommissionReportsHelper"
{
    [EventSubscriber(ObjectType::Page, Page::lvnExpressionList, 'FillBuffer', '', true, true)]
    local procedure OnFillBuffer(
        ExpressionHeader: Record lvnExpressionHeader;
        ConsumerMetadata: Text;
        var ExpressionBuffer: Record lvnExpressionValueBuffer)
    var
        CommissionHelper: Codeunit lvnCommissionCalcHelper;
    begin
        if CommissionHelper.GetCommissionReportConsumerId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
                'REPORTLOAN':
                    FillLoanFields(ExpressionBuffer);
            end;
    end;

    local procedure FillLoanFields(var ExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := Format(LoanFieldsConfiguration."Value Type");
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.FindSet();
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            ExpressionValueBuffer.Type := TableFields."Type Name";
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
    end;
}