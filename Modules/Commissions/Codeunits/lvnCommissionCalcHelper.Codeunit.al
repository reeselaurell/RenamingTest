codeunit 14135300 "lvnCommissionCalcHelper"
{
    SingleInstance = true;

    var
        CommissionId: Guid;
        ReportCommissionId: Guid;
        LoanLevelConditionCodeLbl: Label 'LOAN';
        PeriodLevelConditionCodeLbl: Label 'PERIOD';
        ReportingFunctionCodeLbl: Label 'REPORTLOAN';

    procedure GetCommissionConsumerId(): Guid
    begin
        if IsNullGuid(CommissionId) then
            Evaluate(CommissionId, '3def5809-acaa-44c2-a1bb-1b4ced82881d');
        exit(CommissionId);
    end;

    procedure GetCommissionReportConsumerId(): Guid
    begin
        if IsNullGuid(ReportCommissionId) then
            Evaluate(ReportCommissionId, '9c8a9515-e298-4d37-8eee-fe1ec30afd7d');
        exit(ReportCommissionId);
    end;

    procedure GetLoanLevelExpressionCode(): Code[20]
    begin
        exit(LoanLevelConditionCodeLbl);
    end;

    procedure GetPeriodLevelExpressionCode(): Code[20]
    begin
        exit(PeriodLevelConditionCodeLbl);
    end;

    procedure GetReportingExpressionCode(): Code[20]
    begin
        exit(ReportingFunctionCodeLbl);
    end;

    procedure CalculateLoanTier(
        var LoanCommissionBuffer: Record lvnLoanCommissionBuffer;
        CommissionTierHeader: Record lvnCommissionTierHeader;
        OnGoingVolume: Decimal;
        TotalVolume: Decimal;
        OnGoingUnits: Decimal;
        TotalUnits: Decimal)
    var
        Math: Codeunit Math;
        CalculatedAmount: Decimal;
    begin
        case CommissionTierHeader."Tier Type" of
            CommissionTierHeader."Tier Type"::Volume:
                CalculatedAmount := CalculateTiersAmount(CommissionTierHeader.Code, LoanCommissionBuffer."Base Amount", OnGoingVolume, TotalVolume, false);
            CommissionTierHeader."Tier Type"::Units:
                CalculatedAmount := CalculateTiersAmount(CommissionTierHeader.Code, 1, OnGoingUnits, TotalUnits, true);
            CommissionTierHeader."Tier Type"::"Volume/Units Max":
                CalculatedAmount := Math.Max(CalculateTiersAmount(CommissionTierHeader.Code, LoanCommissionBuffer."Base Amount", OnGoingVolume, TotalVolume, false), CalculateTiersAmount(CommissionTierHeader.Code, 1, OnGoingUnits, TotalUnits, true));
            CommissionTierHeader."Tier Type"::"Volume/Units Min":
                CalculatedAmount := Math.Min(CalculateTiersAmount(CommissionTierHeader.Code, LoanCommissionBuffer."Base Amount", OnGoingVolume, TotalVolume, false), CalculateTiersAmount(CommissionTierHeader.Code, 1, OnGoingUnits, TotalUnits, true));
        end;
        if CommissionTierHeader."Tier Return Value" = CommissionTierHeader."Tier Return Value"::Amount then begin
            LoanCommissionBuffer."Commission Amount" := CalculatedAmount;
            if LoanCommissionBuffer."Base Amount" <> 0 then
                LoanCommissionBuffer.Bps := CalculatedAmount / LoanCommissionBuffer."Base Amount" * 10000;
        end else begin
            LoanCommissionBuffer.Bps := CalculatedAmount;
            LoanCommissionBuffer."Commission Amount" := LoanCommissionBuffer."Base Amount" * CalculatedAmount / 10000;
        end;
        LoanCommissionBuffer.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::lvnExpressionList, 'FillBuffer', '', true, true)]
    local procedure OnFillBuffer(
        ExpressionHeader: Record lvnExpressionHeader;
        ConsumerMetadata: Text;
        var ExpressionBuffer: Record lvnExpressionValueBuffer)
    begin
        if GetCommissionConsumerId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
                LoanLevelConditionCodeLbl:
                    FillLoanFields(ExpressionBuffer);
                PeriodLevelConditionCodeLbl:
                    FillPeriodFields(ExpressionBuffer);
            end;
    end;

    local procedure CalculateTiersAmount(
     CommissionTierHeaderCode: Code[20];
        BaseAmount: Decimal;
        OnGoingAmount: Decimal;
        TotalAmount: Decimal;
        UseUnits: Boolean): Decimal
    var
        TempCalcTierLine: Record lvnCommissionTierLine temporary;
        ReturnAmount: Decimal;
        MaxAmount: Decimal;
        CurrentAmount: Decimal;
    begin
        CurrentAmount := BaseAmount;
        if CurrentAmount <= 0 then
            exit(0);
        MaxAmount := 999999999;
        FillTempCalcTierLines(CommissionTierHeaderCode, TempCalcTierLine, UseUnits);
        TempCalcTierLine.Reset();
        TempCalcTierLine.FindLast();
        TempCalcTierline."To Volume" := MaxAmount;
        TempCalcTierLine.Modify();
        TempCalcTierLine.Reset();
        TempCalcTierLine.SetRange("From Volume", 0, TotalAmount);
        TempCalcTierLine.SetRange(Retroactive, true);
        if TempCalcTierLine.FindLast() then begin
            TempCalcTierLine.SetRange(Retroactive);
            TempCalcTierLine.ModifyAll(Rate, TempCalcTierLine.Rate);
        end;
        TempCalcTierLine.Reset();
        TempCalcTierLine.SetRange("To Volume", OnGoingAmount - CurrentAmount, MaxAmount);
        if TempCalcTierLine.FindFirst() then begin
            TempCalcTierLine."From Volume" := OnGoingAmount - CurrentAmount;
            TempCalcTierLine.Modify();
        end;
        if TempCalcTierLine.FindSet() then
            repeat
                TempCalcTierLine."Spread Amount" := (TempCalcTierLine."To Volume" - TempCalcTierLine."From Volume");
                if TempCalcTierLine."Spread Amount" > CurrentAmount then
                    TempCalcTierLine."Spread Amount" := CurrentAmount;
                CurrentAmount := CurrentAmount - TempCalcTierLine."Spread Amount";
                TempCalcTierLine.Modify();
            until (TempCalcTierLine.Next() = 0) or (CurrentAmount <= 0);
        TempCalcTierLine.Reset();
        TempCalcTierLine.SetFilter("Spread Amount", '<>%1', 0);
        if TempCalcTierLine.FindSet() then
            repeat
                ReturnAmount := ReturnAmount + TempCalcTierLine.Rate * TempCalcTierLine."Spread Amount" / BaseAmount;
            until TempCalcTierLine.Next() = 0;
        exit(ReturnAmount);
    end;

    local procedure FillTempCalcTierLines(
        TierCode: Code[20];
        var TempCalcTierLine: Record lvnCommissionTierLine;
        UseUnits: Boolean)
    var
        CommissionTierLine: Record lvnCommissionTierLine;
    begin
        CommissionTierLine.Reset();
        CommissionTierLine.SetRange("Tier Code", TierCode);
        CommissionTierLine.FindSet();
        repeat
            TempCalcTierLine := CommissionTierLine;
            if UseUnits then begin
                TempCalcTierLine."From Volume" := TempCalcTierLine."From Units";
                TempCalcTierLine."To Volume" := TempCalcTierLine."To Units";
            end;
            TempCalcTierLine.Insert();
        until CommissionTierLine.Next() = 0;
    end;

    local procedure AppendExpressionField(
        var ExpressionValueBuffer: Record lvnExpressionValueBuffer;
        var ValueNo: Integer;
        Name: Text;
        Type: Text)
    begin
        Clear(ExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        ExpressionValueBuffer.Number := ValueNo;
        ExpressionValueBuffer.Name := Name;
        ExpressionValueBuffer.Type := Type;
        ExpressionValueBuffer.Insert();
    end;

    local procedure FillLoanFields(var ExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                AppendExpressionField(ExpressionValueBuffer, FieldSequenceNo, LoanFieldsConfiguration."Field Name", Format(LoanFieldsConfiguration."Value Type"));
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.FindSet();
        repeat
            AppendExpressionField(ExpressionValueBuffer, FieldSequenceNo, TableFields.FieldName, TableFields."Type Name");
        until TableFields.Next() = 0;
        AppendExpressionField(ExpressionValueBuffer, FieldSequenceNo, '!CalculationParameter', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, FieldSequenceNo, '!ProfileLineTag', 'Text');
    end;

    local procedure FillPeriodFields(var ExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        ValueNo: Integer;
    begin
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'CurrentCount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'CurrentAmount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'CurrentCommission', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'PeriodCount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'PeriodAmount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'PeriodCommission', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'MonthCount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'MonthAmount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'MonthCommission', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'QuarterCount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'QuarterAmount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'QuarterCommission', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'YearCount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'YearAmount', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'YearCommission', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'Month', 'Boolean');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, 'Quarter', 'Boolean');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, '!CalculationParameter', 'Decimal');
        AppendExpressionField(ExpressionValueBuffer, ValueNo, '!ProfileLineTag', 'Text');
    end;
}