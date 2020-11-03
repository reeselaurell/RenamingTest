page 14135240 "lvnFormulaEdit"
{
    PageType = Card;
    Caption = 'Edit Formula';

    layout
    {
        area(Content)
        {
            group(General)
            {
                usercontrol(FormulaControl; lvnFormulaControl)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    var
                        Data: JsonArray;
                        Object: JsonObject;
                    begin
                        CurrPage.FormulaControl.LoadFormula(FormulaText);
                        ConditionValueBuffer.Reset();
                        if ConditionValueBuffer.FindSet() then
                            repeat
                                Clear(Object);
                                Object.Add('n', ConditionValueBuffer.Name);
                                Object.Add('t', ConditionValueBuffer.Type);
                                Data.Add(Object);
                            until ConditionValueBuffer.Next() = 0;
                        CurrPage.FormulaControl.LoadFields(Data);
                    end;

                    trigger FormulaDataReady(Data: Text)
                    begin
                        FormulaText := Data;
                        Ready := true;
                        CurrPage.Close();
                    end;
                }
            }
        }
    }

    var
        ConditionValueBuffer: Record lvnExpressionValueBuffer temporary;
        Ready: Boolean;
        FormulaText: Text;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            if not Ready then begin
                CurrPage.FormulaControl.PrepareFormulaData();
                exit(false);
            end;
    end;

    procedure SetFieldList(var FieldList: Record lvnExpressionValueBuffer)
    var
        Engine: Codeunit lvnExpressionEngine;
    begin
        Engine.CloneValueBuffer(FieldList, ConditionValueBuffer);
    end;

    procedure SetFormula(Formula: Text)
    begin
        FormulaText := Formula;
    end;

    procedure GetFormula(): Text
    begin
        exit(FormulaText);
    end;

    procedure IsFormulaCreated(): Boolean
    begin
        exit(Ready);
    end;


}