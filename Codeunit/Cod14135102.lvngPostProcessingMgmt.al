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
        lvngPostProcessingSchemaLine.SetRange("Journal Batch Code", lvngJournalBatchCode);
        if lvngPostProcessingSchemaLine.IsEmpty() then begin
            lvngLoanJournalLine.Reset();
            lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngJournalBatchCode);
            if lvngLoanJournalLine.FindSet() then begin
                repeat
                    AssignDimensions(lvngLoanJournalBatch, lvngLoanJournalLine);
                until lvngLoanJournalLine.Next() = 0;
            end;
            exit;
        end;
        lvngPostProcessingSchemaLine.SetCurrentKey(Priority);
        lvngLoanJournalLine.Reset();
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngJournalBatchCode);
        lvngLoanJournalLine.FindSet();
        repeat
            lvngPostProcessingSchemaLine.FindSet();
            repeat
                case lvngPostProcessingSchemaLine.Type of
                    lvngPostProcessingSchemaLine.Type::lvngCopyLoanCardValue:
                        begin
                            CopyLoanCardValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngCopyLoanJournalValue:
                        begin
                            CopyLoanJournalValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngCopyLoanJournalVariableValue:
                        begin
                            CopyLoanJournalVariableValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngCopyLoanVariableValue:
                        begin
                            CopyLoanVariableValue(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngExpression:
                        begin
                            CalculateExpression(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngSwitchExpression:
                        begin
                            CalculateSwitch(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngDimensionMapping:
                        begin
                            MapImportedDimension(lvngPostProcessingSchemaLine, lvngLoanJournalLine);
                        end;
                    lvngPostProcessingSchemaLine.Type::lvngAssignCustomValue:
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
        case lvngLoanJournalBatch."Dimension Import Rule" of
            lvngloanjournalbatch."Dimension Import Rule"::lvngCopyAllFromLoan:
                begin
                    if lvngloan.Get(lvngLoanJournalLine."Loan No.") then begin
                        lvngLoanJournalLine."Global Dimension 1 Code" := lvngloan."Global Dimension 1 Code";
                        lvngLoanJournalLine."Global Dimension 2 Code" := lvngloan."Global Dimension 2 Code";
                        lvngLoanJournalLine."Shortcut Dimension 3 Code" := lvngloan."Shortcut Dimension 3 Code";
                        lvngLoanJournalLine."Shortcut Dimension 4 Code" := lvngloan."Shortcut Dimension 4 Code";
                        lvngLoanJournalLine."Shortcut Dimension 5 Code" := lvngloan."Shortcut Dimension 5 Code";
                        lvngLoanJournalLine."Shortcut Dimension 6 Code" := lvngloan."Shortcut Dimension 6 Code";
                        lvngLoanJournalLine."Shortcut Dimension 7 Code" := lvngloan."Shortcut Dimension 7 Code";
                        lvngLoanJournalLine."Shortcut Dimension 8 Code" := lvngloan."Shortcut Dimension 8 Code";
                        lvngLoanJournalLine."Business Unit Code" := lvngLoan."Business Unit Code";
                        lvngLoanJournalLine.Modify();
                    end;
                end;
            lvngLoanJournalBatch."Dimension Import Rule"::lvngCopyAllFromLoanIfEmpty:
                begin
                    if lvngloan.Get(lvngLoanJournalLine."Loan No.") then begin
                        if lvngLoanJournalLine."Global Dimension 1 Code" = '' then
                            lvngLoanJournalLine."Global Dimension 1 Code" := lvngloan."Global Dimension 1 Code";
                        if lvngLoanJournalLine."Global Dimension 2 Code" = '' then
                            lvngLoanJournalLine."Global Dimension 2 Code" := lvngloan."Global Dimension 2 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 3 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 3 Code" := lvngloan."Shortcut Dimension 3 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 4 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 4 Code" := lvngloan."Shortcut Dimension 4 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 5 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 5 Code" := lvngloan."Shortcut Dimension 5 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 6 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 6 Code" := lvngloan."Shortcut Dimension 6 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 7 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 7 Code" := lvngloan."Shortcut Dimension 7 Code";
                        if lvngLoanJournalLine."Shortcut Dimension 8 Code" = '' then
                            lvngLoanJournalLine."Shortcut Dimension 8 Code" := lvngloan."Shortcut Dimension 8 Code";
                        if lvngLoanJournalLine."Business Unit Code" = '' then
                            lvngLoanJournalLine."Business Unit Code" := lvngLoan."Business Unit Code";
                        lvngLoanJournalLine.Modify();
                    end;
                end;
        end;
        if lvngLoanJournalBatch."Map Dimensions Using Hierachy" then begin
            case MainDimensionNo of
                1:
                    DimensionCode := lvngLoanJournalLine."Global Dimension 1 Code";
                2:
                    DimensionCode := lvngLoanJournalLine."Global Dimension 2 Code";
                3:
                    DimensionCode := lvngLoanJournalLine."Shortcut Dimension 3 Code";
                4:
                    DimensionCode := lvngLoanJournalLine."Shortcut Dimension 4 Code";
            end;
            lvngDimensionHierarchy.reset;
            lvngDimensionHierarchy.Ascending(false);
            case lvngLoanJournalBatch."Dimension Hierarchy Date" of
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngApplicationDate:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Application Date";
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngCommissionDate:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Commission Date";
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngDateClosed:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Date Closed";
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngDateFunded:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Date Funded";
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngDateLocked:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Date Locked";
                lvngLoanJournalBatch."Dimension Hierarchy Date"::lvngDateSold:
                    lvngHierarchyBasedOnDate := lvngLoanJournalLine."Date Sold";
            end;
            lvngDimensionHierarchy.SetFilter(Date, '..%1', lvngHierarchyBasedOnDate);
            lvngDimensionHierarchy.SetRange(Code, DimensionCode);
            if lvngDimensionHierarchy.FindFirst() then begin
                if HierarchyDimensionsUsage[1] then
                    lvngLoanJournalLine."Global Dimension 1 Code" := lvngDimensionHierarchy."Global Dimension 1 Code";
                if HierarchyDimensionsUsage[2] then
                    lvngLoanJournalLine."Global Dimension 2 Code" := lvngDimensionHierarchy."Global Dimension 2 Code";
                if HierarchyDimensionsUsage[3] then
                    lvngLoanJournalLine."Shortcut Dimension 3 Code" := lvngDimensionHierarchy."Shortcut Dimension 3 Code";
                if HierarchyDimensionsUsage[4] then
                    lvngLoanJournalLine."Shortcut Dimension 4 Code" := lvngDimensionHierarchy."Shortcut Dimension 4 Code";
                if HierarchyDimensionsUsage[5] then
                    lvngLoanJournalLine."Business Unit Code" := lvngDimensionHierarchy."Business Unit Code";
                lvngLoanJournalLine.Modify();
            end;
        end;
    end;

    local procedure AssignCustomValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    begin
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngPostProcessingSchemaLine."Custom Value");
    end;

    local procedure MapImportedDimension(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngImportDimensionMapping: Record lvngImportDimensionMapping;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
    begin
        if lvngPostProcessingSchemaLine."Assign To" = lvngPostProcessingSchemaLine."Assign To"::lvngLoanJournalField then begin
            if not lvngLoanJournalValue.Get(lvngLoanJournalLine."Loan Journal Batch Code", lvngLoanJournalLine."Line No.", lvngPostProcessingSchemaLine."From Field No.") then
                exit;
            GetGLSetup();
            lvngImportDimensionMapping.reset;
            lvngImportDimensionMapping.SetRange("Mapping Value", lvngLoanJournalValue."Field Value");
            case lvngPostProcessingSchemaLine."To Field No." of
                80:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Global Dimension 1 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                81:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Global Dimension 2 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                82:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 3 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                83:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 4 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                84:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 5 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                85:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 6 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                86:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 7 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                87:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Shortcut Dimension 8 Code" := lvngImportDimensionMapping."Dimension Value Code";
                            lvngLoanJournalLine.Modify();
                        end;
                    end;
                88:
                    begin
                        lvngImportDimensionMapping.SetRange("Dimension Code", '');
                        if lvngImportDimensionMapping.FindFirst() then begin
                            lvngLoanJournalLine."Business Unit Code" := lvngImportDimensionMapping."Dimension Value Code";
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
        ExpressionHeader: Record lvngExpressionHeader;
        lvngValue: Text;
        SwitchCaseErrorLbl: Label 'Switch Case %1 can not be resolved';
    begin
        lvngPostProcessingSchemaLine.TestField("Expression Code");
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        ExpressionHeader.Get(lvngPostProcessingSchemaLine."Expression Code", lvngConditionsMgmt.GetConditionsMgmtConsumerId());
        if not lvngExpressionEngine.SwitchCase(ExpressionHeader, lvngValue, lvngExpressionValueBuffer) then
            Error(SwitchCaseErrorLbl, lvngPostProcessingSchemaLine."Expression Code");
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure CalculateExpression(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        lvngValue: Text;
    begin
        lvngPostProcessingSchemaLine.TestField("Expression Code");
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        ExpressionHeader.Get(lvngPostProcessingSchemaLine."Expression Code", lvngConditionsMgmt.GetConditionsMgmtConsumerId());
        lvngValue := lvngExpressionEngine.CalculateFormula(ExpressionHeader, lvngExpressionValueBuffer);
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure CopyLoanCardValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoan: Record lvngLoan;
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngValue: Text;
    begin
        lvngLoan.get(lvngLoanJournalLine."Loan No.");
        lvngRecRef.GetTable(lvngLoan);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine."From Field No.");
        lvngValue := Format(lvngFieldRef.Value());
        if lvngPostProcessingSchemaLine."Copy Field Part" then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine."From Character No.", lvngPostProcessingSchemaLine."Characters Count");
        lvngRecRef.Close();
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure CopyLoanJournalValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngValue: Text;
    begin
        lvngRecRef.GetTable(lvngLoanJournalLine);
        lvngFieldRef := lvngRecRef.Field(lvngPostProcessingSchemaLine."From Field No.");
        lvngValue := lvngFieldRef.Value();
        if lvngPostProcessingSchemaLine."Copy Field Part" then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine."From Character No.", lvngPostProcessingSchemaLine."Characters Count");
        lvngRecRef.Close();
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure CopyLoanJournalVariableValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoanJournalValueFrom: record lvngLoanJournalValue;
        lvngValue: Text;
    begin
        lvngLoanJournalValueFrom.Get(lvngLoanJournalLine."Loan Journal Batch Code", lvngLoanJournalLine."Line No.", lvngPostProcessingSchemaLine."From Field No.");
        lvngValue := lvngLoanJournalValueFrom."Field Value";
        if lvngPostProcessingSchemaLine."Copy Field Part" then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine."From Character No.", lvngPostProcessingSchemaLine."Characters Count");
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure CopyLoanVariableValue(lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var lvngLoanJournalLine: record lvngLoanJournalLine)
    var
        lvngLoanValueFrom: record lvngLoanValue;
        lvngValue: Text;
    begin
        lvngLoanValueFrom.Get(lvngLoanJournalLine."Loan No.", lvngPostProcessingSchemaLine."From Field No.");
        lvngValue := lvngLoanValueFrom."Field Value";
        if lvngPostProcessingSchemaLine."Copy Field Part" then
            lvngValue := CopyFieldPart(lvngValue, lvngPostProcessingSchemaLine."From Character No.", lvngPostProcessingSchemaLine."Characters Count");
        AssignFieldValue(lvngLoanJournalLine, lvngPostProcessingSchemaLine, lvngValue);
    end;

    local procedure AssignFieldValue(var lvngLoanJournalLine: Record lvngLoanJournalLine; lvngPostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; lvngValue: Text)
    var
        lvngRecRefTo: RecordRef;
        lvngFieldRefTo: FieldRef;
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngDecimalValue: Decimal;
    begin
        case lvngPostProcessingSchemaLine."Assign To" of
            lvngPostProcessingSchemaLine."Assign To"::lvngLoanJournalVariableField:
                begin
                    if not lvngLoanJournalValue.Get(lvngLoanJournalLine."Loan Journal Batch Code", lvngLoanJournalLine."Line No.", lvngPostProcessingSchemaLine."To Field No.") then begin
                        Clear(lvngLoanJournalValue);
                        lvngLoanJournalValue.init;
                        lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                        lvngLoanJournalValue."Line No." := lvngloanjournalline."Line No.";
                        lvngLoanJournalValue."Field No." := lvngPostProcessingSchemaLine."To Field No.";
                        lvngLoanJournalValue.Insert(true);
                    end;
                    lvngLoanJournalValue."Field Value" := lvngValue;
                    if lvngPostProcessingSchemaLine."Rounding Expression" <> 0 then begin
                        if Evaluate(lvngDecimalValue, lvngLoanJournalValue."Field Value") then begin
                            lvngLoanJournalValue."Field Value" := Format(Round(lvngDecimalValue, lvngPostProcessingSchemaLine."Rounding Expression"));
                        end;
                    end;
                    lvngLoanJournalValue.Modify(true);
                end;
            lvngPostProcessingSchemaLine."Assign To"::lvngLoanJournalField:
                begin
                    lvngRecRefTo.GetTable(lvngLoanJournalLine);
                    lvngFieldRefTo := lvngRecRefTo.Field(lvngPostProcessingSchemaLine."To Field No.");
                    AssignFieldRefValue(lvngFieldRefTo, lvngPostProcessingSchemaLine."Rounding Expression", lvngValue);
                    lvngRecRefTo.SetTable(lvngLoanJournalLine);
                    lvngRecRefTo.Close();
                    lvngLoanJournalLine.Modify(true);
                end;
        end;
    end;

    local procedure AssignFieldRefValue(var lvngFieldRefTo: FieldRef; lvngRoundExpression: Decimal; lvngValue: Text)
    var
        lvngDateValue: Date;
        lvngDecimalValue: Decimal;
        lvngIntegerValue: Integer;
        lvngBooleanValue: Boolean;
    begin
        case lvngFieldRefTo.Type of
            lvngFieldRefTo.Type::Boolean:
                begin
                    if not Evaluate(lvngBooleanValue, lvngValue) then
                        lvngBooleanValue := false;
                    lvngFieldRefTo.Validate(lvngBooleanValue);
                end;
            lvngFieldRefTo.Type::Decimal:
                begin
                    if not Evaluate(lvngDecimalValue, lvngValue) then
                        lvngDecimalValue := 0;
                    if lvngRoundExpression <> 0 then begin
                        lvngFieldRefTo.Validate(Round(lvngDecimalValue, lvngRoundExpression));
                    end else begin
                        lvngFieldRefTo.Validate(lvngDecimalValue);
                    end;
                end;
            lvngFieldRefTo.Type::Integer:
                begin
                    if not Evaluate(lvngIntegerValue, lvngValue) then
                        lvngIntegerValue := 0;
                    lvngFieldRefTo.Validate(lvngIntegerValue);
                end;
            lvngFieldRefTo.Type::Date:
                begin
                    if not Evaluate(lvngDateValue, lvngValue) then
                        lvngDateValue := 0D;
                    lvngFieldRefTo.Validate(lvngDateValue);
                end;
            else begin
                    lvngFieldRefTo.Validate(lvngValue);
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