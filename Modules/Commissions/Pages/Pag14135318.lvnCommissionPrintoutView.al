page 14135318 lvnCommissionPrintoutView
{
    Caption = 'Commission Printout';
    PageType = Card;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                field(LoanOfficerName; CommissionProfile.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Officer Name';
                }
                field(Period; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'For Date Period';
                }
            }
            usercontrol(CommissionGrid; lvnDataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeCommissionGrid();
                end;
            }
            usercontrol(OverrideGrid; lvnDataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeOverrideGrid();
                end;
            }
            usercontrol(AdjustmentGrid; lvnDataGridControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    InitializeAdjustmentGrid();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        DateFilterFormatLbl: Label '%1..%2', Comment = '%1 = Period Start Date; %2 = Period End Date';
    begin
        LoanVisionSetup.Get();
        CommissionSetup.Get();
        CommissionSchedule.Get(InitScheduleNo);
        CommissionProfile.Get(InitProfileCode);
        if not CurrencyFormat.Get('CURRENCY') then begin
            Clear(CurrencyFormat);
            CurrencyFormat."Blank Zero" := CurrencyFormat."Blank Zero"::Zero;
            CurrencyFormat."Negative Formatting" := CurrencyFormat."Negative Formatting"::Parenthesis;
            CurrencyFormat.Rounding := CurrencyFormat.Rounding::Two;
            CurrencyFormat."Value Type" := CurrencyFormat."Value Type"::Currency;
        end;
        if not BpsFormat.Get('BPS') then begin
            Clear(BpsFormat);
            BpsFormat."Blank Zero" := BpsFormat."Blank Zero"::Default;
            BpsFormat."Negative Formatting" := BpsFormat."Negative Formatting"::None;
            BpsFormat.Rounding := BpsFormat.Rounding::Two;
            BpsFormat."Value Type" := BpsFormat."Value Type"::Regular;
        end;
        LoanOfficerDimensionNo := DimensionManagement.GetDimensionNo(LoanVisionSetup."Loan Officer Dimension Code");
        DateFilter := StrSubstNo(DateFilterFormatLbl, CommissionSchedule."Period Start Date", CommissionSchedule."Period End Date");
        CalculateData();
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        CommissionSetup: Record lvnCommissionSetup;
        CommissionSchedule: Record lvnCommissionSchedule;
        CommissionProfile: Record lvnCommissionProfile;
        CurrencyFormat: Record lvnNumberFormat;
        BpsFormat: Record lvnNumberFormat;
        DimensionManagement: Codeunit lvnDimensionsManagement;
        ImplMgmt: Codeunit lvnImplementationManagement;
        InitScheduleNo: Integer;
        InitProfileCode: Code[20];
        DateFilter: Text;
        LoanOfficerDimensionNo: Integer;
        AdditionalCommissions: Dictionary of [Code[20], Text];
        LoanNoLbl: Label 'Loan No.';
        CommissionDateLbl: Label 'Commission Date';
        OriginatorLbl: Label 'Originator';
        BorrowerNameLbl: Label 'Borrower Name';
        LoanAmountLbl: Label 'Loan Amount';
        GrossCommissionLbl: Label 'Gross Commission';
        BpsLbl: Label 'Bps';
        NetCommissionLbl: Label 'Net Commission';

    procedure SetParams(ScheduleNo: Integer; ProfileCode: Code[20])
    begin
        InitScheduleNo := ScheduleNo;
        InitProfileCode := ProfileCode;
    end;

    local procedure CalculateData()
    var
        CommissionIdentifier: Record lvnCommissionIdentifier;
    begin
        CommissionIdentifier.Reset();
        CommissionIdentifier.SetRange("Additional Identifier", true);
        if CommissionIdentifier.FindSet() then
            repeat
                if HasCommissions(CommissionIdentifier.Code) then
                    AdditionalCommissions.Add(CommissionIdentifier.Code, CommissionIdentifier.Name);
            until CommissionIdentifier.Next() = 0;
    end;

    local procedure AddCommonGridSettings(Json: JsonObject)
    var
        Setting: JsonObject;
    begin
        Setting.Add('enabled', false);
        Json.Add('paging', Setting);
        Clear(Setting);
        Setting.Add('mode', 'none');
        Json.Add('sorting', Setting);
        Json.Add('columnAutoWidth', true);
    end;

    local procedure GetColumn(DataField: Text; Caption: Text) Col: JsonObject
    begin
        Col.Add('dataField', DataField);
        Col.Add('caption', Caption);
    end;

    local procedure InitializeCommissionGrid()
    var
        Json: JsonObject;
    begin
        CurrPage.CommissionGrid.SetHeight(340);
        Json.Add('columns', GetCommissionColumns());
        Json.Add('dataSource', GetCommissionData());
        AddCommonGridSettings(Json);
        CurrPage.CommissionGrid.InitializeDXGrid(Json);
    end;

    local procedure InitializeOverrideGrid()
    var
        Json: JsonObject;
    begin
        CurrPage.OverrideGrid.SetHeight(340);
        Json.Add('columns', GetOverrideColumns());
        Json.Add('dataSource', GetOverrideData());
        AddCommonGridSettings(Json);
        CurrPage.OverrideGrid.InitializeDXGrid(Json);
    end;

    local procedure InitializeAdjustmentGrid()
    var
        Json: JsonObject;
    begin
        CurrPage.AdjustmentGrid.SetHeight(340);
        Json.Add('columns', GetAdjustmentColumns());
        Json.Add('dataSource', GetAdjustmentData());
        AddCommonGridSettings(Json);
        CurrPage.AdjustmentGrid.InitializeDXGrid(Json);
    end;

    local procedure HasCommissions(IdentifierCode: Code[20]): Boolean
    var
        CommissionValueEntry: Record lvnCommissionValueEntry;
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        if CommissionSchedule."Period Posted" then begin
            CommissionValueEntry.Reset();
            CommissionValueEntry.SetRange("Schedule No.", CommissionSchedule."No.");
            CommissionValueEntry.SetRange("Profile Code", CommissionProfile.Code);
            CommissionValueEntry.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            CommissionValueEntry.SetRange("Identifier Code", IdentifierCode);
            exit(not CommissionValueEntry.IsEmpty());
        end else begin
            CommissionJournalLine.Reset();
            CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
            CommissionJournalLine.SetRange("Profile Code", CommissionProfile.Code);
            CommissionJournalLine.SetRange("Profile Line Type", CommissionValueEntry."Profile Line Type"::"Loan Level");
            CommissionJournalLine.SetRange("Identifier Code", IdentifierCode);
            exit(not CommissionJournalLine.IsEmpty());
        end;
    end;

    local procedure GetCommissionColumns() GridColumns: JsonArray
    var
        Idx: Integer;
        CommissionNames: List of [Text];
    begin
        GridColumns.Add(GetColumn('loanNo', LoanNoLbl));
        GridColumns.Add(GetColumn('commDate', CommissionDateLbl));
        GridColumns.Add(GetColumn('originator', OriginatorLbl));
        GridColumns.Add(GetColumn('borrower', BorrowerNameLbl));
        GridColumns.Add(GetColumn('amount', LoanAmountLbl));
        GridColumns.Add(GetColumn('gross', GrossCommissionLbl));
        GridColumns.Add(GetColumn('bps', BpsLbl));
        CommissionNames := AdditionalCommissions.Values();
        for Idx := 1 to AdditionalCommissions.Count do
            GridColumns.Add(GetColumn('comm' + Format(Idx), CommissionNames.Get(Idx)));
        GridColumns.Add(GetColumn('net', NetCommissionLbl));
    end;

    local procedure GetOverrideColumns(): JsonArray
    begin
        ImplMgmt.ThrowNotImplementedError();
    end;

    local procedure GetAdjustmentColumns(): JsonArray
    begin
        ImplMgmt.ThrowNotImplementedError();
    end;

    local procedure GetCommissionData(): JsonArray
    begin
        if CommissionSchedule."Period Posted" then
            exit(GetPostedCommissionData())
        else
            exit(GetJournalCommissionData());
    end;

    local procedure GetOverrideData(): JsonArray
    begin
        ImplMgmt.ThrowNotImplementedError();
    end;

    local procedure GetAdjustmentData(): JsonArray
    begin
        ImplMgmt.ThrowNotImplementedError();
    end;

    local procedure GetLoanOriginator(var Loan: Record lvnLoan): Text
    var
        DimensionValue: Record "Dimension Value";
    begin
        case LoanOfficerDimensionNo of
            1:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Global Dimension 1 Code") then
                    exit(DimensionValue.Name);
            2:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Global Dimension 2 Code") then
                    exit(DimensionValue.Name);
            3:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 3 Code") then
                    exit(DimensionValue.Name);
            4:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 4 Code") then
                    exit(DimensionValue.Name);
            5:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 5 Code") then
                    exit(DimensionValue.Name);
            6:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 6 Code") then
                    exit(DimensionValue.Name);
            7:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 7 Code") then
                    exit(DimensionValue.Name);
            8:
                if DimensionValue.Get(LoanVisionSetup."Loan Officer Dimension Code", Loan."Shortcut Dimension 8 Code") then
                    exit(DimensionValue.Name);
        end;
    end;

    local procedure GetLoanCommissionJournalAmount(
        LoanNo: Code[20];
        IdentifierCode: Code[20];
        var CommissionAmount: Decimal;
        var Bps: Decimal)
    var
        CommissionJournalLoans: Query lvnCommissionJournalLoans;
    begin
        Clear(CommissionJournalLoans);
        CommissionJournalLoans.SetRange(ScheduleNo, CommissionSchedule."No.");
        CommissionJournalLoans.SetRange(ProfileCode, CommissionProfile.Code);
        CommissionJournalLoans.SetRange(IdentifierCode, IdentifierCode);
        CommissionJournalLoans.SetRange(LoanNo, LoanNo);
        CommissionJournalLoans.Open();
        if CommissionJournalLoans.Read() then begin
            CommissionAmount := CommissionJournalLoans.CommissionAmount;
            Bps := CommissionJournalLoans.Bps;
        end else begin
            CommissionAmount := 0;
            Bps := 0;
        end;
    end;

    local procedure GetJournalCommissionData() DataSource: JsonArray
    var
        Loan: Record lvnLoan;
        CommissionJournalLoans: Query lvnCommissionJournalLoans;
        RowData: JsonObject;
        GrossCommission: Decimal;
        NetCommission: Decimal;
        Bps: Decimal;
        Idx: Integer;
        AdditionalCommissionCodes: List of [Code[20]];
    begin
        AdditionalCommissionCodes := AdditionalCommissions.Keys();
        Clear(CommissionJournalLoans);
        CommissionJournalLoans.SetRange(ScheduleNo, CommissionSchedule."No.");
        CommissionJournalLoans.SetRange(ProfileCode, CommissionProfile.Code);
        CommissionJournalLoans.Open();
        while CommissionJournalLoans.Read() do begin
            Clear(RowData);
            Loan.Get(CommissionJournalLoans.LoanNo);
            RowData.Add('loanNo', Loan."No.");
            RowData.Add('commDate', Format(Loan."Commission Date"));
            RowData.Add('originator', GetLoanOriginator(Loan));
            RowData.Add('borrower', Loan."Borrower First Name" + ' ' + Loan."Borrower Last Name");
            RowData.Add('amount', CurrencyFormat.FormatValue(Loan."Loan Amount"));
            GetLoanCommissionJournalAmount(Loan."No.", CommissionSetup."Commission Identifier Code", GrossCommission, Bps);
            NetCommission := GrossCommission;
            RowData.Add('gross', CurrencyFormat.FormatValue(GrossCommission));
            RowData.Add('bps', BpsFormat.FormatValue(Bps));
            for Idx := 1 to AdditionalCommissions.Count do begin
                GetLoanCommissionJournalAmount(Loan."No.", AdditionalCommissionCodes.Get(Idx), GrossCommission, Bps);
                RowData.Add('comm' + Format(Idx), CurrencyFormat.FormatValue(GrossCommission));
                NetCommission += GrossCommission;
            end;
            RowData.Add('net', CurrencyFormat.FormatValue(NetCommission));
            DataSource.Add(RowData);
        end;
        CommissionJournalLoans.Close();
    end;

    local procedure GetPostedCommissionData(): JsonArray
    begin
    end;
}