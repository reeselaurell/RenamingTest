codeunit 14135119 "lvngServicingManagement"
{
    trigger OnRun()
    begin

    end;

    procedure GetPrincipalAndInterest(lvngLoan: Record lvngLoan; var lvngNextPaymentDate: Date; var lvngPrincipalAmount: Decimal; var lvngInterestAmount: Decimal)
    var
        GLEntry: Record "G/L Entry";
        lvngGLEntryBuffer: Record lvngGLEntryBuffer temporary;
        lvngLineNo: Integer;
        lvngPreviousBalance: Decimal;
        lvngInterestPerMonth: Decimal;
        lvngMonthlyPayment: Decimal;
        lvngStartDate: Date;
        lvngCalculationDate: Date;
    begin
        if lvngLoan."Date Funded" = 0D then
            exit;
        if lvngLoan."Loan Term (Months)" = 0 then
            exit;
        if lvngLoan."First Payment Due" = 0D then
            lvngLoan."First Payment Due" := CalcDate('<CM + 1D - 1M>', lvngLoan."Date Funded");
        if CalcDate(StrSubstNo('<+%1M>', lvngLoan."Loan Term (Months)" + 1), lvngLoan."First Payment Due") < lvngNextPaymentDate then
            exit;
        GetLoanServicingSetup();
        lvngLoanServicingSetup.TestField(lvngPrincipalRedReasonCode);
        lvngLoanServicingSetup.TestField(lvngPrincipalRedGLAccountNo);
        GLEntry.reset;
        GLEntry.SetRange(lvngLoanNo, lvngLoan."Loan No.");
        GLEntry.SetRange("Reason Code", lvngLoanServicingSetup.lvngPrincipalRedReasonCode);
        GLEntry.SetRange("G/L Account No.", lvngLoanServicingSetup.lvngPrincipalRedGLAccountNo);
        if GLEntry.FindSet() then begin
            repeat
                Clear(lvngGLEntryBuffer);
                lvngGLEntryBuffer.lvngEntryNo := GLEntry."Entry No.";
                lvngGLEntryBuffer.lvngAmount := GLEntry.Amount;
                lvngGLEntryBuffer.lvngPostingDate := GLEntry."Posting Date";
                lvngGLEntryBuffer.Insert();
            until GLEntry.Next() = 0;
        end;
        lvngInterestPerMonth := lvngLoan."Interest Rate" / 12 / 100;
        lvngMonthlyPayment := lvngInterestPerMonth * lvngLoan."Loan Amount" * Power(1 + lvngInterestPerMonth, lvngloan."Loan Term (Months)") / (Power(1 + lvngInterestPerMonth, lvngLoan."Loan Term (Months)") - 1);
        lvngStartDate := lvngLoan."First Payment Due";
        lvngPreviousBalance := lvngLoan."Loan Amount";
        lvngCalculationDate := lvngStartDate;
        for lvngLineNo := 1 to lvngLoan."Loan Term (Months)" do begin
            lvngGLEntryBuffer.reset;
            lvngGLEntryBuffer.SetRange(lvngPostingDate, CalcDate('<-1M + 1D>', lvngCalculationDate), lvngCalculationDate);
            if lvngGLEntryBuffer.FindSet() then begin
                repeat
                    lvngPreviousBalance := lvngPreviousBalance + lvngGLEntryBuffer.lvngAmount;
                until lvngGLEntryBuffer.Next() = 0;
                if lvngPreviousBalance < 0 then
                    lvngPreviousBalance := 0;
            end;
            lvngInterestAmount := lvngPreviousBalance * lvngInterestPerMonth;
            lvngPrincipalAmount := lvngMonthlyPayment - lvngInterestAmount;
            if lvngPrincipalAmount > lvngPreviousBalance then
                lvngPrincipalAmount := lvngPreviousBalance;
            if (lvngInterestAmount = 0) and (lvngPrincipalAmount = 0) then
                exit;
            lvngInterestAmount := round(lvngInterestAmount, 0.01);
            lvngPrincipalAmount := round(lvngPrincipalAmount, 0.01);
            if (lvngInterestAmount + lvngPrincipalAmount) <> lvngLoan."Monthly Payment Amount" then begin
                lvngPrincipalAmount := lvngLoan."Monthly Payment Amount" - lvngInterestAmount;
            end;
            lvngCalculationDate := calcdate(StrSubstNo('<+%1M>', lvngLineNo), lvngStartDate);
        end;
    end;

    procedure GetTotalEscrowAmounts(lvngLoan: Record lvngLoan): Decimal
    var
        lvngEscrowFieldsMapping: Record lvngEscrowFieldsMapping;
        lvngLoanValue: Record lvngLoanValue;
        lvngEscrowAmount: Decimal;
    begin
        lvngEscrowFieldsMapping.reset;
        if lvngEscrowFieldsMapping.FindSet() then begin
            repeat
                if lvngLoanValue.Get(lvngLoan."Loan No.", lvngEscrowFieldsMapping.lvngFieldNo) then begin
                    lvngEscrowAmount := lvngEscrowAmount + lvngLoanValue."Decimal Value";
                end;
            until lvngEscrowFieldsMapping.Next() = 0;
        end;
        exit(lvngEscrowAmount);
    end;

    procedure ValidateServicingWorksheet()
    begin
        lvngServicingWorksheet.Reset();
        if lvngServicingWorksheet.FindSet() then begin
            repeat
                lvngServicingWorksheet.CalculateAmounts();
                ValidateServicingLine(lvngServicingWorksheet);
                lvngServicingWorksheet.Modify();
            until lvngServicingWorksheet.Next() = 0;
        end;
    end;

    procedure ValidateServicingLine(var lvngServicingWorksheetParam: Record lvngServicingWorksheet)
    var
        lvngLoan: record lvngLoan;
        Customer: Record Customer;
        lvngEscrowsDoesntMatch: Label 'Total escrow amount doesn''t match';
        lvngBorrowerCustomerMissing: Label 'Borrower Customer is empty or doesn''t exist';
    begin
        GetLoanServicingSetup();
        lvngLoan.Get(lvngServicingWorksheetParam.lvngLoanNo);
        clear(lvngServicingWorksheetParam.lvngErrorMessage);
        if lvngLoanServicingSetup.lvngTestEscrowTotals then begin
            if lvngLoan."Monthly Escrow Amount" <> lvngServicingWorksheetParam.lvngEscrowAmount then begin
                lvngServicingWorksheetParam.lvngErrorMessage := copystr(lvngEscrowsDoesntMatch, 1, MaxStrLen(lvngServicingWorksheetParam.lvngErrorMessage));
            end;
        end;
        if lvngServicingWorksheetParam.lvngErrorMessage = '' then begin
            if not Customer.Get(lvngLoan."Borrower Customer No") then begin
                lvngServicingWorksheetParam.lvngErrorMessage := copystr(lvngBorrowerCustomerMissing, 1, MaxStrLen(lvngServicingWorksheetParam.lvngErrorMessage));
            end;
        end;
    end;

    local procedure GetLoanServicingSetup()
    begin
        if not lvngLoanServicingSetupRetrieved then begin
            lvngLoanServicingSetup.Get();
            lvngLoanServicingSetupRetrieved := true;
        end;
    end;

    procedure CreateBorrowerCustomers()
    var
        lvngLoan: Record lvngLoan;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Template";
    begin
        GetLoanServicingSetup();
        lvngLoanServicingSetup.TestField(lvngBorrowerCustomerTemplate);
        CustomerTemplate.Get(lvngLoanServicingSetup.lvngBorrowerCustomerTemplate);
        lvngServicingWorksheet.reset;
        lvngServicingWorksheet.FindSet();
        repeat
            lvngLoan.get(lvngServicingWorksheet.lvngLoanNo);
            if lvngLoan."Borrower Customer No" = '' then begin
                Customer."No." := lvngLoan."Loan No.";
                Customer.Name := copystr(lvngloan."Search Name", 1, MaxStrLen(Customer.Name));
                Customer.CopyFromCustomerTemplate(CustomerTemplate);
                Customer.Insert(true);
                lvngLoan."Borrower Customer No" := Customer."No.";
                lvngLoan.Modify(true);
            end;
        until lvngServicingWorksheet.Next() = 0;
    end;

    procedure CreateServicingDocuments()
    var
        lvngLoanDocument: Record lvngLoanDocument;
        lvngEscrowFieldsMapping: Record lvngEscrowFieldsMapping;
        lvngLoan: Record lvngLoan;
        lvngLoanValue: Record lvngLoanValue;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        lvngLineNo: Integer;
    begin
        ValidateServicingWorksheet();
        GetLoanServicingSetup();
        lvngLoanServicingSetup.testfield(lvngServicedNoSeries);
        lvngLoanServicingSetup.TestField(lvngServicedReasonCode);
        lvngServicingWorksheet.reset;
        lvngServicingWorksheet.FindSet();
        repeat
            if lvngServicingWorksheet.lvngErrorMessage = '' then begin
                lvngLineNo := 1000;
                Clear(lvngLoanDocument);
                lvngLoanDocument.Init();
                lvngLoanDocument.validate(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngServiced);
                lvngLoanDocument.validate(lvngDocumentType, lvngLoanDocument.lvngDocumentType::lvngInvoice);
                lvngLoanDocument.validate(lvngDocumentNo, NoSeriesManagement.DoGetNextNo(lvngLoanServicingSetup.lvngServicedNoSeries, TODAY, true, false));
                lvngLoanDocument.validate(lvngCustomerNo, lvngServicingWorksheet.lvngCustomerNo);
                lvngLoanDocument.validate(lvngLoanNo, lvngServicingWorksheet.lvngLoanNo);
                lvngLoanDocument.validate(lvngPostingDate, lvngServicingWorksheet.lvngNextPaymentDate);
                lvngLoanDocument.Validate(lvngReasonCode, lvngLoanServicingSetup.lvngServicedReasonCode);
                lvngLoanDocument.Insert(true);
                Clear(lvngLoanDocumentLine);
                lvngLoanDocumentLine.validate(lvngTransactionType, lvngLoanDocument.lvngTransactionType);
                lvngLoanDocumentLine.validate(lvngDocumentNo, lvngLoanDocument.lvngDocumentNo);
                lvngLoanDocumentLine.Validate(lvngAccountType, lvngLoanDocumentLine.lvngAccountType::lvngGLAccount);
                lvngLoanDocumentLine.lvngLineNo := lvngLineNo;
                lvngLoanDocumentLine.lvngAmount := lvngServicingWorksheet.lvngInterestAmount;
                lvngLoanDocumentLine.lvngServicingType := lvngLoanDocumentLine.lvngServicingType::lvngInterest;
                lvngLoanDocumentLine.Insert(true);
                lvngLineNo := lvngLineNo + 1000;
            end;
        until lvngServicingWorksheet.Next() = 0;
    end;

    var
        lvngServicingWorksheet: Record lvngServicingWorksheet;
        lvngLoanServicingSetup: Record lvngLoanServicingSetup;
        lvngLoanServicingSetupRetrieved: Boolean;

}