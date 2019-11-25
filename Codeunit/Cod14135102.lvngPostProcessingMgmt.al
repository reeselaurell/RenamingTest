codeunit 14135102 lvngPostProcessingMgmt
{
    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRetrieved: Boolean;
        MainDimensionNo: Integer;
        HierarchyDimensionsUsage: array[5] of Boolean;

    procedure PostProcessBatch(JournalBatchCode: Code[20])
    var
        LoanJournalBatch: Record lvngLoanJournalBatch;
        LoanJournalLine: Record lvngLoanJournalLine;
        PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine;
        DimensionsManagement: Codeunit lvngDimensionsManagement;
    begin
        MainDimensionNo := DimensionsManagement.GetMainHierarchyDimensionNo();
        DimensionsManagement.GetHierarchyDimensionsUsage(HierarchyDimensionsUsage);
        if MainDimensionNo <> 0 then
            HierarchyDimensionsUsage[MainDimensionNo] := false;
        LoanJournalBatch.Get(JournalBatchCode);
        PostProcessingSchemaLine.Reset();
        PostProcessingSchemaLine.SetRange("Journal Batch Code", JournalBatchCode);
        if PostProcessingSchemaLine.IsEmpty() then begin
            LoanJournalLine.Reset();
            LoanJournalLine.SetRange("Loan Journal Batch Code", JournalBatchCode);
            if LoanJournalLine.FindSet() then
                repeat
                    AssignDimensions(LoanJournalBatch, LoanJournalLine);
                until LoanJournalLine.Next() = 0;
            exit;
        end;
        PostProcessingSchemaLine.SetCurrentKey(Priority);
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code", JournalBatchCode);
        LoanJournalLine.FindSet();
        repeat
            PostProcessingSchemaLine.FindSet();
            repeat
                case PostProcessingSchemaLine.Type of
                    PostProcessingSchemaLine.Type::"Copy Loan Card Value":
                        CopyLoanCardValue(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Copy Loan Journal Value":
                        CopyLoanJournalValue(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Copy Loan Journal Variable Value":
                        CopyLoanJournalVariableValue(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Copy Loan Variable Value":
                        CopyLoanVariableValue(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Formula Expression":
                        CalculateFormula(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Switch Expression":
                        CalculateSwitch(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Dimension Mapping":
                        MapImportedDimension(PostProcessingSchemaLine, LoanJournalLine);
                    PostProcessingSchemaLine.Type::"Assign Custom Value":
                        AssignCustomValue(PostProcessingSchemaLine, LoanJournalLine);
                end;
            until PostProcessingSchemaLine.Next() = 0;
            AssignDimensions(LoanJournalBatch, LoanJournalLine);
            LoanJournalLine.Modify();
        until LoanJournalLine.Next() = 0;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRetrieved then begin
            GLSetup.Get();
            GLSetupRetrieved := true;
        end;
    end;

    local procedure AssignDimensions(LoanJournalBatch: Record lvngLoanJournalBatch; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        Loan: Record lvngLoan;
        DimensionCode: Code[20];
        DimensionHierarchy: Record lvngDimensionHierarchy;
        HierarchyBasedOnDate: Date;
    begin
        case LoanJournalBatch."Dimension Import Rule" of
            LoanJournalBatch."Dimension Import Rule"::"Copy All From Loan":
                begin
                    if Loan.Get(LoanJournalLine."Loan No.") then begin
                        LoanJournalLine."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                        LoanJournalLine."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                        LoanJournalLine."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                        LoanJournalLine."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                        LoanJournalLine."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                        LoanJournalLine."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                        LoanJournalLine."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                        LoanJournalLine."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                        LoanJournalLine."Business Unit Code" := Loan."Business Unit Code";
                        LoanJournalLine.Modify();
                    end;
                end;
            LoanJournalBatch."Dimension Import Rule"::"Copy All From Loan If Empty":
                begin
                    if Loan.Get(LoanJournalLine."Loan No.") then begin
                        if LoanJournalLine."Global Dimension 1 Code" = '' then
                            LoanJournalLine."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                        if LoanJournalLine."Global Dimension 2 Code" = '' then
                            LoanJournalLine."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                        if LoanJournalLine."Shortcut Dimension 3 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                        if LoanJournalLine."Shortcut Dimension 4 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                        if LoanJournalLine."Shortcut Dimension 5 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                        if LoanJournalLine."Shortcut Dimension 6 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                        if LoanJournalLine."Shortcut Dimension 7 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                        if LoanJournalLine."Shortcut Dimension 8 Code" = '' then
                            LoanJournalLine."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                        if LoanJournalLine."Business Unit Code" = '' then
                            LoanJournalLine."Business Unit Code" := Loan."Business Unit Code";
                        LoanJournalLine.Modify();
                    end;
                end;
        end;
        if LoanJournalBatch."Map Dimensions Using Hierachy" then begin
            case MainDimensionNo of
                1:
                    DimensionCode := LoanJournalLine."Global Dimension 1 Code";
                2:
                    DimensionCode := LoanJournalLine."Global Dimension 2 Code";
                3:
                    DimensionCode := LoanJournalLine."Shortcut Dimension 3 Code";
                4:
                    DimensionCode := LoanJournalLine."Shortcut Dimension 4 Code";
            end;
            DimensionHierarchy.Reset();
            DimensionHierarchy.Ascending(false);
            case LoanJournalBatch."Dimension Hierarchy Date" of
                LoanJournalBatch."Dimension Hierarchy Date"::Application:
                    HierarchyBasedOnDate := LoanJournalLine."Application Date";
                LoanJournalBatch."Dimension Hierarchy Date"::Commission:
                    HierarchyBasedOnDate := LoanJournalLine."Commission Date";
                LoanJournalBatch."Dimension Hierarchy Date"::Closed:
                    HierarchyBasedOnDate := LoanJournalLine."Date Closed";
                LoanJournalBatch."Dimension Hierarchy Date"::Funded:
                    HierarchyBasedOnDate := LoanJournalLine."Date Funded";
                LoanJournalBatch."Dimension Hierarchy Date"::Locked:
                    HierarchyBasedOnDate := LoanJournalLine."Date Locked";
                LoanJournalBatch."Dimension Hierarchy Date"::Sold:
                    HierarchyBasedOnDate := LoanJournalLine."Date Sold";
            end;
            DimensionHierarchy.SetFilter(Date, '..%1', HierarchyBasedOnDate);
            DimensionHierarchy.SetRange(Code, DimensionCode);
            if DimensionHierarchy.FindFirst() then begin
                if HierarchyDimensionsUsage[1] then
                    LoanJournalLine."Global Dimension 1 Code" := DimensionHierarchy."Global Dimension 1 Code";
                if HierarchyDimensionsUsage[2] then
                    LoanJournalLine."Global Dimension 2 Code" := DimensionHierarchy."Global Dimension 2 Code";
                if HierarchyDimensionsUsage[3] then
                    LoanJournalLine."Shortcut Dimension 3 Code" := DimensionHierarchy."Shortcut Dimension 3 Code";
                if HierarchyDimensionsUsage[4] then
                    LoanJournalLine."Shortcut Dimension 4 Code" := DimensionHierarchy."Shortcut Dimension 4 Code";
                if HierarchyDimensionsUsage[5] then
                    LoanJournalLine."Business Unit Code" := DimensionHierarchy."Business Unit Code";
                LoanJournalLine.Modify();
            end;
        end;
    end;

    local procedure AssignCustomValue(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    begin
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, PostProcessingSchemaLine."Custom Value");
    end;

    local procedure MapImportedDimension(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        ImportDimensionMapping: Record lvngImportDimensionMapping;
        LoanJournalValue: Record lvngLoanJournalValue;
    begin
        if PostProcessingSchemaLine."Assign To" = PostProcessingSchemaLine."Assign To"::"Loan Journal Field" then begin
            if not LoanJournalValue.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", PostProcessingSchemaLine."From Field No.") then
                exit;
            GetGLSetup();
            ImportDimensionMapping.Reset();
            ImportDimensionMapping.SetRange("Mapping Value", LoanJournalValue."Field Value");
            case PostProcessingSchemaLine."To Field No." of
                80:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Global Dimension 1 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                81:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Global Dimension 2 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                82:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 3 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                83:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 4 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                84:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 5 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                85:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 6 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                86:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 7 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                87:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Shortcut Dimension 8 Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
                88:
                    begin
                        ImportDimensionMapping.SetRange("Dimension Code", '');
                        if ImportDimensionMapping.FindFirst() then begin
                            LoanJournalLine."Business Unit Code" := ImportDimensionMapping."Dimension Value Code";
                            LoanJournalLine.Modify();
                        end;
                    end;
            end;
        end;
    end;

    local procedure CalculateSwitch(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionEngine: Codeunit lvngExpressionEngine;
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        Value: Text;
        SwitchCaseErr: Label 'Switch Case %1 can not be resolved';
    begin
        PostProcessingSchemaLine.TestField("Expression Code");
        ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine);
        ExpressionHeader.Get(PostProcessingSchemaLine."Expression Code", ConditionsMgmt.GetConditionsMgmtConsumerId());
        if not ExpressionEngine.SwitchCase(ExpressionHeader, Value, ExpressionValueBuffer) then
            Error(SwitchCaseErr, PostProcessingSchemaLine."Expression Code");
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure CalculateFormula(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionEngine: Codeunit lvngExpressionEngine;
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        Value: Text;
    begin
        PostProcessingSchemaLine.TestField("Expression Code");
        ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine);
        ExpressionHeader.Get(PostProcessingSchemaLine."Expression Code", ConditionsMgmt.GetConditionsMgmtConsumerId());
        Value := ExpressionEngine.CalculateFormula(ExpressionHeader, ExpressionValueBuffer);
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure CopyLoanCardValue(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        Loan: Record lvngLoan;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        Value: Text;
    begin
        Loan.Get(LoanJournalLine."Loan No.");
        RecordReference.GetTable(Loan);
        FieldReference := RecordReference.Field(PostProcessingSchemaLine."From Field No.");
        Value := Format(FieldReference.Value());
        if PostProcessingSchemaLine."Copy Field Part" then
            Value := CopyFieldPart(Value, PostProcessingSchemaLine."From Character No.", PostProcessingSchemaLine."Characters Count");
        RecordReference.Close();
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure CopyLoanJournalValue(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        Value: Text;
    begin
        RecordReference.GetTable(LoanJournalLine);
        FieldReference := RecordReference.Field(PostProcessingSchemaLine."From Field No.");
        Value := FieldReference.Value();
        if PostProcessingSchemaLine."Copy Field Part" then
            Value := CopyFieldPart(Value, PostProcessingSchemaLine."From Character No.", PostProcessingSchemaLine."Characters Count");
        RecordReference.Close();
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure CopyLoanJournalVariableValue(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        LoanJournalValueFrom: record lvngLoanJournalValue;
        Value: Text;
    begin
        LoanJournalValueFrom.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", PostProcessingSchemaLine."From Field No.");
        Value := LoanJournalValueFrom."Field Value";
        if PostProcessingSchemaLine."Copy Field Part" then
            Value := CopyFieldPart(Value, PostProcessingSchemaLine."From Character No.", PostProcessingSchemaLine."Characters Count");
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure CopyLoanVariableValue(PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; var LoanJournalLine: Record lvngLoanJournalLine)
    var
        LoanValueFrom: record lvngLoanValue;
        Value: Text;
    begin
        LoanValueFrom.Get(LoanJournalLine."Loan No.", PostProcessingSchemaLine."From Field No.");
        Value := LoanValueFrom."Field Value";
        if PostProcessingSchemaLine."Copy Field Part" then
            Value := CopyFieldPart(Value, PostProcessingSchemaLine."From Character No.", PostProcessingSchemaLine."Characters Count");
        AssignFieldValue(LoanJournalLine, PostProcessingSchemaLine, Value);
    end;

    local procedure AssignFieldValue(var LoanJournalLine: Record lvngLoanJournalLine; PostProcessingSchemaLine: Record lvngPostProcessingSchemaLine; Value: Text)
    var
        RecordRefTo: RecordRef;
        FieldRefTo: FieldRef;
        LoanJournalValue: Record lvngLoanJournalValue;
        DecimalValue: Decimal;
    begin
        case PostProcessingSchemaLine."Assign To" of
            PostProcessingSchemaLine."Assign To"::"Loan Journal Variable Field":
                begin
                    if not LoanJournalValue.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", PostProcessingSchemaLine."To Field No.") then begin
                        Clear(LoanJournalValue);
                        LoanJournalValue.Init();
                        LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                        LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                        LoanJournalValue."Field No." := PostProcessingSchemaLine."To Field No.";
                        LoanJournalValue.Insert(true);
                    end;
                    LoanJournalValue."Field Value" := Value;
                    if PostProcessingSchemaLine."Rounding Expression" <> 0 then begin
                        if Evaluate(DecimalValue, LoanJournalValue."Field Value") then begin
                            LoanJournalValue."Field Value" := Format(Round(DecimalValue, PostProcessingSchemaLine."Rounding Expression"));
                        end;
                    end;
                    LoanJournalValue.Modify(true);
                end;
            PostProcessingSchemaLine."Assign To"::"Loan Journal Field":
                begin
                    RecordRefTo.GetTable(LoanJournalLine);
                    FieldRefTo := RecordRefTo.Field(PostProcessingSchemaLine."To Field No.");
                    AssignFieldRefValue(FieldRefTo, PostProcessingSchemaLine."Rounding Expression", Value);
                    RecordRefTo.SetTable(LoanJournalLine);
                    RecordRefTo.Close();
                    LoanJournalLine.Modify(true);
                end;
        end;
    end;

    local procedure AssignFieldRefValue(var FieldRefTo: FieldRef; RoundExpression: Decimal; Value: Text)
    var
        DateValue: Date;
        DecimalValue: Decimal;
        IntegerValue: Integer;
        BooleanValue: Boolean;
    begin
        case FieldRefTo.Type of
            FieldRefTo.Type::Boolean:
                begin
                    if not Evaluate(BooleanValue, Value) then
                        BooleanValue := false;
                    FieldRefTo.Validate(BooleanValue);
                end;
            FieldRefTo.Type::Decimal:
                begin
                    if not Evaluate(DecimalValue, Value) then
                        DecimalValue := 0;
                    if RoundExpression <> 0 then
                        FieldRefTo.Validate(Round(DecimalValue, RoundExpression))
                    else
                        FieldRefTo.Validate(DecimalValue);
                end;
            FieldRefTo.Type::Integer:
                begin
                    if not Evaluate(IntegerValue, Value) then
                        IntegerValue := 0;
                    FieldRefTo.Validate(IntegerValue);
                end;
            FieldRefTo.Type::Date:
                begin
                    if not Evaluate(DateValue, Value) then
                        DateValue := 0D;
                    FieldRefTo.Validate(DateValue);
                end;
            else
                FieldRefTo.Validate(Value);
        end;
    end;

    local procedure CopyFieldPart(InputValue: Text; FromCharacterNo: Integer; CharactersCount: Integer): Text
    begin
        if (FromCharacterNo = 0) or (CharactersCount < 1) then
            exit;
        if StrLen(InputValue) <= FromCharacterNo then
            exit;
        exit(copystr(InputValue, FromCharacterNo, CharactersCount));
    end;
}