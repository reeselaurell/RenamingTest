codeunit 14135400 lvngBranchPortalManagement
{
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GeneralLedgerSetupRetrieved: Boolean;
        LoanVisionSetupRetrieved: Boolean;
        UnsupportedChartTypeErr: Label 'Chart type is not supported: %1';
        UnsupportedDataGroupingCodeErr: Label 'Data grouping code is not supported: %1';

    procedure GetDashboardChartData(ChartType: Enum lvngDashboardChartType; var SystemFilter: Record lvngSystemCalculationFilter; ArgumentField: Text; ValueField: Text; TagField: Text) DataSource: JsonArray
    var
        Loan: Record lvngLoan;
        BranchValueCalculation: Record lvngBranchValueCalculation temporary;
        Customer: Record Customer;
        GroupDimNo: Integer;
        GroupDimCode: Code[20];
        DimValue: Code[20];
        ChartPoint: JsonObject;
        AggregateType: Option Amount,Count,AvgToFund,AvgToSell;
        Top: Integer;
    begin
        Clear(DataSource);
        if ChartType = ChartType::lvngNone then
            exit;
        GetLoanVisionSetup();
        BranchValueCalculation.Reset();
        BranchValueCalculation.DeleteAll();
        Loan.Reset();
        case ChartType of
            ChartType::lvngFundedAmountByType:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Type Dimension Code";
                    AggregateType := AggregateType::Amount;
                end;
            ChartType::lvngFundedCountByType:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Type Dimension Code";
                    AggregateType := AggregateType::Count;
                end;
            ChartType::lvngAvgDaysToFundByType:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Type Dimension Code";
                    AggregateType := AggregateType::AvgToFund;
                end;
            ChartType::lvngAvgDaysToSellByType:
                begin
                    Loan.SetFilter("Date Sold", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Type Dimension Code";
                    AggregateType := AggregateType::AvgToSell;
                end;
            ChartType::lvngFundedAmountByLO:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Officer Dimension Code";
                    AggregateType := AggregateType::Amount;
                end;
            ChartType::lvngFundedCountByLO:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Officer Dimension Code";
                    AggregateType := AggregateType::Count;
                end;
            ChartType::lvngAvgDaysToFundByLO:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Officer Dimension Code";
                    AggregateType := AggregateType::AvgToFund;
                end;
            ChartType::lvngAvgDaysToSellByLO:
                begin
                    Loan.SetFilter("Date Sold", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Loan Officer Dimension Code";
                    AggregateType := AggregateType::AvgToSell;
                end;
            ChartType::lvngFundedAmountByBranch:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Cost Center Dimension Code";
                    AggregateType := AggregateType::Amount;
                end;
            ChartType::lvngFundedCountByBranch:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Cost Center Dimension Code";
                    AggregateType := AggregateType::Count;
                end;
            ChartType::lvngAvgDaysToFundByBranch:
                begin
                    Loan.SetFilter("Date Funded", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Cost Center Dimension Code";
                    AggregateType := AggregateType::AvgToFund;
                end;
            ChartType::lvngAvgDaysToSellByBranch:
                begin
                    Loan.SetFilter("Date Sold", SystemFilter."Date Filter");
                    GroupDimCode := LoanVisionSetup."Cost Center Dimension Code";
                    AggregateType := AggregateType::AvgToSell;
                end;
            ChartType::lvngSoldAmountByInvestor:
                begin
                    Loan.SetFilter("Date Sold", SystemFilter."Date Filter");
                    GroupDimCode := '';
                    GroupDimNo := 9;
                    AggregateType := AggregateType::Amount;
                end;
            ChartType::lvngSoldCountByInvestor:
                begin
                    Loan.SetFilter("Date Sold", SystemFilter."Date Filter");
                    GroupDimCode := '';
                    GroupDimNo := 9;
                    AggregateType := AggregateType::Count;
                end
            else
                Error(UnsupportedChartTypeErr, ChartType);
        end;
        if GroupDimCode <> '' then
            GroupDimNo := GetDimensionNo(GroupDimCode);
        if SystemFilter."Shortcut Dimension 1" <> '' then
            Loan.SetRange("Global Dimension 1 Code", SystemFilter."Shortcut Dimension 1");
        if SystemFilter."Shortcut Dimension 2" <> '' then
            Loan.SetRange("Global Dimension 2 Code", SystemFilter."Shortcut Dimension 2");
        if SystemFilter."Shortcut Dimension 3" <> '' then
            Loan.SetRange("Shortcut Dimension 3 Code", SystemFilter."Shortcut Dimension 3");
        if SystemFilter."Shortcut Dimension 4" <> '' then
            Loan.SetRange("Shortcut Dimension 4 Code", SystemFilter."Shortcut Dimension 4");
        if SystemFilter."Shortcut Dimension 5" <> '' then
            Loan.SetRange("Shortcut Dimension 5 Code", SystemFilter."Shortcut Dimension 5");
        if SystemFilter."Shortcut Dimension 6" <> '' then
            Loan.SetRange("Shortcut Dimension 6 Code", SystemFilter."Shortcut Dimension 6");
        if SystemFilter."Shortcut Dimension 7" <> '' then
            Loan.SetRange("Shortcut Dimension 7 Code", SystemFilter."Shortcut Dimension 7");
        if SystemFilter."Shortcut Dimension 8" <> '' then
            Loan.SetRange("Shortcut Dimension 8 Code", SystemFilter."Shortcut Dimension 8");
        if SystemFilter."Business Unit" <> '' then
            Loan.SetRange("Business Unit Code", SystemFilter."Business Unit");
        if Loan.FindSet() then
            repeat
                case GroupDimNo of
                    1:
                        DimValue := Loan."Global Dimension 1 Code";
                    2:
                        DimValue := Loan."Global Dimension 2 Code";
                    3:
                        DimValue := Loan."Shortcut Dimension 3 Code";
                    4:
                        DimValue := Loan."Shortcut Dimension 4 Code";
                    5:
                        DimValue := Loan."Shortcut Dimension 5 Code";
                    6:
                        DimValue := Loan."Shortcut Dimension 6 Code";
                    7:
                        DimValue := Loan."Shortcut Dimension 7 Code";
                    8:
                        DimValue := Loan."Shortcut Dimension 8 Code";
                end;
                if GroupDimNo > 8 then begin
                    case GroupDimNo of
                        9: //Investor No.
                            begin
                                if BranchValueCalculation.Get(Loan."Investor Customer No.") then begin
                                    BranchValueCalculation.Amount += loan."Loan Amount";
                                    BranchValueCalculation.Count += 1;
                                    BranchValueCalculation.Modify();
                                end else begin
                                    Clear(BranchValueCalculation);
                                    BranchValueCalculation."Dimension Value" := Loan."Investor Customer No.";
                                    BranchValueCalculation.Amount := Loan."Loan Amount";
                                    BranchValueCalculation.Count := 1;
                                    if Customer.Get(Loan."Investor Customer No.") then
                                        BranchValueCalculation.Name := Customer.Name
                                    else
                                        BranchValueCalculation.Name := loan."Investor Customer No.";
                                    BranchValueCalculation.Insert();
                                end;
                            end
                        else
                            Error(UnsupportedDataGroupingCodeErr, GroupDimNo);
                    end;
                end else begin
                    if BranchValueCalculation.Get(DimValue) then begin
                        ApplyLoan(BranchValueCalculation, Loan, AggregateType);
                        BranchValueCalculation.Modify();
                    end else begin
                        Clear(BranchValueCalculation);
                        BranchValueCalculation."Dimension Value" := DimValue;
                        ApplyLoan(BranchValueCalculation, Loan, AggregateType);
                        BranchValueCalculation.Name := GetDimensionName(GroupDimCode, DimValue);
                        BranchValueCalculation.Insert();
                    end;
                end;
            until Loan.Next() = 0;
        BranchValueCalculation.Reset();
        if BranchValueCalculation.FindSet(true) then
            repeat
                case AggregateType of
                    AggregateType::Count:
                        BranchValueCalculation.Amount := BranchValueCalculation.Count;
                    AggregateType::AvgToFund,
                        AggregateType::AvgToSell:
                        if BranchValueCalculation.Count = 0 then
                            BranchValueCalculation.Amount := 0
                        else
                            BranchValueCalculation.Amount := BranchValueCalculation.Amount / BranchValueCalculation.Count;
                end;
                BranchValueCalculation.Modify();
            until BranchValueCalculation.Next() = 0;
        BranchValueCalculation.Reset();
        BranchValueCalculation.SetCurrentKey(Amount);
        BranchValueCalculation.Ascending(false);
        Top := 0;
        if BranchValueCalculation.FindSet() then
            repeat
                Top += 1;
                Clear(ChartPoint);
                if TagField <> '' then begin
                    ChartPoint.Add(ArgumentField, BranchValueCalculation."Dimension Value");
                    ChartPoint.Add(ValueField, BranchValueCalculation.Amount);
                    ChartPoint.Add(TagField, BranchValueCalculation.Name);
                end else begin
                    ChartPoint.Add(ArgumentField, BranchValueCalculation.Name);
                    ChartPoint.Add(ValueField, BranchValueCalculation.Amount);
                end;
                DataSource.Add(ChartPoint);
            until (Top >= 10) or (BranchValueCalculation.Next() = 0);
    end;

    local procedure ApplyLoan(var BranchValueCalculation: Record lvngBranchValueCalculation; var Loan: Record lvngLoan; AggregateType: Option Amount,Count,AvgToFund,AvgToSell)
    begin
        case AggregateType of
            AggregateType::AvgToFund:
                if (Loan."Application Date" <> 0D) and (Loan."Date Funded" <> 0D) then begin
                    BranchValueCalculation.Amount += Loan."Date Funded" - Loan."Application Date";
                    BranchValueCalculation.Count += 1;
                end;
            AggregateType::AvgToSell:
                if (Loan."Date Sold" <> 0D) and (Loan."Date Funded" <> 0D) then begin
                    BranchValueCalculation.Amount += Loan."Date Sold" - Loan."Date Funded";
                    BranchValueCalculation.Count += 1;
                end;
            else begin
                    BranchValueCalculation.Amount += loan."Loan Amount";
                    BranchValueCalculation.Count += 1;
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

    procedure DevExtremeChartKind(ChartKind: Enum lvngChartKind) DXKind: Text
    begin
        case ChartKind of
            ChartKind::lvngDefault:
                exit('bar')
            else
                exit(DelChr(Format(ChartKind).ToLower(), '=', ' '));
        end;
    end;

    //Styling:
    //contained - button is filled with color
    //outlined - button bordered with color
    //text - hover color only
    //Type:
    //normal - gray
    //success - green
    //default - blue
    //danger - red
    procedure CreateDashboardButton(var ToArray: JsonArray; GroupId: Text; Id: Text; Metadata: Text; Caption: Text; Styling: Text; Type: Text; Width: Integer) Button: JsonObject
    begin
        Clear(Button);
        ToArray.Add(Button);
        Button.Add('bd_group', GroupId);
        Button.Add('bd_id', Id);
        if Metadata <> '' then
            Button.Add('bd_metadata', Metadata);
        Button.Add('text', Caption);
        if Styling <> '' then
            Button.Add('stylingMode', Styling);
        if Type <> '' then
            Button.Add('type', Type);
        if Width > 0 then
            Button.Add('width', Width);
    end;

    procedure CreateDashboardButtonDropdownItem(var ToArray: JsonArray; GroupId: Text; ItemId: Text; Metadata: Text; Caption: Text) Item: JsonObject
    begin
        Clear(Item);
        ToArray.Add(Item);
        Item.Add('text', Caption);
        Item.Add('bd_group', GroupId);
        Item.Add('bd_id', ItemId);
        if Metadata <> '' then
            Item.Add('bd_metadata', Metadata);
    end;

    procedure AddDashboardButtonDropdown(var Button: JsonObject; var Dropdown: JsonArray)
    begin
        Button.Add('dropdown', Dropdown);
    end;
}