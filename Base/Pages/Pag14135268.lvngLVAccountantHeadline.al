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
                    Reset();
                    SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
                    SetCurrentKey("Net Change");
                    Ascending(false);
                    FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", Code);
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
                    Reset();
                    SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
                    SetCurrentKey("Net Change");
                    Ascending(false);
                    FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", Code);
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
                    Reset();
                    SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
                    SetCurrentKey("Net Change");
                    Ascending(true);
                    FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", Code);
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
                    Reset();
                    SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
                    SetCurrentKey("Net Change");
                    Ascending(true);
                    FindFirst();
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", Code);
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
        FillDimensions();
        SetNetChange();
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
        Reset();
        SetRange("Dimension Code", DimensionCode);
        SetCurrentKey("Net Change");
        Ascending(isAscending);
        FindFirst();
        if not isAscending then
            PerformanceTxt := 'top'
        else
            PerformanceTxt := 'worst';
        if DimensionCode = LVSetup."Cost Center Dimension Code" then begin
            DimensionType := 'Branch';
            InsightTxt := GetBranchInsightText();
        end else begin
            DimensionType := 'LO';
            InsightTxt := GetLOInsightText();
        end;
        exit(StrSubstNo('<qualifier>%1</qualifier><payload>%2 was the %3 performing %4 with <emphasize>$%5</emphasize> in profit</payload>', InsightTxt, Name, PerformanceTxt, DimensionType, "Net Change"));
    end;
}