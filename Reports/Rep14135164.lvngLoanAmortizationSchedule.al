report 14135164 lvngLoanAmortizationSchedule
{
    Caption = 'Loan Amortization Schedule';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135164.rdl';

    dataset
    {
        dataitem(Loan; lvngLoan)
        {
            column(LoanAmount; "Loan Amount") { }
            column(InterestRate; "Interest Rate") { }
            column(Address1; Address1) { }
            column(Address2; Address2) { }
            column(BorrowerFullName; BorrowerFullName) { }
            column(LoanNo; "No.") { }
            column(FirstPaymentDue; "First Payment Due") { }

            dataitem(Amortization; Integer)
            {
                column(PaymentNo; Number) { }
                column(UPB; TempAmScheduleRec.Balance) { }
                column(Interest; TempAmScheduleRec.Interest) { }
                column(Principal; TempAmScheduleRec.Principal) { }
                column(PaymentAmount; TempAmScheduleRec."Payment Amount") { }
                column(PaymentDate; TempAmScheduleRec.Date) { }

                trigger OnPreDataItem()
                begin
                    TempLoan := Loan;
                    CreateAmortizationSchedule(TempLoan, TempAmScheduleRec);
                    SetRange(Number, 1, TempAmScheduleRec.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempAmScheduleRec.FindSet()
                    else
                        TempAmScheduleRec.Next();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Address1 := '';
                Address2 := '';
                if LoanAddress.Get("No.", LoanAddress."Address Type"::Property) then begin
                    Address1 := LoanAddress.Address + ' ' + LoanAddress."Address 2";
                    Address2 := LoanAddress.City + ', ' + LoanAddress.State + ' ' + LoanAddress."ZIP Code";
                end;
                BorrowerFullName := '';
                BorrowerFullName := "Borrower First Name" + ' ' + "Borrower Middle Name" + ' ' + "Borrower Last Name";
            end;
        }
    }

    var
        TempAmScheduleRec: Record lvngAmortizationScheduleBuffer temporary;
        LoanAddress: Record lvngLoanAddress;
        TempLoan: Record lvngLoan temporary;
        LoanServicing: Codeunit lvngServicingManagement;
        Address1: Text;
        Address2: Text;
        BorrowerFullName: Text;

    local procedure CreateAmortizationSchedule(Loan: Record lvngLoan; var AmortizationScheduleBuffer: Record lvngAmortizationScheduleBuffer)
    var
        StartDate: Date;
        LineNo: Integer;
        InterestMonth: Decimal;
        MonthlyPayment: Decimal;
        Interest: Decimal;
        PrevBalanceInterest: Decimal;
        PrincipalAmount: Decimal;
    begin
        Clear(LineNo);
        AmortizationScheduleBuffer.Reset();
        AmortizationScheduleBuffer.DeleteAll();
        if Loan."Date Funded" = 0D then
            exit;
        if Loan."Loan Term (Months)" = 0 then
            exit;
        InterestMonth := Loan."Interest Rate" / 12 / 100;
        MonthlyPayment := InterestMonth * Loan."Loan Amount" * Power(1 + InterestMonth, Loan."Loan Term (Months)") / (Power(1 + InterestMonth, Loan."Loan Term (Months)") - 1);
        if Loan."First Payment Due" = 0D then
            Loan."First Payment Due" := CalcDate('<CM + 1D - 1M>', Loan."Date Funded");
        StartDate := Loan."First Payment Due";
        PrevBalanceInterest := Loan."Loan Amount";
        with AmortizationScheduleBuffer do
            for LineNo := 1 to Loan."Loan Term (Months)" do begin
                Clear(AmortizationScheduleBuffer);
                "Entry No." := LineNo;
                Interest := PrevBalanceInterest * InterestMonth;
                Principal := MonthlyPayment - Interest;
                Balance := PrevBalanceInterest - Principal;
                Date := Calcdate(StrSubstNo('<+%1M-1M>', LineNo), StartDate);
                Insert();
                PrevBalanceInterest := Balance;
            end;
    end;
}