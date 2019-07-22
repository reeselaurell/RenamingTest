codeunit 14135119 "lvngServicingManagement"
{
    trigger OnRun()
    begin

    end;

    procedure lvngGetPrincipalAndInterest(lvngLoan: Record lvngLoan; var lvngNextPaymentDate: Date; var lvngPrincipalAmount: Decimal; var lvngInterestAmount: Decimal)
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
        if lvngLoan.lvngDateFunded = 0D then
            exit;
        if lvngLoan.lvngLoanTermMonths = 0 then
            exit;
        if lvngLoan.lvngFirstPaymentDue = 0D then
            lvngLoan.lvngFirstPaymentDue := CalcDate('<CM + 1D - 1M>', lvngLoan.lvngDateFunded);
        if CalcDate(StrSubstNo('<+%1M>', lvngLoan.lvngLoanTermMonths + 1), lvngLoan.lvngFirstPaymentDue) < lvngNextPaymentDate then
            exit;
        lvngGetLoanServicingSetup();
        lvngLoanServicingSetup.TestField(lvngPrincipalRedReasonCode);
        lvngLoanServicingSetup.TestField(lvngPrincipalRedGLAccountNo);
        GLEntry.reset;
        GLEntry.SetRange(lvngLoanNo, lvngLoan.lvngLoanNo);
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
        lvngInterestPerMonth := lvngLoan.lvngInterestRate / 12 / 100;
        lvngMonthlyPayment := lvngInterestPerMonth * lvngLoan.lvngLoanAmount * Power(1 + lvngInterestPerMonth, lvngloan.lvngLoanTermMonths) / (Power(1 + lvngInterestPerMonth, lvngLoan.lvngLoanTermMonths) - 1);
        lvngStartDate := lvngLoan.lvngFirstPaymentDue;
        lvngPreviousBalance := lvngLoan.lvngLoanAmount;
        lvngCalculationDate := lvngStartDate;
        for lvngLineNo := 1 to lvngLoan.lvngLoanTermMonths do begin
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
            if (lvngInterestAmount + lvngPrincipalAmount) <> lvngLoan.lvngMonthlyPaymentAmount then begin
                lvngPrincipalAmount := lvngLoan.lvngMonthlyPaymentAmount - lvngInterestAmount;
            end;
            lvngCalculationDate := calcdate(StrSubstNo('<+%1M>', lvngLineNo), lvngStartDate);
        end;
    end;

    procedure lvngGetTotalEscrowAmounts(lvngLoan: Record lvngLoan): Decimal
    var
        lvngEscrowFieldsMapping: Record lvngEscrowFieldsMapping;
        lvngLoanValue: Record lvngLoanValue;
        lvngEscrowAmount: Decimal;
    begin
        lvngEscrowFieldsMapping.reset;
        if lvngEscrowFieldsMapping.FindSet() then begin
            repeat
                if lvngLoanValue.Get(lvngLoan.lvngLoanNo, lvngEscrowFieldsMapping.lvngFieldNo) then begin
                    lvngEscrowAmount := lvngEscrowAmount + lvngLoanValue.lvngDecimalValue;
                end;
            until lvngEscrowFieldsMapping.Next() = 0;
        end;
        exit(lvngEscrowAmount);
    end;

    procedure CreateBorrowerCustomers()
    var
        lvngServicingWorksheet: Record lvngServicingWorksheet;
        lvngLoan: Record lvngLoan;
        Customer: Record Customer;
    begin
        lvngServicingWorksheet.reset;
        if lvngServicingWorksheet.FindSet() then begin
            repeat
                if lvngLoan.Get(lvngServicingWorksheet.lvngLoanNo) then begin
                    if lvngLoan.lvngBorrowerCustomerNo = '' then begin

                    end;
                end;
            until lvngServicingWorksheet.Next() = 0;
        end;
    end;

    procedure ValidateServicingWorksheet()
    begin
        lvngServicingWorksheet.Reset();
        if lvngServicingWorksheet.FindSet() then begin
            repeat
                clear(lvngServicingWorksheet.lvngErrorMessage);

            until lvngServicingWorksheet.Next() = 0;
        end;
    end;

    local procedure lvngGetLoanServicingSetup()
    begin
        if not lvngLoanServicingSetupRetrieved then begin
            lvngLoanServicingSetup.Get();
            lvngLoanServicingSetupRetrieved := true;
        end;
    end;

    var
        lvngServicingWorksheet: Record lvngServicingWorksheet;
        lvngLoanServicingSetup: Record lvngLoanServicingSetup;
        lvngLoanServicingSetupRetrieved: Boolean;

}