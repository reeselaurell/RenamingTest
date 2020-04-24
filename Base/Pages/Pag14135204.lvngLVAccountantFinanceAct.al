page 14135204 lvngLVAccountantFinanceAct
{
    PageType = CardPart;
    Caption = 'Activities';
    SourceTable = "Finance Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Group)
            {
                ShowCaption = false;
                CuegroupLayout = Wide;

                field("Cash Accounts Balance"; "Cash Accounts Balance")
                {
                    Caption = 'Cash Account Balance';
                    ApplicationArea = All;
                    DrillDownPageID = "Chart of Accounts";
                    ToolTip = 'Specifies the sum of the accounts that have the cash account category.';

                    trigger OnDrillDown()
                    var
                        ActivitiesMgt: Codeunit "Activities Mgt.";
                    begin
                        ActivitiesMgt.DrillDownCalcCashAccountsBalances;
                    end;
                }
                field(LoanHeldForSaleBalance; CalculateLoansHeldForSale())
                {
                    Caption = 'Loans Held, for Sale Balance';
                    ApplicationArea = All;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        GLCategory: Record "G/L Account Category";
                        GLAccount: Record "G/L Account";
                    begin
                        GetActSetup();
                        if ActSetup."Loans Held, for Sale Accounts" <> '' then begin
                            GLAccount.Reset();
                            GLCategory.Get(ActSetup."Loans Held, for Sale Accounts");
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetFilter("No.", GLCategory.GetTotaling());
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                        end else
                            Error(ActivitiesSetupErr);
                    end;
                }
                field(PayablesBalance; CalculateAccountsPayable())
                {
                    Caption = 'Payables Balance';
                    ApplicationArea = All;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        GLCategory: Record "G/L Account Category";
                        GLAccount: Record "G/L Account";
                    begin
                        GetActSetup();
                        if ActSetup."Accounts Payable Accounts" <> '' then begin
                            GLAccount.Reset();
                            GLCategory.Get(ActSetup."Accounts Payable Accounts");
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetFilter("No.", GLCategory.GetTotaling());
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                        end else
                            Error(ActivitiesSetupErr);
                    end;
                }
                field(TtlFundedLastBusDay; CalculateFundedLastBusDay())
                {
                    Caption = 'Total Funded Last Business Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total loans funded amount from previous business day';
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvngLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter);
                        Page.Run(Page::lvngPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(TtlSoldLastBusDay; CalculateSoldLastBusDay())
                {
                    Caption = 'Total Sold Last Business Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total loans sold amount from previous business day';
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        SoldDoc: Record lvngLoanSoldDocument;
                    begin
                        SoldDoc.Reset();
                        SoldDoc.SetFilter("Document No.", SoldDocFilter);
                        Page.Run(Page::lvngPostedSoldDocuments, SoldDoc);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActivitiesSetup)
            {
                Caption = 'Activities Setup';
                ApplicationArea = All;
                Image = SetupList;
                RunObject = page lvngLVAccountantFinActSetup;
            }
        }
    }

    var
        ActivitiesSetupErr: Label 'Activities Setup does not exist';
        ActivitiesSetupMsg: Label 'Setup Balance fields in the Activities Setup page';
        ActSetup: Record lvngLVAccountantFinActSetup;
        CashAccountBal: Decimal;
        FundedDocFilter: Text;
        SoldDocFilter: Text;
        ActSetupRetrieved: Boolean;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
            Commit;
        end;
        ActSetupRetrieved := false;
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCashAcctBal();
    end;

    local procedure CalculateCashAcctBal()
    var
        ActivitiesMgt: Codeunit "Activities Mgt.";
    begin
        if FieldActive("Cash Accounts Balance") then
            "Cash Accounts Balance" := ActivitiesMgt.CalcCashAccountsBalances;
    end;

    local procedure CalculateFundedLastBusDay(): Decimal
    var
        FundedDoc: Record lvngLoanFundedDocument;
        FundedDocLine: Record lvngLoanFundedDocumentLine;
        Total: Decimal;
    begin
        FundedDocFilter := '';
        FundedDoc.SetFilter("Posting Date", '<>%1', CalcDate('0D'));
        FundedDoc.SetCurrentKey("Posting Date");
        FundedDoc.SetAscending("Posting Date", false);
        if FundedDoc.FindFirst() then begin
            FundedDoc.SetRange("Posting Date", FundedDoc."Posting Date");
            if FundedDoc.FindSet() then
                repeat
                    if FundedDocFilter = '' then
                        FundedDocFilter := FundedDoc."Document No."
                    else
                        FundedDocFilter := FundedDocFilter + '|' + FundedDoc."Document No.";
                    FundedDocLine.SetRange("Document No.", FundedDoc."Document No.");
                    if FundedDocLine.FindSet() then begin
                        FundedDocLine.CalcSums(Amount);
                        Total += FundedDocLine.Amount;
                    end;
                until FundedDoc.Next() = 0;
        end;
        exit(Total);
    end;

    local procedure CalculateSoldLastBusDay(): Decimal
    var
        SoldDoc: Record lvngLoanSoldDocument;
        SoldDocLine: Record lvngLoanSoldDocumentLine;
        Total: Decimal;
    begin
        SoldDocFilter := '';
        SoldDoc.SetFilter("Posting Date", '<>%1', CalcDate('0D'));
        SoldDoc.SetCurrentKey("Posting Date");
        SoldDoc.SetAscending("Posting Date", false);
        if SoldDoc.FindFirst() then begin
            SoldDoc.SetRange("Posting Date", SoldDoc."Posting Date");
            if SoldDoc.FindSet() then
                repeat
                    if SoldDocFilter = '' then
                        SoldDocFilter := SoldDoc."Document No."
                    else
                        SoldDocFilter := SoldDocFilter + '|' + SoldDoc."Document No.";
                    SoldDocLine.SetRange("Document No.", SoldDoc."Document No.");
                    if SoldDocLine.FindSet() then begin
                        SoldDocLine.CalcSums(Amount);
                        Total += SoldDocLine.Amount;
                    end;
                until SoldDoc.Next() = 0;
        end;
        exit(Total);
    end;

    local procedure CalculateLoansHeldForSale(): Decimal
    var
        GLCategory: Record "G/L Account Category";
    begin
        GetActSetup();
        if ActSetup."Loans Held, for Sale Accounts" <> '' then
            if GLCategory.Get(ActSetup."Loans Held, for Sale Accounts") then
                exit(GLCategory.GetBalance());
        exit(0);
    end;

    local procedure CalculateAccountsPayable(): Decimal
    var
        GLCategory: Record "G/L Account Category";
    begin
        GetActSetup();
        if ActSetup."Accounts Payable Accounts" <> '' then
            if GLCategory.Get(ActSetup."Accounts Payable Accounts") then
                exit(GLCategory.GetBalance());
        exit(0);
    end;

    local procedure GetActSetup()
    begin
        if not ActSetupRetrieved then
            if ActSetup.Get() then;
    end;
}