codeunit 14135102 "lvngPostProcessingMgmt"
{

    procedure PostProcessBatch(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine;
    begin
        MainDimensionCode := lvngDimensionsManagement.GetMainHierarchyDimensionCode();
        MainDimensionNo := lvngDimensionsManagement.GetMainHierarchyDimensionNo();
        lvngDimensionsManagement.GetHierarchyDimensionsUsage(HierarchyDimensionsUsage);
        if MainDimensionNo <> 0 then
            HierarchyDimensionsUsage[MainDimensionNo] := false;
        lvngLoanJournalBatch.Get(lvngJournalBatchCode);
        lvngPostProcessingSchemaLine.reset;
        lvngPostProcessingSchemaLine.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
        if lvngPostProcessingSchemaLine.IsEmpty() then begin
            lvngLoanJournalLine.Reset();
            lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngJournalBatchCode);
            if lvngLoanJournalLine.FindSet() then begin
                repeat
                    AssignDimensions(lvngLoanJournalBatch, lvngLoanJournalLine);
                until lvngLoanJournalLine.Next() = 0;
            end;
            exit;
        end;
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
                            CalculateExpression(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngSwitchExpression:
                        begin
                            CalculateSwitch(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngDimensionMapping:
                        begin
                            MapImportedDimension(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.lvngType::lvngAssignCustomValue:
                        begin
                            AssignCustomValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                end;
            until lvngPostProcessingSchemaLine.Next() = 0;
            AssignDimensions(lvngLoanJournalBatch, lvngLoanJournalLine);
            lvngLoanJournalLine.Modify();
        until lvngLoanJournalLine.Next() = 0;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRetrieved then begin
            GLSetup.Get();
            GLSetupRetrieved := true;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not loanvisionsetupretrieved then begin
            lvngLoanVisionSetup.get;
            LoanVisionSetupRetrieved := true;
        end;
    end;

    local procedure AssignDimensions(lvngLoanJournalBatch: Record lvngLoanJournalBatch; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoan: Record lvngLoan;
        DimensionCode: Code[20];
        lvngDimensionHierarchy: Record lvngDimensionHierarchy;
        lvngHierarchyBasedOnDate: Date;
    begin
        case lvngLoanJournalBatch.lvngDimensionImportRule of
            lvngloanjournalbatch.lvngDimensionImportRule::lvngCopyAllFromLoan:
                begin
                    if lvngloan.Get(lvngLoanJournalLine.lvngLoanNo) then begin
                        lvngLoanJournalLine.lvngGlobalDimension1Code := lvngloan.lvngGlobalDimension1Code;
                        lvngLoanJournalLine.lvngGlobalDimension2Code := lvngloan.lvngGlobalDimension2Code;
                        lvngLoanJournalLine.lvngShortcutDimension3Code := lvngloan.lvngShortcutDimension3Code;
                        lvngLoanJournalLine.lvngShortcutDimension4Code := lvngloan.lvngShortcutDimension4Code;
                        lvngLoanJournalLine.lvngShortcutDimension5Code := lvngloan.lvngShortcutDimension5Code;
                        lvngLoanJournalLine.lvngShortcutDimension6Code := lvngloan.lvngShortcutDimension6Code;
                        lvngLoanJournalLine.lvngShortcutDimension7Code := lvngloan.lvngShortcutDimension7Code;
                        lvngLoanJournalLine.lvngShortcutDimension8Code := lvngloan.lvngShortcutDimension8Code;
                        lvngLoanJournalLine.lvngBusinessUnitCode := lvngLoan.lvngBusinessUnitCode;
                        lvngLoanJournalLine.Modify();
                    end;
                end;
            lvngLoanJournalBatch.lvngDimensionImportRule::lvngCopyAllFromLoanIfEmpty:
                begin
                    if lvngloan.Get(lvngLoanJournalLine.lvngLoanNo) then begin
                        if lvngLoanJournalLine.lvngGlobalDimension1Code = '' then
                            lvngLoanJournalLine.lvngGlobalDimension1Code := lvngloan.lvngGlobalDimension1Code;
                        if lvngLoanJournalLine.lvngGlobalDimension2Code = '' then
                            lvngLoanJournalLine.lvngGlobalDimension2Code := lvngloan.lvngGlobalDimension2Code;
                        if lvngLoanJournalLine.lvngShortcutDimension3Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension3Code := lvngloan.lvngShortcutDimension3Code;
                        if lvngLoanJournalLine.lvngShortcutDimension4Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension4Code := lvngloan.lvngShortcutDimension4Code;
                        if lvngLoanJournalLine.lvngShortcutDimension5Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension5Code := lvngloan.lvngShortcutDimension5Code;
                        if lvngLoanJournalLine.lvngShortcutDimension6Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension6Code := lvngloan.lvngShortcutDimension6Code;
                        if lvngLoanJournalLine.lvngShortcutDimension7Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension7Code := lvngloan.lvngShortcutDimension7Code;
                        if lvngLoanJournalLine.lvngShortcutDimension8Code = '' then
                            lvngLoanJournalLine.lvngShortcutDimension8Code := lvngloan.lvngShortcutDimension8Code;
                        if lvngLoanJournalLine.lvngBusinessUnitCode = '' then
                            lvngLoanJournalLine.lvngBusinessUnitCode := lvngLoan.lvngBusinessUnitCode;
                        lvngLoanJournalLine.Modify();
                    end;
                end;
        end;
        if lvngLoanJournalBatch.lvngMapDimensionsUsingHierachy then begin
            case MainDimensionNo of
                1:
                    DimensionCode := lvngLoanJournalLine.lvngGlobalDimension1Code;
                2:
                    DimensionCode := lvngLoanJournalLine.lvngGlobalDimension2Code;
                3:
                    DimensionCode := lvngLoanJournalLine.lvngShortcutDimension3Code;
                4:
                    DimensionCode := lvngLoanJournalLine.lvngShortcutDimension4Code;
            end;
            lvngDimensionHierarchy.reset;
            lvngDimensionHierarchy.Ascending(false);
            case lvngLoanJournalBatch.lvngDimensionHierarchyDate of
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngApplicationDate:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngApplicationDate;
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngCommissionDate:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngCommissionDate;
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngDateClosed:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngDateClosed;
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngDateFunded:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngDateFunded;
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngDateLocked:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngDateLocked;
                lvngLoanJournalBatch.lvngDimensionHierarchyDate::lvngDateSold:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine.lvngDateSold;
            end;
            lvngDimensionHierarchy.SetFilter(lvngDate, '..%1', lvngHierarchyBasedOnDate);
            lvngDimensionHierarchy.SetRange(lvngCode, DimensionCode);
            if lvngDimensionHierarchy.FindFirst() then begin
                if HierarchyDimensionsUsage[1] then
                    lvngLoanJournalLine.lvngGlobalDimension1Code := lvngDimensionHierarchy.lvngGlobalDimension1Code;
                if HierarchyDimensionsUsage[2] then
                    lvngLoanJournalLine.lvngGlobalDimension2Code := lvngDimensionHierarchy.lvngGlobalDimension2Code;
                if HierarchyDimensionsUsage[3] then
                    lvngLoanJournalLine.lvngShortcutDimension3Code := lvngDimensionHierarchy.lvngShortcutDimension3Code;
                if HierarchyDimensionsUsage[4] then
                    lvngLoanJournalLine.lvngShortcutDimension4Code := lvngDimensionHierarchy.lvngShortcutDimension4Code;
                if HierarchyDimensionsUsage[5] then
                    lvngLoanJournalLine.lvngBusinessUnitCode := lvngDimensionHierarchy.lvngBusinessUnitCode;
                lvngLoanJournalLine.Modify();
            end;
        end;
    end;

    local procedure AssignCustomValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
    begin
        if lvngPostProcessingSchemaLine.lvngAssignTo = lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField then begin
            lvngRecRefTo.GetTable(lvngLoanJournalLine);
            lvngFieldRefTo := lvngrecrefto.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
            lvngFieldRefTo.Validate(lvngPostProcessingSchemaLine.lvngCustomValue);
            lvngRecRefTo.SetTable(lvngLoanJournalLine);
            lvngRecRefTo.Close();
            lvngLoanJournalLine.Modify(true);
        end else begin
            if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngToFieldNo) then begin
                Clear(lvngLoanJournalValue);
                lvngLoanJournalValue.init;
                lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                lvngLoanJournalValue.lvngLineNo := lvngloanjournalline.lvngLineNo;
                lvngLoanJournalValue.lvngFieldNo := lvngPostProcessingSchemaLine.lvngToFieldNo;
                lvngLoanJournalValue.Insert(true);
            end;
            lvngLoanJournalValue.lvngFieldValue := copystr(lvngPostProcessingSchemaLine.lvngCustomValue, 1, MaxStrLen(lvngloanjournalvalue.lvngFieldValue));
            lvngLoanJournalValue.Modify(true);
        end;
    end;

    local procedure MapImportedDimension(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngImportDimensionMapping: Record lvngImportDimensionMapping;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
    begin
        if lvngPostProcessingSchemaLine.lvngAssignTo = lvngPostProcessingSchemaLine.lvngAssignTo::lvngLoanJournalField then begin
            if not lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngFromFieldNo) then
                exit;
            GetGLSetup();
            lvngImportDimensionMapping.reset;
            lvngImportDimensionMapping.SetRange(lvngMappingValue, lvngLoanJournalValue.lvngFieldValue);
            case lvngPostProcessingSchemaLine.lvngToFieldNo of
                80:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 1 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngGlobalDimension1Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                81:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 2 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngGlobalDimension2Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                82:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 3 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension3Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                83:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 4 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension4Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                84:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 5 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension5Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                85:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 6 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension6Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                86:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 7 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension7Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                87:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, GLSetup."Shortcut Dimension 8 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngShortcutDimension8Code := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                88:
                    begin
                        lvngImportDimensionMapping.SetRange(lvngDimensionCode, '');
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine.lvngBusinessUnitCode := lvngImportDimensionMapping.lvngDimensionValueCode;
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
            end;
        end;
    end;

    local procedure CalculateSwitch(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngResult: Text;
        lvngDecimalFieldValue: Decimal;
        SwitchCaseErrorLbl: Label 'Switch Case %1 can not be resolved';
    begin
        lvngPostProcessingSchemaLine.TestField(lvngExpressionCode);
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        if not lvngExpressionEngine.SwitchCase(lvngPostProcessingSchemaLine.lvngExpressionCode, lvngResult, lvngExpressionValueBuffer) then
            Error(SwitchCaseErrorLbl, lvngPostProcessingSchemaLine.lvngExpressionCode);
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
                    lvngLoanJournalValue.lvngFieldValue := copystr(lvngResult, 1, MaxStrLen(lvngloanjournalvalue.lvngFieldValue));
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
                    lvngFieldRefTo.Validate(lvngResult);
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

    local procedure CalculateExpression(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngResult: Text;
        lvngDecimalFieldValue: Decimal;
    begin
        lvngPostProcessingSchemaLine.TestField(lvngExpressionCode);
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        lvngResult := lvngExpressionEngine.CalculateFormula(lvngPostProcessingSchemaLine.lvngExpressionCode, lvngExpressionValueBuffer);
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
                    lvngLoanJournalValue.lvngFieldValue := copystr(lvngResult, 1, MaxStrLen(lvngloanjournalvalue.lvngFieldValue));
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
                    lvngFieldRefTo.Validate(lvngResult);
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

    local procedure CopyLoanCardValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoan: Record lvngLoan;
        lvngRecRef: RecordRef;
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngFieldRef: FieldRef;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngDecimalFieldValue: Decimal;
        lvngValue: Text;
    begin
        lvngLoan.get(lvngLoanJournalLine.lvngLoanNo);
        lvngRecRef.GetTable(lvngLoan);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine.lvngFromFieldNo);
        lvngValue := Format(lvngFieldRef.Value());
        if lvngPostProcessingSchemaLine.lvngCopyFieldPart then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine.lvngFromCharacterNo, lvngPostProcessingSchemaLine.lvngCharactersCount);
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
                    lvngLoanJournalValue.lvngFieldValue := lvngValue;
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
                    lvngFieldRefTo.Validate(lvngValue);
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
        lvngValue: Text;
    begin
        lvngRecRef.GetTable(lvngLoanJournalLine);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine.lvngFromFieldNo);
        lvngValue := Format(lvngFieldRef.Value());
        if lvngPostProcessingSchemaLine.lvngCopyFieldPart then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine.lvngFromCharacterNo, lvngPostProcessingSchemaLine.lvngCharactersCount);
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
                    lvngLoanJournalValue.lvngFieldValue := lvngValue;
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
                    lvngFieldRefTo := lvngRecRefTo.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngValue);
                    if lvngPostProcessingSchemaLine.lvngRoundExpression <> 0 then begin
                        if Evaluate(lvngDecimalFieldValue, lvngValue) then begin
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
        lvngValue: Text;
    begin
        lvngLoanJournalValueFrom.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngPostProcessingSchemaLine.lvngFromFieldNo);
        lvngValue := lvngLoanJournalValueFrom.lvngFieldValue;
        if lvngPostProcessingSchemaLine.lvngCopyFieldPart then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine.lvngFromCharacterNo, lvngPostProcessingSchemaLine.lvngCharactersCount);
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
                    lvngLoanJournalValue.lvngFieldValue := lvngValue;
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
                    lvngFieldRefTo := lvngRecRefTo.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngValue);
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
        lvngValue: Text;
    begin
        lvngLoanValueFrom.Get(lvngLoanJournalLine.lvngLoanNo, lvngPostProcessingSchemaLine.lvngFromFieldNo);
        lvngValue := lvngLoanValueFrom.lvngFieldValue;
        if lvngPostProcessingSchemaLine.lvngCopyFieldPart then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine.lvngFromCharacterNo, lvngPostProcessingSchemaLine.lvngCharactersCount);
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
                    lvngLoanJournalValue.lvngFieldValue := lvngValue;
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
                    lvngFieldRefTo := lvngRecRefTo.Field(lvngPostProcessingSchemaLine.lvngToFieldNo);
                    lvngFieldRefTo.Validate(lvngValue);
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

    local procedure CopyFieldPart(lvngInputValue: Text; lvngFromCharacterNo: Integer; lvngCharactersCount: Integer): Text
    begin
        if (lvngFromCharacterNo = 0) or (lvngFromCharacterNo > 249) or (lvngCharactersCount < 1) then
            exit;
        if StrLen(lvngInputValue) > lvngFromCharacterNo then
            exit;
        if (lvngFromCharacterNo + lvngCharactersCount) > 249 then
            exit;
        exit(copystr(lvngInputValue, lvngFromCharacterNo, lvngCharactersCount));
    end;

    var
        GLSetup: Record "General Ledger Setup";
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        GLSetupRetrieved: Boolean;
        LoanVisionSetupRetrieved: Boolean;
        MainDimensionCode: Code[20];
        HierarchyDimensionsUsage: array[5] of boolean;
        MainDimensionNo: Integer;
}