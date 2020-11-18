codeunit 14135128 "lvnExpressionEngine"
{
    var
        WrongTypeErr: Label 'Wrong expression type';
        InvalidExpressionErr: Label 'Invalid expression';
        UnrecognizedFieldErr: Label 'Unrecognized field name: %1';
        UnrecognizedTypeErr: Label 'Unrecognized value type: %1';

    procedure CheckCondition(
        var ExpressionHeader: Record lvnExpressionHeader;
        var ValueBuffer: Record lvnExpressionValueBuffer): Boolean
    var
        ExpressionLine: Record lvnExpressionLine;
        TempValueBuffer: Record lvnExpressionValueBuffer temporary;
        Expression: Text;
        LowerExpression: Text;
        ExpressionType: Option "And","Or",Complex;
        LineNo: Integer;
        PrevNo: Integer;
        LeftHand: Text;
        RightHand: Text;
        Result: Boolean;
        Comparison: Enum lvnComparison;
    begin
        if ExpressionHeader.Type <> ExpressionHeader.Type::Condition then
            Error(WrongTypeErr);
        Expression := GetFormulaFromLines(ExpressionHeader);
        if Expression = '' then begin
            Expression := 'and';
            ExpressionType := ExpressionType::"And";
        end else begin
            LowerExpression := LowerCase(Expression);
            case LowerExpression of
                'and':
                    ExpressionType := ExpressionType::"And";
                'or':
                    ExpressionType := ExpressionType::"Or";
                else
                    ExpressionType := ExpressionType::Complex;
            end;
        end;
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        ExpressionLine.SetFilter("Line No.", '>%1', 0);
        if not ExpressionLine.FindSet() then
            exit(false);
        LineNo := 1;
        repeat
            if PrevNo <> ExpressionLine."Line No." then begin
                if LeftHand <> '' then begin
                    Result := ResolveCondition(LeftHand, Comparison, RightHand, ValueBuffer);
                    case ExpressionType of
                        ExpressionType::"And":
                            if not Result then
                                exit(false);
                        ExpressionType::"Or":
                            if Result then
                                exit(true);
                        ExpressionType::Complex:
                            begin
                                TempValueBuffer.Number := LineNo;
                                TempValueBuffer.Name := 'Condition #' + Format(LineNo);
                                TempValueBuffer.Type := 'Boolean';
                                if Result then
                                    TempValueBuffer.Value := 'True'
                                else
                                    TempValueBuffer.Value := 'False';
                                LineNo := LineNo + 1;
                                TempValueBuffer.Insert();
                            end;
                    end;
                end;
                LeftHand := ExpressionLine."Left Side";
                RightHand := ExpressionLine."Right Side";
                Comparison := ExpressionLine.Comparison;
            end else begin
                LeftHand := LeftHand + ExpressionLine."Left Side";
                RightHand := RightHand + ExpressionLine."Right Side";
            end;
        until ExpressionLine.Next() = 0;
        Result := ResolveCondition(LeftHand, Comparison, RightHand, ValueBuffer);
        case ExpressionType of
            ExpressionType::"And":
                if not Result then
                    exit(false);
            ExpressionType::"Or":
                if Result then
                    exit(true);
            ExpressionType::Complex:
                begin
                    TempValueBuffer.Number := LineNo;
                    TempValueBuffer.Name := 'Condition #' + Format(LineNo);
                    TempValueBuffer.Type := 'Boolean';
                    if Result then
                        TempValueBuffer.Value := 'True'
                    else
                        TempValueBuffer.Value := 'False';
                    LineNo := LineNo + 1;
                    TempValueBuffer.Insert();
                end;
        end;
        ValueBuffer.Reset();
        ValueBuffer.SetRange(Type, 'Boolean');
        if ValueBuffer.FindSet() then
            repeat
                TempValueBuffer := ValueBuffer;
                TempValueBuffer.Insert();
            until ValueBuffer.Next() = 0;
        Evaluate(Result, CalculateValue(Expression, TempValueBuffer));
        exit(Result);
    end;

    procedure CalculateFormula(
        var ExpressionHeader: Record lvnExpressionHeader;
        var ValueBuffer: Record lvnExpressionValueBuffer): Text
    var
        Formula: Text;
    begin
        if ExpressionHeader.Type <> ExpressionHeader.Type::Formula then
            Error(WrongTypeErr);
        Formula := GetFormulaFromLines(ExpressionHeader);
        if Formula = '' then
            exit('');
        exit(CalculateValue(Formula, ValueBuffer));
    end;

    procedure SwitchCase(
        var ExpressionHeader: Record lvnExpressionHeader;
        var Result: Text;
        var ValueBuffer: Record lvnExpressionValueBuffer): Boolean
    var
        CaseLine: Record lvnExpressionLine;
        Value: Text;
        PrevNo: Integer;
        Predicate: Text;
        Returns: Text;
    begin
        if ExpressionHeader.Type <> ExpressionHeader.Type::Switch then
            Error(WrongTypeErr);
        ExpressionHeader.Type := ExpressionHeader.Type::Formula;
        Value := CalculateFormula(ExpressionHeader, ValueBuffer);
        CaseLine.Reset();
        CaseLine.SetRange("Expression Code", ExpressionHeader.Code);
        CaseLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        CaseLine.SetFilter("Line No.", '>%1', 0);
        if not CaseLine.FindSet() then
            exit(false);
        repeat
            if PrevNo <> CaseLine."Line No." then begin
                if Predicate <> '' then
                    if MatchesPredicate(Value, Predicate) then begin
                        Result := CalculateOrReturnValue(Returns, ValueBuffer);
                        exit(true);
                    end;
                Predicate := CaseLine."Left Side";
                Returns := CaseLine."Right Side";
                PrevNo := CaseLine."Line No.";
            end else begin
                Predicate := Predicate + CaseLine."Left Side";
                Returns := Returns + CaseLine."Right Side";
            end;
        until CaseLine.Next() = 0;
        if MatchesPredicate(Value, Predicate) then begin
            Result := CalculateOrReturnValue(Returns, ValueBuffer);
            exit(true);
        end else
            exit(false);
    end;

    procedure Iif(
        var ConditionHeader: Record lvnExpressionHeader;
        var TrueFormulaHeader: Record lvnExpressionHeader;
        var FalseFormulaHeader: Record lvnExpressionHeader;
        var ValueBuffer: Record lvnExpressionValueBuffer): Text
    begin
        if ConditionHeader.Type <> ConditionHeader.Type::Condition then
            Error(WrongTypeErr);
        if CheckCondition(ConditionHeader, ValueBuffer) then begin
            if TrueFormulaHeader.Type <> TrueFormulaHeader.Type::Formula then
                Error(WrongTypeErr);
            exit(CalculateFormula(TrueFormulaHeader, ValueBuffer));
        end else begin
            if FalseFormulaHeader.Type <> FalseFormulaHeader.Type::Formula then
                Error(WrongTypeErr);
            exit(CalculateFormula(FalseFormulaHeader, ValueBuffer));
        end;
    end;

    procedure Iif(
        var ExpressionHeader: Record lvnExpressionHeader;
        var ValueBuffer: Record lvnExpressionValueBuffer): Text
    var
        ExpressionLine: Record lvnExpressionLine;
        LeftHand: Text;
        RightHand: Text;
        Return: Text;
        Comparison: Enum lvnComparison;
        Result: Boolean;
    begin
        if ExpressionHeader.Type <> ExpressionHeader.Type::Iif then
            Error(WrongTypeErr);
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        ExpressionLine.SetRange("Line No.", 0);
        ExpressionLine.FindSet();
        repeat
            LeftHand += ExpressionLine."Left Side";
            RightHand += ExpressionLine."Right Side";
            Comparison := ExpressionLine.Comparison;
        until ExpressionLine.Next() = 0;
        Result := ResolveCondition(LeftHand, Comparison, RightHand, ValueBuffer);
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionHeader.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        if Result then
            ExpressionLine.SetRange("Line No.", 1)
        else
            ExpressionLine.SetRange("Line No.", 2);
        repeat
            Return += ExpressionLine."Right Side";
        until ExpressionLine.Next() = 0;
        exit(CalculateOrReturnValue(Return, ValueBuffer));
    end;

    procedure CloneValueBuffer(
        var FromBuffer: Record lvnExpressionValueBuffer;
        var ToBuffer: Record lvnExpressionValueBuffer)
    begin
        FromBuffer.Reset();
        ToBuffer.Reset();
        ToBuffer.DeleteAll();
        if FromBuffer.FindSet() then
            repeat
                ToBuffer := FromBuffer;
                ToBuffer.Insert();
            until FromBuffer.Next() = 0;
    end;

    procedure GetFormulaFromLines(var ExpressionHeader: Record lvnExpressionHeader) Formula: Text
    begin
        Formula := GetFormulaFromLines(ExpressionHeader, 0);
    end;

    procedure GetFormulaFromLines(var ExpressionHeader: Record lvnExpressionHeader; LineNo: Integer) Formula: Text
    var
        ExpressionLine: Record lvnExpressionLine;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        ExpressionLine.SetRange("Line No.", LineNo);
        if not ExpressionLine.FindSet() then
            exit;
        repeat
            Formula := Formula + ExpressionLine."Left Side" + ExpressionLine."Right Side";
        until ExpressionLine.Next() = 0;
    end;

    procedure SetFormulaToLines(var ExpressionHeader: Record lvnExpressionHeader; Formula: Text)
    begin
        SetFormulaToLines(ExpressionHeader, Formula, 0);
    end;

    procedure SetFormulaToLines(var ExpressionHeader: Record lvnExpressionHeader; Formula: Text; LineNo: Integer)
    var
        ExpressionLine: Record lvnExpressionLine;
        Idx: Integer;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", ExpressionHeader.Code);
        ExpressionLine.SetRange("Consumer Id", ExpressionHeader."Consumer Id");
        ExpressionLine.SetRange("Line No.", LineNo);
        ExpressionLine.DeleteAll();
        Idx := 1;
        while Formula <> '' do begin
            Clear(ExpressionLine);
            ExpressionLine."Expression Code" := ExpressionHeader.Code;
            ExpressionLine."Consumer Id" := ExpressionHeader."Consumer Id";
            ExpressionLine."Line No." := 0;
            ExpressionLine."Split No." := Idx;
            ExpressionLine."Left Side" := CopyStr(Formula, 1, 250);
            Formula := DelStr(Formula, 1, 250);
            if Formula <> '' then begin
                ExpressionLine."Right Side" := CopyStr(Formula, 1, 250);
                Formula := DelStr(Formula, 1, 250);
            end;
            ExpressionLine.Insert();
            Idx := Idx + 1;
        end;
    end;

    procedure EvaluateBooleanExpression(Expression: Text) Result: Boolean
    var
        IsExpression: Boolean;
        Operators: Text;
        OperatorNo: Integer;
        i: Integer;
        Parentheses: Integer;
        LeftOperand: Text;
        RightOperand: Text;
        Operator: Char;
        LeftResult: Boolean;
        RightResult: Boolean;
    begin
        Result := false;
        Expression := ReplaceString(Expression, ' and ', '*', true);
        Expression := ReplaceString(Expression, ' or ', '+', true);
        Expression := ReplaceString(Expression, ' xor ', '^', true);
        Expression := DelChr(Expression, '=', ' ');
        if StrLen(Expression) > 0 then begin
            Parentheses := 0;
            IsExpression := false;
            Operators := '+*^';
            OperatorNo := 1;
            repeat
                i := StrLen(Expression);
                repeat
                    if Expression[i] = '(' then
                        Parentheses := Parentheses + 1
                    else
                        if Expression[i] = ')' then
                            Parentheses := Parentheses - 1;
                    if (Parentheses = 0) and (Expression[i] = Operators[OperatorNo]) then
                        IsExpression := true
                    else
                        i := i - 1;
                until IsExpression or (i <= 0);
                if not IsExpression then
                    OperatorNo := OperatorNo + 1;
            until (OperatorNo > StrLen(Operators)) or IsExpression;
            if IsExpression then begin
                if i > 1 then
                    LeftOperand := CopyStr(Expression, 1, i - 1)
                else
                    LeftOperand := '';
                if i < StrLen(Expression) then
                    RightOperand := CopyStr(Expression, i + 1)
                else
                    RightOperand := '';
                Operator := Expression[i];
                LeftResult := EvaluateBooleanExpression(LeftOperand);
                RightResult := EvaluateBooleanExpression(RightOperand);
                case Operator of
                    '^':
                        Result := LeftResult xor RightResult;
                    '*':
                        Result := LeftResult and RightResult;
                    '+':
                        Result := LeftResult or RightResult;
                end;
            end else
                if (Expression[1] = '(') and (Expression[StrLen(Expression)] = ')') then
                    Result := EvaluateBooleanExpression(CopyStr(Expression, 2, StrLen(Expression) - 2)) else
                    if Evaluate(Result, Expression) then;
        end else
            if Evaluate(Result, Expression) then;
    end;

    procedure FormatComparison(Comparison: Enum lvnComparison): Text
    begin
        case Comparison of
            Comparison::Contains:
                exit('like');
            Comparison::Equal:
                exit('eq');
            Comparison::NotEqual:
                exit('neq');
            Comparison::Greater:
                exit('gt');
            Comparison::GreaterOrEqual:
                exit('gte');
            Comparison::Less:
                exit('lt');
            Comparison::LessOrEqual:
                exit('lte');
            Comparison::Within:
                exit('in');
        end;
    end;

    procedure ParseComparison(Comparison: Text) Result: Enum lvnComparison
    begin
        case Comparison of
            'like':
                Result := Result::Contains;
            'eq':
                Result := Result::Equal;
            'neq':
                Result := Result::NotEqual;
            'gt':
                Result := Result::Greater;
            'gte':
                Result := Result::GreaterOrEqual;
            'lt':
                Result := Result::Less;
            'lte':
                Result := Result::LessOrEqual;
            'in':
                Result := Result::Within;
        end;
    end;

    local procedure ResolveCondition(
        LeftHand: Text;
        Comparison: Enum lvnComparison;
        RightHand: Text;
        var ValueBuffer: Record lvnExpressionValueBuffer): Boolean
    var
        DecimalLeft: Decimal;
        DecimalRight: Decimal;
        DateLeft: Date;
        DateRight: Date;
    begin
        LeftHand := CalculateOrReturnValue(LeftHand, ValueBuffer);
        if Comparison = Comparison::Within then
            exit(MatchesPredicate(UpperCase(LeftHand), UpperCase(RightHand)));
        RightHand := CalculateOrReturnValue(RightHand, ValueBuffer);
        if Comparison = Comparison::Contains then
            exit(StrPos(UpperCase(LeftHand), UpperCase(RightHand)) <> 0);
        if Evaluate(DecimalLeft, LeftHand) and Evaluate(DecimalRight, RightHand) then
            case Comparison of
                Comparison::Equal:
                    exit(DecimalLeft = DecimalRight);
                Comparison::NotEqual:
                    exit(DecimalLeft <> DecimalRight);
                Comparison::Greater:
                    exit(DecimalLeft > DecimalRight);
                Comparison::Less:
                    exit(DecimalLeft < DecimalRight);
                Comparison::GreaterOrEqual:
                    exit(DecimalLeft >= DecimalRight);
                Comparison::LessOrEqual:
                    exit(DecimalLeft <= DecimalRight);
            end
        else
            if Evaluate(DateLeft, LeftHand) and Evaluate(DateRight, RightHand) then
                case Comparison of
                    Comparison::Equal:
                        exit(DateLeft = DateRight);
                    Comparison::NotEqual:
                        exit(DateLeft <> DateRight);
                    Comparison::Greater:
                        exit(DateLeft > DateRight);
                    Comparison::Less:
                        exit(DateLeft < DateRight);
                    Comparison::GreaterOrEqual:
                        exit(DateLeft >= DateRight);
                    Comparison::LessOrEqual:
                        exit(DateLeft <= DateRight);
                end
            else
                case Comparison of
                    Comparison::Equal:
                        exit(UpperCase(LeftHand) = UpperCase(RightHand));
                    Comparison::NotEqual:
                        exit(UpperCase(LeftHand) <> UpperCase(RightHand));
                    Comparison::Greater:
                        exit(UpperCase(LeftHand) > UpperCase(RightHand));
                    Comparison::Less:
                        exit(UpperCase(LeftHand) < UpperCase(RightHand));
                    Comparison::GreaterOrEqual:
                        exit(UpperCase(LeftHand) >= UpperCase(RightHand));
                    Comparison::LessOrEqual:
                        exit(UpperCase(LeftHand) <= UpperCase(RightHand));
                end;
    end;

    local procedure CalculateOrReturnValue(Expression: Text; var ValueBuffer: Record lvnExpressionValueBuffer): Text
    var
        FieldName: Text;
    begin
        if IsNumber(Expression) then
            exit(Expression);
        if IsWrappedInto(Expression, '"', '"') then
            exit(CopyStr(Expression, 2, StrLen(Expression) - 2));
        if IsWrappedInto(Expression, '[', ']') then begin
            FieldName := CopyStr(Expression, 2, StrLen(Expression) - 2);
            if StrPos(FieldName, '[') = 0 then
                exit(GetValue(FieldName, ValueBuffer, false));
        end;
        exit(CalculateValue(Expression, ValueBuffer));
    end;

    local procedure IsNumber(String: Text): Boolean
    var
        Test: Decimal;
    begin
        exit(Evaluate(Test, String));
    end;

    local procedure MatchesPredicate(Value: Text; Predicate: Text): Boolean
    var
        Idx: Integer;
        From: Text;
        Upto: Text;
        Item: Text;
    begin
        if IsWrappedInto(Predicate, '(', ')') then begin
            Predicate := CopyStr(Predicate, 2, StrLen(Predicate) - 2);
            if Predicate = '' then
                exit(false);
            Idx := StrPos(Predicate, '..');
            if Idx <> 0 then begin //Range
                From := CopyStr(Predicate, 1, Idx - 1);
                Upto := CopyStr(Predicate, Idx + 2);
                if (From = '') and (Upto = '') then
                    exit(true)
                else begin
                    if From = '' then
                        exit(VirtuallyGreaterOrEquals(Upto, Value));
                    if Upto = '' then
                        exit(VirtuallyGreaterOrEquals(Value, From));
                    if VirtuallyGreaterOrEquals(Upto, Value) then
                        if VirtuallyGreaterOrEquals(Value, From) then
                            exit(true);
                end;
            end else //Collection
                repeat
                    Idx := StrPos(Predicate, '|');
                    if Idx = 0 then begin
                        Item := Predicate;
                        Predicate := '';
                    end else begin
                        Item := CopyStr(Predicate, 1, Idx - 1);
                        Predicate := CopyStr(Predicate, Idx + 1);
                    end;
                    if VirtuallyEquals(Value, Item) then
                        exit(true);
                until Predicate = '';
        end else //Single Value
            exit(VirtuallyEquals(Value, Predicate));
    end;

    local procedure IsWrappedInto(String: Text; Open: Char; Close: Char): Boolean
    begin
        if String <> '' then
            exit((String[1] = Open) and (String[StrLen(String)] = Close))
        else
            exit(false);
    end;

    local procedure VirtuallyEquals(Source: Text; Target: Text): Boolean
    var
        SourceDecimal: Decimal;
        TargetDecimal: Decimal;
    begin
        if IsWrappedInto(Source, '"', '"') then
            Source := CopyStr(Source, 2, StrLen(Source) - 2);
        if IsWrappedInto(Target, '"', '"') then
            Target := CopyStr(Target, 2, StrLen(Target) - 2);
        if Evaluate(SourceDecimal, Source) and Evaluate(TargetDecimal, Target) then
            exit(SourceDecimal = TargetDecimal)
        else
            exit(UpperCase(Source) = UpperCase(Target));
    end;

    local procedure VirtuallyGreaterOrEquals(Source: Text; Target: Text): Boolean
    var
        SourceDecimal: Decimal;
        TargetDecimal: Decimal;
    begin
        if IsWrappedInto(Source, '"', '"') then
            Source := CopyStr(Source, 2, StrLen(Source) - 2);
        if IsWrappedInto(Target, '"', '"') then
            Target := CopyStr(Target, 2, StrLen(Target) - 2);
        if Evaluate(SourceDecimal, Source) and Evaluate(TargetDecimal, Target) then
            exit(SourceDecimal >= TargetDecimal)
        else
            exit(UpperCase(Source) >= UpperCase(Target));
    end;

    local procedure ResolveVariables(Expression: Text; var ValueBuffer: Record lvnExpressionValueBuffer) Result: Text
    var
        Idx: Integer;
        FieldName: Text;
    begin
        Result := '';
        if Expression = '' then
            exit('');
        //This function should be reworked for the cases when opening square brackets can occur within literals
        Idx := StrPos(Expression, '[');
        while Idx <> 0 do begin
            if Idx > 1 then
                Result := Result + CopyStr(Expression, 1, Idx - 1);
            Expression := CopyStr(Expression, Idx + 1);
            Idx := StrPos(Expression, ']');
            if Idx = 0 then
                Error(InvalidExpressionErr);
            FieldName := CopyStr(Expression, 1, Idx - 1);
            Expression := CopyStr(Expression, Idx + 1);
            Result := Result + GetValue(FieldName, ValueBuffer, true);
            Idx := StrPos(Expression, '[');
        end;
        if Expression <> '' then
            Result := Result + Expression;
    end;

    local procedure GetValue(
        FieldName: Text;
        var ValueBuffer: Record lvnExpressionValueBuffer;
        WrapLiterals: Boolean): Text
    begin
        ValueBuffer.Reset();
        ValueBuffer.SetCurrentKey(Name);
        ValueBuffer.SetRange(Name, FieldName);
        if ValueBuffer.IsEmpty() then
            Error(UnrecognizedFieldErr, FieldName);
        ValueBuffer.FindFirst();
        case ValueBuffer.Type of
            'Integer', 'Decimal', 'Boolean':
                exit(ValueBuffer.Value);
            'Text', 'Code', 'Date', 'Time', 'DateTime':
                if WrapLiterals then
                    exit('"' + ValueBuffer.Value + '"')
                else
                    exit(ValueBuffer.Value);
            else
                Error(UnrecognizedTypeErr, ValueBuffer.Type);
        end;
    end;

    local procedure CalculateValue(Expression: Text; var ValueBuffer: Record lvnExpressionValueBuffer) Result: Text
    var
        Test: Text;
    begin
        if Expression = '' then
            exit('');
        Test := LowerCase(Expression);
        if (StrPos(Test, ' and ') > 0) or (StrPos(Test, ' or ') > 0) or (StrPos(Test, ' xor ') > 0) then
            Result := Format(EvaluateBooleanExpression(ResolveVariables(Expression, ValueBuffer)))
        else
            Result := CalculateDecimalValue(Expression, ValueBuffer);
    end;

    local procedure CalculateDecimalValue(Expression: Text; var ValueBuffer: Record lvnExpressionValueBuffer): Text
    var
        i: Integer;
        OpenIdx: Integer;
        ExpLen: Integer;
        ParCount: Integer;
        OpIdx: Integer;
        ExpandFrom: Integer;
        ExpandTo: Integer;
    begin
        ExpLen := StrLen(Expression);
        OpenIdx := StrPos(Expression, '(');
        while OpenIdx > 0 do begin
            //Open Parenthesis
            ParCount := 1;
            for i := OpenIdx + 1 to ExpLen do
                if Expression[i] = '(' then
                    ParCount += 1
                else
                    if Expression[i] = ')' then begin
                        if ParCount = 1 then
                            Expression := CopyStr(Expression, 1, OpenIdx - 1) + CalculateDecimalValue(CopyStr(Expression, OpenIdx + 1, i - OpenIdx - 1), ValueBuffer) + CopyStr(Expression, i + 1);
                        ParCount -= 1;
                    end;
            OpenIdx := StrPos(Expression, '(');
        end;
        //At this point we have an expression without parenthesis
        OpIdx := IndexOfAny(Expression, '*/');
        while OpIdx > 0 do begin
            ExpandFrom := ExpandToNextOperand(Expression, OpIdx, -1);
            ExpandTo := ExpandToNextOperand(Expression, OpIdx, 1);
            //Here we have a single expression to calculate
            Expression := CopyStr(Expression, 1, ExpandFrom - 1) + Format(EvaluateDecimalExpression(ResolveVariables(CopyStr(Expression, ExpandFrom, ExpandTo - ExpandFrom), ValueBuffer)), 0, 9) + CopyStr(Expression, ExpandTo);
            OpIdx := IndexOfAny(Expression, '*/');
        end;
        OpIdx := IndexOfAny(Expression, '+-');
        while OpIdx > 0 do begin
            ExpandFrom := ExpandToNextOperand(Expression, OpIdx, -1);
            ExpandTo := ExpandToNextOperand(Expression, OpIdx, 1);
            //Here we have a single expression to calculate
            Expression := CopyStr(Expression, 1, ExpandFrom - 1) + Format(EvaluateDecimalExpression(ResolveVariables(CopyStr(Expression, ExpandFrom, ExpandTo - ExpandFrom), ValueBuffer)), 0, 9) + CopyStr(Expression, ExpandTo);
            OpIdx := IndexOfAny(Expression, '+-');
        end;
        exit(ResolveVariables(Expression, ValueBuffer));
    end;

    local procedure ExpandToNextOperand(Expression: Text; StartIndex: Integer; Direction: Integer): Integer
    var
        EndIndex: Integer;
        Operands: Text;
        Skip: Boolean;
        SkipStartChar: Char;
        SkipEndChar: Char;
        i: Integer;
    begin
        Operands := '+-*/^%';
        StartIndex += Direction;    //No need to test the same symbol again
        if Direction > 0 then begin
            EndIndex := StrLen(Expression);
            SkipStartChar := '[';
            SkipEndChar := ']';
        end else begin
            EndIndex := 1;
            SkipStartChar := ']';
            SkipEndChar := '[';
        end;
        Skip := false;
        while StartIndex <> EndIndex do begin
            if not Skip then begin
                if Expression[StartIndex] = SkipStartChar then
                    Skip := true
                else
                    for i := 1 to StrLen(Operands) do
                        if Operands[i] = Expression[StartIndex] then
                            exit(StartIndex);
            end else
                if Expression[StartIndex] = SkipEndChar then
                    Skip := false;
            StartIndex += Direction;
        end;
        if Skip and (Direction > 0) then
            StartIndex += 1; //Important! Fixes situation when everything ended on square bracket!
        if EndIndex = StrLen(Expression) then
            StartIndex += 1; //Important! This ensures last symbol is taken!
        exit(StartIndex);
    end;

    local procedure IndexOfAny(Expression: Text; Operations: Text): Integer
    var
        i: Integer;
        x: Integer;
        Skip: Boolean;
    begin
        Skip := false;
        for i := 1 to StrLen(Expression) do begin
            if Expression[i] = '[' then
                Skip := true
            else
                if Expression[i] = ']' then
                    Skip := false;
            if not Skip then
                for x := 1 to StrLen(Operations) do
                    if Expression[i] = Operations[x] then
                        exit(i);
        end;
        exit(0);
    end;

    local procedure EvaluateDecimalExpression(Expression: Text): Decimal
    var
        Result: Decimal;
        IsExpression: Boolean;
        Operators: Text;
        OperatorNo: Integer;
        i: Integer;
        Parentheses: Integer;
        LeftOperand: Text;
        RightOperand: Text;
        Operator: Char;
        LeftResult: Decimal;
        RightResult: Decimal;
        DivisionError: Boolean;
    begin
        Result := 0;
        Expression := DelChr(Expression, '=', ' ');
        if StrLen(Expression) > 0 then begin
            Parentheses := 0;
            IsExpression := false;
            Operators := '+-*/^%';
            OperatorNo := 1;
            repeat
                i := StrLen(Expression);
                repeat
                    if Expression[i] = '(' then
                        Parentheses := Parentheses + 1
                    else
                        if Expression[i] = ')' then
                            Parentheses := Parentheses - 1;
                    if (Parentheses = 0) and (Expression[i] = Operators[OperatorNo]) then
                        IsExpression := true
                    else
                        i := i - 1;
                until IsExpression or (i <= 0);
                if not IsExpression then
                    OperatorNo := OperatorNo + 1;
            until (OperatorNo > StrLen(Operators)) or IsExpression;
            if IsExpression then begin
                if i > 1 then
                    LeftOperand := CopyStr(Expression, 1, i - 1)
                else
                    LeftOperand := '';
                if i < StrLen(Expression) then
                    RightOperand := CopyStr(Expression, i + 1)
                else
                    RightOperand := '';
                Operator := Expression[i];
                LeftResult := EvaluateDecimalExpression(LeftOperand);
                RightResult := EvaluateDecimalExpression(RightOperand);
                case Operator of
                    '^':
                        Result := Power(LeftResult, RightResult);
                    '%':
                        if RightResult = 0 then begin
                            Result := 0;
                            DivisionError := true;
                        end else
                            Result := 100 * LeftResult / RightResult;
                    '*':
                        Result := LeftResult * RightResult;
                    '/':
                        if RightResult = 0 then begin
                            Result := 0;
                            DivisionError := true;
                        end else
                            Result := LeftResult / RightResult;
                    '+':
                        Result := LeftResult + RightResult;
                    '-':
                        Result := LeftResult - RightResult;
                end;
            end else
                if (Expression[1] = '(') and (Expression[StrLen(Expression)] = ')') then
                    Result := EvaluateDecimalExpression(CopyStr(Expression, 2, StrLen(Expression) - 2)) else
                    if Evaluate(Result, Expression) then;
        end else
            if Evaluate(Result, Expression) then;
        exit(Result);
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text; CaseInsensitive: Boolean): Text
    var
        Idx: Integer;
        LowerString: Text;
        LowerFind: Text;
    begin
        if not CaseInsensitive then begin
            Idx := StrPos(String, FindWhat);
            while Idx > 0 do begin
                String := DelStr(String, Idx) + ReplaceWith + CopyStr(String, Idx + StrLen(FindWhat));
                Idx := StrPos(String, FindWhat);
            end;
            exit(String);
        end else begin
            LowerString := LowerCase(String);
            LowerFind := LowerCase(FindWhat);
            Idx := StrPos(LowerString, LowerFind);
            while Idx > 0 do begin
                String := DelStr(String, Idx) + ReplaceWith + CopyStr(String, Idx + StrLen(FindWhat));
                LowerString := DelStr(LowerString, Idx) + ReplaceWith + CopyStr(LowerString, Idx + StrLen(LowerFind));
                Idx := StrPos(LowerString, LowerFind);
            end;
        end;
        exit(String);
    end;
}