report 14135300 "lvngCalculateCommissions"
{
    Caption = 'Calculate Commissions';
    ProcessingOnly = true;
    /*
    TODO: 
    1 - Prepare test loans by importing data for 7 months - check IHMC if you can take and dummy their loans
    2 - Create 10 profiles from IHMC
    3 - Write function to calculate Tiers
    4 - Write function to calculate other stuff apart from tiers
    5 - Payout Tiers option
    6 - Period Level calculation
    7 - Introduce Conditions Engine
    8 - Tiers Units/Vol/UnitsVol Min/UnitsVol Max
    9 - Create Projected information calculation 
    10 - Create nice printout for commissions
    11 - Check what reports should be included in commissions
    12 - Create functionality to sync data from LV to .NET Portal
    13 - Develop .NET Portal
    14 - Emailing functionality
    15 - Quarterly Bonuses functionality
    16 - Remove last calculation functionality
    17 - Incremental Accruals
    18 - Regular Accruals
    19 - Adjustments Import
    20 - Create calculation view per Loan Officer and Plain Journal View
    21 - Loans not included report
    22 - Simulate loans per line functionality
    23 - YTD based calculation
    24 - Max. Loan Amount for Base Commission per Line
    25 - Minimum and Maximum payout per Loan
    26 = Minimum Period/Monthly payout (Salaried)
    27 - Debt Log
    28 - Profiles Import functionality
    29 - Profile and Profile line copy functionality
    30 - Profile Templates functionality
    31 - Split % add
    */
    dataset
    {
        dataitem(lvngCommissionProfile; lvngCommissionProfile)
        {
            RequestFilterFields = lvngCode;

            trigger OnAfterGetRecord()
            var
                validLoan: Boolean;
                currentOnGoingVolume: Decimal;
                nextOnGoingVolume: Decimal;
                onGoingVolume: Decimal;
                currentOnGoingUnits: Decimal;
                nextOnGoingUnits: Decimal;
                onGoingUnits: Decimal;
                totalUnits: Decimal;
                totalVolume: Decimal;
            begin
                lvngLoanCommissionBuffer.reset;
                lvngLoanCommissionBuffer.DeleteAll();
                clear(lvngBufferEntryNo);
                lvngCommissionProfileLine.reset;
                lvngCommissionProfileLine.SetRange(lvngProfileCode, lvngCommissionProfile.lvngCode);
                if lvngCommissionSchedule.lvngPeriodIdentifier <> '' then
                    lvngCommissionProfileLine.SetRange(lvngPeriodIdentifierCode, lvngCommissionSchedule.lvngPeriodIdentifier) else
                    lvngCommissionProfileLine.SetRange(lvngPeriodIdentifierCode, '');
                if lvngCommissionProfileLine.FindSet() then begin
                    repeat
                        lvngLoan.Reset();
                        lvngLoan.SetCurrentKey("Commission Date");
                        if lvngCommissionProfileLine.lvngPersonalProduction then begin
                            ApplyLoanOfficerFilter(lvngCommissionProfile.lvngCode);
                        end else begin
                            ApplyExtendedFilters(lvngCommissionProfileLine.lvngExtendedFilterCode);
                        end;
                        lvngLoan.SetRange("Commission Date", lvngCurrentPeriodStartDate, lvngCurrentPeriodEndDate);
                        if lvngLoan.FindSet() then begin
                            repeat
                                //Add check for condition and valid dates
                                validLoan := true;
                                if (lvngCommissionProfileLine.lvngValidFromDate <> 0D) then begin
                                    if (lvngLoan."Commission Date" < lvngCommissionProfileLine.lvngValidFromDate) then
                                        validLoan := false;
                                end;
                                if (lvngCommissionProfileLine.lvngValidToDate <> 0D) then begin
                                    if (lvngLoan."Commission Date" > lvngCommissionProfileLine.lvngValidToDate) then
                                        validLoan := false;
                                end;
                                if validLoan then begin
                                    if lvngCommissionProfileLine.lvngLoanLevelConditionCode <> '' then begin
                                        if not lvngExpressionHeader.Get(lvngCommissionProfileLine.lvngLoanLevelConditionCode, CommissionSetup.GetCommissionId()) then
                                            Error(lvngErrorFindingCondition, lvngCommissionProfileLine.lvngProfileCode, lvngCommissionProfileLine.lvngLoanLevelConditionCode, lvngCommissionProfileLine.lvngLineNo);
                                        FillCalculationBuffer();
                                        validLoan := CheckLoanCondition();
                                    end;
                                end;
                                if validLoan then begin
                                    CreateJournalBufferFromLoan();
                                end;
                            until lvngLoan.Next() = 0;
                        end;
                        lvngCommissionValueEntry.reset;
                        lvngCommissionValueEntry.SetRange(lvngCalculationLineNo, lvngCommissionProfileLine.lvngLineNo);
                        lvngCommissionValueEntry.SetRange(lvngProfileCode, lvngCode);
                        lvngCommissionValueEntry.SetRange(lvngPeriodIdentifierCode, lvngCommissionProfileLine.lvngPeriodIdentifierCode);
                        lvngCommissionValueEntry.SetRange(lvngCommissionDate, lvngCurrentMonthStartDate, lvngCurrentMonthEndDate);
                        if lvngCommissionValueEntry.FindSet() then begin
                            repeat
                                CreateJournalBufferFromValueEntry();
                            until lvngCommissionValueEntry.next = 0;
                        end;
                    until lvngCommissionProfileLine.Next() = 0;
                end;
                lvngCalcBuffer.reset;
                lvngCalcBuffer.DeleteAll();
                lvngLoanCommissionBuffer.reset;
                if lvngLoanCommissionBuffer.FindSet() then begin
                    repeat
                        Clear(lvngCalcBuffer);
                        lvngCalcBuffer := lvngLoanCommissionBuffer;
                        Clear(lvngCalcBuffer.lvngCommissionAmount);
                        Clear(lvngCalcBuffer.lvngCommissionBps);
                        lvngCalcBuffer.Insert();
                    until lvngLoanCommissionBuffer.Next() = 0;
                end;
                lvngCommissionProfileLine.SetRange(lvngProfileLineType, lvngCommissionProfileLine.lvngProfileLineType::lvngLoanLevel);
                lvngCommissionProfileLine.SetRange(lvngCalculationOnly, false);
                lvngCommissionProfileLine.SetRange(lvngPeriodIdentifierCode, lvngCommissionSchedule.lvngPeriodIdentifier);
                if lvngCommissionProfileLine.FindSet() then begin
                    repeat
                        clear(lvngCurrentMonthAmount);
                        Clear(lvngCurrentMonthUnits);
                        Clear(lvngNextMonthAmount);
                        Clear(lvngNextMonthUnits);
                        //Add field to point calculation line for Total Loans Amount for retroactive calculation
                        //If Tiered structure then
                        //Fill in Monthly data
                        //Fill in Quarterly data
                        //Fill in Yearly data
                        //Fill in Single period data
                        lvngCalcBuffer.reset;
                        lvngCalcBuffer.SetRange(lvngCommissionProfileCode, lvngCommissionProfileLine.lvngProfileCode);
                        lvngCalcBuffer.SetRange(lvngCommissionProfileLineNo, lvngCommissionProfileLine.lvngLineNo);
                        if lvngCalcBuffer.FindSet() then begin
                            if lvngCommissionProfileLine.lvngLoanCalculationType = lvngCommissionProfileLine.lvngLoanCalculationType::lvngTiers then begin
                                lvngLoanCommissionBuffer.reset;
                                lvngLoanCommissionBuffer.SetRange(lvngCommissionProfileCode, lvngCommissionProfileLine.lvngProfileCode);
                                if lvngCommissionProfileLine.lvngTotalsBasedOnLineNo = 0 then begin
                                    lvngLoanCommissionBuffer.SetRange(lvngCommissionProfileLineNo, lvngCommissionProfileLine.lvngLineNo);
                                end else begin
                                    lvngLoanCommissionBuffer.SetRange(lvngCommissionProfileLineNo, lvngCommissionProfileLine.lvngTotalsBasedOnLineNo);
                                end;
                                lvngLoanCommissionBuffer.SetRange(lvngCommissionDate, lvngCurrentMonthStartDate, lvngCurrentMonthEndDate);
                                lvngCurrentMonthUnits := lvngLoanCommissionBuffer.Count();
                                lvngLoanCommissionBuffer.CalcSums(lvngCommissionBaseAmount);
                                lvngCurrentMonthAmount := lvngLoanCommissionBuffer.lvngCommissionBaseAmount;
                                lvngLoanCommissionBuffer.SetRange(lvngCommissionDate, lvngNextMonthStartDate, lvngNextMonthEndDate);
                                lvngNextMonthUnits := lvngLoanCommissionBuffer.Count();
                                lvngLoanCommissionBuffer.CalcSums(lvngCommissionBaseAmount);
                                lvngNextMonthAmount := lvngLoanCommissionBuffer.lvngCommissionBaseAmount;
                            end;
                            Clear(currentOnGoingUnits);
                            Clear(currentOnGoingVolume);
                            Clear(nextOnGoingUnits);
                            Clear(nextOnGoingVolume);
                            repeat
                                if (lvngCalcBuffer.lvngCommissionDate > lvngCurrentMonthEndDate) then begin
                                    nextOnGoingVolume := nextOnGoingVolume + lvngCalcBuffer.lvngCommissionBaseAmount;
                                    nextOnGoingUnits := nextOnGoingUnits + 1;
                                    onGoingVolume := nextOnGoingVolume;
                                    onGoingUnits := nextOnGoingUnits;
                                    totalUnits := lvngNextMonthUnits;
                                    totalVolume := lvngNextMonthAmount;
                                end else begin
                                    currentOnGoingVolume := currentOnGoingVolume + lvngCalcBuffer.lvngCommissionBaseAmount;
                                    currentOnGoingUnits := currentOnGoingUnits + 1;
                                    onGoingVolume := currentOnGoingVolume;
                                    onGoingUnits := currentOnGoingUnits;
                                    totalUnits := lvngCurrentMonthUnits;
                                    totalVolume := lvngCurrentMonthAmount;
                                end;
                                lvngLoan.Get(lvngCalcBuffer.lvngLoanNo);
                                case lvngCommissionProfileLine.lvngLoanCalculationType of
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngDefinedBps:
                                        begin
                                            lvngCalcBuffer.lvngCommissionAmount := lvngCommissionProfileLine.lvngParameter * lvngCalcBuffer.lvngCommissionBaseAmount / 10000;
                                            lvngCalcBuffer.lvngCommissionBps := lvngCommissionProfileLine.lvngParameter;
                                        end;
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngDefinedValue:
                                        begin
                                            lvngCalcBuffer.lvngCommissionAmount := lvngCommissionProfileLine.lvngParameter;
                                            if lvngCalcBuffer.lvngCommissionBaseAmount <> 0 then
                                                lvngCalcBuffer.lvngCommissionBps := lvngCalcBuffer.lvngCommissionAmount / lvngCalcBuffer.lvngCommissionBaseAmount * 10000;
                                        end;
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngFunction:
                                        begin
                                            if not lvngExpressionHeader.Get(lvngCommissionProfileLine.lvngLoanLevelFunctionCode, CommissionSetup.GetCommissionId()) then
                                                Error(lvngErrorFindingFunction, lvngCommissionProfileLine.lvngLoanLevelFunctionCode, lvngCommissionProfileLine.lvngProfileCode, lvngCommissionProfileLine.lvngLineNo);
                                            FillCalculationBuffer();
                                            evaluate(lvngCalcBuffer.lvngCommissionAmount, lvngExpressionEngine.CalculateFormula(lvngExpressionHeader, lvngExpressionValueBuffer));
                                            if lvngCalcBuffer.lvngCommissionBaseAmount <> 0 then
                                                lvngCalcBuffer.lvngCommissionBps := lvngCalcBuffer.lvngCommissionAmount / lvngCalcBuffer.lvngCommissionBaseAmount * 10000;
                                        end;
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngLoanCardBps:
                                        begin
                                            lvngCalcBuffer.lvngCommissionAmount := lvngLoan."Commission Bps" * lvngCalcBuffer.lvngCommissionBaseAmount;
                                            lvngCalcBuffer.lvngCommissionBps := lvngLoan."Commission Bps";

                                        end;
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngLoanCardValue:
                                        begin
                                            lvngCalcBuffer.lvngCommissionAmount := lvngLoan."Commission Amount";
                                            if lvngCalcBuffer.lvngCommissionBaseAmount <> 0 then
                                                lvngCalcBuffer.lvngCommissionBps := lvngCalcBuffer.lvngCommissionAmount / lvngCalcBuffer.lvngCommissionBaseAmount * 10000;
                                        end;
                                    lvngCommissionProfileLine.lvngLoanCalculationType::lvngTiers:
                                        begin
                                            if lvngCheckLoanTierPayoutCondition(lvngCommissionProfileLine.lvngTierCode) then
                                                lvngCommissionCalcHelper.CalculateLoanTier(lvngCalcBuffer, lvngCommissionProfileLine, onGoingVolume, totalVolume, onGoingUnits, totalUnits);
                                        end;
                                end;
                                lvngCalcBuffer.Modify();
                                AddCommissionJournalLine;
                            until lvngCalcBuffer.Next() = 0;
                        end;
                    until lvngCommissionProfileLine.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(lvngOptions)
                {
                    Caption = 'Options';
                    field(lvngRemoveManualAdjustments; lvngRemoveManualAdjustments)
                    {
                        ApplicationArea = All;
                        Caption = 'Remove Manual Adjustments';
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Loan Officer Dimension Code");
        lvngDimensionNo := lvngDimensionsManagement.GetDimensionNo(LoanVisionSetup."Loan Officer Dimension Code");
        InitializeConfigBuffer;
        lvngCommissionJournalLine.reset;
        lvngCommissionJournalLine.SetRange(lvngScheduleNo, lvngCommissionSchedule.lvngNo);
        lvngCommissionJournalLine.SetRange(lvngProfileLineType, lvngCommissionJournalLine.lvngProfileLineType::lvngLoanLevel);
        lvngCommissionJournalLine.DeleteAll(true);
        lvngCommissionJournalLine.SetRange(lvngProfileLineType, lvngCommissionJournalLine.lvngProfileLineType::lvngPeriodLevel);
        if not lvngRemoveManualAdjustments then begin
            lvngCommissionJournalLine.SetRange(lvngManualAdjustment, false);
        end;
        lvngCommissionJournalLine.DeleteAll(true);
        if lvngCommissionSchedule.lvngQuarterCalculation then begin
            if lvngCommissionSchedule.lvngQuarterStartDate = 0D then begin
                Error(lvngWrongDateLabel, lvngCommissionSchedule.FieldCaption(lvngQuarterStartDate));
            end;
            if lvngCommissionSchedule.lvngQuarterEndDate = 0D then begin
                Error(lvngWrongDateLabel, lvngCommissionSchedule.FieldCaption(lvngQuarterEndDate));
            end;
        end;
        if lvngCommissionSchedule.lvngPeriodStartDate = 0D then begin
            Error(lvngWrongDateLabel, lvngCommissionSchedule.FieldCaption(lvngPeriodStartDate));
        end;
        if lvngCommissionSchedule.lvngPeriodEndDate = 0D then begin
            Error(lvngWrongDateLabel, lvngCommissionSchedule.FieldCaption(lvngPeriodEndDate));
        end;
        lvngQuarterStartDate := lvngCommissionSchedule.lvngQuarterStartDate;
        lvngQuarterEndDate := lvngCommissionSchedule.lvngQuarterEndDate;
        lvngCurrentPeriodStartDate := lvngCommissionSchedule.lvngPeriodStartDate;
        lvngCurrentPeriodEndDate := lvngCommissionSchedule.lvngPeriodEndDate;
        lvngCurrentMonthStartDate := CalcDate('<-CM>', lvngCurrentPeriodStartDate);
        lvngCurrentMonthEndDate := CalcDate('<CM>', lvngCurrentMonthStartDate);
        lvngCurrentYearStartDate := CalcDate('<-CY>', lvngCurrentPeriodStartDate);
        lvngCurrentYearEndDate := CalcDate('<CY>', lvngCurrentPeriodStartDate);
        lvngNextMonthStartDate := lvngCurrentMonthEndDate + 1;
        lvngNextMonthEndDate := CalcDate('<CM>', lvngNextMonthStartDate);

    end;

    local procedure ApplyExtendedFilters(lvngExtendedFilterCode: Code[20])
    var
        lvngInStream: InStream;
        lvngFilters: Text;
    begin
        lvngCommissionExtendedFilter.Get(lvngExtendedFilterCode);
        lvngCommissionExtendedFilter.CalcFields(lvngFilter);
        if lvngCommissionExtendedFilter.lvngFilter.HasValue then begin
            lvngCommissionExtendedFilter.lvngFilter.CreateInStream(lvngInStream);
            lvngInStream.ReadText(lvngFilters);
            lvngLoan.SetView(lvngFilters);
        end;
    end;

    local procedure ApplyLoanOfficerFilter(DimensionCode: Code[20])
    begin
        case lvngDimensionNo of
            1:
                lvngLoan.SetRange("Global Dimension 1 Code", DimensionCode);
            2:
                lvngLoan.SetRange("Global Dimension 2 Code", DimensionCode);
            3:
                lvngLoan.SetRange("Shortcut Dimension 3 Code", DimensionCode);
            4:
                lvngLoan.SetRange("Shortcut Dimension 4 Code", DimensionCode);
            5:
                lvngLoan.SetRange("Shortcut Dimension 5 Code", DimensionCode);
            6:
                lvngLoan.SetRange("Shortcut Dimension 6 Code", DimensionCode);
            7:
                lvngLoan.SetRange("Shortcut Dimension 7 Code", DimensionCode);
            8:
                lvngLoan.SetRange("Shortcut Dimension 8 Code", DimensionCode);
        end;
    end;

    local procedure CheckLoanCondition(): Boolean
    begin
        exit(lvngExpressionEngine.CheckCondition(lvngExpressionHeader, lvngExpressionValueBuffer));
    end;

    local procedure FillCalculationBuffer()
    var
        lvngLoanValue: Record lvngLoanValue;
        lvngTableFields: Record Field;
        lvngFieldSequenceNo: Integer;
        lvngRecordReference: RecordRef;
        lvngFieldReference: FieldRef;
    begin
        lvngExpressionValueBuffer.Reset();
        lvngExpressionValueBuffer.DeleteAll();
        lvngLoanFieldsConfigurationTemp.reset;
        if lvngLoanFieldsConfigurationTemp.FindSet() then begin
            repeat
                lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
                lvngLoanValue.reset;
                lvngLoanValue.SetRange("Loan No.", lvngLoan."No.");
                lvngLoanValue.SetRange("Field No.", lvngLoanFieldsConfigurationTemp."Field No.");
                Clear(lvngExpressionValueBuffer);
                lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
                lvngExpressionValueBuffer.Name := lvngLoanFieldsConfigurationTemp."Field Name";
                lvngExpressionValueBuffer.Type := Format(lvngLoanFieldsConfigurationTemp."Value Type");
                if lvngLoanValue.FindFirst() then begin
                    lvngExpressionValueBuffer.Value := lvngLoanValue."Field Value";
                end else begin
                    case lvngLoanFieldsConfigurationTemp."Value Type" of
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngBoolean:
                            begin
                                lvngExpressionValueBuffer.Value := 'False';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngDecimal:
                            begin
                                lvngExpressionValueBuffer.Value := '0.00';
                            end;
                        lvngLoanFieldsConfigurationTemp."Value Type"::lvngInteger:
                            begin
                                lvngExpressionValueBuffer.Value := '0';
                            end;
                    end;
                end;
                lvngExpressionValueBuffer.Insert();
            until lvngLoanFieldsConfigurationTemp.Next() = 0;
        end;

        lvngTableFields.reset;
        lvngTableFields.SetRange(TableNo, Database::lvngLoan);
        lvngTableFields.SetFilter("No.", '>%1', 4);
        lvngTableFields.FindSet();
        lvngRecordReference.GetTable(lvngLoan);
        repeat
            lvngFieldSequenceNo := lvngFieldSequenceNo + 1;
            Clear(lvngExpressionValueBuffer);
            lvngExpressionValueBuffer.Number := lvngFieldSequenceNo;
            lvngExpressionValueBuffer.Name := lvngTableFields.FieldName;
            lvngFieldReference := lvngRecordReference.Field(lvngTableFields."No.");
            lvngExpressionValueBuffer.Value := Delchr(Format(lvngFieldReference.Value()), '<>', ' ');
            lvngExpressionValueBuffer.Type := format(lvngFieldReference.Type());
            lvngExpressionValueBuffer.Insert();
        until lvngTableFields.Next() = 0;
        lvngRecordReference.Close();
    end;

    local procedure CreateJournalBufferFromLoan()
    begin
        Clear(lvngLoanCommissionBuffer);
        lvngLoanCommissionBuffer.lvngEntryNo := lvngBufferEntryNo;
        lvngBufferEntryNo := lvngBufferEntryNo + 1;
        lvngLoanCommissionBuffer.lvngLoanNo := lvngLoan."No.";
        lvngLoanCommissionBuffer.lvngCommissionProfileCode := lvngCommissionProfile.lvngCode;
        lvngLoanCommissionBuffer.lvngCommissionProfileLineNo := lvngCommissionProfileLine.lvngLineNo;
        lvngLoanCommissionBuffer.lvngCommissionDate := lvngLoan."Commission Date";
        lvngLoanCommissionBuffer.lvngCommissionBaseAmount := lvngLoan."Commission Base Amount";
        lvngLoanCommissionBuffer.Insert();
    end;

    local procedure CreateJournalBufferFromValueEntry()
    begin
        Clear(lvngLoanCommissionBuffer);
        lvngLoanCommissionBuffer.lvngEntryNo := lvngBufferEntryNo;
        lvngBufferEntryNo := lvngBufferEntryNo + 1;
        lvngLoanCommissionBuffer.lvngLoanNo := lvngCommissionValueEntry.lvngLoanNo;
        lvngLoanCommissionBuffer.lvngCommissionProfileCode := lvngCommissionProfile.lvngCode;
        lvngLoanCommissionBuffer.lvngCommissionProfileLineNo := lvngCommissionProfileLine.lvngLineNo;
        lvngLoanCommissionBuffer.lvngCommissionDate := lvngCommissionValueEntry.lvngCommissionDate;
        lvngLoanCommissionBuffer.lvngCommissionBaseAmount := lvngCommissionValueEntry.lvngCommissionAmount;
        lvngLoanCommissionBuffer.lvngCommissionAmount := lvngCommissionValueEntry.lvngCommissionAmount;
        lvngLoanCommissionBuffer.lvngCommissionBps := lvngCommissionValueEntry.lvngBps;
        lvngLoanCommissionBuffer.lvngValueEntry := true;
        lvngLoanCommissionBuffer.Insert();
    end;

    local procedure AddCommissionJournalLine()
    var
        lvngJournalLineNo: Integer;
    begin
        lvngCommissionJournalLine.reset;
        lvngCommissionJournalLine.setrange(lvngScheduleNo, lvngCommissionSchedule.lvngNo);
        if lvngCommissionJournalLine.FindLast() then
            lvngJournalLineNo := lvngCommissionJournalLine.lvngLineNo + 1 else
            lvngJournalLineNo := 1;
        Clear(lvngCommissionJournalLine);
        lvngCommissionJournalLine.Init();
        lvngCommissionJournalLine.lvngLineNo := lvngJournalLineNo;
        lvngCommissionJournalLine.lvngScheduleNo := lvngCommissionSchedule.lvngNo;
        lvngCommissionJournalLine.lvngBaseAmount := lvngCalcBuffer.lvngCommissionBaseAmount;
        lvngCommissionJournalLine.lvngBps := lvngCalcBuffer.lvngCommissionBps;
        lvngCommissionJournalLine.lvngCalculationLineNo := lvngCommissionProfileLine.lvngLineNo;
        lvngCommissionJournalLine.lvngPeriodIdentifierCode := lvngCommissionSchedule.lvngPeriodIdentifier;
        lvngCommissionJournalLine.lvngProfileCode := lvngCommissionProfile.lvngCode;
        lvngCommissionJournalLine.lvngProfileLineType := lvngCommissionProfileLine.lvngProfileLineType;
        lvngCommissionJournalLine.lvngLoanNo := lvngCalcBuffer.lvngLoanNo;
        lvngCommissionJournalLine.lvngDescription := lvngCommissionProfileLine.lvngDescription;
        lvngCommissionJournalLine.lvngIdentifierCode := lvngCommissionProfileLine.lvngIdentifierCode;
        lvngCommissionJournalLine.lvngCommissionDate := lvngCalcBuffer.lvngCommissionDate;
        lvngCommissionJournalLine.lvngCommissionAmount := lvngCalcBuffer.lvngCommissionAmount;
        lvngCommissionJournalLine.lvngCommissionAmount := lvngCommissionJournalLine.lvngCommissionAmount / 100 * lvngCommissionProfileLine.lvngSplitPercentage;
        if lvngCommissionProfileLine.lvngMinCommissionAmount > 0 then begin
            if lvngCommissionJournalLine.lvngCommissionAmount < lvngCommissionProfileLine.lvngMinCommissionAmount then
                lvngCommissionJournalLine.lvngCommissionAmount := lvngCommissionProfileLine.lvngMinCommissionAmount;
        end;
        if lvngCommissionProfileLine.lvngMaxCommissionAmount > 0 then begin
            if lvngCommissionJournalLine.lvngCommissionAmount > lvngCommissionProfileLine.lvngMaxCommissionAmount then
                lvngCommissionJournalLine.lvngCommissionAmount := lvngCommissionProfileLine.lvngMaxCommissionAmount;
        end;
        if lvngCalcBuffer.lvngValueEntry then begin
            lvngLoanCommissionBuffer.Get(lvngCalcBuffer.lvngEntryNo);
            if lvngLoanCommissionBuffer.lvngCommissionAmount <> lvngCalcBuffer.lvngCommissionAmount then begin
                lvngCommissionJournalLine.lvngCommissionAmount := lvngCalcBuffer.lvngCommissionAmount - lvngCommissionJournalLine.lvngCommissionAmount;
                lvngCommissionJournalLine.lvngBps := lvngCalcBuffer.lvngCommissionBps - lvngCommissionJournalLine.lvngBps;
                lvngCommissionJournalLine.Insert();
            end;
        end else
            lvngCommissionJournalLine.Insert(true);
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

    local procedure lvngCheckLoanTierPayoutCondition(lvngTierCode: Code[20]): Boolean
    var
        lvngLoanValue: Record lvngLoanValue;
        lvngCommissionTierHeader: Record lvngCommissionTierHeader;
        lvngValidCondition: Boolean;
    begin
        Clear(lvngValidCondition);
        lvngCommissionTierHeader.Get(lvngTierCode);
        case lvngCommissionTierHeader.lvngPayoutOption of
            lvngCommissionTierHeader.lvngPayoutOption::lvngAlways:
                exit(true);
            lvngCommissionTierHeader.lvngPayoutOption::lvngNever:
                exit(false);
            lvngCommissionTierHeader.lvngPayoutOption::lvngLoanValue:
                begin
                    if not lvngLoanValue.Get(lvngLoan."No.", lvngCommissionTierHeader.lvngPayoutFieldNo) then
                        exit(false);
                    if UpperCase(lvngLoanValue."Field Value") <> UpperCase(lvngCommissionTierHeader.lvngPayoutCompareValue) then
                        exit(false) else
                        exit(true);
                end;
            lvngCommissionTierHeader.lvngPayoutOption::lvngCondition:
                begin
                    if not lvngExpressionHeader.Get(lvngCommissionTierHeader.lvngPayoutConditionCode, CommissionSetup.GetCommissionId()) then
                        Error(lvngErrorFindingConditionForTier, lvngCommissionTierHeader.lvngPayoutConditionCode, lvngCommissionTierHeader.lvngPayoutConditionCode);
                    FillCalculationBuffer();
                    lvngValidCondition := lvngExpressionEngine.CheckCondition(lvngExpressionHeader, lvngExpressionValueBuffer);
                    exit(lvngValidCondition);
                end;
        end;
    end;

    procedure SetParams(lvngScheduleNo: Integer)
    begin
        lvngCommissionSchedule.Get(lvngScheduleNo);
    end;

    var
        lvngLoan: Record lvngLoan;
        lvngCommissionSchedule: Record lvngCommissionSchedule;
        CommissionSetup: Record lvngCommissionSetup;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        lvngCommissionJournalLine: Record lvngCommissionJournalLine;
        lvngCommissionProfileLine: Record lvngCommissionProfileLine;
        lvngLoanCommissionBuffer: Record lvngLoanCommissionBuffer temporary;
        lvngCalcBuffer: Record lvngLoanCommissionBuffer temporary;
        lvngCommissionExtendedFilter: Record lvngCommissionExtendedFilter;
        lvngCommissionValueEntry: Record lvngCommissionValueEntry;
        lvngExpressionValueBuffer: Record lvngExpressionValueBuffer temporary;
        lvngExpressionHeader: Record lvngExpressionHeader;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        lvngCommissionCalcHelper: Codeunit lvngCommissionCalcHelper;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngCurrentMonthAmount: Decimal;
        lvngCurrentMonthUnits: Integer;
        lvngNextMonthAmount: Decimal;
        lvngNextMonthUnits: Integer;
        lvngRemoveManualAdjustments: Boolean;
        lvngLoanFieldsConfigInitialized: Boolean;
        lvngCurrentMonthStartDate: Date;
        lvngCurrentMonthEndDate: Date;
        lvngNextMonthStartDate: Date;
        lvngNextMonthEndDate: Date;
        lvngCurrentPeriodStartDate: Date;
        lvngCurrentPeriodEndDate: Date;
        lvngCurrentYearStartDate: Date;
        lvngCurrentYearEndDate: Date;
        lvngQuarterStartDate: Date;
        lvngQuarterEndDate: Date;
        lvngDimensionNo: Integer;
        lvngBufferEntryNo: Integer;
        lvngWrongDateLabel: Label '%1 can''t be blank';
        lvngErrorFindingFunction: Label 'Error finding function %1 for profile %2 Line No. %3';
        lvngErrorFindingCondition: Label 'Error finding condition %1 for profile %2 Line No. %3';
        lvngErrorFindingConditionForTier: Label 'Error finding condition %1 for tier %2';
}