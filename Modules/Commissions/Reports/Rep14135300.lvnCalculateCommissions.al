report 14135300 lvnCalculateCommissions
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
        dataitem(CommissionProfile; lvnCommissionProfile)
        {
            RequestFilterFields = Code;

            trigger OnAfterGetRecord()
            var
                CommissionProfileLine: Record lvnCommissionProfileLine;
                TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer temporary;
                Loan: Record lvnLoan;
                CommissionValueEntry: Record lvnCommissionValueEntry;
                ExpressionHeader: Record lvnExpressionHeader;
                TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
                CommissionTierHeader: Record lvnCommissionTierHeader;
                BufferEntryNo: Integer;
                ValidLoan: Boolean;
                CurrentOnGoingVolume: Decimal;
                NextOnGoingVolume: Decimal;
                OnGoingVolume: Decimal;
                CurrentOnGoingUnits: Decimal;
                NextOnGoingUnits: Decimal;
                OnGoingUnits: Decimal;
                TotalUnits: Decimal;
                TotalVolume: Decimal;
            begin
                TempLoanCommissionBuffer.Reset();
                TempLoanCommissionBuffer.DeleteAll();
                BufferEntryNo := 0;
                CommissionProfileLine.Reset();
                CommissionProfileLine.SetRange("Profile Code", CommissionProfile.Code);
                CommissionProfileLine.SetRange("Period Identifier Code", CommissionSchedule."Period Identifier Code");
                if CommissionProfileLine.FindSet() then
                    repeat
                        Loan.Reset();
                        Loan.SetCurrentKey("Commission Date");
                        if CommissionProfileLine."Personal Production" then
                            ApplyLoanOfficerFilter(Loan, CommissionProfile.Code)
                        else
                            ApplyExtendedFilters(Loan, CommissionProfileLine."Extended Filter Code");
                        Loan.SetRange("Commission Date", CurrentPeriodStartDate, CurrentPeriodEndDate);
                        if Loan.FindSet() then
                            repeat
                                //Add check for condition and valid dates
                                ValidLoan := true;
                                if (CommissionProfileLine."Valid From Date" <> 0D) then
                                    if (Loan."Commission Date" < CommissionProfileLine."Valid From Date") then
                                        ValidLoan := false;
                                if (CommissionProfileLine."Valid To Date" <> 0D) then
                                    if (Loan."Commission Date" > CommissionProfileLine."Valid To Date") then
                                        ValidLoan := false;
                                if ValidLoan then
                                    if CommissionProfileLine."Loan Level Condition Code" <> '' then begin
                                        if not ExpressionHeader.Get(CommissionProfileLine."Loan Level Condition Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                                            Error(FindingConditionErr, CommissionProfileLine."Profile Code", CommissionProfileLine."Loan Level Condition Code", CommissionProfileLine."Line No.");
                                        FillCalculationBuffer(Loan, CommissionProfileLine, TempExpressionValueBuffer);
                                        ValidLoan := ExpressionEngine.CheckCondition(ExpressionHeader, TempExpressionValueBuffer);
                                    end;
                                if ValidLoan then
                                    CreateJournalBufferFromLoan(Loan, BufferEntryNo, CommissionProfileLine."Line No.");
                            until Loan.Next() = 0;
                        CommissionValueEntry.Reset();
                        CommissionValueEntry.SetRange("Calculation Line No.", CommissionProfileLine."Line No.");
                        CommissionValueEntry.SetRange("Profile Code", Code);
                        CommissionValueEntry.SetRange("Period Identifier Code", CommissionProfileLine."Period Identifier Code");
                        CommissionValueEntry.SetRange("Commission Date", CurrentMonthStartDate, CurrentMonthEndDate);
                        if CommissionValueEntry.FindSet() then
                            repeat
                                CreateJournalBufferFromValueEntry(CommissionValueEntry, BufferEntryNo, CommissionProfileLine."Line No.");
                            until CommissionValueEntry.Next() = 0;
                    until CommissionProfileLine.Next() = 0;
                TempLoanCommissionBuffer.Reset();
                TempLoanCommissionBuffer.DeleteAll();
                TempLoanCommissionBuffer.Reset();
                if TempLoanCommissionBuffer.FindSet() then
                    repeat
                        Clear(TempLoanCommissionBuffer);
                        TempLoanCommissionBuffer := TempLoanCommissionBuffer;
                        TempLoanCommissionBuffer."Commission Amount" := 0;
                        TempLoanCommissionBuffer.Bps := 0;
                        TempLoanCommissionBuffer.Insert();
                    until TempLoanCommissionBuffer.Next() = 0;
                //Loan Level
                CommissionProfileLine.SetRange("Profile Line Type", CommissionProfileLine."Profile Line Type"::"Loan Level");
                if CommissionProfileLine.FindSet() then
                    repeat
                        CurrentMonthAmount := 0;
                        CurrentMonthUnits := 0;
                        NextMonthAmount := 0;
                        NextMonthUnits := 0;
                        //Add field to point calculation line for Total Loans Amount for retroactive calculation
                        //If Tiered structure then
                        //Fill in Monthly data
                        //Fill in Quarterly data
                        //Fill in Yearly data
                        //Fill in Single period data
                        TempLoanCommissionBuffer.Reset();
                        TempLoanCommissionBuffer.SetRange("Profile Code", CommissionProfileLine."Profile Code");
                        TempLoanCommissionBuffer.SetRange("Profile Line No.", CommissionProfileLine."Line No.");
                        if TempLoanCommissionBuffer.FindSet() then begin
                            if CommissionProfileLine."Loan Calculation Type" = CommissionProfileLine."Loan Calculation Type"::Tiers then begin
                                TempLoanCommissionBuffer.Reset();
                                TempLoanCommissionBuffer.SetRange("Profile Code", CommissionProfileLine."Profile Code");
                                if CommissionProfileLine."Totals Based On Line No." = 0 then
                                    TempLoanCommissionBuffer.SetRange("Profile Line No.", CommissionProfileLine."Line No.")
                                else
                                    TempLoanCommissionBuffer.SetRange("Profile Line No.", CommissionProfileLine."Totals Based On Line No.");
                                TempLoanCommissionBuffer.SetRange("Commission Date", CurrentMonthStartDate, CurrentMonthEndDate);
                                CurrentMonthUnits := TempLoanCommissionBuffer.Count();
                                TempLoanCommissionBuffer.CalcSums("Base Amount");
                                CurrentMonthAmount := TempLoanCommissionBuffer."Base Amount";
                                TempLoanCommissionBuffer.SetRange("Commission Date", NextMonthStartDate, NextMonthEndDate);
                                NextMonthUnits := TempLoanCommissionBuffer.Count();
                                TempLoanCommissionBuffer.CalcSums("Base Amount");
                                NextMonthAmount := TempLoanCommissionBuffer."Base Amount";
                            end;
                            CurrentOnGoingUnits := 0;
                            CurrentOnGoingVolume := 0;
                            NextOnGoingUnits := 0;
                            NextOnGoingVolume := 0;
                            repeat
                                if TempLoanCommissionBuffer."Commission Date" > CurrentMonthEndDate then begin
                                    NextOnGoingVolume := NextOnGoingVolume + TempLoanCommissionBuffer."Base Amount";
                                    NextOnGoingUnits := NextOnGoingUnits + 1;
                                    OnGoingVolume := NextOnGoingVolume;
                                    OnGoingUnits := NextOnGoingUnits;
                                    TotalUnits := NextMonthUnits;
                                    TotalVolume := NextMonthAmount;
                                end else begin
                                    CurrentOnGoingVolume := CurrentOnGoingVolume + TempLoanCommissionBuffer."Base Amount";
                                    CurrentOnGoingUnits := CurrentOnGoingUnits + 1;
                                    OnGoingVolume := CurrentOnGoingVolume;
                                    OnGoingUnits := CurrentOnGoingUnits;
                                    TotalUnits := CurrentMonthUnits;
                                    TotalVolume := CurrentMonthAmount;
                                end;
                                Loan.Get(TempLoanCommissionBuffer."Loan No.");
                                case CommissionProfileLine."Loan Calculation Type" of
                                    CommissionProfileLine."Loan Calculation Type"::"Defined Bps":
                                        begin
                                            TempLoanCommissionBuffer."Commission Amount" := CommissionProfileLine.Parameter * TempLoanCommissionBuffer."Base Amount" / 10000;
                                            TempLoanCommissionBuffer.Bps := CommissionProfileLine.Parameter;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Defined Value":
                                        begin
                                            TempLoanCommissionBuffer."Commission Amount" := CommissionProfileLine.Parameter;
                                            if TempLoanCommissionBuffer."Base Amount" <> 0 then
                                                TempLoanCommissionBuffer.Bps := TempLoanCommissionBuffer."Commission Amount" / TempLoanCommissionBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::Formula:
                                        begin
                                            if not ExpressionHeader.Get(CommissionProfileLine."Loan Level Function Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                                                Error(FindingFunctionErr, CommissionProfileLine."Loan Level Function Code", CommissionProfileLine."Profile Code", CommissionProfileLine."Line No.");
                                            FillCalculationBuffer(Loan, CommissionProfileLine, TempExpressionValueBuffer);
                                            Evaluate(TempLoanCommissionBuffer."Commission Amount", ExpressionEngine.CalculateFormula(ExpressionHeader, TempExpressionValueBuffer));
                                            if TempLoanCommissionBuffer."Base Amount" <> 0 then
                                                TempLoanCommissionBuffer.Bps := TempLoanCommissionBuffer."Commission Amount" / TempLoanCommissionBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Loan Card Bps":
                                        begin
                                            TempLoanCommissionBuffer."Commission Amount" := Loan."Commission Bps" * TempLoanCommissionBuffer."Base Amount" / 10000;
                                            TempLoanCommissionBuffer.Bps := Loan."Commission Bps";
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Loan Card Value":
                                        begin
                                            TempLoanCommissionBuffer."Commission Amount" := Loan."Commission Amount";
                                            if TempLoanCommissionBuffer."Base Amount" <> 0 then
                                                TempLoanCommissionBuffer.Bps := TempLoanCommissionBuffer."Commission Amount" / TempLoanCommissionBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::Tiers:
                                        begin
                                            CommissionTierHeader.Get(CommissionProfileLine."Tier Code");
                                            if CheckLoanTierPayoutCondition(Loan, CommissionTierHeader) then
                                                CommissionCalcHelper.CalculateLoanTier(TempLoanCommissionBuffer, CommissionTierHeader, OnGoingVolume, TotalVolume, OnGoingUnits, TotalUnits);
                                        end;
                                end;
                                TempLoanCommissionBuffer.Modify();
                                AddCommissionJournalLine(CommissionProfileLine, TempLoanCommissionBuffer);
                            until TempLoanCommissionBuffer.Next() = 0;
                        end;
                    until CommissionProfileLine.Next() = 0;
                //Period Level
                if not ExcludePeriodCalculation then begin
                    CommissionProfileLine.SetRange("Profile Line Type", CommissionProfileLine."Profile Line Type"::"Period Level");
                    CommissionProfileLine.SetFilter("Valid From Date", '%1|<=%2', 0D, CurrentPeriodStartDate);
                    CommissionProfileLine.SetFilter("Valid To Date", '%1|>=%2', 0D, CurrentPeriodEndDate);
                    CommissionProfileLine.SetRange("Period Type", CommissionProfileLine."Period Type"::"Single Period");
                    if CommissionProfileLine.FindSet() then
                        repeat
                            CalculatePeriodLevelProfileLine(CommissionProfileLine, CurrentPeriodEndDate);
                        until CommissionProfileLine.Next() = 0;
                    if CommissionSchedule."Month End Calculation" then begin
                        CommissionProfileLine.SetRange("Period Type", CommissionProfileLine."Period Type"::"Month End");
                        if CommissionProfileLine.FindSet() then
                            repeat
                                CalculatePeriodLevelProfileLine(CommissionProfileLine, CurrentMonthEndDate);
                            until CommissionProfileLine.Next() = 0;
                    end;
                    if CommissionSchedule."Quarter Calculation" then begin
                        CommissionProfileLine.SetRange("Period Type", CommissionProfileLine."Period Type"::Quarterly);
                        if CommissionProfileLine.FindSet() then
                            repeat
                                CalculatePeriodLevelProfileLine(CommissionProfileLine, QuarterEndDate);
                            until CommissionProfileLine.Next() = 0;
                    end;
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
                group(Options)
                {
                    field(RemoveManualAdjustments; RemoveManualAdjustments)
                    {
                        ApplicationArea = All;
                        Caption = 'Remove Manual Adjustments';
                    }

                    field(ExcludePeriodCalculation; ExcludePeriodCalculation)
                    {
                        ApplicationArea = All;
                        Caption = 'Exclude Period Calculation';
                    }
                }
            }
        }

    }

    var
        CommissionSchedule: Record lvnCommissionSchedule;
        LoanVisionSetup: Record lvnLoanVisionSetup;
        TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer temporary;
        DimensionsManagement: Codeunit lvnDimensionsManagement;
        CommissionCalcHelper: Codeunit lvnCommissionCalcHelper;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        ImplementationMgmt: Codeunit lvnImplementationManagement;
        CurrentMonthAmount: Decimal;
        CurrentMonthUnits: Integer;
        NextMonthAmount: Decimal;
        NextMonthUnits: Integer;
        RemoveManualAdjustments: Boolean;
        ExcludePeriodCalculation: Boolean;
        CurrentMonthStartDate: Date;
        CurrentMonthEndDate: Date;
        NextMonthStartDate: Date;
        NextMonthEndDate: Date;
        CurrentPeriodStartDate: Date;
        CurrentPeriodEndDate: Date;
        CurrentYearStartDate: Date;
        CurrentYearEndDate: Date;
        QuarterStartDate: Date;
        QuarterEndDate: Date;
        LoanOfficerDimensionNo: Integer;
        WrongDateLbl: Label '%1 can''t be blank';
        FindingFunctionErr: Label 'Error finding function %1 for profile %2 Line No. %3';
        FindingConditionErr: Label 'Error finding condition %1 for profile %2 Line No. %3';
        FindingConditionForTierErr: Label 'Error finding condition %1 for tier %2';
        BooleanFalseLbl: Label 'False';
        DecimalZeroLbl: Label '0.00';
        IntegerZeroLbl: Label '0';
        CurrentMonthLbl: Label '<CM>';
        PreviousCurrentMonthLbl: Label '<-CM>';
        CurrentYearLbl: Label '<CY>';
        PreviousYearLbl: Label '<-CY>';

    trigger OnPreReport()
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        if CommissionSchedule."Quarter Calculation" then begin
            if CommissionSchedule."Quarter Start Date" = 0D then
                Error(WrongDateLbl, CommissionSchedule.FieldCaption("Quarter Start Date"));
            if CommissionSchedule."Quarter End Date" = 0D then
                Error(WrongDateLbl, CommissionSchedule.FieldCaption("Quarter End Date"));
        end;
        if CommissionSchedule."Period Start Date" = 0D then
            Error(WrongDateLbl, CommissionSchedule.FieldCaption("Period Start Date"));
        if CommissionSchedule."Period End Date" = 0D then
            Error(WrongDateLbl, CommissionSchedule.FieldCaption("Period End Date"));
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Loan Officer Dimension Code");
        LoanOfficerDimensionNo := DimensionsManagement.GetDimensionNo(LoanVisionSetup."Loan Officer Dimension Code");
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
        CommissionJournalLine.DeleteAll(true);
        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
        if not RemoveManualAdjustments then
            CommissionJournalLine.SetRange("Manual Adjustment", false);
        CommissionJournalLine.DeleteAll(true);
        QuarterStartDate := CommissionSchedule."Quarter Start Date";
        QuarterEndDate := CommissionSchedule."Quarter End Date";
        CurrentPeriodStartDate := CommissionSchedule."Period Start Date";
        CurrentPeriodEndDate := CommissionSchedule."Period End Date";
        CurrentMonthStartDate := CalcDate(PreviousCurrentMonthLbl, CurrentPeriodStartDate);
        CurrentMonthEndDate := CalcDate(CurrentMonthLbl, CurrentMonthStartDate);
        CurrentYearStartDate := CalcDate(PreviousYearLbl, CurrentPeriodStartDate);
        CurrentYearEndDate := CalcDate(CurrentYearLbl, CurrentPeriodStartDate);
        NextMonthStartDate := CurrentMonthEndDate + 1;
        NextMonthEndDate := CalcDate(CurrentMonthLbl, NextMonthStartDate);
    end;

    trigger OnPostReport()
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
        CommissionJournalLine.SetRange("Calculation Only", true);
        CommissionJournalLine.DeleteAll(true);
    end;

    local procedure AppendExpressionValue(var TempExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Decimal)
    begin
        Clear(TempExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        TempExpressionValueBuffer.Number := ValueNo;
        TempExpressionValueBuffer.Name := Name;
        TempExpressionValueBuffer.Type := 'Decimal';
        TempExpressionValueBuffer.Value := Format(Value, 0, 9);
        TempExpressionValueBuffer.Insert();
    end;

    local procedure AppendExpressionValue(var TempExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Boolean)
    begin
        Clear(TempExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        TempExpressionValueBuffer.Number := ValueNo;
        TempExpressionValueBuffer.Name := Name;
        TempExpressionValueBuffer.Type := 'Decimal';
        if Value then
            TempExpressionValueBuffer.Value := 'True'
        else
            TempExpressionValueBuffer.Value := 'False';
        TempExpressionValueBuffer.Insert();
    end;

    local procedure AppendExpressionValue(var TempExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Text)
    begin
        Clear(TempExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        TempExpressionValueBuffer.Number := ValueNo;
        TempExpressionValueBuffer.Name := Name;
        TempExpressionValueBuffer.Type := 'Text';
        TempExpressionValueBuffer.Value := Value;
        TempExpressionValueBuffer.Insert();
    end;

    local procedure GetJournalStats(var CommissionProfileLine: Record lvnCommissionProfileLine; StartDate: Date; EndDate: Date; var Units: Decimal; var Volume: Decimal; var Commission: Decimal; Append: Boolean): Boolean
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        if not Append then begin
            Units := 0;
            Volume := 0;
            Commission := 0;
        end;
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Profile Code", CommissionProfileLine."Profile Code");
        CommissionJournalLine.SetRange("Commission Date", StartDate, EndDate);
        if CommissionProfileLine."Totals Based On Line No." <> 0 then
            CommissionJournalLine.SetRange("Calculation Line No.", CommissionProfileLine."Totals Based On Line No.");
        if CommissionJournalLine.IsEmpty() then
            exit(false);
        CommissionJournalLine.CalcSums("Commission Amount", "Base Amount");
        Commission += CommissionJournalLine."Commission Amount";
        Volume += CommissionJournalLine."Base Amount";
        Units += CommissionJournalLine.Count();
    end;

    local procedure GetLedgerStats(var CommissionProfileLine: Record lvnCommissionProfileLine; StartDate: Date; EndDate: Date; var Units: Decimal; var Volume: Decimal; var Commission: Decimal; Append: Boolean): Boolean
    var
        CommissionValueEntry: Record lvnCommissionValueEntry;
    begin
        if not Append then begin
            Units := 0;
            Volume := 0;
            Commission := 0;
        end;
        CommissionValueEntry.Reset();
        CommissionValueEntry.SetRange("Profile Code", CommissionProfileLine."Profile Code");
        CommissionValueEntry.SetRange("Commission Date", StartDate, EndDate);
        if CommissionProfileLine."Totals Based On Line No." <> 0 then
            CommissionValueEntry.SetRange("Calculation Line No.", CommissionProfileLine."Totals Based On Line No.");
        if CommissionValueEntry.IsEmpty() then
            exit(false);
        CommissionValueEntry.CalcSums("Commission Amount", "Base Amount");
        Commission += CommissionValueEntry."Commission Amount";
        Volume += CommissionValueEntry."Base Amount";
        Units += CommissionValueEntry.Count();
    end;

    local procedure CalculatePeriodLevelProfileLine(var CommissionProfileLine: Record lvnCommissionProfileLine; CommissionDate: Date)
    var
        ExpressionHeader: Record lvnExpressionHeader;
        TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer temporary;
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        CommissionTierHeader: Record lvnCommissionTierHeader;
        Commission: Decimal;
        Volume: Decimal;
        Units: Decimal;
        CurrentMonthUnits: Integer;
        CurrentMonthVolume: Decimal;
        ValueNo: Integer;
    begin
        TempExpressionValueBuffer.Reset();
        TempExpressionValueBuffer.DeleteAll();
        ValueNo := 0;
        Clear(TempLoanCommissionBuffer);
        TempLoanCommissionBuffer."Commission Date" := CommissionDate;
        GetJournalStats(CommissionProfileLine, CurrentPeriodStartDate, CurrentPeriodEndDate, Units, Volume, Commission, false);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'CurrentCount', Units);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'CurrentAmount', Volume);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'CurrentCommission', Commission);
        GetLedgerStats(CommissionProfileLine, CurrentPeriodStartDate, CurrentPeriodEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'PeriodCount', Units);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'PeriodAmount', Volume);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'PeriodCommission', Commission);
        GetJournalStats(CommissionProfileLine, CurrentMonthStartDate, CurrentMonthEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, CurrentMonthStartDate, CurrentMonthEndDate, Units, Volume, Commission, true);
        CurrentMonthUnits := Units;
        CurrentMonthVolume := Volume;
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'MonthCount', Units);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'MonthAmount', Volume);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'MonthCommission', Commission);
        GetJournalStats(CommissionProfileLine, QuarterStartDate, QuarterEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, QuarterStartDate, QuarterEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'QuarterCount', Units);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'QuarterAmount', Volume);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'QuarterCommission', Commission);
        GetJournalStats(CommissionProfileLine, CurrentYearStartDate, CurrentYearEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, CurrentYearStartDate, CurrentYearEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'YearCount', Units);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'YearAmount', Volume);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'YearCommission', Commission);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'Month', CommissionSchedule."Month End Calculation");
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, 'Quarter', CommissionSchedule."Quarter Calculation");
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, '!CalculationParameter', CommissionProfileLine.Parameter);
        AppendExpressionValue(TempExpressionValueBuffer, ValueNo, '!ProfileLineTag', CommissionProfileLine.Tag);
        if CommissionProfileLine."Period Level Condition Code" <> '' then begin
            if not ExpressionHeader.Get(CommissionProfileLine."Period Level Condition Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                Error(FindingConditionErr, CommissionProfileLine."Profile Code", CommissionProfileLine."Loan Level Condition Code", CommissionProfileLine."Line No.");
            if not ExpressionEngine.CheckCondition(ExpressionHeader, TempExpressionValueBuffer) then
                exit;
        end;
        case CommissionProfileLine."Period Calculation Type" of
            CommissionProfileLine."Period Calculation Type"::"Defined Value":
                begin
                    TempLoanCommissionBuffer."Commission Amount" := CommissionProfileLine.Parameter;
                    TempLoanCommissionBuffer."Base Amount" := CommissionProfileLine.Parameter;
                end;
            CommissionProfileLine."Period Calculation Type"::Formula, CommissionProfileLine."Period Calculation Type"::Tiers:
                begin
                    if not ExpressionHeader.Get(CommissionProfileLine."Period Level Function Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                        Error(FindingFunctionErr, CommissionProfileLine."Period Level Function Code", CommissionProfileLine."Profile Code", CommissionProfileLine."Line No.");
                    Evaluate(TempLoanCommissionBuffer."Commission Amount", ExpressionEngine.CalculateFormula(ExpressionHeader, TempExpressionValueBuffer));
                    TempLoanCommissionBuffer."Base Amount" := TempLoanCommissionBuffer."Commission Amount";
                    if CommissionProfileLine."Period Calculation Type" = CommissionProfileLine."Period Calculation Type"::Tiers then begin
                        CommissionTierHeader.Get(CommissionProfileLine."Tier Code");
                        if CheckPeriodTierPayoutCondition(TempLoanCommissionBuffer, CommissionTierHeader) then
                            CommissionCalcHelper.CalculateLoanTier(TempLoanCommissionBuffer, CommissionTierHeader, TempLoanCommissionBuffer."Base Amount", 1, CurrentMonthAmount, CurrentMonthUnits);
                    end;
                end;
            else
                ImplementationMgmt.ThrowNotImplementedError();
        end;
        if TempLoanCommissionBuffer."Commission Amount" <> 0 then
            AddCommissionJournalLine(CommissionProfileLine, TempLoanCommissionBuffer);
    end;

    local procedure ApplyExtendedFilters(var Loan: Record lvnLoan; ExtendedFilterCode: Code[20])
    var
        CommissionExtendedFilter: Record lvnCommissionExtendedFilter;
        InStream: InStream;
        Filters: Text;
    begin
        CommissionExtendedFilter.Get(ExtendedFilterCode);
        CommissionExtendedFilter.CalcFields("Extended Filter");
        if CommissionExtendedFilter."Extended Filter".HasValue then begin
            CommissionExtendedFilter."Extended Filter".CreateInStream(InStream);
            InStream.ReadText(Filters);
            Loan.SetView(Filters);
        end;
    end;

    local procedure ApplyLoanOfficerFilter(var Loan: Record lvnLoan; DimensionCode: Code[20])
    begin
        case LoanOfficerDimensionNo of
            1:
                Loan.SetRange("Global Dimension 1 Code", DimensionCode);
            2:
                Loan.SetRange("Global Dimension 2 Code", DimensionCode);
            3:
                Loan.SetRange("Shortcut Dimension 3 Code", DimensionCode);
            4:
                Loan.SetRange("Shortcut Dimension 4 Code", DimensionCode);
            5:
                Loan.SetRange("Shortcut Dimension 5 Code", DimensionCode);
            6:
                Loan.SetRange("Shortcut Dimension 6 Code", DimensionCode);
            7:
                Loan.SetRange("Shortcut Dimension 7 Code", DimensionCode);
            8:
                Loan.SetRange("Shortcut Dimension 8 Code", DimensionCode);
        end;
    end;

    local procedure FillCalculationBuffer(var Loan: Record lvnLoan; var CommissionProfileLine: Record lvnCommissionProfileLine; var TempExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        LoanValue: Record lvnLoanValue;
        TableFields: Record Field;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        FieldSequenceNo: Integer;
    begin
        TempExpressionValueBuffer.Reset();
        TempExpressionValueBuffer.DeleteAll();
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanValue.Reset();
                LoanValue.SetRange("Loan No.", Loan."No.");
                LoanValue.SetRange("Field No.", LoanFieldsConfiguration."Field No.");
                Clear(TempExpressionValueBuffer);
                TempExpressionValueBuffer.Number := FieldSequenceNo;
                TempExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                TempExpressionValueBuffer.Type := Format(LoanFieldsConfiguration."Value Type");
                if LoanValue.FindFirst() then
                    TempExpressionValueBuffer.Value := LoanValue."Field Value"
                else
                    case LoanFieldsConfiguration."Value Type" of
                        LoanFieldsConfiguration."Value Type"::Boolean:
                            TempExpressionValueBuffer.Value := BooleanFalseLbl;
                        LoanFieldsConfiguration."Value Type"::Decimal:
                            TempExpressionValueBuffer.Value := DecimalZeroLbl;
                        LoanFieldsConfiguration."Value Type"::Integer:
                            TempExpressionValueBuffer.Value := IntegerZeroLbl;
                    end;
                TempExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.SetFilter("No.", '>%1', 4);
        TableFields.FindSet();
        RecordReference.GetTable(Loan);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(TempExpressionValueBuffer);
            TempExpressionValueBuffer.Number := FieldSequenceNo;
            TempExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            TempExpressionValueBuffer.Value := Delchr(Format(FieldReference.Value()), '<>', ' ');
            TempExpressionValueBuffer.Type := Format(FieldReference.Type());
            TempExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();
        AppendExpressionValue(TempExpressionValueBuffer, FieldSequenceNo, '!CalculationParameter', CommissionProfileLine.Parameter);
        AppendExpressionValue(TempExpressionValueBuffer, FieldSequenceNo, '!ProfileLineTag', CommissionProfileLine.Tag);
    end;

    local procedure CreateJournalBufferFromLoan(var Loan: Record lvnLoan; var BufferEntryNo: Integer; ProfileLineNo: Integer)
    begin
        Clear(TempLoanCommissionBuffer);
        TempLoanCommissionBuffer."Entry No." := BufferEntryNo;
        BufferEntryNo := BufferEntryNo + 1;
        TempLoanCommissionBuffer."Loan No." := Loan."No.";
        TempLoanCommissionBuffer."Profile Code" := CommissionProfile.Code;
        TempLoanCommissionBuffer."Profile Line No." := ProfileLineNo;
        TempLoanCommissionBuffer."Commission Date" := Loan."Commission Date";
        TempLoanCommissionBuffer."Base Amount" := Loan."Commission Base Amount";
        TempLoanCommissionBuffer.Insert();
    end;

    local procedure CreateJournalBufferFromValueEntry(var CommissionValueEntry: Record lvnCommissionValueEntry; var BufferEntryNo: Integer; ProfileLineNo: Integer)
    begin
        Clear(TempLoanCommissionBuffer);
        TempLoanCommissionBuffer."Entry No." := BufferEntryNo;
        BufferEntryNo := BufferEntryNo + 1;
        TempLoanCommissionBuffer."Loan No." := CommissionValueEntry."Loan No.";
        TempLoanCommissionBuffer."Profile Code" := CommissionProfile.Code;
        TempLoanCommissionBuffer."Profile Line No." := ProfileLineNo;
        TempLoanCommissionBuffer."Commission Date" := CommissionValueEntry."Commission Date";
        TempLoanCommissionBuffer."Base Amount" := CommissionValueEntry."Commission Amount";
        TempLoanCommissionBuffer."Commission Amount" := CommissionValueEntry."Commission Amount";
        TempLoanCommissionBuffer.Bps := CommissionValueEntry.Bps;
        TempLoanCommissionBuffer."Value Entry" := true;
        TempLoanCommissionBuffer.Insert();
    end;

    local procedure AddCommissionJournalLine(var CommissionProfileLine: Record lvnCommissionProfileLine; var TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer)
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
        JournalLineNo: Integer;
    begin
        //Get the line number and initialize
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
        if CommissionJournalLine.FindLast() then
            JournalLineNo := CommissionJournalLine."Line No." + 1
        else
            JournalLineNo := 1;
        Clear(CommissionJournalLine);
        CommissionJournalLine.Init();
        CommissionJournalLine."Line No." := JournalLineNo;
        //Fill schedule fields
        CommissionJournalLine."Schedule No." := CommissionSchedule."No.";
        CommissionJournalLine."Period Identifier Code" := CommissionSchedule."Period Identifier Code";
        //Fill profile fields
        CommissionJournalLine."Profile Code" := CommissionProfileLine."Profile Code";
        CommissionJournalLine."Calculation Line No." := CommissionProfileLine."Line No.";
        CommissionJournalLine."Profile Line Type" := CommissionProfileLine."Profile Line Type";
        if CommissionProfileLine."Profile Line Type" = CommissionProfileLine."Profile Line Type"::"Loan Level" then
            CommissionJournalLine."Calculation Type" := Format(CommissionProfileLine."Loan Calculation Type")
        else
            CommissionJournalLine."Calculation Type" := Format(CommissionProfileLine."Period Calculation Type");
        CommissionJournalLine."Identifier Code" := CommissionProfileLine."Identifier Code";
        CommissionJournalLine.Description := CommissionProfileLine.Description;
        CommissionJournalLine."Calculation Only" := CommissionProfileLine."Calculation Only";
        //Fill calculated fields
        CommissionJournalLine."Loan No." := TempLoanCommissionBuffer."Loan No.";
        CommissionJournalLine."Base Amount" := TempLoanCommissionBuffer."Base Amount";
        CommissionJournalLine."Commission Date" := TempLoanCommissionBuffer."Commission Date";
        CommissionJournalLine."Commission Amount" := TempLoanCommissionBuffer."Commission Amount";
        CommissionJournalLine.Bps := TempLoanCommissionBuffer.Bps;
        //Adjust amount according to split
        CommissionJournalLine."Commission Amount" := CommissionJournalLine."Commission Amount" / 100 * CommissionProfileLine."Split Percentage";
        //Adjust amount according to min/max
        if CommissionProfileLine."Min. Commission Amount" > 0 then
            if CommissionJournalLine."Commission Amount" < CommissionProfileLine."Min. Commission Amount" then
                CommissionJournalLine."Commission Amount" := CommissionProfileLine."Min. Commission Amount";
        if CommissionProfileLine."Max. Commission Amount" > 0 then
            if CommissionJournalLine."Commission Amount" > CommissionProfileLine."Max. Commission Amount" then
                CommissionJournalLine."Commission Amount" := CommissionProfileLine."Max. Commission Amount";
        //Check for posted entries (loan-level)
        if (CommissionProfileLine."Profile Line Type" = CommissionProfileLine."Profile Line Type"::"Loan Level") and TempLoanCommissionBuffer."Value Entry" then begin
            TempLoanCommissionBuffer.Get(TempLoanCommissionBuffer."Entry No.");
            if TempLoanCommissionBuffer."Commission Amount" <> TempLoanCommissionBuffer."Commission Amount" then begin
                CommissionJournalLine."Commission Amount" := TempLoanCommissionBuffer."Commission Amount" - CommissionJournalLine."Commission Amount";
                CommissionJournalLine.Bps := TempLoanCommissionBuffer.Bps - CommissionJournalLine.Bps;
                CommissionJournalLine.Insert();
            end;
        end else
            CommissionJournalLine.Insert(true);
    end;

    local procedure CheckLoanTierPayoutCondition(var Loan: Record lvnLoan; CommissionTierHeader: Record lvnCommissionTierHeader): Boolean
    var
        LoanValue: Record lvnLoanValue;
        ExpressionHeader: Record lvnExpressionHeader;
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        TempDummy: Record lvnCommissionProfileLine temporary;
        ValidCondition: Boolean;
    begin
        Clear(ValidCondition);
        case CommissionTierHeader."Tier Payout Type" of
            CommissionTierHeader."Tier Payout Type"::Always:
                exit(true);
            CommissionTierHeader."Tier Payout Type"::Never:
                exit(false);
            CommissionTierHeader."Tier Payout Type"::"Loan Value":
                if not LoanValue.Get(Loan."No.", CommissionTierHeader."Payout Field No.") then
                    exit(false)
                else
                    exit(UpperCase(LoanValue."Field Value") = UpperCase(CommissionTierHeader."Payout Compare Value"));
            CommissionTierHeader."Tier Payout Type"::Condition:
                begin
                    if not ExpressionHeader.Get(CommissionTierHeader."Payout Condition Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                        Error(FindingConditionForTierErr, CommissionTierHeader."Payout Condition Code", CommissionTierHeader.Code);
                    FillCalculationBuffer(Loan, TempDummy, TempExpressionValueBuffer);
                    ValidCondition := ExpressionEngine.CheckCondition(ExpressionHeader, TempExpressionValueBuffer);
                    exit(ValidCondition);
                end;
        end;
    end;

    local procedure CheckPeriodTierPayoutCondition(var TempLoanCommissionBuffer: Record lvnLoanCommissionBuffer; var CommissionTierHeader: Record lvnCommissionTierHeader): Boolean
    begin
        ImplementationMgmt.ThrowNotImplementedError();
    end;

    procedure SetParams(ScheduleNo: Integer)
    begin
        CommissionSchedule.Get(ScheduleNo);
    end;
}