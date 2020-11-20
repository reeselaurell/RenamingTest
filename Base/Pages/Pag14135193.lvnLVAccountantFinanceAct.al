page 14135193 "lvnLVAccountantFinanceAct"
{
    PageType = CardPart;
    Caption = 'Financial Activities';
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

                field("Cash Accounts Balance"; Rec."Cash Accounts Balance")
                {
                    Caption = 'Cash Account Balance';
                    ApplicationArea = All;
                    DrillDownPageID = "Chart of Accounts";
                    ToolTip = 'Specifies the Sum of the Accounts that have the Cash Account Category.';

                    trigger OnDrillDown()
                    var
                        ActivitiesMgt: Codeunit "Activities Mgt.";
                    begin
                        ActivitiesMgt.DrillDownCalcCashAccountsBalances();
                    end;
                }
                field(LoanHeldForSaleBalance; CalculateLoansHeldForSale())
                {
                    Caption = 'Loans Held, for Sale Balance';
                    ApplicationArea = All;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Sum of the Accounts that have the Loans Held for Sale Account Category.';

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
                    ToolTip = 'Specifies the Sum of the Accounts that have the Payables Account Category.';

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
                    ToolTip = 'Specifies the Total Loans Funded Amount From Previous Business Day';
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter);
                        Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(TtlSoldLastBusDay; CalculateSoldLastBusDay())
                {
                    Caption = 'Total Sold Last Business Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Loans Sold Amount From Previous Business Day';
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;

                    trigger OnDrillDown()
                    var
                        SoldDoc: Record lvnLoanSoldDocument;
                    begin
                        SoldDoc.Reset();
                        SoldDoc.SetFilter("Document No.", SoldDocFilter);
                        Page.Run(Page::lvnPostedSoldDocuments, SoldDoc);
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
                RunObject = page lvnLVAccountantFinActSetup;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
            Commit();
        end;
        ActSetupRetrieved := false;
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCashAcctBal();
    end;

    var
        ActSetup: Record lvnLVAccountantFinActSetup;
        FundedDocFilter: Text;
        SoldDocFilter: Text;
        ActSetupRetrieved: Boolean;
        ActivitiesSetupErr: Label 'Activities Setup does not exist';

    local procedure CalculateCashAcctBal()
    var
        ActivitiesMgt: Codeunit "Activities Mgt.";
    begin
        if Rec.FieldActive("Cash Accounts Balance") then
            Rec."Cash Accounts Balance" := ActivitiesMgt.CalcCashAccountsBalances();
    end;

    local procedure CalculateFundedLastBusDay(): Decimal
    var
        FundedDoc: Record lvnLoanFundedDocument;
        FundedDocLine: Record lvnLoanFundedDocumentLine;
        Total: Decimal;
    begin
        FundedDocFilter := '';
        FundedDoc.SetFilter("Posting Date", '<>%1', CalcDate('<CD>'));
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
        SoldDoc: Record lvnLoanSoldDocument;
        SoldDocLine: Record lvnLoanSoldDocumentLine;
        Total: Decimal;
    begin
        SoldDocFilter := '';
        SoldDoc.SetFilter("Posting Date", '<>%1', CalcDate('<CD>'));
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