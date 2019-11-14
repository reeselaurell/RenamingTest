codeunit 14135301 "lvngCommissionReportsHelper"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', true, true)]
    procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
        GetCommissionSetup();
        if lvngCommissionSetup.GetCommissionReportId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
                'REPORTLOAN':
                    begin
                        FillLoanFields(ExpressionBuffer);
                    end;
            end;
    end;

    local procedure FillLoanFields(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer)
    var
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
    begin
        InitializeConfigBuffer();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;
        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoan);
        lvngTableFields.FindSet();
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngExpressionValueBuffer.Type := lvngTableFields."Type Name";
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
    end;

    local procedure GetCommissionSetup()
    begin
        if not lvngCommissionSetupRetrieved then begin
            lvngCommissionSetup.Get();
            lvngCommissionSetupRetrieved := true;
        end;
    end;

    local procedure InitializeConfigBuffer()
    begin
        if not lvngLoanFieldsConfigInitialized then begin
            lvngLoanFieldsConfigInitialized := true;
            lvngLoanFieldsConfiguration.reset;
            if lvngLoanFieldsConfiguration.FindSet() then begin
                repeat
                    Clear(lvngLoanFieldsConfigurationTemp);
                    lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
                    lvngLoanFieldsConfigurationTemp.Insert();
                until lvngLoanFieldsConfiguration.Next() = 0;
            end;
        end;
    end;

    var
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngCommissionSetupRetrieved: Boolean;
        lvngLoanFieldsConfigInitialized: Boolean;
}