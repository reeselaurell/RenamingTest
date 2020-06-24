page 14135268 lvngLVAccountantHeadline
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    Caption = 'LV Headline';

    layout
    {
        area(Content)
        {
            group("LV Accountant Headline")
            {
                Editable = false;

                field(WelcomeMsg; LoanVisionLbl) { ApplicationArea = All; }

                field(BranchProfit; BranchProfitText)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = BranchInfoVisible;

                    trigger OnDrillDown()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        GLAccount.Reset();
                        GLAccount.SetFilter("Date Filter", BranchDateFilter);
                        SetGLAccountDimFilter(GLAccount, LVSetup."Cost Center Dimension Code", GreatestBranchCode);
                        if GLAccount.FindSet() then
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                    end;
                }

                field(LOProfit; LOProfitText)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = LOInfoVisible;

                    trigger OnDrillDown()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        GLAccount.Reset();
                        GLAccount.SetFilter("Date Filter", LODateFilter);
                        SetGLAccountDimFilter(GLAccount, LVSetup."Loan Officer Dimension Code", GreatestLOCode);
                        if GLAccount.FindSet() then
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                    end;
                }
            }
        }
    }

    var
        LoanVisionLbl: Label '<qualifier>Welcome</qualifier><payload>Welcome to Loan Vision</payload>';
        YTDInsightLbl: Label 'Year to Date Insight';
        QTDInsightLbl: Label 'Quarter to Date Insight';
        MTDInsightLbl: Label 'Month to Date Insight';
        WTDInsightLbl: Label 'Week to Date Insight';
        LVSetup: Record lvngLoanVisionSetup;
        HeadlineSetup: Record lvngLVAcctRCHeadlineSetup;
        BranchProfitText: Text;
        LOProfitText: Text;
        BranchInfoVisible: Boolean;
        LOInfoVisible: Boolean;
        GreatestBranchProfit: Decimal;
        GreatestBranchName: Text[50];
        GreatestBranchCode: Code[20];
        GreatestLOProfit: Decimal;
        GreatestLOName: Text[50];
        GreatestLOCode: Code[20];
        LODateFilter: Text;
        BranchDateFilter: Text;

    trigger OnOpenPage()
    begin
        HeadlineSetup.Get();
        LVSetup.Get();
        SetDateFilters();
        GetTopPerformingLO();
        GetTopPerformingBranch();
        BranchProfitText := StrSubstNo('<qualifier>%1 </qualifier><payload>%2 was the top performing Branch with <emphasize>$%3</emphasize> in profit</payload>', GetBranchInsightText(), GreatestBranchName, GreatestBranchProfit);
        LOProfitText := StrSubstNo('<qualifier>%1</qualifier><payload>%2 was the top performing LO with <emphasize>$%3</emphasize> in profit</payload>', GetLOInsightText(), GreatestLOName, GreatestLOProfit);
    end;

    local procedure GetTopPerformingBranch()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        First: Boolean;
    begin
        First := true;
        if LVSetup.Get() then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
            if DimensionValue.FindSet() then
                repeat
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", BranchDateFilter);
                    SetGLAccountDimFilter(GLAccount, LVSetup."Cost Center Dimension Code", DimensionValue.Code);
                    GLAccount.SetRange("No.", HeadlineSetup."Net Income G/L Account No.");
                    if GLAccount.FindSet() then begin
                        BranchInfoVisible := true;
                        GLAccount.CalcFields("Net Change");
                        if First then begin
                            GreatestBranchProfit := GLAccount."Net Change";
                            GreatestBranchName := DimensionValue.Name;
                            GreatestBranchCode := DimensionValue.Code;
                            First := false;
                        end else
                            if GLAccount."Net Change" > GreatestBranchProfit then begin
                                GreatestBranchProfit := GLAccount."Net Change";
                                GreatestBranchName := DimensionValue.Name;
                                GreatestBranchCode := DimensionValue.Code;
                            end;
                    end;
                until DimensionValue.Next() = 0;
        end;
    end;

    local procedure GetTopPerformingLO()
    var
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        First: Boolean;
    begin
        First := true;
        if LVSetup.Get() then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
            if DimensionValue.FindSet() then
                repeat
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", LODateFilter);
                    SetGLAccountDimFilter(GLAccount, LVSetup."Loan Officer Dimension Code", DimensionValue.Code);
                    GLAccount.SetRange("No.", HeadlineSetup."Net Income G/L Account No.");
                    if GLAccount.FindSet() then begin
                        LOInfoVisible := true;
                        GLAccount.CalcFields("Net Change");
                        if First then begin
                            GreatestLOProfit := GLAccount."Net Change";
                            GreatestLOName := DimensionValue.Name;
                            GreatestLOCode := DimensionValue.Code;
                            First := false;
                        end else
                            if GLAccount."Net Change" > GreatestLOProfit then begin
                                GreatestLOProfit := GLAccount."Net Change";
                                GreatestLOName := DimensionValue.Name;
                                GreatestLOCode := DimensionValue.Code;
                            end;
                    end;
                until DimensionValue.Next() = 0;
        end;
    end;

    local procedure SetGLAccountDimFilter(var GLAccount: Record "G/L Account"; DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimensionMgmt: Codeunit lvngDimensionsManagement;
        DimNo: Integer;
    begin
        DimNo := DimensionMgmt.GetDimensionNo(DimCode);
        case DimNo of
            1:
                GLAccount.SetFilter("Global Dimension 1 Filter", DimValueCode);
            2:
                GLAccount.SetFilter("Global Dimension 2 Filter", DimValueCode);
        end;
    end;

    local procedure GetBranchInsightText(): Text
    begin
        case HeadlineSetup."Branch Performace Date Range" of
            HeadlineSetup."Branch Performace Date Range"::"Year to Date":
                exit(YTDInsightLbl);
            HeadlineSetup."Branch Performace Date Range"::"Quarter to Date":
                exit(QTDInsightLbl);
            HeadlineSetup."Branch Performace Date Range"::"Month to Date":
                exit(MTDInsightLbl);
            HeadlineSetup."Branch Performace Date Range"::"Week to Date":
                exit(WTDInsightLbl);
        end;
    end;

    local procedure GetLOInsightText(): Text
    begin
        case HeadlineSetup."LO Performace Date Range" of
            HeadlineSetup."LO Performace Date Range"::"Year to Date":
                exit(YTDInsightLbl);
            HeadlineSetup."LO Performace Date Range"::"Quarter to Date":
                exit(QTDInsightLbl);
            HeadlineSetup."LO Performace Date Range"::"Month to Date":
                exit(MTDInsightLbl);
            HeadlineSetup."LO Performace Date Range"::"Week to Date":
                exit(WTDInsightLbl);
        end;
    end;

    local procedure SetDateFilters()
    begin
        case HeadlineSetup."Branch Performace Date Range" of
            HeadlineSetup."Branch Performace Date Range"::"Year to Date":
                BranchDateFilter := '-CY..t';
            HeadlineSetup."Branch Performace Date Range"::"Quarter to Date":
                BranchDateFilter := '-CQ..t';
            HeadlineSetup."Branch Performace Date Range"::"Month to Date":
                BranchDateFilter := '-CM..t';
            HeadlineSetup."Branch Performace Date Range"::"Week to Date":
                BranchDateFilter := '-CW..t';
        end;
        case HeadlineSetup."LO Performace Date Range" of
            HeadlineSetup."LO Performace Date Range"::"Year to Date":
                LODateFilter := '-CY..t';
            HeadlineSetup."LO Performace Date Range"::"Quarter to Date":
                LODateFilter := '-CQ..t';
            HeadlineSetup."LO Performace Date Range"::"Month to Date":
                LODateFilter := '-CM..t';
            HeadlineSetup."LO Performace Date Range"::"Week to Date":
                LODateFilter := '-CW..t';
        end;
    end;
}