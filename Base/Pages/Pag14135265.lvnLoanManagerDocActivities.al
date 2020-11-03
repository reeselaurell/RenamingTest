page 14135265 "lvnLoanManagerDocActivities"
{
    PageType = CardPart;
    Caption = 'Loan Document Activities';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Totals)
            {
                CuegroupLayout = Wide;

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
                field(FundedClearingBalance; GetFundedClearingBalance())
                {
                    Caption = 'Funded Clearing Balance';
                    ApplicationArea = All;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Total Funded Clearing Account Balance';

                    trigger OnDrillDown()
                    var
                        GLCategory: Record "G/L Account Category";
                        GLAccount: Record "G/L Account";
                    begin
                        GetActSetup();
                        if ActSetup."Funded Clearing Bal. Account" <> '' then begin
                            GLAccount.Reset();
                            GLCategory.Get(ActSetup."Funded Clearing Bal. Account");
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetFilter("No.", GLCategory.GetTotaling());
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                        end;
                    end;
                }
                field(SoldClearingBalance; GetSoldClearingBalance())
                {
                    Caption = 'Sold Clearing Balance';
                    ApplicationArea = All;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Total Sold Clearing Account Balance';

                    trigger OnDrillDown()
                    var
                        GLCategory: Record "G/L Account Category";
                        GLAccount: Record "G/L Account";
                    begin
                        GetActSetup();
                        if ActSetup."Sold Clearing Bal. Account" <> '' then begin
                            GLAccount.Reset();
                            GLCategory.Get(ActSetup."Sold Clearing Bal. Account");
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetFilter("No.", GLCategory.GetTotaling());
                            Page.Run(Page::"Chart of Accounts", GLAccount);
                        end;
                    end;
                }
            }

            cuegroup(Group)
            {
                Caption = 'Unproccessed Loan Fundings';

                field(UnproccessedFunding1; UnprocessedFundingCount(1))
                {
                    Caption = 'Unprocessed Loan Fundings';
                    CaptionClass = FundedCaption[1];
                    ApplicationArea = All;
                    Visible = FundedVisible1;
                    ToolTip = 'Unprocessed Loan Funding Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 1";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnproccessedFunding2; UnprocessedFundingCount(2))
                {
                    Caption = 'Unprocessed Loan Fundings';
                    CaptionClass = FundedCaption[2];
                    ApplicationArea = All;
                    Visible = FundedVisible2;
                    ToolTip = 'Unprocessed Loan Funding Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 2";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnproccessedFunding3; UnprocessedFundingCount(3))
                {
                    Caption = 'Unprocessed Loan Fundings';
                    CaptionClass = FundedCaption[3];
                    ApplicationArea = All;
                    Visible = FundedVisible3;
                    ToolTip = 'Unprocessed Loan Funding Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 3";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnproccessedFunding4; UnprocessedFundingCount(4))
                {
                    Caption = 'Unprocessed Loan Fundings';
                    CaptionClass = FundedCaption[4];
                    ApplicationArea = All;
                    Visible = FundedVisible4;
                    ToolTip = 'Unprocessed Loan Funding Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 4";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnproccessedFunding5; UnprocessedFundingCount(5))
                {
                    Caption = 'Unprocessed Loan Fundings';
                    CaptionClass = FundedCaption[5];
                    ApplicationArea = All;
                    Visible = FundedVisible5;
                    ToolTip = 'Unprocessed Loan Funding Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 5";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
            }

            cuegroup(Sold)
            {
                Caption = 'Unproccessed Loan Sales';

                field(UnprocessedSold1; UnprocessedSoldCount(1))
                {
                    Caption = 'Unprocessed Loan Sales';
                    CaptionClass = SoldCaption[1];
                    ApplicationArea = All;
                    Visible = SoldVisible1;
                    ToolTip = 'Unprocessed Loan Sold Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 1";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnprocessedSold2; UnprocessedSoldCount(2))
                {
                    Caption = 'Unprocessed Loan Sales';
                    CaptionClass = SoldCaption[2];
                    ApplicationArea = All;
                    Visible = SoldVisible2;
                    ToolTip = 'Unprocessed Loan Sold Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 2";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnprocessedSold3; UnprocessedSoldCount(3))
                {
                    Caption = 'Unprocessed Loan Sales';
                    CaptionClass = SoldCaption[3];
                    ApplicationArea = All;
                    Visible = SoldVisible3;
                    ToolTip = 'Unprocessed Loan Sold Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 3";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnprocessedSold4; UnprocessedSoldCount(4))
                {
                    Caption = 'Unprocessed Loan Sales';
                    CaptionClass = SoldCaption[4];
                    ApplicationArea = All;
                    Visible = SoldVisible4;
                    ToolTip = 'Unprocessed Loan Sold Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 4";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
                field(UnprocessedSold5; UnprocessedSoldCount(5))
                {
                    Caption = 'Unprocessed Loan Sales';
                    CaptionClass = SoldCaption[5];
                    ApplicationArea = All;
                    Visible = SoldVisible5;
                    ToolTip = 'Unprocessed Loan Sold Journal Information';

                    trigger OnDrillDown()
                    var
                        LoanJnlLine: Record lvnLoanJournalLine;
                        LoanJnlBatchCode: Code[10];
                    begin
                        LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 5";
                        LoanJnlLine.Reset();
                        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
                        if LoanJnlLine.FindSet() then
                            Page.Run(Page::lvnLoanJournalLines, LoanJnlLine);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Setup)
            {
                Caption = 'Activity Setup';
                ApplicationArea = All;
                RunObject = page lvnLoanManagerDocActSetup;
            }
        }
    }

    var
        ActSetup: Record lvnLoanManagerDocActSetup;
        ActSetupRetrieved: Boolean;
        FundedDocFilter: Text[250];
        SoldDocFilter: Text[250];
        FundedCaption: array[5] of Text[250];
        SoldCaption: array[5] of Text[250];
        FundedVisible1: Boolean;
        FundedVisible2: Boolean;
        FundedVisible3: Boolean;
        FundedVisible4: Boolean;
        FundedVisible5: Boolean;
        SoldVisible1: Boolean;
        SoldVisible2: Boolean;
        SoldVisible3: Boolean;
        SoldVisible4: Boolean;
        SoldVisible5: Boolean;

    trigger OnOpenPage()
    begin
        ActSetupRetrieved := false;
        CheckVisibility();
        CalculateFundedLastBusDay();
    end;

    local procedure CheckVisibility()
    begin
        GetActSetup();
        if ActSetup."Unprocessed Funding Jnl 1" <> '' then begin
            FundedVisible1 := true;
            FundedCaption[1] := ActSetup."Unprocessed Funding Jnl 1";
        end;
        if ActSetup."Unprocessed Funding Jnl 2" <> '' then begin
            FundedVisible2 := true;
            FundedCaption[2] := ActSetup."Unprocessed Funding Jnl 2";
        end;
        if ActSetup."Unprocessed Funding Jnl 3" <> '' then begin
            FundedVisible3 := true;
            FundedCaption[3] := ActSetup."Unprocessed Funding Jnl 3";
        end;
        if ActSetup."Unprocessed Funding Jnl 4" <> '' then begin
            FundedVisible4 := true;
            FundedCaption[4] := ActSetup."Unprocessed Funding Jnl 4";
        end;
        if ActSetup."Unprocessed Funding Jnl 5" <> '' then begin
            FundedVisible5 := true;
            FundedCaption[5] := ActSetup."Unprocessed Funding Jnl 5";
        end;
        if ActSetup."Unprocessed Sold Jnl 1" <> '' then begin
            SoldVisible1 := true;
            SoldCaption[1] := ActSetup."Unprocessed Sold Jnl 1";
        end;
        if ActSetup."Unprocessed Sold Jnl 2" <> '' then begin
            SoldVisible2 := true;
            SoldCaption[2] := ActSetup."Unprocessed Sold Jnl 2";
        end;
        if ActSetup."Unprocessed Sold Jnl 3" <> '' then begin
            SoldVisible3 := true;
            SoldCaption[3] := ActSetup."Unprocessed Sold Jnl 3";
        end;
        if ActSetup."Unprocessed Sold Jnl 4" <> '' then begin
            SoldVisible4 := true;
            SoldCaption[4] := ActSetup."Unprocessed Sold Jnl 4";
        end;
        if ActSetup."Unprocessed Sold Jnl 5" <> '' then begin
            SoldVisible5 := true;
            SoldCaption[5] := ActSetup."Unprocessed Sold Jnl 5";
        end;
    end;

    local procedure GetActSetup()
    begin
        if not ActSetupRetrieved then
            if ActSetup.Get() then
                ActSetupRetrieved := true;
    end;

    local procedure CalculateFundedLastBusDay(): Decimal
    var
        FundedDoc: Record lvnLoanFundedDocument;
        FundedDocLine: Record lvnLoanFundedDocumentLine;
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
        SoldDoc: Record lvnLoanSoldDocument;
        SoldDocLine: Record lvnLoanSoldDocumentLine;
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

    local procedure GetFundedClearingBalance(): Decimal
    var
        GLCategory: Record "G/L Account Category";
    begin
        GetActSetup();
        if ActSetup."Funded Clearing Bal. Account" <> '' then
            if GLCategory.Get(ActSetup."Funded Clearing Bal. Account") then
                exit(GLCategory.GetBalance());
        exit(0);
    end;

    local procedure GetSoldClearingBalance(): Decimal
    var
        GLCategory: Record "G/L Account Category";
    begin
        GetActSetup();
        if ActSetup."Sold Clearing Bal. Account" <> '' then
            if GLCategory.Get(ActSetup."Sold Clearing Bal. Account") then
                exit(GLCategory.GetBalance());
        exit(0);
    end;

    local procedure UnprocessedFundingCount(JnlNo: Integer): Integer
    var
        LoanJnlLine: Record lvnLoanJournalLine;
        LoanJnlBatchCode: Code[10];
    begin
        GetActSetup();
        case JnlNo of
            1:
                LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 1";
            2:
                LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 2";
            3:
                LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 3";
            4:
                LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 4";
            5:
                LoanJnlBatchCode := ActSetup."Unprocessed Funding Jnl 5";
        end;
        LoanJnlLine.Reset();
        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
        exit(LoanJnlLine.Count());
    end;

    local procedure UnprocessedSoldCount(JnlNo: Integer): Integer
    var
        LoanJnlLine: Record lvnLoanJournalLine;
        LoanJnlBatchCode: Code[10];
    begin
        GetActSetup();
        case JnlNo of
            1:
                LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 1";
            2:
                LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 2";
            3:
                LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 3";
            4:
                LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 4";
            5:
                LoanJnlBatchCode := ActSetup."Unprocessed Sold Jnl 5";
        end;
        LoanJnlLine.Reset();
        LoanJnlLine.SetRange("Loan Journal Batch Code", LoanJnlBatchCode);
        exit(LoanJnlLine.Count());
    end;
}