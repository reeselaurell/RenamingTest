codeunit 14135131 "lvnExpressionCalculator"
{
    var
        ExpressionJson: JsonArray;
        SourceExpression: Text;
        ExpressionLength: Integer;
        ParserPosition: Integer;
        //Possible character classes:
        //- whitespace
        //- operator
        //- variable start
        //- variable end
        //- scope start
        //- scope end
        //- literal start
        //- literal end
        //- content
        CharacterClass: Option Whitespace,Operator,"Variable Start","Variable End","Scope Start","Scope End",Literal,Content;
        UnrecognizedFieldErr: Label 'Unrecognized field name: %1', Comment = '%1 - Field name';
        UnSupportedTypeErr: Label 'Unsupported value type: %1', Comment = '%1 - Value type';
        InvalidExpressionErr: Label 'Invalid expression: %1', Comment = '%1 - Expression';
        UnexpectedOperatorErr: Label 'Unexpected operator in scope: %1', Comment = '%1 - Json representation of the scope';
        OperatorTok: Label 'op';
        ScopeTok: Label 'sc';
        VariableTok: Label 'var';
        ContentTok: Label 'cnt';
        ValueTok: Label 'val';

    local procedure ThrowInvalidExpressionError()
    begin
        Error(InvalidExpressionErr, SourceExpression);
    end;

    procedure Init(Expression: Text)
    begin
        Clear(CharacterClass);
        SourceExpression := Expression;
        ExpressionLength := StrLen(Expression);
        ParserPosition := 1;
        ExpressionJson := ParseExpressionScope(1);
    end;

    procedure Calculate(var ValueBuffer: Record lvnExpressionValueBuffer): Decimal
    begin
        exit(ResolveScope(ExpressionJson, ValueBuffer));
    end;

    local procedure ResolveScope(ScopeArray: JsonArray; var ValueBuffer: Record lvnExpressionValueBuffer): Decimal
    var
        Idx: Integer;
        Operand: JsonObject;
        Token: JsonToken;
        Value: Decimal;
    begin
        for Idx := 0 to ScopeArray.Count() - 1 do begin
            ScopeArray.Get(Idx, Token);
            Operand := Token.AsObject();
            if Operand.Contains(ScopeTok) then begin
                Operand.Get(ScopeTok, Token);
                Operand.Add(ValueTok, ResolveScope(Token.AsArray(), ValueBuffer));
                Operand.Remove(ScopeTok);
            end else
                if Operand.Contains(VariableTok) then begin
                    Operand.Get(VariableTok, Token);
                    Operand.Add(ValueTok, GetValue(Token.AsValue().AsText(), ValueBuffer));
                    Operand.Remove(VariableTok);
                end else
                    if Operand.Contains(ContentTok) then begin
                        Operand.Get(ContentTok, Token);
                        Evaluate(Value, Token.AsValue().AsText());
                        Operand.Add(ValueTok, Value);
                        Operand.Remove(ContentTok);
                    end;
        end;
        exit(CalculateScope(ScopeArray));
    end;

    local procedure CalculateScope(ScopeArray: JsonArray): Decimal
    var
        Idx: Integer;
        Total: Integer;
        Token: JsonToken;
        Op: Text;
        Value: Decimal;
        PrevOp: Text;
        PrevValue: Decimal;
        Operand: JsonObject;
    begin
        Total := ScopeArray.Count();
        if Total = 0 then
            exit(0);
        if (Total = 1) then begin
            ScopeArray.Get(0, Token);
            ExtractOperand(Token, Op, Value);
            case Op of
                '', '+':
                    exit(Value);
                '-':
                    exit(-Value);
                else
                    Error(UnexpectedOperatorErr, ScopeArray);
            end;
        end;
        for Idx := 1 to ScopeArray.Count() - 1 do begin
            ScopeArray.Get(Idx, Token);
            ExtractOperand(Token, Op, Value);
            if (Op = '*') or (Op = '/') then begin
                ScopeArray.Get(Idx - 1, Token);
                ExtractOperand(Token, PrevOp, PrevValue);
                if PrevOp = '-' then
                    PrevValue := -PrevValue;
                if Op = '*' then
                    Value := PrevValue * Value
                else
                    Value := PrevValue / Value;
                ScopeArray.RemoveAt(Idx);
                Clear(Operand);
                if Value < 0 then
                    Operand.Add(OperatorTok, '-')
                else
                    Operand.Add(OperatorTok, '+');
                Operand.Add(ValueTok, Abs(Value));
                ScopeArray.Set(Idx - 1, Operand);
                exit(CalculateScope(ScopeArray));
            end;
        end;
        Value := 0;
        for Idx := 0 to ScopeArray.Count() - 1 do begin
            ScopeArray.Get(Idx, Token);
            ExtractOperand(Token, Op, PrevValue);
            if (Idx = 0) and (Op = '') then
                Op := '+';
            case Op of
                '+':
                    ;
                '-':
                    PrevValue := -PrevValue;
                else
                    Error(UnexpectedOperatorErr, ScopeArray);
            end;
            Value += PrevValue;
        end;
        exit(Value);
    end;

    local procedure ExtractOperand(Token: JsonToken; var Op: Text; var Value: Decimal)
    var
        Operand: JsonObject;
    begin
        Operand := Token.AsObject();
        Operand.Get(OperatorTok, Token);
        Op := Token.AsValue().AsText();
        Operand.Get(ValueTok, Token);
        Value := Token.AsValue().AsDecimal();
    end;

    local procedure GetValue(
        FieldName: Text;
        var ValueBuffer: Record lvnExpressionValueBuffer) Result: Decimal
    begin
        ValueBuffer.Reset();
        ValueBuffer.SetCurrentKey(Name);
        ValueBuffer.SetRange(Name, FieldName);
        if ValueBuffer.IsEmpty() then
            Error(UnrecognizedFieldErr, FieldName);
        ValueBuffer.FindFirst();
        case ValueBuffer.Type of
            'Integer', 'Decimal', 'Text', 'Code':
                Evaluate(Result, ValueBuffer.Value);
            else
                Error(UnSupportedTypeErr, ValueBuffer.Type);
        end;
    end;

    local procedure GetNextChar() Result: Text
    begin
        if ParserPosition > ExpressionLength then
            Result := ''
        else begin
            Result := SourceExpression[ParserPosition];
            ParserPosition += 1;
        end;
    end;

    local procedure PeekNextChar() Result: Text
    begin
        Result := GetNextChar();
        ParserPosition -= 1;
    end;

    local procedure GetCharacterClass(C: Char): Option
    begin
        case C of
            ' ':
                exit(CharacterClass::Whitespace);
            '+', '-', '*', '/':
                exit(CharacterClass::Operator);
            '[':
                exit(CharacterClass::"Variable Start");
            ']':
                exit(CharacterClass::"Variable End");
            '(':
                exit(CharacterClass::"Scope Start");
            ')':
                exit(CharacterClass::"Scope End");
            '"':
                exit(CharacterClass::Literal);
            else
                exit(CharacterClass::Content);
        end;
    end;

    local procedure ParseExpressionScope(Level: Integer) ScopeArray: JsonArray
    var
        Operand: JsonObject;
        ParserState: Option Whitespace,Variable,Literal,Content;
        CurrentOperator: Text;
        CurrentChar: Text;
        BackBuffer: TextBuilder;
        Ok: Boolean;
    begin
        CurrentChar := GetNextChar();
        while CurrentChar <> '' do begin
            CharacterClass := GetCharacterClass(CurrentChar[1]);
            case ParserState of
                ParserState::Whitespace:
                    case CharacterClass of
                        CharacterClass::Whitespace:
                            ;//Do nothing
                        CharacterClass::Operator:
                            begin
                                if CurrentOperator <> '' then
                                    ThrowInvalidExpressionError();
                                CurrentOperator := CurrentChar;
                            end;
                        CharacterClass::"Variable Start":
                            begin
                                if (ScopeArray.Count() > 0) and (CurrentOperator = '') then
                                    ThrowInvalidExpressionError();
                                ParserState := ParserState::Variable;
                            end;
                        CharacterClass::"Scope Start":
                            begin
                                if (ScopeArray.Count() > 0) and (CurrentOperator = '') then
                                    ThrowInvalidExpressionError();
                                Clear(Operand);
                                Operand.Add(OperatorTok, CurrentOperator);
                                Operand.Add(ScopeTok, ParseExpressionScope(Level + 1));
                                ScopeArray.Add(Operand);
                                CurrentOperator := '';
                            end;
                        CharacterClass::Literal:
                            begin
                                if (ScopeArray.Count() > 0) and (CurrentOperator = '') then
                                    ThrowInvalidExpressionError();
                                ParserState := ParserState::Literal;
                            end;
                        CharacterClass::"Scope End":
                            begin
                                if CurrentOperator <> '' then
                                    ThrowInvalidExpressionError();
                                exit;
                            end;
                        CharacterClass::Content:
                            begin
                                if (ScopeArray.Count() > 0) and (CurrentOperator = '') then
                                    ThrowInvalidExpressionError();
                                ParserState := ParserState::Content;
                                BackBuffer.Append(CurrentChar);
                            end;
                        CharacterClass::"Variable End":
                            ThrowInvalidExpressionError();
                    end;
                ParserState::Variable:
                    if CharacterClass = CharacterClass::"Variable End" then begin
                        Clear(Operand);
                        Operand.Add(OperatorTok, CurrentOperator);
                        Operand.Add(VariableTok, BackBuffer.ToText());
                        ScopeArray.Add(Operand);
                        CurrentOperator := '';
                        Clear(BackBuffer);
                        ParserState := ParserState::Whitespace;
                    end else
                        BackBuffer.Append(CurrentChar);
                ParserState::Literal:
                    begin
                        Ok := true;
                        if (CharacterClass = CharacterClass::Literal) then
                            if PeekNextChar() = '"' then
                                GetNextChar()
                            else begin
                                Ok := false;
                                Clear(Operand);
                                Operand.Add(OperatorTok, CurrentOperator);
                                Operand.Add(ContentTok, BackBuffer.ToText());
                                ScopeArray.Add(Operand);
                                CurrentOperator := '';
                                Clear(BackBuffer);
                                ParserState := ParserState::Whitespace;
                            end;
                        if Ok then
                            BackBuffer.Append(CurrentChar);
                    end;
                ParserState::Content:
                    case CharacterClass of
                        CharacterClass::Content:
                            BackBuffer.Append(CurrentChar);
                        CharacterClass::Whitespace,
                        CharacterClass::Operator,
                        CharacterClass::"Scope End":
                            begin
                                Clear(Operand);
                                Operand.Add(OperatorTok, CurrentOperator);
                                Operand.Add(ContentTok, BackBuffer.ToText());
                                ScopeArray.Add(Operand);
                                CurrentOperator := '';
                                Clear(BackBuffer);
                                ParserState := ParserState::Whitespace;
                                if CharacterClass = CharacterClass::Operator then
                                    CurrentOperator := CurrentChar
                                else
                                    if CharacterClass = CharacterClass::"Scope End" then
                                        exit;
                            end;
                    end;
            end;
            CurrentChar := GetNextChar();
        end;
        if Level > 1 then
            ThrowInvalidExpressionError();
        if ParserState = ParserState::Content then begin
            Clear(Operand);
            Operand.Add(OperatorTok, CurrentOperator);
            Operand.Add(ContentTok, BackBuffer.ToText());
            ScopeArray.Add(Operand);
            CurrentOperator := '';
            Clear(BackBuffer);
            ParserState := ParserState::Whitespace;
        end;
        if ParserState <> ParserState::Whitespace then
            ThrowInvalidExpressionError();
    end;
}