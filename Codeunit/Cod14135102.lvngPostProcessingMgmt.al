codeunit 14135102 "lvngPostProcessingMgmt"
{
    procedure PostProcessBatch(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine;
    begin
        lvngLoanJournalBatch.Get(lvngJournalBatchCode);
        lvngPostProcessingSchemaLine.reset;
        lvngPostProcessingSchemaLine.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
        if lvngPostProcessingSchemaLine.IsEmpty() then
            exit;
        lvngPostProcessingSchemaLine.SetCurrentKey(lvngPriority);
        lvngLoanJournalLine.Reset();
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngJournalBatchCode);
        lvngLoanJournalLine.FindSet();
        repeat
            lvngPostProcessingSchemaLine.FindSet();
            repeat
                case lvngPostProcessingSchemaLine.lvngType of
                    lvngPostProcessingSchemaLine.lvngType::lvngCopyLoanCardValue:
                        begin
                            CopyLoanCardValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngCopyLoanJournalValue:
                        begin
                            CopyLoanJournalValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngCopyLoanJournalVariableValue:
                        begin
                            CopyLoanJournalVariableValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngCopyLoanVariableValue:
                        begin
                            CopyLoanVariableValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngExpression:
                        begin

                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngSwitchExpression:
                        begin

                        end;
                end;

            until lvngPostProcessingSchemaLine.Next() = 0;
        until lvngLoanJournalLine.Next() = 0;
    end;

    local procedure CopyLoanCardValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoan: Record lvngLoan;
        lvngRecRef: RecordRef;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngFieldRef: FieldRef;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngDecimalFieldValue: Decimal;
    begin
        lvngLoan.get(lvngLoanJournalLine.lvngLoanNo);
        lvngRecRef.GetTable(lvngLoan);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine.lvngFromFieldNo);
        case lvngPostProcessingSchemaLine.lvngAssignTo of
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalVariableField:
                begin
                    if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngToFieldNo) then begin
                        Clear(lvngLoanJournalValue);
                        lvngLoanJournalValue.init;
                        lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                        lvngLoanJournalValue.lvngLineNo := lvngloanjournalline.lvngLineNo;
                        lvngLoanJournalValue.lvngFieldNo := lvngPostProcessingSchemaLine.lvngToFieldNo;
                        lvngLoanJournalValue.Insert(true);
                    end;
                    lvngLoanJournalValue.lvngFieldValue := Format(lvngFieldRef.Value());
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, lvngLoanJournalValue.lvngFieldValue) then begin
                            lvngLoanJournalValue.lvngFieldValue := Format(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngLoanJournalValue.Modify(true);
                end;
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField:
                begin
                    lvngRecRefTo.GetTable(lvngLoanJournalLine);
                    lvngFieldRefTo := lvngrecrefto.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngFieldRef.Value());
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, format(lvngFieldRefTo.Value())) then begin
                            lvngFieldRefTo.Validate(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngRecRefTo.SetTable(lvngLoanJournalLine);
                    lvngRecRefTo.Close();
                    lvngLoanJournalLine.Modify(true);
                end;
        end;
        lvngRecRef.Close();
    end;

    local procedure CopyLoanJournalValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngRecRef: RecordRef;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngFieldRef: FieldRef;
        lvngDecimalFieldValue: Decimal;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
    begin
        lvngRecRef.GetTable(lvngLoanJournalLine);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine.lvngFromFieldNo);
        case lvngPostProcessingSchemaLine.lvngAssignTo of
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalVariableField:
                begin
                    if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngToFieldNo) then begin
                        Clear(lvngLoanJournalValue);
                        lvngLoanJournalValue.init;
                        lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                        lvngLoanJournalValue.lvngLineNo := lvngloanjournalline.lvngLineNo;
                        lvngLoanJournalValue.lvngFieldNo := lvngPostProcessingSchemaLine.lvngToFieldNo;
                        lvngLoanJournalValue.Insert(true);
                    end;
                    lvngLoanJournalValue.lvngFieldValue := Format(lvngFieldRef.Value());
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, lvngLoanJournalValue.lvngFieldValue) then begin
                            lvngLoanJournalValue.lvngFieldValue := Format(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngLoanJournalValue.Modify(true);
                end;
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField:
                begin
                    lvngRecRefTo.GetTable(lvngLoanJournalLine);
                    lvngFieldRefTo := lvngrecrefto.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngFieldRef.Value());
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, format(lvngFieldRefTo.Value())) then begin
                            lvngFieldRefTo.Validate(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngRecRefTo.SetTable(lvngLoanJournalLine);
                    lvngRecRefTo.Close();
                    lvngLoanJournalLine.Modify(true);
                end;
        end;
        lvngRecRef.Close();
    end;

    local procedure CopyLoanJournalVariableValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngLoanJournalValueFrom: record lvngLoanJournalValue;
        lvngDecimalFieldValue: Decimal;
    begin
        lvngLoanJournalValueFrom.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngFromFieldNo);
        case lvngPostProcessingSchemaLine.lvngAssignTo of
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalVariableField:
                begin
                    if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngToFieldNo) then begin
                        Clear(lvngLoanJournalValue);
                        lvngLoanJournalValue.init;
                        lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                        lvngLoanJournalValue.lvngLineNo := lvngloanjournalline.lvngLineNo;
                        lvngLoanJournalValue.lvngFieldNo := lvngPostProcessingSchemaLine.lvngToFieldNo;
                        lvngLoanJournalValue.Insert(true);
                    end;
                    lvngLoanJournalValue.lvngFieldValue := lvngLoanJournalValueFrom.lvngFieldValue;
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, lvngLoanJournalValue.lvngFieldValue) then begin
                            lvngLoanJournalValue.lvngFieldValue := Format(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngLoanJournalValue.Modify(true);
                end;
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField:
                begin
                    lvngRecRefTo.GetTable(lvngLoanJournalLine);
                    lvngFieldRefTo := lvngrecrefto.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngLoanJournalValueFrom.lvngFieldValue);
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, format(lvngFieldRefTo.Value())) then begin
                            lvngFieldRefTo.Validate(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngRecRefTo.SetTable(lvngLoanJournalLine);
                    lvngRecRefTo.Close();
                    lvngLoanJournalLine.Modify(true);
                end;
        end;
    end;

    local procedure CopyLoanVariableValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngLoanValueFrom: record lvngLoanValue;
        lvngDecimalFieldValue: Decimal;
    begin
        lvngLoanValueFrom.Get(lvngLoanJournalLine.lvngLoanNo, lvngPostProcessingSchemaLine.lvngFromFieldNo);
        case lvngPostProcessingSchemaLine.lvngAssignTo of
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalVariableField:
                begin
                    if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngToFieldNo) then begin
                        Clear(lvngLoanJournalValue);
                        lvngLoanJournalValue.init;
                        lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                        lvngLoanJournalValue.lvngLineNo := lvngloanjournalline.lvngLineNo;
                        lvngLoanJournalValue.lvngFieldNo := lvngPostProcessingSchemaLine.lvngToFieldNo;
                        lvngLoanJournalValue.Insert(true);
                    end;
                    lvngLoanJournalValue.lvngFieldValue := lvngLoanValueFrom.lvngFieldValue;
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, lvngLoanJournalValue.lvngFieldValue) then begin
                            lvngLoanJournalValue.lvngFieldValue := Format(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngLoanJournalValue.Modify(true);
                end;
            lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField:
                begin
                    lvngRecRefTo.GetTable(lvngLoanJournalLine);
                    lvngFieldRefTo := lvngrecrefto.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngLoanValueFrom.lvngFieldValue);
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, format(lvngFieldRefTo.Value())) then begin
                            lvngFieldRefTo.Validate(Round(lvngDecimalFieldValue, lvngPostProcessingSchemaLine.lvngRoundExpression));
                        end;
                    end;
                    lvngRecRefTo.SetTable(lvngLoanJournalLine);
                    lvngRecRefTo.Close();
                    lvngLoanJournalLine.Modify(true);
                end;
        end;
    end;
}