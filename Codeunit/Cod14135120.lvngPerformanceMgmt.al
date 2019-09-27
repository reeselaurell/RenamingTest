codeunit 14135120 lvngPerformanceMgmt
{
    SingleInstance = true;

    var
        CircularReferenceErr: Label 'Circular reference detected!';
        CalcUnitConsumerId: Guid;

    procedure GetCalcUnitConsumerId(): Guid
    begin
        if IsNullGuid(CalcUnitConsumerId) then
            Evaluate(CalcUnitConsumerId, '3def5809-ac44-44c2-a1bb-1b4ced82881d');
        exit(CalcUnitConsumerId);
    end;

    procedure CalculatePeriod(var Buffer: Record lvngPerformanceValueBuffer; var ColGroupSchema: Record lvngPerformanceColumnGroup; var RowPerformanceSchema: Record lvngRowPerformanceSchema; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        ColGroupLine: Record lvngPerformanceColumnGroupLine;
        PerformanceLine: Record lvngPerformanceSchemaLine;
        CalculationUnit: Record lvngCalculationUnit;
        Cache: Dictionary of [Code[20], Decimal];
        Path: List of [Code[20]];
        ColumnNo: Integer;
    begin
        Buffer.Reset();
        if Buffer.FindLast() then
            ColumnNo := Buffer."Column No." + 1;
        ColGroupLine.Reset();
        ColGroupLine.SetRange("Group Code", ColGroupSchema.Code);
        ColGroupLine.FindSet();
        repeat
            PerformanceLine.Reset();
            PerformanceLine.SetRange("Performance Schema Code", RowPerformanceSchema.Code);
            PerformanceLine.SetRange("Column Group Code", ColGroupLine."Group Code");
            PerformanceLine.SetRange("Column Group Line No.", ColGroupLine."Line No.");
            PerformanceLine.FindSet();
            repeat
                CalculationUnit.Get(PerformanceLine."Calculation Unit Code");
                Clear(Buffer);
                Buffer."Column No." := ColumnNo;
                Buffer."Row No." := PerformanceLine."Line No.";
                Buffer.Value := CalculateSingleValue(CalculationUnit, SystemFilter, Cache, Path);
                Buffer.Insert();
            until PerformanceLine.Next() = 0;
            ColumnNo := ColumnNo + 1;
        until ColGroupLine.Next() = 0;
    end;

    local procedure CalculateSingleValue(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
    begin
        if Cache.Get(CalculationUnit.Code, Result) then
            exit;
        if Path.IndexOf(CalculationUnit.Code) <> -1 then
            Error(CircularReferenceErr);
        case CalculationUnit.Type of
            CalculationUnit.Type::Constant:
                Result := CalculationUnit."Constant Value";
            CalculationUnit.Type::"Amount Lookup", CalculationUnit.Type::"Count Lookup":
                begin
                    if CalculationUnit."Lookup Source" = CalculationUnit."Lookup Source"::"Loan Card" then
                        Result := LookupLoanCard(CalculationUnit, SystemFilter)
                    else
                        Result := LookupGeneralLedger(CalculationUnit, SystemFilter);
                end;
            CalculationUnit.Type::Expression:
                begin
                    Path.Add(CalculationUnit.Code);
                    Result := CalculateExpression(CalculationUnit, SystemFilter, Cache, Path);
                    Path.RemoveAt(Path.Count() - 1);
                end;
        end;
        Cache.Add(CalculationUnit.Code, Result);
    end;

    local procedure LookupLoanCard(var CalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter) Result: Decimal
    var
        LoanAmountsByDimension: Query lvngLoanAmountsByDimension;
    begin
        if SystemFilter."Shortcut Dimension 1" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
        if SystemFilter."Shortcut Dimension 2" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
        if SystemFilter."Shortcut Dimension 3" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
        if SystemFilter."Shortcut Dimension 4" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
        if SystemFilter."Shortcut Dimension 5" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
        if SystemFilter."Shortcut Dimension 6" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
        if SystemFilter."Shortcut Dimension 7" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
        if SystemFilter."Shortcut Dimension 8" <> '' then
            LoanAmountsByDimension.SetFilter(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
        if SystemFilter."Business Unit" <> '' then
            LoanAmountsByDimension.SetFilter(BusinessUnitFilter, SystemFilter."Business Unit");
        case CalculationUnit."Based On Date" of
            CalculationUnit."Based On Date"::Application:
                LoanAmountsByDimension.SetRange(DateApplicationFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::Closed:
                LoanAmountsByDimension.SetRange(DateClosedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::Funded:
                LoanAmountsByDimension.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::Locked:
                LoanAmountsByDimension.SetRange(DateLockedFilter, SystemFilter."Date From", SystemFilter."Date To");
            CalculationUnit."Based On Date"::Sold:
                LoanAmountsByDimension.SetRange(DateSoldFilter, SystemFilter."Date From", SystemFilter."Date To");
        end;
        LoanAmountsByDimension.Open();
        LoanAmountsByDimension.Read();
        if CalculationUnit.Type = CalculationUnit.Type::"Amount Lookup" then
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
        if SystemFilter."Shortcut Dimension 1" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension1Code, SystemFilter."Shortcut Dimension 1");
        if SystemFilter."Shortcut Dimension 2" <> '' then
            GLEntry.SetFilter(lvngGlobalDimension2Code, SystemFilter."Shortcut Dimension 2");
        if SystemFilter."Shortcut Dimension 3" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension3Code, SystemFilter."Shortcut Dimension 3");
        if SystemFilter."Shortcut Dimension 4" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension4Code, SystemFilter."Shortcut Dimension 4");
        if SystemFilter."Shortcut Dimension 5" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension5Code, SystemFilter."Shortcut Dimension 5");
        if SystemFilter."Shortcut Dimension 6" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension6Code, SystemFilter."Shortcut Dimension 6");
        if SystemFilter."Shortcut Dimension 7" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension7Code, SystemFilter."Shortcut Dimension 7");
        if SystemFilter."Shortcut Dimension 8" <> '' then
            GLEntry.SetFilter(lvngShortcutDimension8Code, SystemFilter."Shortcut Dimension 8");
        if SystemFilter."Business Unit" <> '' then
            GLEntry.SetFilter(lvngBusinessUnitCode, SystemFilter."Business Unit");
        GLEntry.SetRange(lvngPostingDate, SystemFilter."Date From", SystemFilter."Date To");
        case CalculationUnit."Amount Type" of
            CalculationUnit."Amount Type"::"Net Amount":
                begin
                    GLEntry.CalcSums(lvngAmount);
                    Result := GLEntry.lvngAmount;
                end;
            CalculationUnit."Amount Type"::"Debit Amount":
                begin
                    GLEntry.CalcSums(lvngDebitAmount);
                    Result := GLEntry.lvngDebitAmount;
                end;
            CalculationUnit."Amount Type"::"Credit Amount":
                begin
                    GLEntry.CalcSums(lvngCreditAmount);
                    Result := GLEntry.lvngCreditAmount;
                end;
        end;
    end;

    local procedure CalculateExpression(var BaseCalculationUnit: Record lvngCalculationUnit; var SystemFilter: Record lvngSystemCalculationFilter; var Cache: Dictionary of [Code[20], Decimal]; Path: List of [Code[20]]) Result: Decimal
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
            ValueBuffer.Value := Format(CalculateSingleValue(CalculationUnit, SystemFilter, Cache, Path), 0, 9);
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
        if BranchPortalMgmt.GetCalcUnitConsumerId() = ExpressionHeader."Consumer Id" then begin
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