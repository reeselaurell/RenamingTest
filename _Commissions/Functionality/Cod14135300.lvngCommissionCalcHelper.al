codeunit 14135300 "lvngCommissionCalcHelper"
{
    trigger OnRun()
    begin

    end;

    procedure CalculateLoanTier(var lvngLoanCommissionBuffer: Record lvngLoanCommissionBuffer; lvngCommissionProfileLine: Record lvngCommissionProfileLine; onGoingVolume: Decimal; totalVolume: Decimal; onGoingUnits: Decimal; totalUnits: Decimal)
    var
        lvngAmountBasedOnVolume: Decimal;
        lvngAmountBasedOnUnits: Decimal;
    begin
        CheckTiersInitialization(lvngCommissionProfileLine.lvngTierCode);
        case lvngTempCommissionTierHeader.lvngTierType of
            lvngTempCommissionTierHeader.lvngTierType::lvngVolume:
                begin
                    lvngAmountBasedOnVolume := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, lvngLoanCommissionBuffer.lvngCommissionBaseAmount, onGoingVolume, totalVolume);
                    lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnVolume;
                    if lvngLoanCommissionBuffer.lvngCommissionBaseAmount <> 0 then
                        lvngLoanCommissionBuffer.lvngCommissionBps := lvngLoanCommissionBuffer.lvngCommissionAmount / lvngLoanCommissionBuffer.lvngCommissionBaseAmount * 10000;
                end;
            lvngTempCommissionTierHeader.lvngTierType::lvngUnits:
                begin
                    lvngAmountBasedOnUnits := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, 1, onGoingUnits, totalUnits);
                    lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnVolume;
                    if lvngLoanCommissionBuffer.lvngCommissionBaseAmount <> 0 then
                        lvngLoanCommissionBuffer.lvngCommissionBps := lvngLoanCommissionBuffer.lvngCommissionAmount / lvngLoanCommissionBuffer.lvngCommissionBaseAmount * 10000;
                end;
            lvngTempCommissionTierHeader.lvngTierType::lvngVolumeUnitsMax:
                begin
                    lvngAmountBasedOnVolume := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, lvngLoanCommissionBuffer.lvngCommissionBaseAmount, onGoingVolume, totalVolume);
                    lvngAmountBasedOnUnits := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, 1, onGoingUnits, totalUnits);
                    if lvngAmountBasedOnVolume > lvngAmountBasedOnUnits then begin
                        lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnVolume;
                    end else begin
                        lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnUnits;
                    end;
                end;
            lvngTempCommissionTierHeader.lvngTierType::lvngVolumeUnitsMin:
                begin
                    lvngAmountBasedOnVolume := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, lvngLoanCommissionBuffer.lvngCommissionBaseAmount, onGoingVolume, totalVolume);
                    lvngAmountBasedOnUnits := CalculateTiersVolume(lvngTempCommissionTierHeader.lvngCode, 1, onGoingUnits, totalUnits);
                    if lvngAmountBasedOnVolume < lvngAmountBasedOnUnits then begin
                        lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnVolume;
                    end else begin
                        lvngLoanCommissionBuffer.lvngCommissionAmount := lvngAmountBasedOnUnits;
                    end;
                end;
        end;
        lvngLoanCommissionBuffer.Modify();
    end;

    local procedure CalculateTiersVolume(lvngTierCode: Code[20]; currentAmount: Decimal; onGoingVolume: Decimal; totalVolume: Decimal): Decimal
    var
        lvngTempCalcTierHeader: Record lvngCommissionTierHeader temporary;
        lvngTempCalcTierLine: Record lvngCommissionTierLine temporary;
        returnAmount: Decimal;
        maxAmount: Decimal;
    begin
        if currentAmount = 0 then
            exit(returnAmount);
        maxAmount := 999999999;
        FillTempCalcTierLines(lvngTierCode, lvngTempCalcTierHeader, lvngTempCalcTierLine);
        lvngTempCalcTierLine.reset;
        lvngTempCalcTierLine.FindLast();
        lvngTempCalcTierline.lvngToVolume := maxAmount;
        lvngTempCalcTierLine.Modify();
        lvngTempCalcTierLine.reset;
        lvngTempCalcTierLine.SetRange(lvngfromVolume, 0, totalVolume);
        lvngTempCalcTierLine.SetRange(lvngRetroactive, true);
        if lvngTempCalcTierLine.FindLast() then begin
            lvngTempCalcTierLine.SetRange(lvngRetroactive);
            lvngTempCalcTierLine.ModifyAll(lvngRate, lvngTempCalcTierLine.lvngRate);
        end;
        lvngTempCalcTierLine.Reset();
        lvngTempCalcTierLine.SetRange(lvngToVolume, onGoingVolume - currentAmount, maxAmount);
        if lvngTempCalcTierLine.FindFirst() then begin
            lvngTempCalcTierLine.lvngFromVolume := onGoingVolume - currentAmount;
            lvngTempCalcTierLine.Modify();
        end;
        if lvngTempCalcTierLine.FindSet() then begin
            repeat
                lvngTempCalcTierLine.lvngSpreadAmount := (lvngTempCalcTierLine.lvngToVolume - lvngTempCalcTierLine.lvngFromVolume);
                if lvngTempCalcTierLine.lvngSpreadAmount > currentAmount then begin
                    lvngTempCalcTierLine.lvngSpreadAmount := currentAmount;
                end;
                currentAmount := currentAmount - lvngTempCalcTierLine.lvngSpreadAmount;
                lvngTempCalcTierLine.Modify();
            until (lvngTempCalcTierLine.Next() = 0) or (currentAmount <= 0);
        end;
        if lvngTempCommissionTierHeader.lvngTierReturnValue = lvngTempCommissionTierHeader.lvngTierReturnValue::lvngAmount then begin
            lvngTempCalcTierLine.reset;
            lvngTempCalcTierLine.SetFilter(lvngSpreadAmount, '<>%1', 0);
            if lvngTempCalcTierLine.FindSet() then begin
                repeat
                    returnAmount := returnAmount + lvngTempCalcTierLine.lvngRate * lvngTempCalcTierLine.lvngSpreadAmount / currentAmount;
                until lvngTempCalcTierLine.Next() = 0;
            end;
        end else begin
            lvngTempCalcTierLine.reset;
            lvngTempCalcTierLine.SetFilter(lvngSpreadAmount, '<>%1', 0);
            if lvngTempCalcTierLine.FindSet() then begin
                repeat
                    returnAmount := returnAmount + lvngTempCalcTierLine.lvngRate * lvngTempCalcTierLine.lvngSpreadAmount / 10000;
                until lvngTempCalcTierLine.Next() = 0;
            end;
        end;
        exit(returnAmount);
    end;

    local procedure FillTempCalcTierLines(lvngTierCode: code[20]; var lvngTempCalcTierHeader: Record lvngCommissionTierHEader; var lvngTempCalcTierLine: Record lvngCommissionTierLine)
    begin
        lvngTempCommissionTierHeader.Get(lvngTierCode);
        Clear(lvngTempCalcTierHeader);
        lvngTempCalcTierHeader := lvngTempCommissionTierHeader;
        lvngTempCalcTierHeader.Insert();
        lvngTempCommissionTierLine.reset();
        lvngTempCommissionTierLine.SetRange(lvngCode, lvngTierCode);
        lvngTempCommissionTierLine.FindSet();
        repeat
            Clear(lvngTempCalcTierLine);
            lvngTempCalcTierLine := lvngTempCommissionTierLine;
            lvngTempCalcTierLine.Insert();
        until lvngTempCommissionTierLine.Next() = 0;
    end;

    local procedure CheckTiersInitialization(lvngTierCode: Code[20])
    begin
        if not lvngTempCommissionTierHeader.Get(lvngTierCode) then begin
            lvngCommissionTierHeader.Get(lvngTierCode);
            Clear(lvngTempCommissionTierHeader);
            lvngTempCommissionTierHeader := lvngCommissionTierHeader;
            lvngTempCommissionTierHeader.Insert();
            lvngCommissionTierLine.reset;
            lvngCommissionTierLine.SetRange(lvngCode, lvngTierCode);
            lvngCommissionTierLine.FindSet();
            repeat
                Clear(lvngTempCommissionTierLine);
                lvngTempCommissionTierLine := lvngCommissionTierLine;
                lvngTempCommissionTierLine.Insert();
            until lvngCommissionTierLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::lvngExpressionList, 'FillBuffer', '', true, true)]
    procedure OnFillBuffer(ExpressionHeader: Record lvngExpressionHeader; ConsumerMetadata: Text; var ExpressionBuffer: Record lvngExpressionValueBuffer)
    begin
        GetCommissionSetup();
        if lvngCommissionSetup.GetCommissionId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
                'LOAN':
                    begin
                        FillLoanFields(ExpressionBuffer);
                    end;
            end;
        if lvngCommissionSetup.GetCommissionReportId() = ExpressionHeader."Consumer Id" then
            case ConsumerMetadata of
            end;
    end;

    local procedure FillLoanFields(var lvngExpressionValueBuffer: Record lvngExpressionValueBuffer)
    var
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
        lvngParameterText: Label 'Parameter';
    begin
        InitializeConfigBuffer();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type");
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;
        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoan);
        lvngTableFields.FindSet();
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngExpressionValueBuffer.Type := lvngTableFields."Type Name";
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
        Clear(lvngExpressionValueBuffer);
        lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
        lvngExpressionValueBuffer.Name := lvngParameterText;
        lvngExpressionValueBuffer.Type := format(lvngLoanFieldsConfigurationTemp."Value Type"::lvngDecimal);
        lvngExpressionValueBuffer.Insert();
    end;

    local procedure InitializeConfigBuffer()
    begin
        if not lvngLoanFieldsConfigInitialized then begin
            lvngLoanFieldsConfigInitialized := true;
            lvngLoanFieldsConfiguration.reset;
            if lvngLoanFieldsConfiguration.FindSet() then begin
                repeat
                    Clear(lvngLoanFieldsConfigurationTemp);
                    lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
                    lvngLoanFieldsConfigurationTemp.Insert();
                until lvngLoanFieldsConfiguration.Next() = 0;
            end;
        end;
    end;

    local procedure GetCommissionSetup()
    begin
        if not lvngCommissionSetupRetrieved then begin
            lvngCommissionSetupRetrieved := true;
            lvngCommissionSetup.Get();
        end;
    end;

    var
        lvngCommissionTierHeader: Record lvngCommissionTierHeader;
        lvngCommissionTierLine: Record lvngCommissionTierLine;
        lvngCommissionSetup: Record lvngCommissionSetup;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngTempCommissionTierHeader: Record lvngCommissionTierHeader temporary;
        lvngTempCommissionTierLine: Record lvngCommissionTierLine temporary;
        lvngCommissionSetupRetrieved: Boolean;
        lvngLoanFieldsConfigInitialized: Boolean;
}