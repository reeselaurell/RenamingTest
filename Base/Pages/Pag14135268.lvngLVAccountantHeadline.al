page 14135268 lvngLVAccountantHeadline
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    Caption = 'LV Headline';
    SourceTable = lvngLVAcctRCHeadline;

    layout
    {
        area(Content)
        {
            field(LoanVisionLbl; LoanVisionLbl) { Caption = 'Welcome'; ApplicationArea = All; }
            field(TopBranch; BranchProfitText)
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    GLAccount: Record "G/L Account";
                begin
                    Rec.Reset();
                    Rec.SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
                    Rec.SetCurrentKey("Net Change");
                    Rec.Ascending(false);
                    Rec.FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", Rec.GetDateFilter(Rec."Dimension Code"));
                    Rec.SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", Rec.Code);
                    if GLAccount.FindSet() then
                        Page.Run(Page::"Chart of Accounts", GLAccount);
                end;
            }
            field(TopLO; LOProfitText)
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    GLAccount: Record "G/L Account";
                begin
                    Rec.Reset();
                    Rec.SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
                    Rec.SetCurrentKey("Net Change");
                    Rec.Ascending(false);
                    Rec.FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", Rec.GetDateFilter(Rec."Dimension Code"));
                    Rec.SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", Rec.Code);
                    if GLAccount.FindSet() then
                        Page.Run(Page::"Chart of Accounts", GLAccount);
                end;
            }
            field(BottomBranch; LowBranchProfitText)
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    GLAccount: Record "G/L Account";
                begin
                    Rec.Reset();
                    Rec.SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
                    Rec.SetCurrentKey("Net Change");
                    Rec.Ascending(true);
                    Rec.FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", Rec.GetDateFilter(Rec."Dimension Code"));
                    Rec.SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", Rec.Code);
                    if GLAccount.FindSet() then
                        Page.Run(Page::"Chart of Accounts", GLAccount);
                end;
            }
            field(BottomLO; LowLOProfitText)
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    GLAccount: Record "G/L Account";
                begin
                    Rec.Reset();
                    Rec.SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
                    Rec.SetCurrentKey("Net Change");
                    Rec.Ascending(true);
                    Rec.FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", Rec.GetDateFilter(Rec."Dimension Code"));
                    Rec.SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", Rec.Code);
                    if GLAccount.FindSet() then
                        Page.Run(Page::"Chart of Accounts", GLAccount);
                end;
            }
        }
    }

    var
        LoanVisionLbl: Label '<qualifier>Welcome</qualifier><payload>Welcome to Loan Vision</payload>';
        LVSetup: Record lvngLoanVisionSetup;
        HeadlineSetup: Record lvngLVAcctRCHeadlineSetup;
        BranchProfitText: Text;
        LOProfitText: Text;
        LowBranchProfitText: Text;
        LowLOProfitText: Text;

    trigger OnOpenPage()
    begin
        HeadlineSetup.Get();
        LVSetup.Get();
        Rec.FillDimensions();
        Rec.SetNetChange();
        BranchProfitText := GetText(LVSetup."Cost Center Dimension Code", false);
        LOProfitText := GetText(LVSetup."Loan Officer Dimension Code", false);
        LowBranchProfitText := GetText(LVSetup."Cost Center Dimension Code", true);
        LowLOProfitText := GetText(LVSetup."Loan Officer Dimension Code", true);
    end;

    local procedure GetText(DimensionCode: Code[20]; isAscending: Boolean): Text
    var
        DimensionType: Text;
        PerformanceTxt: Text;
        InsightTxt: Text;
    begin
        Rec.Reset();
        Rec.SetRange("Dimension Code", DimensionCode);
        Rec.SetCurrentKey("Net Change");
        Rec.Ascending(isAscending);
        Rec.FindFirst();
        if not isAscending then
            PerformanceTxt := 'top'
        else
            PerformanceTxt := 'worst';
        if DimensionCode = LVSetup."Cost Center Dimension Code" then begin
            DimensionType := 'Branch';
            InsightTxt := Rec.GetBranchInsightText();
        end else begin
            DimensionType := 'LO';
            InsightTxt := Rec.GetLOInsightText();
        end;
        exit(StrSubstNo('<qualifier>%1</qualifier><payload>%2 was the %3 performing %4 with <emphasize>%5</emphasize> in profit</payload>', InsightTxt, Rec.Name, PerformanceTxt, DimensionType, GetNetChangeText(Rec."Net Change")));
    end;

    local procedure GetNetChangeText(NetChange: Decimal): Text
    begin
        if NetChange < 0 then begin
            NetChange := NetChange * -1;
            exit('-$' + Format(NetChange));
        end else
            exit('$' + Format(NetChange));
    end;
}