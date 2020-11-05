page 14135270 "lvnLoanManagerHeadline"
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    Caption = 'Loan Manager Headline';

    layout
    {
        area(Content)
        {
            group("Loan Manager Headline")
            {
                Editable = false;

                field(WelcomeMsg; LoanVisionLbl)
                {
                    ApplicationArea = All;
                }
                field(TtlFundedLastBusDay; FundedText)
                {
                    Caption = 'Total Funded Last Business Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total loans funded amount from previous business day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter);
                        Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(TtlSoldLastBusDay; SoldText)
                {
                    Caption = 'Total Sold Last Business Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total loans sold amount from previous business day';

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

    trigger OnOpenPage()
    begin
        CompanyInfo.CalcFields(Picture);
        FundedText := StrSubstNo('The Total Funded Amount for the Previous Business Day was %1', CalcTotalFundedAmountText());
        SoldText := StrSubstNo('The Total Sold Amount for the Previous Business Day was %1', CalcTotalSoldAmountText());
    end;

    var
        CompanyInfo: Record "Company Information";
        FundedText: Text;
        FundedDocFilter: Text;
        SoldText: Text;
        SoldDocFilter: Text;
        LoanVisionLbl: Label '<qualifier>Welcome</qualifier><payload>Welcome to Loan Vision</payload>';

    local procedure CalcTotalFundedAmountText(): Text
    var
        AmtText: Text;
    begin
        AmtText := Format(CalcTotalFundedAmount());
        if AmtText.Contains('-') then
            AmtText := AmtText.Replace('-', '-$')
        else
            AmtText := '$' + AmtText;
        exit(AmtText);
    end;

    local procedure CalcTotalSoldAmountText(): Text
    var
        AmtText: Text;
    begin
        AmtText := Format(CalcTotalSoldAmount());
        if AmtText.Contains('-') then
            AmtText := AmtText.Replace('-', '-$')
        else
            AmtText := '$' + AmtText;
        exit(AmtText);
    end;

    local procedure CalcTotalFundedAmount(): Decimal
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

    local procedure CalcTotalSoldAmount(): Decimal
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
}