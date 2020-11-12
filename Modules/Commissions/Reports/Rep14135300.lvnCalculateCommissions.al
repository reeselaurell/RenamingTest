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
                CalcBuffer: Record lvnLoanCommissionBuffer temporary;
                Loan: Record lvnLoan;
                CommissionValueEntry: Record lvnCommissionValueEntry;
                ExpressionHeader: Record lvnExpressionHeader;
                ExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
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
                LoanCommissionBuffer.Reset();
                LoanCommissionBuffer.DeleteAll();
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
                                if (CommissionProfileLine."Valid From Date" <> 0D) then begin
                                    if (Loan."Commission Date" < CommissionProfileLine."Valid From Date") then
                                        ValidLoan := false;
                                end;
                                if (CommissionProfileLine."Valid To Date" <> 0D) then begin
                                    if (Loan."Commission Date" > CommissionProfileLine."Valid To Date") then
                                        ValidLoan := false;
                                end;
                                if ValidLoan then begin
                                    if CommissionProfileLine."Loan Level Condition Code" <> '' then begin
                                        if not ExpressionHeader.Get(CommissionProfileLine."Loan Level Condition Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                                            Error(FindingConditionErr, CommissionProfileLine."Profile Code", CommissionProfileLine."Loan Level Condition Code", CommissionProfileLine."Line No.");
                                        FillCalculationBuffer(Loan, CommissionProfileLine, ExpressionValueBuffer);
                                        ValidLoan := ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer);
                                    end;
                                end;
                                if ValidLoan then begin
                                    CreateJournalBufferFromLoan(Loan, BufferEntryNo, CommissionProfileLine."Line No.");
                                end;
                            until Loan.Next() = 0;
                        CommissionValueEntry.Reset();
                        CommissionValueEntry.SetRange("Calculation Line No.", CommissionProfileLine."Line No.");
                        CommissionValueEntry.SetRange("Profile Code", Code);
                        CommissionValueEntry.SetRange("Period Identifier Code", CommissionProfileLine."Period Identifier Code");
                        CommissionValueEntry.SetRange("Commission Date", CurrentMonthStartDate, CurrentMonthEndDate);
                        if CommissionValueEntry.FindSet() then
                            repeat
                                CreateJournalBufferFromValueEntry(CommissionValueEntry, BufferEntryNo, CommissionProfileLine."Line No.");
                            until CommissionValueEntry.next = 0;
                    until CommissionProfileLine.Next() = 0;
                CalcBuffer.Reset();
                CalcBuffer.DeleteAll();
                LoanCommissionBuffer.Reset();
                if LoanCommissionBuffer.FindSet() then
                    repeat
                        Clear(CalcBuffer);
                        CalcBuffer := LoanCommissionBuffer;
                        CalcBuffer."Commission Amount" := 0;
                        CalcBuffer.Bps := 0;
                        CalcBuffer.Insert();
                    until LoanCommissionBuffer.Next() = 0;
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
                        CalcBuffer.Reset();
                        CalcBuffer.SetRange("Profile Code", CommissionProfileLine."Profile Code");
                        CalcBuffer.SetRange("Profile Line No.", CommissionProfileLine."Line No.");
                        if CalcBuffer.FindSet() then begin
                            if CommissionProfileLine."Loan Calculation Type" = CommissionProfileLine."Loan Calculation Type"::Tiers then begin
                                LoanCommissionBuffer.Reset();
                                LoanCommissionBuffer.SetRange("Profile Code", CommissionProfileLine."Profile Code");
                                if CommissionProfileLine."Totals Based On Line No." = 0 then
                                    LoanCommissionBuffer.SetRange("Profile Line No.", CommissionProfileLine."Line No.")
                                else
                                    LoanCommissionBuffer.SetRange("Profile Line No.", CommissionProfileLine."Totals Based On Line No.");
                                LoanCommissionBuffer.SetRange("Commission Date", CurrentMonthStartDate, CurrentMonthEndDate);
                                CurrentMonthUnits := LoanCommissionBuffer.Count();
                                LoanCommissionBuffer.CalcSums("Base Amount");
                                CurrentMonthAmount := LoanCommissionBuffer."Base Amount";
                                LoanCommissionBuffer.SetRange("Commission Date", NextMonthStartDate, NextMonthEndDate);
                                NextMonthUnits := LoanCommissionBuffer.Count();
                                LoanCommissionBuffer.CalcSums("Base Amount");
                                NextMonthAmount := LoanCommissionBuffer."Base Amount";
                            end;
                            CurrentOnGoingUnits := 0;
                            CurrentOnGoingVolume := 0;
                            NextOnGoingUnits := 0;
                            NextOnGoingVolume := 0;
                            repeat
                                if CalcBuffer."Commission Date" > CurrentMonthEndDate then begin
                                    NextOnGoingVolume := NextOnGoingVolume + CalcBuffer."Base Amount";
                                    NextOnGoingUnits := NextOnGoingUnits + 1;
                                    OnGoingVolume := NextOnGoingVolume;
                                    OnGoingUnits := NextOnGoingUnits;
                                    TotalUnits := NextMonthUnits;
                                    TotalVolume := NextMonthAmount;
                                end else begin
                                    CurrentOnGoingVolume := CurrentOnGoingVolume + CalcBuffer."Base Amount";
                                    CurrentOnGoingUnits := CurrentOnGoingUnits + 1;
                                    OnGoingVolume := CurrentOnGoingVolume;
                                    OnGoingUnits := CurrentOnGoingUnits;
                                    TotalUnits := CurrentMonthUnits;
                                    TotalVolume := CurrentMonthAmount;
                                end;
                                Loan.Get(CalcBuffer."Loan No.");
                                case CommissionProfileLine."Loan Calculation Type" of
                                    CommissionProfileLine."Loan Calculation Type"::"Defined Bps":
                                        begin
                                            CalcBuffer."Commission Amount" := CommissionProfileLine.Parameter * CalcBuffer."Base Amount" / 10000;
                                            CalcBuffer.Bps := CommissionProfileLine.Parameter;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Defined Value":
                                        begin
                                            CalcBuffer."Commission Amount" := CommissionProfileLine.Parameter;
                                            if CalcBuffer."Base Amount" <> 0 then
                                                CalcBuffer.Bps := CalcBuffer."Commission Amount" / CalcBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::Formula:
                                        begin
                                            if not ExpressionHeader.Get(CommissionProfileLine."Loan Level Function Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                                                Error(FindingFunctionErr, CommissionProfileLine."Loan Level Function Code", CommissionProfileLine."Profile Code", CommissionProfileLine."Line No.");
                                            FillCalculationBuffer(Loan, CommissionProfileLine, ExpressionValueBuffer);
                                            Evaluate(CalcBuffer."Commission Amount", ExpressionEngine.CalculateFormula(ExpressionHeader, ExpressionValueBuffer));
                                            if CalcBuffer."Base Amount" <> 0 then
                                                CalcBuffer.Bps := CalcBuffer."Commission Amount" / CalcBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Loan Card Bps":
                                        begin
                                            CalcBuffer."Commission Amount" := Loan."Commission Bps" * CalcBuffer."Base Amount" / 10000;
                                            CalcBuffer.Bps := Loan."Commission Bps";
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::"Loan Card Value":
                                        begin
                                            CalcBuffer."Commission Amount" := Loan."Commission Amount";
                                            if CalcBuffer."Base Amount" <> 0 then
                                                CalcBuffer.Bps := CalcBuffer."Commission Amount" / CalcBuffer."Base Amount" * 10000;
                                        end;
                                    CommissionProfileLine."Loan Calculation Type"::Tiers:
                                        begin
                                            CommissionTierHeader.Get(CommissionProfileLine."Tier Code");
                                            if CheckLoanTierPayoutCondition(Loan, CommissionTierHeader) then
                                                CommissionCalcHelper.CalculateLoanTier(CalcBuffer, CommissionTierHeader, OnGoingVolume, TotalVolume, OnGoingUnits, TotalUnits);
                                        end;
                                end;
                                CalcBuffer.Modify();
                                AddCommissionJournalLine(CommissionProfileLine, CalcBuffer);
                            until CalcBuffer.Next() = 0;
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
        LoanCommissionBuffer: Record lvnLoanCommissionBuffer temporary;
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

    local procedure AppendExpressionValue(var ExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Decimal)
    begin
        Clear(ExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        ExpressionValueBuffer.Number := ValueNo;
        ExpressionValueBuffer.Name := Name;
        ExpressionValueBuffer.Type := 'Decimal';
        ExpressionValueBuffer.Value := Format(Value, 0, 9);
        ExpressionValueBuffer.Insert();
    end;

    local procedure AppendExpressionValue(var ExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Boolean)
    begin
        Clear(ExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        ExpressionValueBuffer.Number := ValueNo;
        ExpressionValueBuffer.Name := Name;
        ExpressionValueBuffer.Type := 'Decimal';
        if Value then
            ExpressionValueBuffer.Value := 'True'
        else
            ExpressionValueBuffer.Value := 'False';
        ExpressionValueBuffer.Insert();
    end;

    local procedure AppendExpressionValue(var ExpressionValueBuffer: Record lvnExpressionValueBuffer; var ValueNo: Integer; Name: Text; Value: Text)
    begin
        Clear(ExpressionValueBuffer);
        ValueNo := ValueNo + 1;
        ExpressionValueBuffer.Number := ValueNo;
        ExpressionValueBuffer.Name := Name;
        ExpressionValueBuffer.Type := 'Text';
        ExpressionValueBuffer.Value := Value;
        ExpressionValueBuffer.Insert();
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
        CalcBuffer: Record lvnLoanCommissionBuffer temporary;
        ExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        CommissionTierHeader: Record lvnCommissionTierHeader;
        Commission: Decimal;
        Volume: Decimal;
        Units: Decimal;
        CurrentMonthUnits: Integer;
        CurrentMonthVolume: Decimal;
        ValueNo: Integer;
    begin
        ExpressionValueBuffer.Reset();
        ExpressionValueBuffer.DeleteAll();
        ValueNo := 0;
        Clear(CalcBuffer);
        CalcBuffer."Commission Date" := CommissionDate;
        GetJournalStats(CommissionProfileLine, CurrentPeriodStartDate, CurrentPeriodEndDate, Units, Volume, Commission, false);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'CurrentCount', Units);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'CurrentAmount', Volume);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'CurrentCommission', Commission);
        GetLedgerStats(CommissionProfileLine, CurrentPeriodStartDate, CurrentPeriodEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'PeriodCount', Units);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'PeriodAmount', Volume);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'PeriodCommission', Commission);
        GetJournalStats(CommissionProfileLine, CurrentMonthStartDate, CurrentMonthEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, CurrentMonthStartDate, CurrentMonthEndDate, Units, Volume, Commission, true);
        CurrentMonthUnits := Units;
        CurrentMonthVolume := Volume;
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'MonthCount', Units);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'MonthAmount', Volume);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'MonthCommission', Commission);
        GetJournalStats(CommissionProfileLine, QuarterStartDate, QuarterEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, QuarterStartDate, QuarterEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'QuarterCount', Units);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'QuarterAmount', Volume);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'QuarterCommission', Commission);
        GetJournalStats(CommissionProfileLine, CurrentYearStartDate, CurrentYearEndDate, Units, Volume, Commission, false);
        GetLedgerStats(CommissionProfileLine, CurrentYearStartDate, CurrentYearEndDate, Units, Volume, Commission, true);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'YearCount', Units);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'YearAmount', Volume);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'YearCommission', Commission);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'Month', CommissionSchedule."Month End Calculation");
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, 'Quarter', CommissionSchedule."Quarter Calculation");
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, '!CalculationParameter', CommissionProfileLine.Parameter);
        AppendExpressionValue(ExpressionValueBuffer, ValueNo, '!ProfileLineTag', CommissionProfileLine.Tag);
        if CommissionProfileLine."Period Level Condition Code" <> '' then begin
            if not ExpressionHeader.Get(CommissionProfileLine."Period Level Condition Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                Error(FindingConditionErr, CommissionProfileLine."Profile Code", CommissionProfileLine."Loan Level Condition Code", CommissionProfileLine."Line No.");
            if not ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer) then
                exit;
        end;
        case CommissionProfileLine."Period Calculation Type" of
            CommissionProfileLine."Period Calculation Type"::"Defined Value":
                begin
                    CalcBuffer."Commission Amount" := CommissionProfileLine.Parameter;
                    CalcBuffer."Base Amount" := CommissionProfileLine.Parameter;
                end;
            CommissionProfileLine."Period Calculation Type"::Formula, CommissionProfileLine."Period Calculation Type"::Tiers:
                begin
                    if not ExpressionHeader.Get(CommissionProfileLine."Period Level Function Code", CommissionCalcHelper.GetCommissionConsumerId()) then
                        Error(FindingFunctionErr, CommissionProfileLine."Period Level Function Code", CommissionProfileLine."Profile Code", CommissionProfileLine."Line No.");
                    Evaluate(CalcBuffer."Commission Amount", ExpressionEngine.CalculateFormula(ExpressionHeader, ExpressionValueBuffer));
                    CalcBuffer."Base Amount" := CalcBuffer."Commission Amount";
                    if CommissionProfileLine."Period Calculation Type" = CommissionProfileLine."Period Calculation Type"::Tiers then begin
                        CommissionTierHeader.Get(CommissionProfileLine."Tier Code");
                        if CheckPeriodTierPayoutCondition(CalcBuffer, CommissionTierHeader) then
                            CommissionCalcHelper.CalculateLoanTier(CalcBuffer, CommissionTierHeader, CalcBuffer."Base Amount", 1, CurrentMonthAmount, CurrentMonthUnits);
                    end;
                end;
            else
                ImplementationMgmt.ThrowNotImplementedError();
        end;
        if CalcBuffer."Commission Amount" <> 0 then
            AddCommissionJournalLine(CommissionProfileLine, CalcBuffer);
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

    local procedure FillCalculationBuffer(var Loan: Record lvnLoan; var CommissionProfileLine: Record lvnCommissionProfileLine; var ExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        LoanFieldsConfiguration: Record lvnLoanFieldsConfiguration;
        LoanValue: Record lvnLoanValue;
        TableFields: Record Field;
        FieldSequenceNo: Integer;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
    begin
        ExpressionValueBuffer.Reset();
        ExpressionValueBuffer.DeleteAll();
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then
            repeat
                FieldSequenceNo := FieldSequenceNo + 1;
                LoanValue.Reset();
                LoanValue.SetRange("Loan No.", Loan."No.");
                LoanValue.SetRange("Field No.", LoanFieldsConfiguration."Field No.");
                Clear(ExpressionValueBuffer);
                ExpressionValueBuffer.Number := FieldSequenceNo;
                ExpressionValueBuffer.Name := LoanFieldsConfiguration."Field Name";
                ExpressionValueBuffer.Type := Format(LoanFieldsConfiguration."Value Type");
                if LoanValue.FindFirst() then
                    ExpressionValueBuffer.Value := LoanValue."Field Value"
                else
                    case LoanFieldsConfiguration."Value Type" of
                        LoanFieldsConfiguration."Value Type"::Boolean:
                            ExpressionValueBuffer.Value := BooleanFalseLbl;
                        LoanFieldsConfiguration."Value Type"::Decimal:
                            ExpressionValueBuffer.Value := DecimalZeroLbl;
                        LoanFieldsConfiguration."Value Type"::Integer:
                            ExpressionValueBuffer.Value := IntegerZeroLbl;
                    end;
                ExpressionValueBuffer.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        TableFields.Reset();
        TableFields.SetRange(TableNo, Database::lvnLoan);
        TableFields.SetFilter("No.", '>%1', 4);
        TableFields.FindSet();
        RecordReference.GetTable(Loan);
        repeat
            FieldSequenceNo := FieldSequenceNo + 1;
            Clear(ExpressionValueBuffer);
            ExpressionValueBuffer.Number := FieldSequenceNo;
            ExpressionValueBuffer.Name := TableFields.FieldName;
            FieldReference := RecordReference.Field(TableFields."No.");
            ExpressionValueBuffer.Value := Delchr(Format(FieldReference.Value()), '<>', ' ');
            ExpressionValueBuffer.Type := Format(FieldReference.Type());
            ExpressionValueBuffer.Insert();
        until TableFields.Next() = 0;
        RecordReference.Close();
        AppendExpressionValue(ExpressionValueBuffer, FieldSequenceNo, '!CalculationParameter', CommissionProfileLine.Parameter);
        AppendExpressionValue(ExpressionValueBuffer, FieldSequenceNo, '!ProfileLineTag', CommissionProfileLine.Tag);
    end;

    local procedure CreateJournalBufferFromLoan(var Loan: Record lvnLoan; var BufferEntryNo: Integer; ProfileLineNo: Integer)
    begin
        Clear(LoanCommissionBuffer);
        LoanCommissionBuffer."Entry No." := BufferEntryNo;
        BufferEntryNo := BufferEntryNo + 1;
        LoanCommissionBuffer."Loan No." := Loan."No.";
        LoanCommissionBuffer."Profile Code" := CommissionProfile.Code;
        LoanCommissionBuffer."Profile Line No." := ProfileLineNo;
        LoanCommissionBuffer."Commission Date" := Loan."Commission Date";
        LoanCommissionBuffer."Base Amount" := Loan."Commission Base Amount";
        LoanCommissionBuffer.Insert();
    end;

    local procedure CreateJournalBufferFromValueEntry(var CommissionValueEntry: Record lvnCommissionValueEntry; var BufferEntryNo: Integer; ProfileLineNo: Integer)
    begin
        Clear(LoanCommissionBuffer);
        LoanCommissionBuffer."Entry No." := BufferEntryNo;
        BufferEntryNo := BufferEntryNo + 1;
        LoanCommissionBuffer."Loan No." := CommissionValueEntry."Loan No.";
        LoanCommissionBuffer."Profile Code" := CommissionProfile.Code;
        LoanCommissionBuffer."Profile Line No." := ProfileLineNo;
        LoanCommissionBuffer."Commission Date" := CommissionValueEntry."Commission Date";
        LoanCommissionBuffer."Base Amount" := CommissionValueEntry."Commission Amount";
        LoanCommissionBuffer."Commission Amount" := CommissionValueEntry."Commission Amount";
        LoanCommissionBuffer.Bps := CommissionValueEntry.Bps;
        LoanCommissionBuffer."Value Entry" := true;
        LoanCommissionBuffer.Insert();
    end;

    local procedure AddCommissionJournalLine(var CommissionProfileLine: Record lvnCommissionProfileLine; var CalcBuffer: Record lvnLoanCommissionBuffer)
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
        CommissionJournalLine."Loan No." := CalcBuffer."Loan No.";
        CommissionJournalLine."Base Amount" := CalcBuffer."Base Amount";
        CommissionJournalLine."Commission Date" := CalcBuffer."Commission Date";
        CommissionJournalLine."Commission Amount" := CalcBuffer."Commission Amount";
        CommissionJournalLine.Bps := CalcBuffer.Bps;
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
        if (CommissionProfileLine."Profile Line Type" = CommissionProfileLine."Profile Line Type"::"Loan Level") and CalcBuffer."Value Entry" then begin
            LoanCommissionBuffer.Get(CalcBuffer."Entry No.");
            if LoanCommissionBuffer."Commission Amount" <> CalcBuffer."Commission Amount" then begin
                CommissionJournalLine."Commission Amount" := CalcBuffer."Commission Amount" - CommissionJournalLine."Commission Amount";
                CommissionJournalLine.Bps := CalcBuffer.Bps - CommissionJournalLine.Bps;
                CommissionJournalLine.Insert();
            end;
        end else
            CommissionJournalLine.Insert(true);
    end;

    local procedure CheckLoanTierPayoutCondition(var Loan: Record lvnLoan; CommissionTierHeader: Record lvnCommissionTierHeader): Boolean
    var
        LoanValue: Record lvnLoanValue;
        ExpressionHeader: Record lvnExpressionHeader;
        ExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        Dummy: Record lvnCommissionProfileLine temporary;
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
                    FillCalculationBuffer(Loan, Dummy, ExpressionValueBuffer);
                    ValidCondition := ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer);
                    exit(ValidCondition);
                end;
        end;
    end;

    local procedure CheckPeriodTierPayoutCondition(var CalcBuffer: Record lvnLoanCommissionBuffer; var CommissionTierHeader: Record lvnCommissionTierHeader): Boolean
    begin
        ImplementationMgmt.ThrowNotImplementedError();
    end;

    procedure SetParams(ScheduleNo: Integer)
    begin
        CommissionSchedule.Get(ScheduleNo);
    end;
}