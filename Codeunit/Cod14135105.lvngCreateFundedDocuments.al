codeunit 14135105 "lvngCreateFundedDocuments"
{
    procedure CreateSingleDocument(lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLoanDocument: record lvngLoanDocument; var lvngLoanDocumentLine: Record lvngLoanDocumentLine; lvngPreview: Boolean)
    var
        lvngLoanProcessingSchema: Record lvngLoanProcessingSchema;
        lvngLoanProcessingSchemaLine: Record lvngLoanProcessingSchemaLine;
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        TempDocumentLbl: Label 'XXXXXXXX';
        lvngLineNo: Integer;
    begin
        lvngLoanJournalLine.TestField(lvngProcessingSchemaCode);
        lvngLoanProcessingSchema.Get(lvngLoanJournalLine.lvngProcessingSchemaCode);
        lvngLoanJournalBatch.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLineNo := 10000;
        clear(lvngLoanDocument);
        lvngLoanDocument.init;
        if not lvngPreview then
            lvngLoanDocument.lvngDocumentNo := NoSeriesManagement.DoGetNextNo(lvngLoanProcessingSchema.lvngNoSeries, TODAY, true, false) else
            lvngLoanDocument.lvngDocumentNo := TempDocumentLbl;
        lvngLoanDocument.Insert(true);
        lvngLoanDocument.lvngCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
        lvngLoanDocument.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
        lvngLoanDocument.Modify(true);
        if lvngLoanProcessingSchema.lvngUseGlobalSchemaCode <> '' then begin
            lvngLoanProcessingSchemaLine.reset;
            lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngUseGlobalSchemaCode);
            if lvngLoanProcessingSchemaLine.FindSet() then begin
                repeat
                    CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
                until lvngLoanProcessingSchemaLine.Next() = 0;
            end;
        end;
        lvngLoanProcessingSchemaLine.reset;
        lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngCode);
        if lvngLoanProcessingSchemaLine.FindSet() then begin
            repeat
                CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
            until lvngLoanProcessingSchemaLine.Next() = 0;
        end;

    end;

    local procedure CreateDocumentLine(var lvngLoanDocumentLine: Record lvngLoanDocumentLine; lvngLoanDocument: record lvngLoanDocument; lvngLoanProcessingSchemaLine: Record lvngLoanProcessingSchemaLine; lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLineNo: integer)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngAccountNo: Code[20];
        lvngDecimalValue: Decimal;

    begin
        if CheckCondition(lvngLoanProcessingSchemaLine.lvngConditionCode, lvngLoanJournalLine) then begin
            Clear(lvngLoanDocumentLine);
            lvngLoanDocumentLine.init;
            lvngLoanDocumentLine.lvngDocumentNo := lvngLoanDocument.lvngDocumentNo;
            lvngLoanDocumentLine.lvngLoanDocumentType := lvngLoanDocument.lvngLoanDocumentType;
            lvngLoanDocumentLine.lvngLineNo := lvngLineNo;
            lvngLoanDocumentLine.lvngProcessingSchemaCode := lvngLoanProcessingSchemaLine.lvngProcessingCode;
            lvngloandocumentline.lvngProcessingSchemaLineNo := lvngLoanProcessingSchemaLine.lvngLineNo;
            lvngLoanDocumentLine.lvngBalancingEntry := lvngLoanProcessingSchemaLine.lvngBalancingEntry;
            lvngLineNo := lvngLineNo + 10000;
            lvngLoanDocumentLine.Insert();
            if lvngLoanProcessingSchemaLine.lvngOverrideReasonCode <> '' then begin
                lvngLoanDocumentLine.lvngReasonCode := lvngLoanProcessingSchemaLine.lvngOverrideReasonCode;
            end else begin
                lvngLoanDocumentLine.lvngReasonCode := lvngLoanJournalLine.lvngReasonCode;
            end;
            lvngLoanDocumentLine.lvngDescription := CopyStr(lvngLoanProcessingSchemaLine.lvngDescription, 1, MaxStrLen(lvngLoanDocumentLine.lvngDescription));
            lvngLoanDocumentLine.lvngAccountType := lvngLoanProcessingSchemaLine.lvngAccountType;
            lvngLoanDocumentLine.lvngAccountNo := lvngLoanProcessingSchemaLine.lvngAccountNo;
            if lvngLoanProcessingSchemaLine.lvngAccountNoSwitchCode <> '' then begin
                lvngAccountNo := GetSwitchValue(lvngLoanProcessingSchemaLine.lvngAccountNoSwitchCode, lvngLoanJournalLine);
                if lvngAccountNo <> '' then
                    lvngLoanDocumentLine.lvngAccountNo := lvngAccountNo;
            end;
            case lvngLoanProcessingSchemaLine.lvngProcessingSourceType of
                lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngFunction:
                    begin
                        if Evaluate(lvngDecimalValue, GetFunctionValue(lvngLoanProcessingSchemaLine.lvngFunctionCode, lvngLoanJournalLine)) then
                            lvngLoanDocumentLine.lvngAmount := lvngDecimalValue;
                    end;
                lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngLoanJournalValue:
                    begin
                        lvngRecRef.GetTable(lvngLoanJournalLine);
                        lvngFieldRef := lvngRecRef.Field(lvngLoanProcessingSchemaLine.lvngFieldNo);
                        lvngLoanDocumentLine.lvngAmount := lvngFieldRef.Value();
                        lvngRecRef.Close();
                    end;
                lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngLoanJournalVariableValue:
                    begin
                        if lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngLoanProcessingSchemaLine.lvngFieldNo) then begin
                            if Evaluate(lvngDecimalValue, lvngLoanJournalValue.lvngFieldValue) then
                                lvngLoanDocumentLine.lvngAmount := lvngDecimalValue;
                        end;

                    end;
            end;
            if lvngLoanProcessingSchemaLine.lvngReverseSign then
                lvngLoanDocumentLine.lvngAmount := -lvngLoanDocumentLine.lvngAmount;

            AssignDimensions(lvngLoanDocumentLine.lvngGlobalDimension1Code, lvngLoanProcessingSchemaLine.lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code, lvngLoanProcessingSchemaLine.lvngDimension1Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngGlobalDimension2Code, lvngLoanProcessingSchemaLine.lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code, lvngLoanProcessingSchemaLine.lvngDimension2Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension3Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code, lvngLoanProcessingSchemaLine.lvngDimension3Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension4Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code, lvngLoanProcessingSchemaLine.lvngDimension4Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension5Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code, lvngLoanProcessingSchemaLine.lvngDimension5Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension6Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code, lvngLoanProcessingSchemaLine.lvngDimension6Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension7Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code, lvngLoanProcessingSchemaLine.lvngDimension7Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngShortcutDimension8Code, lvngLoanProcessingSchemaLine.lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code, lvngLoanProcessingSchemaLine.lvngDimension8Rule);
            AssignDimensions(lvngLoanDocumentLine.lvngBusinessUnitCode, lvngLoanProcessingSchemaLine.lvngBusinessUnitCode, lvngLoanJournalLine.lvngBusinessUnitCode, lvngLoanProcessingSchemaLine.lvngBusinessUnitRule);
            lvngLoanDocumentLine.Modify();
        end;
    end;

    local procedure AssignDimensions(var AssignToDimension: Code[20]; lvngProcessingDimensionValueCode: Code[20]; lvngJournalDimensionValueCode: Code[20]; lvngProcessingDimensionRule: enum lvngProcessingDimensionRule)
    begin
        case lvngProcessingDimensionRule of
            lvngProcessingDimensionRule::lvngDefined:
                begin
                    AssignToDimension := lvngProcessingDimensionValueCode;
                end;
            lvngProcessingDimensionRule::lvngJournalLine:
                begin
                    AssignToDimension := lvngJournalDimensionValueCode;
                end;
        end;
    end;

    local procedure CheckCondition(lvngConditionCode: code[20]; lvngLoanJournalLine: Record lvngLoanJournalLine): Boolean
    var
        myInt: Integer;
    begin
        if lvngConditionCode = '' then
            exit(true);
        exit(true);
    end;

    local procedure GetFunctionValue(lvngFunctionCode: code[20]; lvngLoanJournalLine: Record lvngLoanJournalLine): Text
    var
        myInt: Integer;
    begin
        exit('100');
    end;

    local procedure GetSwitchValue(lvngSwitchCode: code[20]; lvngLoanJournalLine: Record lvngLoanJournalLine): Code[20]
    var
        myInt: Integer;
    begin
        exit('TEST');
    end;
}