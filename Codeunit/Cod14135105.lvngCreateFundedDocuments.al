codeunit 14135105 "lvngCreateFundedDocuments"
{
    procedure CreateDocuments(lvngLoanJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
        lvngLoanManagement: Codeunit lvngLoanManagement;
        lvngLoanDocumentTemp: Record lvngLoanDocument temporary;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngDocumentsCreated: Integer;
        lvngTotalEntries: Integer;
        lvngProcessResultLbl: Label '%1 of %2 documents were created';
    begin
        GetLoanVisionSetup();
        lvngValidateFundedJournal.ValidateFundedLines(lvngLoanJournalBatchCode);
        lvngLoanManagement.UpdateLoans(lvngLoanJournalBatchCode);
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
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        TempDocumentLbl: Label 'XXXXXXXX';
        lvngLineNo: Integer;
        lvngDocumentAmount: Decimal;
    begin
        GetLoanVisionSetup();
        if lvngLoanVisionSetup.lvngFundedVoidReasonCode <> '' then begin
            if (lvngLoanVisionSetup.lvngFundedVoidReasonCode = lvngLoanJournalLine.lvngReasonCode) then begin
                lvngLoanVisionSetup.TestField(lvngVoidFundedNoSeries);
                lvngLoanFundedDocument.reset;
                lvngLoanFundedDocument.SetRange(lvngLoanNo, lvngLoanJournalLine.lvngLoanNo);
                lvngLoanFundedDocument.SetRange(lvngVoid, false);
                lvngLoanFundedDocument.FindLast();
                Clear(lvngLoanDocument);
                lvngLoanDocument.init;
                lvngLoanDocument.TransferFields(lvngLoanFundedDocument);
                lvngLoanDocument.lvngTransactionType := lvngLoanDocument.lvngTransactionType::lvngFunded;
                if not lvngPreview then begin
                    lvngLoanDocument.lvngDocumentNo := NoSeriesManagement.DoGetNextNo(lvngLoanVisionSetup.lvngVoidFundedNoSeries, TODAY, true, false);
                end else begin
                    lvngLoanDocument.lvngDocumentNo := TempDocumentLbl;
                end;
                if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngCreditMemo then
                    lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngInvoice else
                    lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngCreditMemo;

                lvngLoanDocument.lvngVoid := true;
                lvngLoanDocument.lvngVoidDocumentNo := lvngLoanFundedDocument.lvngDocumentNo;
                lvngLoanDocument.Insert();
                lvngLoanFundedDocumentLine.reset;
                lvngLoanFundedDocumentLine.SetRange(lvngDocumentNo, lvngLoanFundedDocument.lvngDocumentNo);
                lvngLoanFundedDocumentLine.FindSet();
                repeat
                    Clear(lvngLoanDocumentLine);
                    lvngLoanDocumentLine.TransferFields(lvngLoanFundedDocumentLine);
                    lvngLoanDocumentLine.lvngTransactionType := lvngLoanDocument.lvngTransactionType;
                    lvngLoanDocumentLine.lvngDocumentNo := lvngLoanDocument.lvngDocumentNo;
                    lvngLoanDocumentLine.lvngAmount := -lvngLoanDocumentLine.lvngAmount;
                    lvngLoanDocumentLine.Insert();
                until lvngLoanFundedDocumentLine.Next() = 0;
                exit;
            end;
        end;
        lvngLoanJournalLine.TestField(lvngProcessingSchemaCode);
        lvngLoanProcessingSchema.Get(lvngLoanJournalLine.lvngProcessingSchemaCode);
        lvngLoanJournalBatch.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngExpressionValueBuffer.reset;
        lvngExpressionValueBuffer.DeleteAll();
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        lvngLineNo := 10000;
        clear(lvngLoanDocument);
        lvngLoanDocument.init;
        if not lvngPreview then begin
            if lvngLoanProcessingSchema.lvngNoSeries <> '' then
                lvngLoanDocument.lvngDocumentNo := NoSeriesManagement.DoGetNextNo(lvngLoanProcessingSchema.lvngNoSeries, TODAY, true, false) else
                lvngLoanDocument.lvngDocumentNo := NoSeriesManagement.DoGetNextNo(lvngLoanVisionSetup.lvngFundedNoSeries, TODAY, true, false);
        end else begin
            lvngLoanDocument.lvngDocumentNo := TempDocumentLbl;
        end;
        lvngLoanDocument.Insert(true);
        lvngLoanDocument.lvngCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
        lvngLoanDocument.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
        lvngLoanDocument.lvngPostingDate := lvngLoanJournalLine.lvngDateFunded;
        lvngLoanDocument.lvngWarehouseLineCode := lvngLoanJournalLine.lvngWarehouseLineCode;
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
        lvngLoanDocumentLine.SetRange(lvngAmount, 0);
        lvngLoanDocumentLine.DeleteAll();
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(lvngBalancingEntry, false);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                lvngDocumentAmount := lvngDocumentAmount + lvngLoanDocumentLine.lvngAmount;
            until lvngLoanDocumentLine.Next() = 0;
        end;
        //Option here
        case lvngLoanProcessingSchema.lvngDocumentTypeOption of
            lvngloanprocessingschema.lvngDocumentTypeOption::lvngInvoice:
                begin
                    lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngInvoice;
                end;
            lvngloanprocessingschema.lvngDocumentTypeOption::lvngCreditMemo:
                begin
                    lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngCreditMemo;
                end;
            lvngloanprocessingschema.lvngDocumentTypeOption::lvngAmountBased:
                begin
                    IF lvngDocumentAmount > 0 THEN BEGIN
                        lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngInvoice;
                    END ELSE BEGIN
                        lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngCreditMemo;
                        lvngLoanDocumentLine.reset;
                        lvngLoanDocumentLine.SetRange(lvngBalancingEntry, false);
                        if lvngLoanDocumentLine.FindSet() then begin
                            repeat
                                lvngLoanDocumentLine.lvngAmount := -lvngLoanDocumentLine.lvngAmount;
                                lvngLoanDocumentLine.Modify();
                            until lvngLoanDocumentLine.Next() = 0;
                        end;
                    END;
                end;
            lvngloanprocessingschema.lvngDocumentTypeOption::lvngAmountBasedReversed:
                begin
                    IF lvngDocumentAmount > 0 THEN BEGIN
                        lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngCreditMemo;
                    END ELSE BEGIN
                        lvngLoanDocument.lvngDocumentType := lvngLoanDocument.lvngDocumentType::lvngInvoice;
                        lvngLoanDocumentLine.reset;
                        lvngLoanDocumentLine.SetRange(lvngBalancingEntry, false);
                        if lvngLoanDocumentLine.FindSet() then begin
                            repeat
                                lvngLoanDocumentLine.lvngAmount := -lvngLoanDocumentLine.lvngAmount;
                                lvngLoanDocumentLine.Modify();
                            until lvngLoanDocumentLine.Next() = 0;
                        end;
                    END;
                end;
        end;
        lvngLoanDocument.Modify();
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
            lvngLoanDocumentLine.lvngTransactionType := lvngLoanDocument.lvngTransactionType;
            lvngLoanDocumentLine.lvngLineNo := lvngLineNo;
            lvngLoanDocumentLine.lvngProcessingSchemaCode := lvngLoanProcessingSchemaLine.lvngProcessingCode;
            lvngloandocumentline.lvngProcessingSchemaLineNo := lvngLoanProcessingSchemaLine.lvngLineNo;
            lvngLoanDocumentLine.lvngBalancingEntry := lvngLoanProcessingSchemaLine.lvngBalancingEntry;
            lvngLoanDocumentLine.lvngTagCode := lvngLoanProcessingSchemaLine.lvngTagCode;
            lvngLoanDocumentLine.lvngServicingType := lvngLoanProcessingSchemaLine.lvngServicingType;
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
        exit(lvngExpressionEngine.CheckCondition(lvngConditionCode, lvngExpressionValueBuffer));
    end;

    local procedure GetFunctionValue(lvngFunctionCode: code[20]): Text
    begin
        exit(lvngExpressionEngine.CalculateFormula(lvngFunctionCode, lvngExpressionValueBuffer));
    end;

    local procedure GetSwitchValue(lvngSwitchCode: code[20]): Code[20]
    var
        lvngResult: Text;
    begin
        if not lvngExpressionEngine.SwitchCase(lvngSwitchCode, lvngResult, lvngExpressionValueBuffer) then
            exit('');
        exit(copystr(lvngResult, 1, 20));

    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;

        lvngExpressionValueBuffer: record lvngExpressionValueBuffer temporary;
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        lvngLoanVisionSetupRetrieved: Boolean;
}