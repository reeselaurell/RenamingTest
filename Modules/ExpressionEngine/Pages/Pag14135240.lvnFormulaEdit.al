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
                        TempExpressionValueBuffer.Reset();
                        if TempExpressionValueBuffer.FindSet() then
                            repeat
                                Clear(Object);
                                Object.Add('n', TempExpressionValueBuffer.Name);
                                Object.Add('t', TempExpressionValueBuffer.Type);
                                Data.Add(Object);
                            until TempExpressionValueBuffer.Next() = 0;
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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            if not Ready then begin
                CurrPage.FormulaControl.PrepareFormulaData();
                exit(false);
            end;
    end;

    var
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        Ready: Boolean;
        FormulaText: Text;

    procedure SetFieldList(var FieldList: Record lvnExpressionValueBuffer)
    var
        Engine: Codeunit lvnExpressionEngine;
    begin
        Engine.CloneValueBuffer(FieldList, TempExpressionValueBuffer);
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