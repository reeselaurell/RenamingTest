codeunit 14135108 "lvngConditionsMgmt"
{
    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', true, true)]
    procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
        case ConsumerMetadata of
            'JOURNAL':
                begin
                    FillJournalFields(ExpressionBuffer);
                end;
        end;
    end;

    local procedure FillJournalFields(var ExpressionBuffer: Record lvngExpressionValueBuffer)
    var
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
    begin
        InitializeConfigBuffer();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                Clear(ExpressionBuffer);
                ExpressionBuffer.Number := lvngFieldSequenceNo;
                ExpressionBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                ExpressionBuffer.Type := lvngExpressionEngine.GetNetType(format(lvngLoanFieldsConfigurationTemp.lvngValueType));
                ExpressionBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;
        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        lvngTableFields.SetFilter("No.", '>%1', 4);
        lvngTableFields.FindSet();
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(ExpressionBuffer);
            ExpressionBuffer.Number := lvngFieldSequenceNo;
            ExpressionBuffer.Name := lvngTableFields.FieldName;
            ExpressionBuffer.Type := lvngExpressionEngine.GetNetType(lvngTableFields."Type Name");
            ExpressionBuffer.Insert();
        until lvngTableFields.Next() = 0;
    end;

    procedure FillJournalFieldValues(var ExpressionBuffer: Record lvngExpressionValueBuffer; var lvngLoanJournalLine: Record lvngLoanJournalLine)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
        lvngRecordReference: RecordRef;
        lvngFieldReference: FieldRef;
    begin
        InitializeConfigBuffer();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                lvngLoanJournalValue.reset;
                lvngLoanJournalValue.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
                lvngLoanJournalValue.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
                lvngLoanJournalValue.SetRange(lvngFieldNo, lvngLoanFieldsConfigurationTemp.lvngFieldNo);
                Clear(ExpressionBuffer);
                ExpressionBuffer.Number := lvngFieldSequenceNo;
                ExpressionBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                ExpressionBuffer.Type := lvngExpressionEngine.GetNetType(format(lvngLoanFieldsConfigurationTemp.lvngValueType));
                if lvngLoanJournalValue.FindFirst() then begin
                    ExpressionBuffer.Value := lvngLoanJournalValue.lvngFieldValue;
                end else begin
                    case lvngLoanFieldsConfigurationTemp.lvngValueType of
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngBoolean:
                            begin
                                ExpressionBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngDecimal:
                            begin
                                ExpressionBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngInteger:
                            begin
                                ExpressionBuffer.Value := '0';
                            end;
                    end;
                end;
                ExpressionBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;

        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        lvngTableFields.SetFilter("No.", '>%1', 4);
        lvngTableFields.FindSet();
        lvngRecordReference.GetTable(lvngLoanJournalLine);
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(ExpressionBuffer);
            ExpressionBuffer.Number := lvngFieldSequenceNo;
            ExpressionBuffer.Name := lvngTableFields.FieldName;
            lvngFieldReference := lvngRecordReference.Field(lvngTableFields."No.");
            ExpressionBuffer.Value := Delchr(Format(lvngFieldReference.Value()), '<>', ' ');
            ExpressionBuffer.Type := lvngExpressionEngine.GetNetType(format(lvngFieldReference.Type()));
            if (ExpressionBuffer.Type = 'System.DateTime') and (ExpressionBuffer.Value = '') then
                ExpressionBuffer.Value := format(DMY2Date(1, 1, 1974));
            ExpressionBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngRecordReference.Close();
    end;

    procedure GetApplicationId(): Guid
    begin
        GetLoanVisionSetup();
        exit(lvngLoanVisionSetup.lvngApplicationId);
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetupRetrieved := true;
            lvngLoanVisionSetup.get;
            lvngLoanVisionSetup.TestField(lvngApplicationId);
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
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanVisionSetupRetrieved: Boolean;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngLoanFieldsConfigInitialized: Boolean;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
}