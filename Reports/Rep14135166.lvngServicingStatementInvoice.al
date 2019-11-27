report 14135166 lvngServicingStatementInvoice
{
    Caption = 'Servicing Statement/Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135166.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");

            dataitem(Customer; Customer)
            {
                DataItemTableView = sorting("No.");
                DataItemLink = "No." = field("Sell-to Customer No.");

                column(Logo; MortgageStatementSetup."Statement Logo") { }
                column(AccountNumber; "No.") { }
                column(StatementDate; AsOfDate) { }
                column(PropertyAddress1; PropertyAddress[1]) { }
                column(PropertyAddress2; PropertyAddress[2]) { }
                column(PropertyAddress3; PropertyAddress[3]) { }
                column(PropertyAddress4; PropertyAddress[4]) { }
                column(PaymentDueDate; PaymentDueDate) { }
                column(CurrentInvoiceAmountDue; CurrentInvoiceAmountDue) { }
                column(LatePaymentVerbiage; LatePaymentVerbiage) { }
                column(ServicingPhoneNo; MortgageStatementSetup."Serv. Department Phone No.") { }
                column(ServicingName; MortgageStatementSetup."Name On Statement Report") { }
                column(CustomerAddress1; CustAddr[1]) { }
                column(CustomerAddress2; CustAddr[2]) { }
                column(CustomerAddress3; CustAddr[3]) { }
                column(CustomerAddress4; CustAddr[4]) { }
                column(AmountDuePrincipal; AmountDuePrincipal) { }
                column(AmountDueInterest; AmountDueInterest) { }
                column(AmountDueEscrow; AmountDueEscrow) { }
                column(RegularMonthlyPayment; RegularMonthlyPayment) { }
                column(TotalFeesCharged; TotalFeesCharged) { }
                column(OverduePayment; OverduePayment) { }
                column(TotalAmountDue; TotalAmountDue) { }
                column(OutstandingPrincipalBalance; OutstandingPrincipalBalance) { }
                column(CurrentEscrowAccountBalance; CurrentEscrowAccountBalance) { }
                column(MaturityDate; MaturityDate) { }
                column(InterestRate; InterestRate) { }
                column(CompanyAddress1; CompanyAddr[1]) { }
                column(CompanyAddress2; CompanyAddr[2]) { }
                column(CompanyAddress3; CompanyAddr[3]) { }
                column(CompanyAddress4; CompanyAddr[4]) { }
                column(HeaderAddress; HeaderAddress) { }
                column(ActivityForVerbiage; ActivityForVerbiage) { }
                column(ActivityDate1; ActivityDates[1]) { }
                column(ActivityDate2; ActivityDates[2]) { }
                column(ActivityDate3; ActivityDates[3]) { }
                column(ActivityDate4; ActivityDates[4]) { }
                column(ActivityDate5; ActivityDates[5]) { }
                column(ActivityDate6; ActivityDates[6]) { }
                column(ActivityDate7; ActivityDates[7]) { }
                column(ActivityDate8; ActivityDates[8]) { }
                column(ActivityDate9; ActivityDates[9]) { }
                column(ActivityDate10; ActivityDates[10]) { }
                column(ActivityDescription1; ActivityDescriptions[1]) { }
                column(ActivityDescription2; ActivityDescriptions[2]) { }
                column(ActivityDescription3; ActivityDescriptions[3]) { }
                column(ActivityDescription4; ActivityDescriptions[4]) { }
                column(ActivityDescription5; ActivityDescriptions[5]) { }
                column(ActivityDescription6; ActivityDescriptions[6]) { }
                column(ActivityDescription7; ActivityDescriptions[7]) { }
                column(ActivityDescription8; ActivityDescriptions[8]) { }
                column(ActivityDescription9; ActivityDescriptions[9]) { }
                column(ActivityDescription10; ActivityDescriptions[10]) { }
                column(ActivityAmount1; ActivityAmounts[1]) { }
                column(ActivityAmount2; ActivityAmounts[2]) { }
                column(ActivityAmount3; ActivityAmounts[3]) { }
                column(ActivityAmount4; ActivityAmounts[4]) { }
                column(ActivityAmount5; ActivityAmounts[5]) { }
                column(ActivityAmount6; ActivityAmounts[6]) { }
                column(ActivityAmount7; ActivityAmounts[7]) { }
                column(ActivityAmount8; ActivityAmounts[8]) { }
                column(ActivityAmount9; ActivityAmounts[9]) { }
                column(ActivityAmount10; ActivityAmounts[10]) { }
                column(ActivityOther1; ActivityOther[1]) { }
                column(ActivityOther2; ActivityOther[2]) { }
                column(ActivityOther3; ActivityOther[3]) { }
                column(ActivityOther4; ActivityOther[4]) { }
                column(ActivityOther5; ActivityOther[5]) { }
                column(ActivityOther6; ActivityOther[6]) { }
                column(ActivityOther7; ActivityOther[7]) { }
                column(ActivityOther8; ActivityOther[8]) { }
                column(ActivityOther9; ActivityOther[9]) { }
                column(ActivityOther10; ActivityOther[10]) { }
                column(ActivityEscrow1; ActivityEscrow[1]) { }
                column(ActivityEscrow2; ActivityEscrow[2]) { }
                column(ActivityEscrow3; ActivityEscrow[3]) { }
                column(ActivityEscrow4; ActivityEscrow[4]) { }
                column(ActivityEscrow5; ActivityEscrow[5]) { }
                column(ActivityEscrow6; ActivityEscrow[6]) { }
                column(ActivityEscrow7; ActivityEscrow[7]) { }
                column(ActivityEscrow8; ActivityEscrow[8]) { }
                column(ActivityEscrow9; ActivityEscrow[9]) { }
                column(ActivityEscrow10; ActivityEscrow[10]) { }
                column(ActivityPrincipal1; ActivityPrincipal[1]) { }
                column(ActivityPrincipal2; ActivityPrincipal[2]) { }
                column(ActivityPrincipal3; ActivityPrincipal[3]) { }
                column(ActivityPrincipal4; ActivityPrincipal[4]) { }
                column(ActivityPrincipal5; ActivityPrincipal[5]) { }
                column(ActivityPrincipal6; ActivityPrincipal[6]) { }
                column(ActivityPrincipal7; ActivityPrincipal[7]) { }
                column(ActivityPrincipal8; ActivityPrincipal[8]) { }
                column(ActivityPrincipal9; ActivityPrincipal[9]) { }
                column(ActivityPrincipal10; ActivityPrincipal[10]) { }
                column(ActivityInterest1; ActivityInterest[1]) { }
                column(ActivityInterest2; ActivityInterest[2]) { }
                column(ActivityInterest3; ActivityInterest[3]) { }
                column(ActivityInterest4; ActivityInterest[4]) { }
                column(ActivityInterest5; ActivityInterest[5]) { }
                column(ActivityInterest6; ActivityInterest[6]) { }
                column(ActivityInterest7; ActivityInterest[7]) { }
                column(ActivityInterest8; ActivityInterest[8]) { }
                column(ActivityInterest9; ActivityInterest[9]) { }
                column(ActivityInterest10; ActivityInterest[10]) { }
                column(PaidYTD1; PaidYTD[1]) { }
                column(PaidYTD2; PaidYTD[2]) { }
                column(PaidYTD3; PaidYTD[3]) { }
                column(PaidYTD4; PaidYTD[4]) { }
                column(PaidYTD5; PaidYTD[5]) { }
                column(PaidYTD6; PaidYTD[6]) { }
                column(DueByVerbiage; DueByVerbiage) { }
                column(ServPhoneNo; MortgageStatementSetup."Serv. Department Phone No.") { }
                column(ServFaxNo; MortgageStatementSetup."Serv. Department Fax No.") { }
                column(ServWorkingDays; MortgageStatementSetup."Serv. Department Working Days") { }
                column(ServWorkingHours; MortgageStatementSetup."Serv. Department Working Hours") { }
                column(ServEmail; MortgageStatementSetup."Serv. Department E-Mail") { }
                column(Website; MortgageStatementSetup."Company Website") { }
                column(ServAddressFull; ServAddressFull) { }
                column(CollectionPhoneNo; MortgageStatementSetup."Collection Dep. Phone No.") { }
                column(CollectionWorkingDays; MortgageStatementSetup."Collection Dep. Working Days") { }
                column(CollectionWorkingHours; MortgageStatementSetup."Collection Dep. Working Hours") { }
                column(CollectionFaxNo; MortgageStatementSetup."Collection Dep.Fax No.") { }
                column(CompanyNameOnStatement; MortgageStatementSetup."Name On Statement Report") { }

                trigger OnPreDataItem()
                begin
                    Customer.SetRange("Date Filter", 0D, SalesInvHeader."Posting Date" - 1);
                end;

                trigger OnAfterGetRecord()
                var
                    BorrowerName: Text;
                begin
                    Customer.CalcFields("Balance on Date");
                    OverduePayment := Customer."Balance on Date";
                    CurrentInvoiceAmountDue := 0;
                    AmountDueInterest := 0;
                    AmountDuePrincipal := 0;
                    AmountDueEscrow := 0;
                    RegularMonthlyPayment := 0;
                    LateFeeAmount := 0;
                    OutstandingPrincipalBalance := 0;
                    CurrentEscrowAccountBalance := 0;
                    InterestRate := 0;
                    LatePaymentVerbiage := '';
                    PaymentDueDate := 0D;
                    Clear(CustAddr);
                    Clear(PropertyAddress);
                    Clear(ActivityAmounts);
                    Clear(ActivityEscrow);
                    Clear(ActivityInterest);
                    Clear(ActivityOther);
                    Clear(ActivityPrincipal);
                    Clear(ActivityDates);
                    Clear(ActivityDescriptions);
                    Clear(PaidYTD);
                    Loan.Reset();
                    Loan.SetRange("Borrower Customer No", "No.");
                    Loan.FindFirst();
                    InterestRate := Loan."Interest Rate";
                    LoanAddress.Reset();
                    LoanAddress.SetRange("Address Type", LoanAddress."Address Type"::Property);
                    LoanAddress.SetRange("Loan No.", Loan."No.");
                    if LoanAddress.FindFirst() then begin
                        FormatAddress.FormatAddr(PropertyAddress, '', '', '', LoanAddress.Address, LoanAddress."Address 2",
                        LoanAddress.City, LoanAddress."ZIP Code", LoanAddress.State, '');
                    end;
                    LoanAddress.SetRange("Address Type", LoanAddress."Address Type"::Mailing);
                    if LoanAddress.FindFirst() then begin
                        BorrowerName := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                        FormatAddress.FormatAddr(CustAddr, BorrowerName, '', '', LoanAddress.Address, LoanAddress."Address 2",
                        LoanAddress.City, LoanAddress."ZIP Code", LoanAddress.State, '');
                    end else
                        FormatAddress.Customer(CustAddr, Customer);

                    CustLedgEntry.Reset();
                    CustLedgEntry.SetRange("Customer No.", "No.");
                    CustLedgEntry.SetRange("Reason Code", LoanServicingSetup."Serviced Reason Code");
                    CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
                    CustLedgEntry.SetRange("Posting Date", DateFrom, "Sales Invoice Header"."Posting Date");
                    CustLedgEntry.SetRange("Date Filter", DateFrom, "Sales Invoice Header"."Posting Date");
                    if CustLedgEntry.FindLast() then begin
                        CustLedgEntry.CalcFields(Amount, "Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then begin
                            CurrentInvoiceAmountDue := CustLedgEntry.Amount;
                            if MortgageStatementSetup."Serv. Report Due Date" = MortgageStatementSetup."Serv. Report Due Date"::"Ledger Entries" then
                                PaymentDueDate := CustLedgEntry."Due Date"
                            else
                                PaymentDueDate := CalcDate(MortgageStatementSetup."Serv. Due Date Formula", CustLedgEntry."Posting Date");
                            LateFeeAmount := Round(MortgageStatementSetup."Late Payment Fee Percent" * CustLedgEntry.Amount / 100, 0.01);
                            LatePaymentVerbiage := StrSubstNo(LateFeeTxt, CalcDate(MortgageStatementSetup."Late Payment Date Formula", PaymentDueDate), LateFeeAmount);
                        end;
                        RegularMonthlyPayment := CustLedgEntry.Amount;
                        if SalesInvHeader.Get(CustLedgEntry."Document No.") then begin
                            SalesInvLine.Reset();
                            SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                            SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Interest);
                            if SalesInvLine.FindSet() then
                                repeat
                                    AmountDueInterest := AmountDueInterest + SalesInvLine.Amount;
                                until SalesInvLine.Next() = 0;
                            SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Principal);
                            if SalesInvLine.FindSet() then
                                repeat
                                    AmountDuePrincipal := AmountDuePrincipal + SalesInvLine.Amount;
                                until SalesInvLine.Next() = 0;
                            SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Escrow);
                            if SalesInvLine.FindSet() then
                                repeat
                                    AmountDueEscrow := AmountDueEscrow + SalesInvLine.Amount;
                                until SalesInvLine.Next() = 0;
                        end;
                    end;
                    GLEntry.Reset();
                    GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
                    GLEntry.SetRange("Loan No.", Loan."No.");
                    GLEntry.SetRange("Servicing Type", GLEntry."Servicing Type"::Escrow);
                    GLEntry.SetRange("Posting Date", 0D, "Sales Invoice Header"."Posting Date");
                    if GLEntry.FindSet() then
                        repeat
                            CustLedgEntry.Reset();
                            CustLedgEntry.SetRange("Date Filter", 0D, "Sales Invoice Header"."Posting Date");
                            CustLedgEntry.SetRange("Document Type", GLEntry."Document Type");
                            CustLedgEntry.SetRange("Document No.", GLEntry."Document No.");
                            if CustLedgEntry.FindFirst() then begin
                                CustLedgEntry.CalcFields("Remaining Amount");
                                if CustLedgEntry."Remaining Amount" = 0 then
                                    CurrentEscrowAccountBalance := CurrentEscrowAccountBalance + GLEntry.Amount;
                            end;
                        until GLEntry.Next() = 0;
                    GLEntry.Reset();
                    GLEntry.SetRange("Source Type", GLEntry."Source Type"::Vendor);
                    GLEntry.SetRange("Loan No.", Loan."No.");
                    GLEntry.SetRange("Servicing Type", GLEntry."Servicing Type"::Escrow);
                    GLEntry.SetRange("Posting Date", 0D, "Sales Invoice Header"."Posting Date");
                    if GLEntry.FindSet() then
                        repeat
                            VendLedgEntry.Reset();
                            VendLedgEntry.SetRange("Date Filter", 0D, "Sales Invoice Header"."Posting Date");
                            VendLedgEntry.SetRange("Document Type", GLEntry."Document Type");
                            VendLedgEntry.SetRange("Document No.", GLEntry."Document No.");
                            if VendLedgEntry.FindFirst() then begin
                                VendLedgEntry.CalcFields("Remaining Amount");
                                if (VendLedgEntry."Remaining Amount" = 0) then
                                    CurrentEscrowAccountBalance := CurrentEscrowAccountBalance + GLEntry.Amount;
                            end;
                        until GLEntry.Next() = 0;
                    CurrentEscrowAccountBalance := -CurrentEscrowAccountBalance;
                    MaturityDate := CalcDate(StrSubstNo('<+%1M>', Loan."Loan Term (Months)"), Loan."Date Funded");
                    OutstandingPrincipalBalance := Loan."Loan Amount";
                    GLEntry.Reset();
                    GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
                    GLEntry.SetRange("Source No.", Customer."No.");
                    GLEntry.SetRange("Servicing Type", GLEntry."Servicing Type"::Principal);
                    GLEntry.SetRange("Posting Date", 0D, "Sales Invoice Header"."Posting Date");
                    if GLEntry.FindSet() then
                        repeat
                            CustLedgEntry.Reset();
                            CustLedgEntry.SetRange("Document Type", GLEntry."Document Type");
                            CustLedgEntry.SetRange("Document No.", GLEntry."Document No.");
                            CustLedgEntry.SetRange("Date Filter", 0D, "Sales Invoice Header"."Posting Date");
                            if CustLedgEntry.FindFirst() then begin
                                CustLedgEntry.CalcFields("Remaining Amount");
                                if (CustLedgEntry."Remaining Amount" = 0) then
                                    OutstandingPrincipalBalance := OutstandingPrincipalBalance + GLEntry.Amount;
                            end;
                        until GLEntry.Next() = 0;
                    ActivityForVerbiage := TransactionActivityTxt;
                    Counter := 1;
                    if Counter < 11 then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Vendor);
                        GLEntry.SetRange("Loan No.", Loan."No.");
                        GLEntry.SetRange("Posting Date", PreviousInvoiceDate, "Sales Invoice Header"."Posting Date");
                        GLEntry.SetRange("Servicing Type", GLEntry."Servicing Type"::Escrow);
                        if GLEntry.FindSet() then
                            repeat
                                VendLedgEntry.Reset();
                                VendLedgEntry.SetRange("Document Type", GLEntry."Document Type");
                                VendLedgEntry.SetRange("Document No.", GLEntry."Document No.");
                                VendLedgEntry.SetRange("Date Filter", PreviousInvoiceDate, "Sales Invoice Header"."Posting Date");
                                if VendLedgEntry.FindFirst() then begin
                                    VendLedgEntry.CalcFields("Remaining Amount");
                                    if (VendLedgEntry."Remaining Amount" = 0) then begin
                                        ActivityDescriptions[Counter] := GLEntry.Description;
                                        ActivityAmounts[Counter] := -GLEntry.Amount;
                                        ActivityEscrow[Counter] := -GLEntry.Amount;
                                        ActivityDates[Counter] := VendLedgEntry."Closed at Date";
                                        if ActivityDates[Counter] = 0D then
                                            ActivityDates[Counter] := GLEntry."Posting Date";
                                        Counter := Counter + 1;
                                    end;
                                end;
                            until (GLEntry.Next() = 0) or (Counter = 11);
                    end;

                    if Counter < 11 then begin
                        CustLedgEntry.Reset();
                        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Payment);
                        CustLedgEntry.SetRange("Sell-to Customer No.", "No.");
                        CustLedgEntry.SetRange("Posting Date", PreviousInvoiceDate, "Sales Invoice Header"."Posting Date");
                        if CustLedgEntry.FindSet() then
                            repeat
                                DetCustLedgEntry.Reset();
                                DetCustLedgEntry.SetRange("Document Type", DetCustLedgEntry."Document Type"::Refund);
                                DetCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                                DetCustLedgEntry.SetRange("Entry Type", DetCustLedgEntry."Entry Type"::Application);
                                if DetCustLedgEntry.IsEmpty then begin
                                    DetCustLedgEntry.SetRange("Document Type", DetCustLedgEntry."Document Type"::Payment);
                                    DetCustLedgEntry.SetRange("Initial Document Type", DetCustLedgEntry."Initial Document Type"::Invoice);
                                    DetCustLedgEntry.SetRange("Cust. Ledger Entry No.");
                                    DetCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                                    if DetCustLedgEntry.FindSet() then
                                        repeat
                                            CustLedgEntry2.Get(DetCustLedgEntry."Cust. Ledger Entry No.");
                                            CustLedgEntry2.CalcFields(Amount, "Remaining Amount");
                                            if CustLedgEntry2."Remaining Amount" = 0 then
                                                if SalesInvHeader.Get(CustLedgEntry2."Document No.") then begin
                                                    if SalesInvHeader."Reason Code" = LoanServicingSetup."Serviced Reason Code" then
                                                        ActivityDescriptions[Counter] := 'Payment'
                                                    else
                                                        ActivityDescriptions[Counter] := CustLedgEntry2.Description;

                                                    ActivityDates[Counter] := CustLedgEntry."Posting Date";
                                                    ActivityAmounts[Counter] := CustLedgEntry2.Amount;
                                                    SalesInvLine.Reset();
                                                    SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                                                    SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Blank);
                                                    if SalesInvLine.FindSet() then
                                                        repeat
                                                            ActivityOther[Counter] := ActivityOther[Counter] + SalesInvLine.Amount;
                                                        until SalesInvLine.Next() = 0;
                                                    SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Escrow);
                                                    if SalesInvLine.FindSet() then
                                                        repeat
                                                            ActivityEscrow[Counter] := ActivityEscrow[Counter] + SalesInvLine.Amount;
                                                        until SalesInvLine.Next() = 0;
                                                    SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Principal);
                                                    if SalesInvLine.FindSet() then
                                                        repeat
                                                            ActivityPrincipal[Counter] := ActivityPrincipal[Counter] + SalesInvLine.Amount;
                                                        until SalesInvLine.Next() = 0;
                                                    SalesInvLine.SetRange("Servicing Type", SalesInvLine."Servicing Type"::Interest);
                                                    if SalesInvLine.FindSet() then
                                                        repeat
                                                            ActivityInterest[Counter] := ActivityInterest[Counter] + SalesInvLine.Amount;
                                                        until SalesInvLine.Next() = 0;
                                                end else begin
                                                    ActivityDescriptions[Counter] := CustLedgEntry2.Description;
                                                    ActivityAmounts[Counter] := CustLedgEntry2.Amount;
                                                    ActivityDates[Counter] := CustLedgEntry2."Closed at Date";
                                                    ActivityOther[Counter] := CustLedgEntry2.Amount;
                                                end;
                                            Counter := Counter + 1;
                                        until (DetCustLedgEntry.Next() = 0) or (Counter = 11);
                                end;
                            until (CustLedgEntry.Next() = 0) or (Counter = 11);
                    end;

                    //YTD
                    CustLedgEntry.Reset();
                    CustLedgEntry.SetFilter("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice, CustLedgEntry."Document Type"::"Credit Memo");
                    CustLedgEntry.SetRange("Posting Date", YTDStart, "Sales Invoice Header"."Posting Date");//zz
                    CustLedgEntry.SetRange("Date Filter", 0D, "Sales Invoice Header"."Posting Date");//zz
                    CustLedgEntry.SetRange("Customer No.", "No.");
                    if CustLedgEntry.FindSet() then
                        repeat
                            CustLedgEntry.CalcFields("Remaining Amount", Amount);
                            if CustLedgEntry."Remaining Amount" = 0 then begin
                                if CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice then begin
                                    SalesInvLine.Reset();
                                    SalesInvLine.SetRange("Document No.", CustLedgEntry."Document No.");
                                    if SalesInvLine.FindSet() then
                                        repeat
                                            if SalesInvLine."Servicing Type" = SalesInvLine."Servicing Type"::Escrow then
                                                PaidYTD[3] := PaidYTD[3] + SalesInvLine.Amount;
                                            if SalesInvLine."Servicing Type" = SalesInvLine."Servicing Type"::Interest then
                                                PaidYTD[2] := PaidYTD[2] + SalesInvLine.Amount;
                                            if SalesInvLine."Servicing Type" = SalesInvLine."Servicing Type"::Principal then
                                                PaidYTD[1] := PaidYTD[1] + SalesInvLine.Amount;
                                            if SalesInvLine."Servicing Type" = SalesInvLine."Servicing Type"::Blank then
                                                PaidYTD[4] := PaidYTD[4] + SalesInvLine.Amount;
                                        until SalesInvLine.Next() = 0
                                    else
                                        PaidYTD[4] := PaidYTD[4] + CustLedgEntry.Amount;
                                end else begin
                                    SalesCrMemoLine.Reset();
                                    SalesCrMemoLine.SetRange("Document No.", CustLedgEntry."Document No.");
                                    if SalesCrMemoLine.FindSet() then begin
                                        repeat
                                            if SalesCrMemoLine."Servicing Type" = SalesCrMemoLine."Servicing Type"::Escrow then
                                                PaidYTD[3] := PaidYTD[3] - SalesCrMemoLine.Amount;
                                            if SalesCrMemoLine."Servicing Type" = SalesCrMemoLine."Servicing Type"::Interest then
                                                PaidYTD[2] := PaidYTD[2] - SalesCrMemoLine.Amount;
                                            if SalesCrMemoLine."Servicing Type" = SalesCrMemoLine."Servicing Type"::Principal then
                                                PaidYTD[1] := PaidYTD[1] - SalesCrMemoLine.Amount;
                                            if SalesCrMemoLine."Servicing Type" = SalesCrMemoLine."Servicing Type"::Blank then
                                                PaidYTD[4] := PaidYTD[4] - SalesCrMemoLine.Amount;
                                        until SalesCrMemoLine.Next() = 0;
                                    end else
                                        PaidYTD[4] := PaidYTD[4] + CustLedgEntry.Amount;
                                end;
                            end else
                                PaidYTD[5] := PaidYTD[5] + (CustLedgEntry.Amount - CustLedgEntry."Remaining Amount");
                        until CustLedgEntry.Next() = 0;
                    CustLedgEntry.SetFilter("Document Type", '%1|%2', CustLedgEntry."Document Type"::Payment, CustLedgEntry."Document Type"::Refund);
                    if CustLedgEntry.FindSet() then
                        repeat
                            CustLedgEntry.CalcFields("Remaining Amount", Amount);
                            if CustLedgEntry."Remaining Amount" <> 0 then
                                PaidYTD[5] := PaidYTD[5] - CustLedgEntry.Amount;
                        until CustLedgEntry.Next() = 0;

                    PaidYTD[6] := PaidYTD[1] + PaidYTD[2] + PaidYTD[3] + PaidYTD[4] + PaidYTD[5];

                    TotalAmountDue := OverduePayment + CurrentInvoiceAmountDue;
                    DueByVerbiage := StrSubstNo(DueByTxt, PaymentDueDate, TotalAmountDue);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                AsOfDate := "Posting Date";
                DateFrom := DMY2Date(1, Date2DMY(AsOfDate, 2), Date2DMY(AsOfDate, 3));
                DateTo := CalcDate('<CM>', AsOfDate);

                YTDStart := DMY2Date(1, 1, Date2DMY(AsOfDate, 3));
                YTDEnd := AsOfDate;

                SalesInvHeader.Reset();
                SalesInvHeader.SetFilter("Posting Date", '<%1', "Posting Date");
                SalesInvHeader.SetRange("Reason Code", LoanServicingSetup."Serviced Reason Code");
                SalesInvHeader.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                if SalesInvHeader.FindLast() then
                    PreviousInvoiceDate := SalesInvHeader."Posting Date";
            end;
        }
    }

    var
        LateFeeTxt: Label 'If payment is received after %1 a $%2 late fee will be charged.';
        TransactionActivityTxt: Label 'Transaction Activity Since Last Statement';
        DueByTxt: Label 'Due By %1: $%2';
        MortgageStatementSetup: Record lvngMortgageStatementSetup;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanServicingSetup: Record lvngLoanServicingSetup;
        Loan: Record lvngLoan;
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ReasonCode: Record "Reason Code";
        VendLedgEntry: Record "Vendor Ledger Entry";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvLine: Record "Sales Invoice Line";
        GLEntry: Record "G/L Entry";
        LoanAddress: Record lvngLoanAddress;
        FormatAddress: Codeunit "Format Address";
        PropertyAddress: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PaymentDueDate: Date;
        LatePaymentVerbiage: Text;
        AmountDuePrincipal: Decimal;
        AmountDueInterest: Decimal;
        AmountDueEscrow: Decimal;
        RegularMonthlyPayment: Decimal;
        TotalFeesCharged: Decimal;
        OverduePayment: Decimal;
        TotalAmountDue: Decimal;
        OutstandingPrincipalBalance: Decimal;
        CurrentEscrowAccountBalance: Decimal;
        MaturityDate: Date;
        InterestRate: Decimal;
        CurrentInvoiceAmountDue: Decimal;
        LateFeeAmount: Decimal;
        HeaderAddress: Text;
        Counter: Integer;
        ActivityDates: array[40] of Date;
        ActivityDescriptions: array[40] of Text;
        ActivityAmounts: array[40] of Decimal;
        ActivityEscrow: array[40] of Decimal;
        ActivityPrincipal: array[40] of Decimal;
        ActivityInterest: array[40] of Decimal;
        ActivityOther: array[40] of Decimal;
        ActivityForVerbiage: Text;
        DateFrom: Date;
        DateTo: Date;
        PaidYTD: array[6] of Decimal;
        YTDStart: Date;
        YTDEnd: Date;
        DueByVerbiage: Text;
        ServAddressFull: Text;
        PreviousInvoiceDate: Date;
        AsOfDate: Date;

    trigger OnPreReport()
    begin
        MortgageStatementSetup.Get();
        MortgageStatementSetup.CalcFields("Statement Logo");
        LoanVisionSetup.Get();
        Clear(FormatAddress);
        with MortgageStatementSetup do begin
            FormatAddress.FormatAddr(CompanyAddr, '', '', '', "Serv. Department Address 1", "Serv. Department Address 2",
            "Serv. Department City", "Serv. Department Zip Code", "Serv. Department State", '');
        end;

        for Counter := 1 to 8 do
            HeaderAddress := HeaderAddress + CompanyAddr[Counter] + ', ';
        HeaderAddress := DelChr(HeaderAddress, '<>', ', ');

        DateFrom := DMY2Date(1, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3));
        DateTo := CalcDate('<CM>', WorkDate());

        YTDStart := DMY2Date(1, 1, Date2DMY(WorkDate(), 3));
        YTDEnd := WorkDate();
    end;

}