page 14135554 lvngIifEdit
{
    PageType = Card;
    SourceTable = lvngExpressionHeader;
    Caption = 'Iif Editor';

    layout
    {
        area(Content)
        {
            group(Predicate)
            {
                usercontrol(PredicateControl; PredicateControl)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    begin
                        LoadPredicateFields();
                        LoadPredicate();
                        InitState += 1;
                    end;

                    trigger PredicateDataError(Data: Text)
                    begin
                        Message(Data);
                    end;

                    trigger PredicateResponse(Left: Text; Comparison: Text; Right: Text)
                    var
                        ExpressionLine: Record lvngExpressionLine;
                        SplitNo: Integer;
                    begin
                        ExpressionLine.SetRange("Expression Code", Code);
                        ExpressionLine.SetRange("Consumer Id", "Consumer Id");
                        ExpressionLine.SetRange("Line No.", 0);
                        ExpressionLine.DeleteAll();
                        SplitNo := 1;
                        while (Left <> '') and (Right <> '') do begin
                            Clear(ExpressionLine);
                            ExpressionLine."Expression Code" := Code;
                            ExpressionLine."Consumer Id" := "Consumer Id";
                            ExpressionLine."Line No." := 0;
                            ExpressionLine."Split No." := SplitNo;
                            SplitNo += 1;
                            if Left <> '' then begin
                                ExpressionLine."Left Side" := CopyStr(Left, 1, 250);
                                Left := DelStr(Left, 1, 250);
                            end;
                            if Right <> '' then begin
                                ExpressionLine."Right Side" := CopyStr(Right, 1, 250);
                                Right := DelStr(Right, 1, 250);
                            end;
                            ExpressionLine.Comparison := Engine.ParseComparison(Comparison);
                            ExpressionLine.Insert();
                        end;
                        ReadyState += 1;
                        if ReadyState >= 2 then
                            CurrPage.Close();
                    end;

                    trigger EditFormula(Left: Boolean; Value: Text)
                    var
                        FormulaEdit: Page lvngFormulaEdit;
                    begin
                        if InitState >= 2 then begin
                            FormulaEdit.SetFormula(Value);
                            FormulaEdit.SetFieldList(ExpressionValueBuffer);
                            FormulaEdit.LookupMode(true);
                            FormulaEdit.RunModal();
                            if FormulaEdit.IsFormulaCreated() then begin
                                Value := FormulaEdit.GetFormula();
                                CurrPage.PredicateControl.ApplyFormula(Left, Value);
                            end;
                        end;
                    end;
                }
            }
            group("Return Value")
            {
                usercontrol(SwitchControl; SwitchControl)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    begin
                        LoadSwitchFields();
                        CurrPage.SwitchControl.OptimizeForPredicate();
                        LoadResults();
                        InitState += 1;
                    end;

                    trigger SwitchDataError(Data: Text)
                    begin
                        Message(Data);
                    end;

                    trigger ReportLines(Data: JsonArray)
                    var
                        ConditionLine: Record lvngExpressionLine;
                        Item: JsonToken;
                        Object: JsonObject;
                        ReturnsToken: JsonToken;
                        Returns: Text;
                        SplitNo: Integer;
                        LineNo: Integer;
                    begin
                        ConditionLine.Reset();
                        ConditionLine.SetRange("Expression Code", Code);
                        ConditionLine.SetRange("Consumer Id", "Consumer Id");
                        ConditionLine.SetFilter("Line No.", '<>0');
                        ConditionLine.DeleteAll();
                        for LineNo := 1 to 2 do
                            if Data.Get(LineNo - 1, Item) then begin
                                Object := Item.AsObject();
                                Object.Get('returns', ReturnsToken);
                                Returns := ReturnsToken.AsValue().AsText();
                                SplitNo := 1;
                                while Returns <> '' do begin
                                    Clear(ConditionLine);
                                    ConditionLine."Expression Code" := Code;
                                    ConditionLine."Consumer Id" := "Consumer Id";
                                    ConditionLine."Line No." := LineNo;
                                    ConditionLine."Split No." := SplitNo;
                                    if SplitNo = 1 then
                                        if LineNo = 1 then
                                            ConditionLine."Left Side" := TrueTxt
                                        else
                                            ConditionLine."Left Side" := FalseTxt;
                                    ConditionLine."Right Side" := CopyStr(Returns, 1, 250);
                                    Returns := DelStr(Returns, 1, 250);
                                    ConditionLine.Insert();
                                    SplitNo += 1;
                                end;
                            end;
                        ReadyState += 1;
                        if ReadyState >= 2 then
                            CurrPage.Close();
                    end;

                    trigger EditFormula(Id: Text; Value: Text)
                    var
                        FormulaEdit: Page lvngFormulaEdit;
                    begin
                        if InitState >= 2 then begin
                            FormulaEdit.SetFormula(Value);
                            FormulaEdit.SetFieldList(ExpressionValueBuffer);
                            FormulaEdit.LookupMode(true);
                            FormulaEdit.RunModal();
                            if FormulaEdit.IsFormulaCreated() then begin
                                Value := FormulaEdit.GetFormula();
                                CurrPage.SwitchControl.ApplyFormula(Id, false, Value);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    var
        ExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionLine: Record lvngExpressionLine;
        Engine: Codeunit lvngExpressionEngine;
        ReadyState: Integer;
        InitState: Integer;
        TrueTxt: Label 'true';
        FalseTxt: Label 'false';

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ReadyState < 2 then
            if CloseAction = Action::LookupOK then begin
                CurrPage.PredicateControl.RequestPredicate();
                CurrPage.SwitchControl.DumpLines();
                exit(false);
            end;
        exit(true);
    end;

    procedure SetFieldList(var FieldList: Record lvngExpressionValueBuffer)
    begin
        Engine.CloneValueBuffer(FieldList, ExpressionValueBuffer);
    end;

    local procedure LoadPredicateFields()
    var
        Object: JsonObject;
        Data: JsonArray;
    begin
        ExpressionValueBuffer.Reset();
        if ExpressionValueBuffer.FindSet() then
            repeat
                Clear(Object);
                Object.Add('n', ExpressionValueBuffer.Name);
                Object.Add('type', 'v');
                data.Add(Object);
            until ExpressionValueBuffer.Next() = 0;
        CurrPage.PredicateControl.LoadFields(Data);
    end;

    local procedure LoadSwitchFields()
    var
        Object: JsonObject;
        Data: JsonArray;
    begin
        ExpressionValueBuffer.Reset();
        if ExpressionValueBuffer.FindSet() then
            repeat
                Clear(Object);
                Object.Add('n', ExpressionValueBuffer.Name);
                Object.Add('type', 'v');
                data.Add(Object);
            until ExpressionValueBuffer.Next() = 0;
        CurrPage.SwitchControl.LoadFields(Data);
    end;

    local procedure LoadPredicate()
    var
        Left: Text;
        Right: Text;
        Cond: Text;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", Code);
        ExpressionLine.SetRange("Line No.", 0);
        if ExpressionLine.FindSet() then begin
            repeat
                Left := Left + ExpressionLine."Left Side";
                Right := Right + ExpressionLine."Right Side";
                Cond := Engine.FormatComparison(ExpressionLine.Comparison);
            until ExpressionLine.Next() = 0;
            if Left <> '' then
                CurrPage.PredicateControl.SetPredicate(Left, Cond, Right);
        end;
    end;

    local procedure LoadResults()
    var
        ConditionLine: Record lvngExpressionLine;
        Predicate: Text;
        Returns: Text;
        LineNo: Integer;
    begin
        for LineNo := 1 to 2 do begin
            ConditionLine.Reset();
            ConditionLine.SetRange("Expression Code", Code);
            ConditionLine.SetRange("Line No.", LineNo);
            Returns := '';
            if ConditionLine.FindSet() then
                repeat
                    Returns := Returns + ConditionLine."Right Side";
                until ConditionLine.Next() = 0;
            if LineNo = 1 then
                Predicate := TrueTxt
            else
                Predicate := FalseTxt;
            CurrPage.SwitchControl.AppendLine(Predicate, Returns);
        end;
    end;
}