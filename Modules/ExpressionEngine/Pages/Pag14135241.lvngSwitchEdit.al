page 14135241 lvngSwitchEdit
{
    PageType = Card;
    SourceTable = lvngExpressionHeader;
    Caption = 'Switch Expression Editor';
    DataCaptionFields = Code;

    layout
    {
        area(Content)
        {
            group("Switch Value Expression")
            {
                field(SwitchValue; SwitchValue)
                {
                    AssistEdit = true;
                    ShowCaption = false;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        FormulaEdit: Page lvngFormulaEdit;
                    begin
                        Clear(FormulaEdit);
                        FormulaEdit.SetFormula(SwitchValue);
                        FormulaEdit.SetFieldList(ConditionValueBuffer);
                        FormulaEdit.LookupMode(true);
                        FormulaEdit.RunModal();
                        if FormulaEdit.IsFormulaCreated() then
                            SwitchValue := FormulaEdit.GetFormula();
                    end;
                }
            }
            group("Switch Case List")
            {
                usercontrol(SwitchControl; SwitchControl)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    begin
                        LoadFields();
                        LoadCases();
                        AddInInitialized := true;
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
                        PredicateToken: JsonToken;
                        ReturnsToken: JsonToken;
                        Predicate: Text;
                        Returns: Text;
                        SplitNo: Integer;
                        LineNo: Integer;
                    begin
                        ConditionLine.Reset();
                        ConditionLine.SetRange("Expression Code", Code);
                        ConditionLine.SetRange("Consumer Id", "Consumer Id");
                        ConditionLine.DeleteAll();
                        LineNo := 1;
                        foreach Item in Data do begin
                            Object := Item.AsObject();
                            Object.Get('predicate', PredicateToken);
                            Object.Get('returns', ReturnsToken);
                            Predicate := PredicateToken.AsValue().AsText();
                            Returns := ReturnsToken.AsValue().AsText();
                            SplitNo := 1;
                            while (Predicate <> '') and (Returns <> '') do begin
                                Clear(ConditionLine);
                                ConditionLine."Expression Code" := Code;
                                ConditionLine."Consumer Id" := "Consumer Id";
                                ConditionLine."Line No." := LineNo;
                                ConditionLine."Split No." := SplitNo;
                                if Predicate <> '' then begin
                                    ConditionLine."Left Side" := CopyStr(Predicate, 1, 250);
                                    Predicate := DelStr(Predicate, 1, 250);
                                end;
                                if Returns <> '' then begin
                                    ConditionLine."Right Side" := CopyStr(Returns, 1, 250);
                                    Returns := DelStr(Returns, 1, 250);
                                end;
                                ConditionLine.Insert();
                                SplitNo := SplitNo + 1;
                            end;
                            LineNo := LineNo + 100;
                        end;
                        Engine.SetFormulaToLines(Rec, SwitchValue);
                        Ready := true;
                        CurrPage.Close();
                    end;

                    trigger EditFormula(Id: Text; Value: Text)
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
                                CurrPage.SwitchControl.ApplyFormula(Id, false, Value);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    var
        ConditionValueBuffer: Record lvngExpressionValueBuffer temporary;
        Engine: Codeunit lvngExpressionEngine;
        ValueEmptyErr: Label 'Switch value cannot be empty';
        SwitchValue: Text;
        Ready: Boolean;
        AddInInitialized: Boolean;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Ready then
            if CloseAction = Action::LookupOK then begin
                if SwitchValue = '' then begin
                    Message(ValueEmptyErr);
                    exit(false);
                end;
                CurrPage.SwitchControl.DumpLines();
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
        CurrPage.SwitchControl.LoadFields(Data);
    end;

    local procedure LoadCases()
    var
        ConditionLine: Record lvngExpressionLine;
        PrevNo: Integer;
        Predicate: Text;
        Returns: Text;
    begin
        SwitchValue := Engine.GetFormulaFromLines(Rec);
        ConditionLine.Reset();
        ConditionLine.SetRange("Expression Code", Code);
        ConditionLine.SetRange("Consumer Id", "Consumer Id");
        ConditionLine.SetFilter("Line No.", '<>%1', 0);
        PrevNo := 0;
        if ConditionLine.FindSet() then begin
            repeat
                if PrevNo <> ConditionLine."Line No." then begin
                    if Predicate <> '' then
                        CurrPage.SwitchControl.AppendLine(Predicate, Returns);
                    PrevNo := ConditionLine."Line No.";
                    Predicate := ConditionLine."Left Side";
                    Returns := ConditionLine."Right Side";
                end else begin
                    Predicate := Predicate + ConditionLine."Left Side";
                    Returns := Returns + ConditionLine."Right Side";
                end;
            until ConditionLine.Next() = 0;
            if Predicate <> '' then
                CurrPage.SwitchControl.AppendLine(Predicate, Returns);
        end;
    end;
}