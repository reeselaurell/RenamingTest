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
            'LOAN':
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
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp.lvngValueType);
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

    procedure FillLoanFieldValues(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer; var lvngLoan: Record lvngLoan)
    var
        lvngLoanValue: Record lvngLoanValue;
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
                lvngLoanValue.reset;
                lvngLoanValue.SetRange(lvngLoanNo, lvngLoan.lvngLoanNo);
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp.lvngValueType);
                if lvngLoanValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanValue.lvngFieldValue;
                end else begin
                    case lvngLoanFieldsConfigurationTemp.lvngValueType of
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngInteger:
                            begin
                                lvngExpressionValueBuffer.Value := '0';
                            end;
                    end;
                end;
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;

        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoan);
        lvngTableFields.FindSet();
        lvngRecordReference.GetTable(lvngLoan);
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngFieldReference := lvngRecordReference.Field(lvngTableFields."No.");
            lvngExpressionValueBuffer.Value := Delchr(Format(lvngFieldReference.Value()), '<>', ' ');
            lvngExpressionValueBuffer.Type := format(lvngFieldReference.Type());
            if (lvngExpressionValueBuffer.Type = 'System.DateTime') and (lvngExpressionValueBuffer.Value = '') then
                lvngExpressionValueBuffer.Value := format(DMY2Date(1, 1, 1974));
            if (lvngExpressionValueBuffer.Type = 'System.Boolean') then begin
                if (lvngExpressionValueBuffer.Value = 'No') then
                    lvngExpressionValueBuffer.Value := 'False';
                if (lvngExpressionValueBuffer.Value = 'Yes') then
                    lvngExpressionValueBuffer.Value := 'True';
            end;
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngRecordReference.Close();
    end;

    local procedure FillJournalFields(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer)
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
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp.lvngValueType);
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;
        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        lvngTableFields.SetFilter("No.", '>%1', 4);
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

    procedure FillJournalFieldValues(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer; var lvngLoanJournalLine: Record lvngLoanJournalLine)
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
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp.lvngFieldName;
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp.lvngValueType);
                if lvngLoanJournalValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanJournalValue.lvngFieldValue;
                end else begin
                    case lvngLoanFieldsConfigurationTemp.lvngValueType of
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp.lvngValueType::lvngInteger:
                            begin
                                lvngExpressionValueBuffer.Value := '0';
                            end;
                    end;
                end;
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;

        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoanJournalLine);
        lvngTableFields.SetFilter("No.", '>%1', 4);
        lvngTableFields.FindSet();
        lvngRecordReference.GetTable(lvngLoanJournalLine);
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngFieldReference := lvngRecordReference.Field(lvngTableFields."No.");
            lvngExpressionValueBuffer.Value := Delchr(Format(lvngFieldReference.Value()), '<>', ' ');
            lvngExpressionValueBuffer.Type := format(lvngFieldReference.Type());
            /*
            if (lvngExpressionValueBuffer.Type = 'Date') and (lvngExpressionValueBuffer.Value = '') then
                lvngExpressionValueBuffer.Value := format(DMY2Date(1, 1, 1974));
            if (lvngExpressionValueBuffer.Type = 'Boolean') then begin
                if (lvngExpressionValueBuffer.Value = 'No') then
                    lvngExpressionValueBuffer.Value := 'False';
                if (lvngExpressionValueBuffer.Value = 'Yes') then
                    lvngExpressionValueBuffer.Value := 'True';
            end;*/
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngRecordReference.Close();
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetupRetrieved := true;
            lvngLoanVisionSetup.get;
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