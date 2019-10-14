page 14135553 lvngConditionEdit
{
    PageType = Card;
    SourceTable = lvngExpressionHeader;
    Caption = 'Condition Editor';

    layout
    {
        area(Content)
        {
            group(Expression)
            {
                field(ConditionValue; ConditionValue)
                {
                    AssistEdit = true;
                    ShowCaption = false;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        TempValueBuffer: Record lvngExpressionValueBuffer temporary;
                        FormulaEdit: Page lvngFormulaEdit;
                        Idx: Integer;
                    begin
                        FormulaEdit.SetFormula(ConditionValue);
                        for Idx := 1 to ItemCount do begin
                            Clear(TempValueBuffer);
                            TempValueBuffer.Number := Idx;
                            TempValueBuffer.Name := StrSubstNo(ConditionNoTxt, Idx);
                            TempValueBuffer.Type := 'Boolean';
                            TempValueBuffer.Insert();
                        end;
                        FormulaEdit.SetFieldList(TempValueBuffer);
                        FormulaEdit.LookupMode(true);
                        FormulaEdit.RunModal();
                        if FormulaEdit.IsFormulaCreated() then
                            ConditionValue := FormulaEdit.GetFormula();
                    end;
                }
            }
            group(List)
            {
                usercontrol(ConditionControl; ConditionControl)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    begin
                        LoadFields();
                        LoadConditions();
                        AddInInitialized := true;
                    end;

                    trigger ConditionDataError(Data: Text)
                    begin
                        Message(Data);
                    end;

                    trigger ReportLines(Data: JsonArray)
                    var
                        ConditionLine: Record lvngExpressionLine;
                        Item: JsonToken;
                        Object: JsonObject;
                        LeftToken: JsonToken;
                        RightToken: JsonToken;
                        ComparisonToken: JsonToken;
                        Left: Text;
                        Right: Text;
                        Comparison: Text;
                        SplitNo: Integer;
                        LineNo: Integer;
                    begin
                        ConditionLine.Reset();
                        ConditionLine.SetRange("Expression Code", Code);
                        ConditionLine.DeleteAll();
                        LineNo := 1;
                        foreach Item in Data do begin
                            Object := Item.AsObject();
                            Object.Get('leftHand', LeftToken);
                            Object.Get('rightHand', RightToken);
                            Object.Get('comparison', ComparisonToken);
                            Left := LeftToken.AsValue().AsText();
                            Right := RightToken.AsValue().AsText();
                            Comparison := ComparisonToken.AsValue().AsText();
                            SplitNo := 1;
                            while (Left <> '') and (Right <> '') do begin
                                Clear(ConditionLine);
                                ConditionLine."Expression Code" := Code;
                                ConditionLine."Line No." := LineNo;
                                ConditionLine."Split No." := SplitNo;
                                if Left <> '' then begin
                                    ConditionLine."Left Side" := CopyStr(Left, 1, 250);
                                    Left := DelStr(Left, 1, 250);
                                end;
                                if Right <> '' then begin
                                    ConditionLine."Right Side" := CopyStr(Right, 1, 250);
                                    Right := DelStr(Right, 1, 250);
                                end;
                                ConditionLine.Comparison := Engine.ParseComparison(Comparison);
                                ConditionLine.Insert();
                                SplitNo := SplitNo + 1;
                            end;
                            LineNo := LineNo + 100;
                        end;
                        Engine.SetFormulaToLines(Rec, ConditionValue);
                        Ready := true;
                        CurrPage.Close();
                    end;

                    trigger EditFormula(Id: Text; Left: Boolean; Value: Text)
                    var
                        FormulaEdit: Page lvngFormulaEdit;
                    begin
                        if AddInInitialized then begin
                            FormulaEdit.SetFormula(Value);
                            FormulaEdit.SetFieldList(ConditionValueBuffer);
                            FormulaEdit.LookupMode(true);
                            FormulaEdit.RunModal();
                            if FormulaEdit.IsFormulaCreated() then begin
                                Value := FormulaEdit.GetFormula();
                                CurrPage.ConditionControl.ApplyFormula(Id, Left, Value);
                            end;
                        end;
                    end;

                    trigger ItemAdded()
                    begin
                        ItemCount := ItemCount + 1;
                    end;

                    trigger ItemRemoved()
                    begin
                        ItemCount := ItemCount - 1;
                    end;
                }
            }
        }
    }

    var
        TempConditionLine: Record lvngExpressionLine temporary;
        ConditionValueBuffer: Record lvngExpressionValueBuffer temporary;
        ConditionLine: Record lvngExpressionLine;
        Engine: Codeunit lvngExpressionEngine;
        ConditionNoTxt: Label 'Condition #%1';
        ConditionValue: Text;
        Ready: Boolean;
        ItemCount: Integer;
        AddInInitialized: Boolean;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Ready then
            if CloseAction = Action::LookupOK then begin
                TempConditionLine.Reset();
                TempConditionLine.DeleteAll();
                CurrPage.ConditionControl.DumpLines();
                exit(false);
            end;
        exit(true);
    end;

    procedure SetFieldList(var FieldList: Record lvngExpressionValueBuffer)
    begin
        Engine.CloneValueBuffer(FieldList, ConditionValueBuffer);
    end;

    local procedure LoadFields()
    var
        Object: JsonObject;
        Data: JsonArray;
    begin
        ConditionValueBuffer.Reset();
        if ConditionValueBuffer.FindSet() then
            repeat
                Clear(Object);
                Object.Add('n', ConditionValueBuffer.Name);
                Object.Add('type', 'v');
                data.Add(Object);
            until ConditionValueBuffer.Next() = 0;
        CurrPage.ConditionControl.LoadFields(Data);
    end;

    local procedure LoadConditions()
    var
        PrevNo: Integer;
        Left: Text;
        Right: Text;
        Cond: Text;
    begin
        ConditionValue := Engine.GetFormulaFromLines(Rec);
        ConditionLine.Reset();
        ConditionLine.SetRange("Expression Code", Code);
        ConditionLine.SetFilter("Line No.", '<>%1', 0);
        PrevNo := 0;
        if ConditionLine.FindSet() then begin
            repeat
                if PrevNo <> ConditionLine."Line No." then begin
                    if Left <> '' then
                        CurrPage.ConditionControl.AppendLine(Left, Cond, Right);
                    PrevNo := ConditionLine."Line No.";
                    Left := ConditionLine."Left Side";
                    Right := ConditionLine."Right Side";
                end else begin
                    Left := Left + ConditionLine."Left Side";
                    Right := Right + ConditionLine."Right Side";
                end;
                Cond := Engine.FormatComparison(ConditionLine.Comparison);
            until ConditionLine.Next() = 0;
            if Left <> '' then
                CurrPage.ConditionControl.AppendLine(Left, Cond, Right);
        end;
    end;
}