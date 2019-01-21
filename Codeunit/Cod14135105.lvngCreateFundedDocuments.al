codeunit 14135105 "lvngCreateFundedDocuments"
{
    procedure CreateDocuments(lvngLoanJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
        lvngLoanCardManagement: Codeunit lvngLoanCardManagement;
        lvngLoanDocumentTemp: Record lvngLoanDocument temporary;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngDocumentsCreated: Integer;
        lvngTotalEntries: Integer;
        lvngProcessResultLbl: Label '%1 of %2 documents were created';
    begin
        lvngValidateFundedJournal.ValidateFundedLines(lvngLoanJournalBatchCode);
        lvngLoanCardManagement.UpdateLoanCards(lvngLoanJournalBatchCode);
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode);
        lvngTotalEntries := lvngLoanJournalLine.Count();
        if lvngLoanJournalLine.FindSet() then begin
            repeat
                if not lvngLoanJournalErrorMgmt.HasError(lvngLoanJournalLine) then begin
                    lvngLoanDocumentTemp.reset;
                    lvngLoanDocumentTemp.DeleteAll();
                    lvngLoanDocumentLineTemp.reset;
                    lvngLoanDocumentLineTemp.DeleteAll();
                    CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocumentTemp, lvngLoanDocumentLineTemp, false);
                    lvngLoanDocumentTemp.reset;
                    if lvngLoanDocumentTemp.FindSet() then begin
                        repeat
                            Clear(lvngLoanDocument);
                            lvngLoanDocument := lvngLoanDocumentTemp;
                            lvngLoanDocument.Insert();
                            lvngLoanDocumentLineTemp.reset;
                            if lvngLoanDocumentLineTemp.FindSet() then begin
                                repeat
                                    clear(lvngLoanDocumentLine);
                                    lvngLoanDocumentLine := lvngLoanDocumentLineTemp;
                                    lvngLoanDocumentLine.Insert();
                                until lvngLoanDocumentLineTemp.Next() = 0;
                            end;
                        until lvngLoanDocumentLineTemp.Next() = 0;
                        lvngLoanJournalLine.Mark(true);
                        lvngDocumentsCreated := lvngDocumentsCreated + 1;
                    end;
                end;
            until lvngLoanJournalLine.Next() = 0;
        end;
        lvngLoanJournalLine.MarkedOnly(true);
        lvngLoanJournalLine.DeleteAll(true);
        commit;
        Message(lvngProcessResultLbl, lvngTotalEntries, lvngDocumentsCreated);
    end;

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
        lvngExpressionValueBuffer.reset;
        lvngExpressionValueBuffer.DeleteAll();
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        lvngLineNo := 10000;
        clear(lvngLoanDocument);
        lvngLoanDocument.init;
        if not lvngPreview then
            lvngLoanDocument.lvngDocumentNo := NoSeriesManagement.DoGetNextNo(lvngLoanProcessingSchema.lvngNoSeries, TODAY, true, false) else
            lvngLoanDocument.lvngDocumentNo := TempDocumentLbl;
        lvngLoanDocument.Insert(true);
        lvngLoanDocument.lvngCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
        lvngLoanDocument.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
        AssignDimensions(lvngLoanDocument.lvngGlobalDimension1Code, lvngLoanProcessingSchema.lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code, lvngLoanProcessingSchema.lvngDimension1Rule);
        AssignDimensions(lvngLoanDocument.lvngGlobalDimension2Code, lvngLoanProcessingSchema.lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code, lvngLoanProcessingSchema.lvngDimension2Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension3Code, lvngLoanProcessingSchema.lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code, lvngLoanProcessingSchema.lvngDimension3Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension4Code, lvngLoanProcessingSchema.lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code, lvngLoanProcessingSchema.lvngDimension4Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension5Code, lvngLoanProcessingSchema.lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code, lvngLoanProcessingSchema.lvngDimension5Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension6Code, lvngLoanProcessingSchema.lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code, lvngLoanProcessingSchema.lvngDimension6Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension7Code, lvngLoanProcessingSchema.lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code, lvngLoanProcessingSchema.lvngDimension7Rule);
        AssignDimensions(lvngLoanDocument.lvngShortcutDimension8Code, lvngLoanProcessingSchema.lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code, lvngLoanProcessingSchema.lvngDimension8Rule);
        AssignDimensions(lvngLoanDocument.lvngBusinessUnitCode, lvngLoanProcessingSchema.lvngBusinessUnitCode, lvngLoanJournalLine.lvngBusinessUnitCode, lvngLoanProcessingSchema.lvngBusinessUnitRule);
        lvngLoanDocument.GenerateDimensionSetId();
        lvngLoanDocument.Modify(true);
        if lvngLoanProcessingSchema.lvngUseGlobalSchemaCode <> '' then begin
            lvngLoanProcessingSchemaLine.reset;
            lvngLoanProcessingSchemaLine.SetRange(lvngBalancingEntry, false);
            lvngLoanProcessingSchemaLine.Setfilter(lvngProcessingSourceType, '<>%1', lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngTag);
            lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngUseGlobalSchemaCode);
            if lvngLoanProcessingSchemaLine.FindSet() then begin
                repeat
                    CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
                until lvngLoanProcessingSchemaLine.Next() = 0;
            end;
        end;
        lvngLoanProcessingSchemaLine.reset;
        lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngCode);
        lvngLoanProcessingSchemaLine.SetRange(lvngBalancingEntry, false);
        lvngLoanProcessingSchemaLine.Setfilter(lvngProcessingSourceType, '<>%1', lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngTag);
        if lvngLoanProcessingSchemaLine.FindSet() then begin
            repeat
                CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
            until lvngLoanProcessingSchemaLine.Next() = 0;
        end;
        lvngLoanDocumentLineTemp.reset;
        lvngLoanDocumentLineTemp.DeleteAll();
        lvngLoanDocumentLine.reset;
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLineTemp);
                lvngLoanDocumentLineTemp := lvngLoanDocumentLine;
                lvngLoanDocumentLineTemp.Insert();
            until lvngLoanDocumentLine.Next() = 0;
        end;
        if lvngLoanProcessingSchema.lvngUseGlobalSchemaCode <> '' then begin
            lvngLoanProcessingSchemaLine.reset;
            lvngLoanProcessingSchemaLine.SetRange(lvngBalancingEntry, true);
            lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngUseGlobalSchemaCode);
            if lvngLoanProcessingSchemaLine.FindSet() then begin
                repeat
                    CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
                until lvngLoanProcessingSchemaLine.Next() = 0;
            end;
        end;
        lvngLoanProcessingSchemaLine.reset;
        lvngLoanProcessingSchemaLine.SetRange(lvngProcessingCode, lvngLoanProcessingSchema.lvngCode);
        lvngLoanProcessingSchemaLine.SetRange(lvngBalancingEntry, true);
        if lvngLoanProcessingSchemaLine.FindSet() then begin
            repeat
                CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
            until lvngLoanProcessingSchemaLine.Next() = 0;
        end;
        lvngLoanDocumentLine.reset;
        lvngloandocumentline.SetRange(lvngAmount, 0);
        lvngLoanDocumentLine.DeleteAll();
    end;

    local procedure CreateDocumentLine(var lvngLoanDocumentLine: Record lvngLoanDocumentLine; lvngLoanDocument: record lvngLoanDocument; lvngLoanProcessingSchemaLine: Record lvngLoanProcessingSchemaLine; lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLineNo: integer)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngAccountNo: Code[20];
        lvngDecimalValue: Decimal;
    begin
        if CheckCondition(lvngLoanProcessingSchemaLine.lvngConditionCode) then begin
            Clear(lvngLoanDocumentLine);
            lvngLoanDocumentLine.init;
            lvngLoanDocumentLine.lvngDocumentNo := lvngLoanDocument.lvngDocumentNo;
            lvngLoanDocumentLine.lvngLoanDocumentType := lvngLoanDocument.lvngLoanDocumentType;
            lvngLoanDocumentLine.lvngLineNo := lvngLineNo;
            lvngLoanDocumentLine.lvngProcessingSchemaCode := lvngLoanProcessingSchemaLine.lvngProcessingCode;
            lvngloandocumentline.lvngProcessingSchemaLineNo := lvngLoanProcessingSchemaLine.lvngLineNo;
            lvngLoanDocumentLine.lvngBalancingEntry := lvngLoanProcessingSchemaLine.lvngBalancingEntry;
            lvngloandocumentline.lvngTagCode := lvngLoanProcessingSchemaLine.lvngTagCode;
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
                lvngAccountNo := GetSwitchValue(lvngLoanProcessingSchemaLine.lvngAccountNoSwitchCode);
                if lvngAccountNo <> '' then
                    lvngLoanDocumentLine.lvngAccountNo := lvngAccountNo;
            end;
            case lvngLoanProcessingSchemaLine.lvngProcessingSourceType of
                lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngFunction:
                    begin
                        if Evaluate(lvngDecimalValue, GetFunctionValue(lvngLoanProcessingSchemaLine.lvngFunctionCode)) then
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
                lvngLoanProcessingSchemaLine.lvngProcessingSourceType::lvngTag:
                    begin
                        Clear(lvngDecimalValue);
                        lvngLoanProcessingSchemaLine.TestField(lvngBalancingEntry);
                        lvngLoanDocumentLineTemp.reset;
                        lvngLoanDocumentLineTemp.SetRange(lvngTagCode, lvngLoanProcessingSchemaLine.lvngTagCode);
                        if lvngLoanDocumentLineTemp.FindSet() then begin
                            repeat
                                lvngDecimalValue := lvngDecimalValue + lvngLoanDocumentLineTemp.lvngAmount;
                            until lvngLoanDocumentLineTemp.Next() = 0;
                        end;
                        lvngLoanDocumentLine.lvngAmount := lvngDecimalValue;
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
            lvngLoanDocumentLine.GenerateDimensionSetId();
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

    local procedure CheckCondition(lvngConditionCode: code[20]): Boolean
    begin
        if lvngConditionCode = '' then
            exit(true);
        exit(lvngExpressionEngine.CheckCondition(lvngConditionCode, lvngExpressionValueBuffer, true));
    end;

    local procedure GetFunctionValue(lvngFunctionCode: code[20]): Text
    begin
        exit(lvngExpressionEngine.CalculateFormula(lvngFunctionCode, lvngExpressionValueBuffer, true));
    end;

    local procedure GetSwitchValue(lvngSwitchCode: code[20]): Code[20]
    var
        lvngResult: Text;
    begin
        if not lvngExpressionEngine.SwitchCase(lvngSwitchCode, lvngResult, lvngExpressionValueBuffer, true) then
            exit('');
        exit(copystr(lvngResult, 1, 20));

    end;

    var
        lvngExpressionValueBuffer: record lvngExpressionValueBuffer temporary;
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
}