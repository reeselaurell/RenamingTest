codeunit 14135108 "lvngConditionsMgmt"
{
    procedure GetConditionsMgmtConsumerId(): Guid
    var
        g: Guid;
    begin
        Evaluate(g, '321a0cba-a28f-42d5-9254-cb477c494dcd');
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', true, true)]
    procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
        if GetConditionsMgmtConsumerId() = ExpressionHeader."Consumer Id" then
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
                lvngLoanValue.SetRange("Loan No.", lvngLoan."Loan No.");
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
                if lvngLoanValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanValue."Field Value";
                end else begin
                    case lvngLoanFieldsConfigurationTemp."Value Type" of
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngInteger:
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
            if (lvngExpressionValueBuffer.Type = 'DateTime') and (lvngExpressionValueBuffer.Value = '') then
                lvngExpressionValueBuffer.Value := format(DMY2Date(1, 1, 1974));
            if (lvngExpressionValueBuffer.Type = 'Boolean') then begin
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
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
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
                lvngLoanJournalValue.SetRange(lvngFieldNo, lvngLoanFieldsConfigurationTemp."Field No.");
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
                if lvngLoanJournalValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanJournalValue.lvngFieldValue;
                end else begin
                    case lvngLoanFieldsConfigurationTemp."Value Type" of
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngInteger:
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