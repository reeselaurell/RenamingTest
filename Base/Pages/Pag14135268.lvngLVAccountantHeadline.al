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

                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", GreatestBranchCode);
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
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", GreatestLOCode);
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
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Cost Center Dimension Code", BottomBranchCode);
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
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", GetDateFilter("Dimension Code"));
                    SetGLAccountFilters(GLAccount, LVSetup."Loan Officer Dimension Code", BottomLOCode);
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
        GreatestBranchCode: Code[20];
        BottomBranchCode: Code[20];
        GreatestLOCode: Code[20];
        BottomLOCode: Code[20];

    trigger OnOpenPage()
    var
        GreatestBranchProfit: Decimal;
        GreatestBranchName: Text[50];
        BottomBranchName: Text[50];
        BottomBranchProfit: Decimal;
        GreatestLOProfit: Decimal;
        GreatestLOName: Text[50];
        BottomLOProfit: Decimal;
        BottomLOName: Text[50];
    begin
        HeadlineSetup.Get();
        LVSetup.Get();
        FillDimensions();
        SetNetChange();
        Reset();
        SetRange("Dimension Code", LVSetup."Loan Officer Dimension Code");
        SetCurrentKey("Net Change");
        Ascending(false);
        FindFirst();
        GreatestLOName := Name;
        GreatestLOProfit := "Net Change";
        GreatestLOCode := Code;
        FindLast();
        BottomLOName := Name;
        BottomLOProfit := "Net Change";
        BottomLOCode := Code;
        Reset();
        SetRange("Dimension Code", LVSetup."Cost Center Dimension Code");
        SetCurrentKey("Net Change");
        Ascending(false);
        FindFirst();
        GreatestBranchName := Name;
        GreatestBranchProfit := "Net Change";
        GreatestBranchCode := Code;
        FindLast();
        BottomBranchName := Name;
        BottomBranchProfit := "Net Change";
        BottomBranchCode := Code;
        BranchProfitText := StrSubstNo('<qualifier>%1 </qualifier><payload>%2 was the top performing Branch with <emphasize>$%3</emphasize> in profit</payload>', GetBranchInsightText(), GreatestBranchName, GreatestBranchProfit);
        LOProfitText := StrSubstNo('<qualifier>%1</qualifier><payload>%2 was the top performing LO with <emphasize>$%3</emphasize> in profit</payload>', GetLOInsightText(), GreatestLOName, GreatestLOProfit);
        LowBranchProfitText := StrSubstNo('<qualifier>%1 </qualifier><payload>%2 was the worst performing Branch with <emphasize>$%3</emphasize> in profit</payload>', GetBranchInsightText(), BottomBranchName, BottomBranchProfit);
        LowLOProfitText := StrSubstNo('<qualifier>%1</qualifier><payload>%2 was the worst performing LO with <emphasize>$%3</emphasize> in profit</payload>', GetLOInsightText(), BottomLOName, BottomLOProfit);
    end;
}