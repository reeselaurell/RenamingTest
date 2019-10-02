codeunit 14135220 lvngPerformanceMgmt
{
    SingleInstance = true;

    var
        CircularReferenceErr: Label 'Circular reference detected!';
        BandExpressionConsumerId: Guid;
        RowExpressionConsumerId: Guid;
        RowFieldFormatTxt: Label 'BAND%1COL%2';
        BandCountTxt: Label '$BANDCOUNT';
        ColCountTxt: Label '$COLCOUNT';

    procedure GetBandExpressionConsumerId(): Guid
    begin
        if IsNullGuid(BandExpressionConsumerId) then
            Evaluate(BandExpressionConsumerId, '3def5809-ac44-44c2-a1bb-1b4ced82881d');
        exit(BandExpressionConsumerId);
    end;

    procedure GetRowExpressionConsumerId(): Guid
    begin
        if IsNullGuid(RowExpressionConsumerId) then
            Evaluate(RowExpressionConsumerId, '8085a41d-56df-4ce5-9122-d6a12698faa1');
    end;

    procedure CalculatePeriod(var Buffer: Record lvngPerformanceValueBuffer; var BandLine: Record lvngPeriodPerfBandSchemaLine; var RowSchema: Record lvngPerformanceRowSchema; var ColSchema: Record lvngPerformanceColSchema; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
        ColLine: Record lvngPerformanceColSchemaLine;
        CalculationUnit: Record lvngCalculationUnit;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
    begin
        ColLine.Reset();
        ColLine.SetRange("Schema Code", ColSchema.Code);
        ColLine.FindSet();
        repeat
            RowLine.Reset();
            RowLine.SetRange("Schema Code", RowSchema.Code);
            RowLine.SetRange("Column No.", ColLine."Column No.");
            RowLine.FindSet();
            repeat
                CalculationUnit.Get(RowLine."Calculation Unit Code");
                Clear(Buffer);
                Buffer."Column No." := ColLine."Column No.";
                Buffer."Row No." := RowLine."Line No.";
                Buffer."Band No." := BandLine."Line No.";
                Buffer.Value := CalculateSingleBandValue(CalculationUnit, SystemFilter, Cache, Path);
                Buffer.Insert();
            until RowLine.Next() = 0;
        until ColLine.Next() = 0;
    end;

    local procedure CalculateSingleRowValue(RowNo: Integer; ExpressionCode: Code[20]; var Buffer: Record lvngPerformanceValueBuffer) Result: Decimal
    var
        ValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        ExpressionEngine: Codeunit lvngExpressionEngine;
        Number: Integer;
        BandNo: Integer;
    begin
        //NO FORWARD REFERENCES AT THE MOMENT!!!
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        if not Buffer.FindSet() then
            exit(0);
        repeat
            Number += 1;
            Clear(ValueBuffer);
            ValueBuffer.Number := Number;
            ValueBuffer.Name := StrSubstNo(RowFieldFormatTxt, Buffer."Band No.", Buffer."Column No.");
            ValueBuffer.Type := 'System.Decimal';
            ValueBuffer.Value := Format(Buffer.Value);
            ValueBuffer.Insert();
        until Buffer.Next() = 0;
        //Insert band count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Column No.", 1);
        Clear(ValueBuffer);
        ValueBuffer.Number := Number + 1;
        ValueBuffer.Name := BandCountTxt;
        ValueBuffer.Type := 'System.Decimal';
        ValueBuffer.Value := Format(Buffer.Count());
        ValueBuffer.Insert();
        Buffer.FindFirst();
        BandNo := Buffer."Band No.";
        //Insert column count
        Buffer.Reset();
        Buffer.SetRange("Row No.", RowNo);
        Buffer.SetRange("Band No.", BandNo);
        Clear(ValueBuffer);
        ValueBuffer.Number := Number + 2;
        ValueBuffer.Name := ColCountTxt;
        ValueBuffer.Type := 'System.Decimal';
        ValueBuffer.Value := Format(Buffer.Count());
        ValueBuffer.Insert();
        ExpressionHeader.Get(ExpressionCode);
        Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, ValueBuffer));
    end;

    local procedure CalculateSingleBandValue(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    begin
        if Cache.Get(CalculationUnit.Code, Result) then
            exit;
        if Path.IndexOf(CalculationUnit.Code) <> -1 then
            Error(CircularReferenceErr);
        case CalculationUnit.Type of
            CalculationUnit.Type::lvngConstant:
                Result := CalculationUnit."Constant Value";
            CalculationUnit.Type::lvngAmountLookup, CalculationUnit.Type::lvngCountLookup:
                begin
                    if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::lvngLoanCard then
                        Result := LookupLoanCard(CalculationUnit, SystemFilter)
                    else
                        Result := LookupGeneralLedger(CalculationUnit, SystemFilter);
                end;
            CalculationUnit.Type::lvngExpression:
                begin
                    Path.Add(CalculationUnit.Code);
                    Result := CalculateBandExpression(CalculationUnit, SystemFilter, Cache, Path);
                    Path.RemoveAt(Path.Count() - 1);
                end;
        end;
        Cache.Add(CalculationUnit.Code, Result);
    end;

    local procedure LookupLoanCard(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter) Result: Decimal
    var
        LoanAmountsByDimension: Query lvngLoanAmountsByDimension;
    begin
        if CalculationUnit."Dimension 1 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension1Filter, CalculationUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension2Filter, CalculationUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension3Filter, CalculationUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension4Filter, CalculationUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension5Filter, CalculationUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension6Filter, CalculationUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension7Filter, CalculationUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension8Filter, CalculationUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                LoanAmountsByDimension.SetFilter(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            LoanAmountsByDimension.SetFilter(BusinessUnitFilter, CalculationUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                LoanAmountsByDimension.SetFilter(BusinessUnitFilter, SystemFilter."Business Unit");
        case CalculationUnit."Based On Date" of
            CalculationUnit."Based On Date"::lvngApplication:
                LoanAmountsByDimension.SetRange(DateApplicationFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::lvngClosed:
                LoanAmountsByDimension.SetRange(DateClosedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::lvngFunded:
                LoanAmountsByDimension.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::lvngLocked:
                LoanAmountsByDimension.SetRange(DateLockedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::lvngSold:
                LoanAmountsByDimension.SetRange(DateSoldFilter, SystemFilter."Date From", SystemFilter."Date To");
        end;
        LoanAmountsByDimension.Open();
        LoanAmountsByDimension.Read();
        if CalculationUnit.Type = CalculationUnit.Type::lvngAmountLookup then
            Result := LoanAmountsByDimension.LoanAmount
        else
            Result := LoanAmountsByDimension.LoanCount;
        LoanAmountsByDimension.Close();
    end;

    local procedure LookupGeneralLedger(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter) Result: Decimal
    var
        GLEntry: Record lvngGroupedGLEntry;
    begin
        GLEntry.Reset();
        GLEntry.SetFilter(lvngGLAccountNo, CalculationUnit."Account No. Filter");
        if CalculationUnit."Dimension 1 Filter" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension1Code, CalculationUnit."Dimension 1 Filter")
        else
            if SystemFilter."Shortcut Dimension 1" <> '' then
                GLEntry.SetFilter(lvngGlobalDimension1Code, SystemFilter."Shortcut Dimension 1");
        if CalculationUnit."Dimension 2 Filter" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension2Code, CalculationUnit."Dimension 2 Filter")
        else
            if SystemFilter."Shortcut Dimension 2" <> '' then
                GLEntry.SetFilter(lvngGlobalDimension2Code, SystemFilter."Shortcut Dimension 2");
        if CalculationUnit."Dimension 3 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension3Code, CalculationUnit."Dimension 3 Filter")
        else
            if SystemFilter."Shortcut Dimension 3" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension3Code, SystemFilter."Shortcut Dimension 3");
        if CalculationUnit."Dimension 4 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension4Code, CalculationUnit."Dimension 4 Filter")
        else
            if SystemFilter."Shortcut Dimension 4" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension4Code, SystemFilter."Shortcut Dimension 4");
        if CalculationUnit."Dimension 5 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension5Code, CalculationUnit."Dimension 5 Filter")
        else
            if SystemFilter."Shortcut Dimension 5" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension5Code, SystemFilter."Shortcut Dimension 5");
        if CalculationUnit."Dimension 6 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension6Code, CalculationUnit."Dimension 6 Filter")
        else
            if SystemFilter."Shortcut Dimension 6" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension6Code, SystemFilter."Shortcut Dimension 6");
        if CalculationUnit."Dimension 7 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension7Code, CalculationUnit."Dimension 7 Filter")
        else
            if SystemFilter."Shortcut Dimension 7" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension7Code, SystemFilter."Shortcut Dimension 7");
        if CalculationUnit."Dimension 8 Filter" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension8Code, CalculationUnit."Dimension 8 Filter")
        else
            if SystemFilter."Shortcut Dimension 8" <> '' then
                GLEntry.SetFilter(lvngShortcutDimension8Code, SystemFilter."Shortcut Dimension 8");
        if CalculationUnit."Business Unit Filter" <> '' then
            GLEntry.SetFilter(lvngBusinessUnitCode, CalculationUnit."Business Unit Filter")
        else
            if SystemFilter."Business Unit" <> '' then
                GLEntry.SetFilter(lvngBusinessUnitCode, SystemFilter."Business Unit");
        GLEntry.SetRange(lvngPostingDate, SystemFilter."Date From", SystemFilter."Date To");
        case CalculationUnit."Amount Type" of
            CalculationUnit."Amount Type"::lvngNetAmount:
                begin
                    GLEntry.CalcSums(lvngAmount);
                    Result := GLEntry.lvngAmount;
                end;
            CalculationUnit."Amount Type"::lvngDebitAmount:
                begin
                    GLEntry.CalcSums(lvngDebitAmount);
                    Result := GLEntry.lvngDebitAmount;
                end;
            CalculationUnit."Amount Type"::lvngCreditAmount:
                begin
                    GLEntry.CalcSums(lvngCreditAmount);
                    Result := GLEntry.lvngCreditAmount;
                end;
        end;
    end;

    local procedure CalculateBandExpression(var BaseCalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    var
        CalculationUnit: Record lvngCalculationUnit;
        CalculationLine: Record lvngCalculationUnitLine;
        ValueBuffer: Record lvngExpressionValueBuffer temporary;
        ExpressionHeader: Record lvngExpressionHeader;
        ExpressionEngine: Codeunit lvngExpressionEngine;
    begin
        CalculationLine.Reset();
        CalculationLine.SetRange("Unit Code", BaseCalculationUnit.Code);
        if not CalculationLine.FindSet() then
            exit(0);
        repeat
            CalculationUnit.Get(CalculationLine."Source Unit Code");
            Clear(ValueBuffer);
            ValueBuffer.Name := CalculationLine."Source Unit Code";
            ValueBuffer.Number := CalculationLine."Line no.";
            ValueBuffer.Type := 'System.Decimal';
            ValueBuffer.Value := Format(CalculateSingleBandValue(CalculationUnit, SystemFilter, Cache, Path), 0, 9);
            ValueBuffer.Insert();
        until CalculationLine.Next() = 0;
        ExpressionHeader.Get(BaseCalculationUnit."Expression Code");
        Evaluate(Result, ExpressionEngine.CalculateFormula(ExpressionHeader, ValueBuffer));
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', false, false)]
    local procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    var
        CalcUnitLine: Record lvngCalculationUnitLine;
        BranchPortalMgmt: Codeunit lvngPerformanceMgmt;
    begin
        if BranchPortalMgmt.GetBandExpressionConsumerId() = ExpressionHeader."Consumer Id" then begin
            CalcUnitLine.Reset();
            CalcUnitLine.SetRange("Unit Code", ConsumerMetadata);
            if CalcUnitLine.FindSet() then
                repeat
                    Clear(ExpressionBuffer);
                    ExpressionBuffer.Name := CalcUnitLine."Source Unit Code";
                    ExpressionBuffer.Number := CalcUnitLine."Line no.";
                    ExpressionBuffer.Type := 'System.Decimal';
                    ExpressionBuffer.Insert();
                until CalcUnitLine.Next() = 0;
        end;
    end;
}