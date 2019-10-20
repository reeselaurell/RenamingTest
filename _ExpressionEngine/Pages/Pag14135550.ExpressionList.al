page 14135550 lvngExpressionList
{
    PageType = List;
    SourceTable = lvngExpressionHeader;
    Caption = 'Expression List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                ApplicationArea = All;
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    TempCondBuffer: Record lvngExpressionValueBuffer temporary;
                    ConditionHeader: Record lvngExpressionHeader;
                    FormulaEdit: Page lvngFormulaEdit;
                    SwitchEdit: Page lvngSwitchEdit;
                    ConditionEdit: Page lvngConditionEdit;
                    IifEdit: Page lvngIifEdit;
                begin
                    FillBuffer(Rec, Metadata, TempCondBuffer);
                    case Type of
                        Type::Formula:
                            begin
                                Clear(FormulaEdit);
                                FormulaEdit.SetFieldList(TempCondBuffer);
                                FormulaEdit.SetFormula(Engine.GetFormulaFromLines(Rec));
                                FormulaEdit.LookupMode(true);
                                FormulaEdit.RunModal();
                                if FormulaEdit.IsFormulaCreated() then
                                    Engine.SetFormulaToLines(Rec, FormulaEdit.GetFormula());
                            end;
                        Type::"Switch":
                            begin
                                Clear(SwitchEdit);
                                ConditionHeader.Reset();
                                ConditionHeader := Rec;
                                ConditionHeader.SetRecFilter();
                                SwitchEdit.SetTableView(ConditionHeader);
                                SwitchEdit.LookupMode(true);
                                SwitchEdit.SetFieldList(TempCondBuffer);
                                SwitchEdit.RunModal();
                            end;
                        Type::Condition:
                            begin
                                Clear(ConditionEdit);
                                ConditionHeader.Reset();
                                ConditionHeader := Rec;
                                ConditionHeader.SetRecFilter();
                                ConditionEdit.SetTableView(ConditionHeader);
                                ConditionEdit.LookupMode(true);
                                ConditionEdit.SetFieldList(TempCondBuffer);
                                ConditionEdit.RunModal();
                            end;
                        Type::Iif:
                            begin
                                Clear(IifEdit);
                                ConditionHeader.Reset();
                                ConditionHeader := Rec;
                                ConditionHeader.SetRecFilter();
                                IifEdit.SetTableView(ConditionHeader);
                                IifEdit.LookupMode(true);
                                IifEdit.SetFieldList(TempCondBuffer);
                                IifEdit.RunModal();
                            end;
                    end;
                end;
            }
            action("Copy From")
            {
                Image = CopyFromTask;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConditionHeader: Record lvngExpressionHeader;
                    ConditionLineFrom: Record lvngExpressionLine;
                    ConditionLineTo: Record lvngExpressionLine;
                begin
                    ConditionLineTo.Reset();
                    ConditionLineTo.SetFilter("Expression Code", Code);
                    if not ConditionLineTo.IsEmpty() then
                        if not Confirm(DestinationExistsQst) then
                            exit;
                    ConditionHeader.Reset();
                    ConditionHeader.SetRange(Type, Type);
                    ConditionHeader.SetFilter(Code, '<>%1', Code);
                    if Page.RunModal(0, ConditionHeader) = Action::LookupOK then begin
                        ConditionLineTo.Reset();
                        ConditionLineTo.SetFilter("Expression Code", Code);
                        ConditionLineTo.DeleteAll();
                        ConditionLineFrom.Reset();
                        ConditionLineFrom.SetRange("Expression Code", ConditionHeader.Code);
                        if ConditionLineFrom.FindSet() then
                            repeat
                                Clear(ConditionLineTo);
                                ConditionLineTo := ConditionLineFrom;
                                ConditionLineTo."Expression Code" := Code;
                                ConditionLineTo.Insert();
                            until ConditionLineFrom.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        Engine: Codeunit lvngExpressionEngine;
        DestinationExistsQst: Label 'This expression already contains associated data.\If you choose to continue it will be completely overwritten.\Continue anyway?';
        ProviderId: Guid;
        Metadata: Text;
        DefaultType: Enum lvngExpressionType;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Consumer Id" := ProviderId;
        Rec.Type := DefaultType;
    end;

    [IntegrationEvent(false, false)]
    procedure FillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
    end;

    procedure SelectExpression(ConsumerId: Guid; ConsumerMetadata: Text; SelectedRecord: Code[20]; PreferredType: Enum lvngExpressionType): Code[20]
    var
        ExpressionList: Page lvngExpressionList;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        Metadata := ConsumerMetadata;
        ProviderId := ConsumerId;
        DefaultType := PreferredType;
        ExpressionHeader.Reset();
        ExpressionHeader.SetRange("Consumer Id", ConsumerId);
        //case AllowedTypes of
        //    AllowedTypes::Condition, AllowedTypes::Formula, AllowedTypes::Switch, AllowedTypes::Iif: //Simple filter
        //        ExpressionHeader.SetRange(Type, AllowedTypes);
        //TODO: Set Complex filter when filtering on enums is fixed
        //    else //Complex filter
        //ExpressionHeader.SetFilter(Type, GetExpressionFilter(AllowedTypes));
        //SetExpressionFilter(ExpressionHeader, AllowedTypes);
        //begin
        //    ExpressionHeader.SetFilter(Type, '%1|%2', AllowedTypes::Condition, AllowedTypes::Formula);
        //    Message(ExpressionHeader.GetFilter(Type));
        //end;
        //end;
        CurrPage.SetTableView(ExpressionHeader);
        if SelectedRecord <> '' then
            if ExpressionHeader.Get(SelectedRecord, ConsumerId) then
                CurrPage.SetRecord(ExpressionHeader);
        CurrPage.LookupMode(true);
        if CurrPage.RunModal() = Action::LookupOK then
            exit(Code)
        else
            exit('');
    end;
    /*
    local procedure GetExpressionFilter(ExpressionType: Enum lvngExpressionType): Text
    var
        Idx: Integer;
        Test: Integer;
        Ordinals: List of [Integer];
        Filter: Text;
        Val: Integer;
    begin
        Filter := '';
        if ExpressionType <> ExpressionType::All then begin
            Test := ExpressionType.AsInteger();
            Ordinals := ExpressionType.Ordinals;
            for Idx := Ordinals.Count() downto 1 do begin
                if Test > 0 then begin
                    Val := Ordinals.Get(Idx);
                    if Test div Val > 0 then
                        Filter := '''' + ExpressionType.Names().Get(Idx) + '''|' + Filter;
                    Test := Test mod Val;
                end;
            end;
        end;
        if Filter = '' then
            exit('')
        else
            exit(DelChr(Filter, '>', '|'));
    end;

    local procedure SetExpressionFilter(var ExpressionHeader: Record lvngExpressionHeader; ExpressionType: Enum lvngExpressionType)
    var
        Ordinals: List of [Integer];
        Allowed: List of [Integer];
        Test: Integer;
        Val: Integer;
        Idx: Integer;
    begin
        //Workaround (for some reason pipe filter on enums is not supported, at least for now)
        if ExpressionHeader.FindSet() then begin
            Test := ExpressionType.AsInteger();
            Ordinals := ExpressionType.Ordinals;
            for Idx := Ordinals.Count() downto 2 do begin //First is 0
                Val := Ordinals.Get(Idx);
                if Test >= Val then
                    Allowed.Add(Val);
                Test := Test mod Val;
            end;
            repeat
                if Allowed.IndexOf(ExpressionHeader.Type.AsInteger()) <> 0 then
                    ExpressionHeader.Mark(true);
            until ExpressionHeader.Next() = 0;
        end;
        ExpressionHeader.MarkedOnly(true);
    end;
    */
}