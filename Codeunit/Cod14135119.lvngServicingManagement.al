codeunit 14135119 lvngServicingManagement
{
    var
        LoanServicingSetup: Record lvngLoanServicingSetup;
        LoanServicingSetupRetrieved: Boolean;

    procedure GetPrincipalAndInterest(Loan: Record lvngLoan; var NextPaymentDate: Date; var PrincipalAmount: Decimal; var InterestAmount: Decimal)
    var
        GLEntry: Record "G/L Entry";
        GLEntryBuffer: Record lvngGLEntryBuffer temporary;
        LineNo: Integer;
        PreviousBalance: Decimal;
        InterestPerMonth: Decimal;
        MonthlyPayment: Decimal;
        StartDate: Date;
        CalculationDate: Date;
    begin
        if Loan."Date Funded" = 0D then
            exit;
        if Loan."Loan Term (Months)" = 0 then
            exit;
        if Loan."First Payment Due" = 0D then
            Loan."First Payment Due" := CalcDate('<CM + 1D - 1M>', Loan."Date Funded");
        if CalcDate(StrSubstNo('<+%1M>', Loan."Loan Term (Months)" + 1), Loan."First Payment Due") < NextPaymentDate then
            exit;
        GetLoanServicingSetup();
        LoanServicingSetup.TestField("Principal Red. Reason Code");
        LoanServicingSetup.TestField("Principal Red. G/L Account No.");
        GLEntry.Reset();
        GLEntry.SetRange(lvngLoanNo, Loan."No.");
        GLEntry.SetRange("Reason Code", LoanServicingSetup."Principal Red. Reason Code");
        GLEntry.SetRange("G/L Account No.", LoanServicingSetup."Principal Red. G/L Account No.");
        if GLEntry.FindSet() then
            repeat
                Clear(GLEntryBuffer);
                GLEntryBuffer."Entry No." := GLEntry."Entry No.";
                GLEntryBuffer.Amount := GLEntry.Amount;
                GLEntryBuffer."Posting Date" := GLEntry."Posting Date";
                GLEntryBuffer.Insert();
            until GLEntry.Next() = 0;
        InterestPerMonth := Loan."Interest Rate" / 12 / 100;
        MonthlyPayment := InterestPerMonth * Loan."Loan Amount" * Power(1 + InterestPerMonth, Loan."Loan Term (Months)") / (Power(1 + InterestPerMonth, Loan."Loan Term (Months)") - 1);
        StartDate := Loan."First Payment Due";
        PreviousBalance := Loan."Loan Amount";
        CalculationDate := StartDate;
        for LineNo := 1 to Loan."Loan Term (Months)" do begin
            GLEntryBuffer.Reset();
            GLEntryBuffer.SetRange("Posting Date", CalcDate('<-1M + 1D>', CalculationDate), CalculationDate);
            if GLEntryBuffer.FindSet() then begin
                repeat
                    PreviousBalance := PreviousBalance + GLEntryBuffer.Amount;
                until GLEntryBuffer.Next() = 0;
                if PreviousBalance < 0 then
                    PreviousBalance := 0;
            end;
            InterestAmount := PreviousBalance * InterestPerMonth;
            PrincipalAmount := MonthlyPayment - InterestAmount;
            if PrincipalAmount > PreviousBalance then
                PrincipalAmount := PreviousBalance;
            if (InterestAmount = 0) and (PrincipalAmount = 0) then
                exit;
            InterestAmount := Round(InterestAmount, 0.01);
            PrincipalAmount := Round(PrincipalAmount, 0.01);
            if (InterestAmount + PrincipalAmount) <> Loan."Monthly Payment Amount" then begin
                PrincipalAmount := Loan."Monthly Payment Amount" - InterestAmount;
            end;
            CalculationDate := calcdate(StrSubstNo('<+%1M>', LineNo), StartDate);
        end;
    end;

    procedure GetTotalEscrowAmounts(Loan: Record lvngLoan): Decimal
    var
        EscrowFieldsMapping: Record lvngEscrowFieldsMapping;
        LoanValue: Record lvngLoanValue;
        EscrowAmount: Decimal;
    begin
        EscrowFieldsMapping.Reset();
        if EscrowFieldsMapping.FindSet() then
            repeat
                if LoanValue.Get(Loan."No.", EscrowFieldsMapping."Field No.") then
                    EscrowAmount := EscrowAmount + LoanValue."Decimal Value";
            until EscrowFieldsMapping.Next() = 0;
        exit(EscrowAmount);
    end;

    procedure ValidateServicingWorksheet()
    var
        ServicingWorksheet: Record lvngServicingWorksheet;
    begin
        ServicingWorksheet.Reset();
        if ServicingWorksheet.FindSet() then begin
            repeat
                ServicingWorksheet.CalculateAmounts();
                ValidateServicingLine(ServicingWorksheet);
                ServicingWorksheet.Modify();
            until ServicingWorksheet.Next() = 0;
        end;
    end;

    procedure ValidateServicingLine(var ServicingWorksheet: Record lvngServicingWorksheet)
    var
        Loan: Record lvngLoan;
        Customer: Record Customer;
        EscrowsDoesntMatchErr: Label 'Total escrow amount doesn''t match';
        BorrowerCustomerMissingErr: Label 'Borrower Customer is empty or doesn''t exist';
    begin
        GetLoanServicingSetup();
        Loan.Get(ServicingWorksheet."Loan No.");
        if Loan."Date Sold" <> 0D then begin
            if Date2DMY(Loan."Date Sold", 1) > LoanServicingSetup."Last Servicing Month Day" then
                ServicingWorksheet."Payable to Investor" := true else
                ServicingWorksheet."Last Servicing Period" := true;
        end;
        Clear(ServicingWorksheet."Error Message");
        if LoanServicingSetup."Test Escrow Totals" then
            if Loan."Monthly Escrow Amount" <> ServicingWorksheet."Escrow Amount" then
                ServicingWorksheet."Error Message" := CopyStr(EscrowsDoesntMatchErr, 1, MaxStrLen(ServicingWorksheet."Error Message"));
        if ServicingWorksheet."Error Message" = '' then
            if not Customer.Get(Loan."Borrower Customer No") then
                ServicingWorksheet."Error Message" := CopyStr(BorrowerCustomerMissingErr, 1, MaxStrLen(ServicingWorksheet."Error Message"));
    end;

    local procedure GetLoanServicingSetup()
    begin
        if not LoanServicingSetupRetrieved then begin
            LoanServicingSetup.Get();
            LoanServicingSetupRetrieved := true;
        end;
    end;

    procedure CreateBorrowerCustomers()
    var
        ServicingWorksheet: Record lvngServicingWorksheet;
        Loan: Record lvngLoan;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Template";
    begin
        GetLoanServicingSetup();
        LoanServicingSetup.TestField("Borrower Customer Template");
        CustomerTemplate.Get(LoanServicingSetup."Borrower Customer Template");
        ServicingWorksheet.Reset();
        ServicingWorksheet.FindSet();
        repeat
            Loan.get(ServicingWorksheet."Loan No.");
            if Loan."Borrower Customer No" = '' then begin
                Customer."No." := Loan."No.";
                Customer.Name := copystr(Loan."Search Name", 1, MaxStrLen(Customer.Name));
                Customer.CopyFromCustomerTemplate(CustomerTemplate);
                Customer.Insert(true);
                Loan."Borrower Customer No" := Customer."No.";
                Loan.Modify(true);
            end;
        until ServicingWorksheet.Next() = 0;
    end;

    procedure CreateServicingDocuments()
    var
        ServicingWorksheet: Record lvngServicingWorksheet;
        LoanDocument: Record lvngLoanDocument;
        EscrowFieldsMapping: Record lvngEscrowFieldsMapping;
        Loan: Record lvngLoan;
        LoanValue: Record lvngLoanValue;
        LoanDocumentLine: Record lvngLoanDocumentLine;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        ValidateServicingWorksheet();
        GetLoanServicingSetup();
        LoanServicingSetup.TestField("Serviced No. Series");
        LoanServicingSetup.TestField("Serviced Reason Code");
        ServicingWorksheet.Reset();
        ServicingWorksheet.FindSet();
        repeat
            if ServicingWorksheet."Error Message" = '' then begin
                LineNo := 1000;
                Clear(LoanDocument);
                LoanDocument.Init();
                LoanDocument.Validate("Transaction Type", LoanDocument."Transaction Type"::Serviced);
                LoanDocument.Validate("Document Type", LoanDocument."Document Type"::Invoice);
                LoanDocument.Validate("Document No.", NoSeriesManagement.DoGetNextNo(LoanServicingSetup."Serviced No. Series", TODAY, true, false));
                LoanDocument.Validate("Customer No.", ServicingWorksheet."Customer No.");
                LoanDocument.Validate("Loan No.", ServicingWorksheet."Loan No.");
                LoanDocument.Validate("Posting Date", ServicingWorksheet."Next Payment Date");
                LoanDocument.Validate("Reason Code", LoanServicingSetup."Serviced Reason Code");
                LoanDocument.Insert(true);
                Clear(LoanDocumentLine);
                LoanDocumentLine.Validate("Transaction Type", LoanDocument."Transaction Type");
                LoanDocumentLine.Validate("Document No.", LoanDocument."Document No.");
                LoanDocumentLine.Validate("Account Type", LoanDocumentLine."Account Type"::"G/L Account");
                LoanDocumentLine."Line No." := LineNo;
                LoanDocumentLine.Amount := ServicingWorksheet."Interest Amount";
                LoanDocumentLine."Servicing Type" := LoanDocumentLine."Servicing Type"::Interest;
                LoanDocumentLine.Insert(true);
                LineNo := LineNo + 1000;
            end;
        until ServicingWorksheet.Next() = 0;
    end;
}