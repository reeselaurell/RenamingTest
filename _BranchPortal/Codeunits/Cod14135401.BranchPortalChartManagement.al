codeunit 14135401 lvngBranchPortalChartMgmt
{
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanTypeLbl: Label 'Loan Type';
        ByLoanTypeLbl: Label 'Loans by Loan Type';
        LoanOfficerLbl: Label 'Loan Officer';
        ByLoanOfficerLbl: Label 'Loans by Loan Officer';
        BranchLbl: Label 'Branch';
        ByBranchLbl: Label 'Loans by Branch';
        BranchPortalMgmt: Codeunit lvngBranchPortalManagement;
        GeneralLedgerSetupRetrieved: Boolean;
        LoanVisionSetupRetrieved: Boolean;

    procedure UpdateDataForLoansFundedByLoanType(var BusinessChartBuffer: Record "Business Chart Buffer"; ChartType: Enum lvngChartKind; ValueToCalculate: Enum lvngChartCalculatedValue; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        DimensionNo: Integer;
    begin
        GetLoanVisionSetup();
        DimensionNo := GetDimensionNo(LoanVisionSetup.lvngLoanTypeDimensionCode);
        UpdateDataForLoansByDimension(DimensionNo, LoanTypeLbl, ByLoanTypeLbl, BusinessChartBuffer, ChartType, ValueToCalculate, SystemFilter);
    end;

    procedure UpdateDataForLoansFundedByLO(var BusinessChartBuffer: Record "Business Chart Buffer"; ChartType: Enum lvngChartKind; ValueToCalculate: Enum lvngChartCalculatedValue; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        DimensionNo: Integer;
    begin
        GetLoanVisionSetup();
        DimensionNo := GetDimensionNo(LoanVisionSetup.lvngLoanOfficerDimensionCode);
        UpdateDataForLoansByDimension(DimensionNo, LoanOfficerLbl, ByLoanOfficerLbl, BusinessChartBuffer, ChartType, ValueToCalculate, SystemFilter);
    end;

    procedure UpdateDataForLoansFundedByBranch(var BusinessChartBuffer: Record "Business Chart Buffer"; ChartType: Enum lvngChartKind; ValueToCalculate: Enum lvngChartCalculatedValue; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        DimensionNo: Integer;
    begin
        GetLoanVisionSetup();
        DimensionNo := GetDimensionNo(LoanVisionSetup.lvngCostCenterDimensionCode);
        UpdateDataForLoansByDimension(DimensionNo, BranchLbl, ByBranchLbl, BusinessChartBuffer, ChartType, ValueToCalculate, SystemFilter);
    end;

    procedure UpdateDataForLoansByAverageDaysToSell()
    begin
        Error('Not Implemented');
    end;

    procedure UpdateDataForLoansByAverageDaysToFund()
    begin
        Error('Not Implemented');
    end;

    local procedure UpdateDataForLoansByDimension(DimensionNo: Integer; AxisLabel: Text; MeasureLabel: Text; var BusinessChartBuffer: Record "Business Chart Buffer"; ChartType: Enum lvngChartKind; ValueToCalculate: Enum lvngChartCalculatedValue; var SystemFilter: Record lvngSystemCalculationFilter)
    var
        Idx: Integer;
        Q1Amount: Query lvngLoanDim1Top10Amount;
        Q2Amount: Query lvngLoanDim2Top10Amount;
        Q3Amount: Query lvngLoanDim3Top10Amount;
        Q4Amount: Query lvngLoanDim4Top10Amount;
        Q5Amount: Query lvngLoanDim5Top10Amount;
        Q6Amount: Query lvngLoanDim6Top10Amount;
        Q7Amount: Query lvngLoanDim7Top10Amount;
        Q8Amount: Query lvngLoanDim8Top10Amount;
        Q1Count: Query lvngLoanDim1Top10Count;
        Q2Count: Query lvngLoanDim2Top10Count;
        Q3Count: Query lvngLoanDim3Top10Count;
        Q4Count: Query lvngLoanDim4Top10Count;
        Q5Count: Query lvngLoanDim5Top10Count;
        Q6Count: Query lvngLoanDim6Top10Count;
        Q7Count: Query lvngLoanDim7Top10Count;
        Q8Count: Query lvngLoanDim8Top10Count;
    begin
        BusinessChartBuffer.Initialize();
        BusinessChartBuffer.SetXAxis(AxisLabel, BusinessChartBuffer."Data Type"::String);
        BusinessChartBuffer.AddMeasure(MeasureLabel, MeasureLabel, BusinessChartBuffer."Data Type"::Decimal, BranchPortalMgmt.EnumToInt(ChartType));
        if ValueToCalculate = ValueToCalculate::Amount then begin
            case DimensionNo of
                1:
                    begin
                        Q1Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q1Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q1Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q1Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q1Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q1Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q1Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q1Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q1Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q1Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q1Amount.Open();
                        Idx := 0;
                        while Q1Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q1Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q1Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q1Amount.Close();
                    end;
                2:
                    begin
                        Q2Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q2Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q2Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q2Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q2Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q2Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q2Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q2Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q2Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q2Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q2Amount.Open();
                        Idx := 0;
                        while Q2Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q2Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q2Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q1Amount.Close();
                    end;
                3:
                    begin
                        Q3Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q3Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q3Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q3Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q3Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q3Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q3Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q3Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q3Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q3Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q3Amount.Open();
                        Idx := 0;
                        while Q3Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q3Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q3Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q3Amount.Close();
                    end;
                4:
                    begin
                        Q4Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q4Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q4Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q4Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q4Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q4Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q4Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q4Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q4Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q4Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q4Amount.Open();
                        Idx := 0;
                        while Q4Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q4Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q4Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q4Amount.Close();
                    end;
                5:
                    begin
                        Q5Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q5Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q5Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q5Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q5Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q5Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q5Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q5Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q5Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q5Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q5Amount.Open();
                        Idx := 0;
                        while Q5Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q5Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q5Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q5Amount.Close();
                    end;
                6:
                    begin
                        Q6Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q6Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q6Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q6Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q6Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q6Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q6Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q6Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q6Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q6Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q6Amount.Open();
                        Idx := 0;
                        while Q6Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q6Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q6Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q6Amount.Close();
                    end;
                7:
                    begin
                        Q7Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q7Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q7Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q7Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q7Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q7Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q7Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q7Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q7Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q7Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q7Amount.Open();
                        Idx := 0;
                        while Q7Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q7Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q7Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q7Amount.Close();
                    end;
                8:
                    begin
                        Q8Amount.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q8Amount.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q8Amount.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q8Amount.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q8Amount.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q8Amount.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q8Amount.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q8Amount.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q8Amount.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q8Amount.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q8Amount.Open();
                        Idx := 0;
                        while Q8Amount.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q8Amount.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q8Amount.LoanAmount);
                            Idx := Idx + 1;
                        end;
                        Q8Amount.Close();
                    end;
            end;
        end;
        if ValueToCalculate = ValueToCalculate::Count then begin
            case DimensionNo of
                1:
                    begin
                        Q1Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q1Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q1Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q1Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q1Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q1Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q1Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q1Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q1Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q1Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q1Count.Open();
                        Idx := 0;
                        while Q1Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q1Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q1Count.LoanCount);
                        end;
                        Q1Count.Close();
                    end;
                2:
                    begin
                        Q2Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q2Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q2Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q2Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q2Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q2Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q2Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q2Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q2Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q2Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q2Count.Open();
                        Idx := 0;
                        while Q2Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q2Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q2Count.LoanCount);
                        end;
                        Q2Count.Close();
                    end;
                3:
                    begin
                        Q3Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q3Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q3Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q3Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q3Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q3Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q3Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q3Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q3Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q3Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q3Count.Open();
                        Idx := 0;
                        while Q3Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q3Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q3Count.LoanCount);
                        end;
                        Q3Count.Close();
                    end;
                4:
                    begin
                        Q4Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q4Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q4Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q4Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q4Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q4Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q4Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q4Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q4Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q4Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q4Count.Open();
                        Idx := 0;
                        while Q4Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q4Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q4Count.LoanCount);
                        end;
                        Q4Count.Close();
                    end;
                5:
                    begin
                        Q5Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q5Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q5Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q5Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q5Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q5Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q5Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q5Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q5Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q5Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q5Count.Open();
                        Idx := 0;
                        while Q5Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q5Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q5Count.LoanCount);
                        end;
                        Q5Count.Close();
                    end;
                6:
                    begin
                        Q6Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q6Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q6Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q6Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q6Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q6Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q6Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q6Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q6Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q6Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q6Count.Open();
                        Idx := 0;
                        while Q6Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q6Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q6Count.LoanCount);
                        end;
                        Q6Count.Close();
                    end;
                7:
                    begin
                        Q7Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q7Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q7Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q7Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q7Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q7Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q7Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q7Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q7Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q7Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q7Count.Open();
                        Idx := 0;
                        while Q7Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q7Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q7Count.LoanCount);
                        end;
                        Q7Count.Close();
                    end;
                8:
                    begin
                        Q8Count.SetRange(DateFundedFilter, SystemFilter."Date From", SystemFilter."Date To");
                        if SystemFilter."Shortcut Dimension 1" <> '' then
                            Q8Count.SetRange(Dimension1Filter, SystemFilter."Shortcut Dimension 1");
                        if SystemFilter."Shortcut Dimension 2" <> '' then
                            Q8Count.SetRange(Dimension2Filter, SystemFilter."Shortcut Dimension 2");
                        if SystemFilter."Shortcut Dimension 3" <> '' then
                            Q8Count.SetRange(Dimension3Filter, SystemFilter."Shortcut Dimension 3");
                        if SystemFilter."Shortcut Dimension 4" <> '' then
                            Q8Count.SetRange(Dimension4Filter, SystemFilter."Shortcut Dimension 4");
                        if SystemFilter."Shortcut Dimension 5" <> '' then
                            Q8Count.SetRange(Dimension5Filter, SystemFilter."Shortcut Dimension 5");
                        if SystemFilter."Shortcut Dimension 6" <> '' then
                            Q8Count.SetRange(Dimension6Filter, SystemFilter."Shortcut Dimension 6");
                        if SystemFilter."Shortcut Dimension 7" <> '' then
                            Q8Count.SetRange(Dimension7Filter, SystemFilter."Shortcut Dimension 7");
                        if SystemFilter."Shortcut Dimension 8" <> '' then
                            Q8Count.SetRange(Dimension8Filter, SystemFilter."Shortcut Dimension 8");
                        if SystemFilter."Business Unit" <> '' then
                            Q8Count.SetRange(BusinessUnitFilter, SystemFilter."Business Unit");
                        Q8Count.Open();
                        Idx := 0;
                        while Q8Count.Read() do begin
                            BusinessChartBuffer.AddColumn(GetDimensionName(LoanVisionSetup.lvngLoanTypeDimensionCode, Q8Count.Code));
                            BusinessChartBuffer.SetValueByIndex(0, Idx, Q8Count.LoanCount);
                        end;
                        Q8Count.Close();
                    end;
            end;
        end;
    end;

    local procedure GetDimensionName(DimensionCode: Code[20]; ValueCode: Code[20]): Text
    var
        DimensionValue: Record "Dimension Value";
    begin
        if DimensionValue.Get(DimensionCode, ValueCode) then
            exit(DimensionValue.Name)
        else
            exit(ValueCode);
    end;

    local procedure GetGeneralLedgerSetup()
    begin
        if not GeneralLedgerSetupRetrieved then begin
            GeneralLedgerSetup.Get();
            GeneralLedgerSetupRetrieved := true;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;

    local procedure GetDimensionNo(Code: Code[20]): Integer;
    begin
        GetGeneralLedgerSetup();
        case Code of
            GeneralLedgerSetup."Global Dimension 1 Code":
                exit(1);
            GeneralLedgerSetup."Global Dimension 2 Code":
                exit(2);
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                exit(3);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                exit(4);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                exit(5);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                exit(6);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                exit(7);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                exit(8);
        end;
    end;
}