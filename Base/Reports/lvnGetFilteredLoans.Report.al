report 14135107 "lvnGetFilteredLoans"
{
    Caption = 'Get Filtered Loans';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Loan; lvnLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Alternative Loan No.", "Date Funded", "Date Sold", "Global Dimension 1 Code", "Global Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Business Unit Code";

            trigger OnAfterGetRecord()
            begin
                Clear(TempReportingBuffer);
                TempReportingBuffer."Loan No." := "No.";
                TempReportingBuffer.Insert();
            end;
        }
    }

    var
        TempReportingBuffer: Record lvnLoanReportingBuffer temporary;

    procedure RetrieveData(var LoanReportingBuffer: Record lvnLoanReportingBuffer)
    begin
        LoanReportingBuffer.Reset();
        LoanReportingBuffer.DeleteAll();
        TempReportingBuffer.Reset();
        TempReportingBuffer.FindSet();
        repeat
            Clear(LoanReportingBuffer);
            LoanReportingBuffer := TempReportingBuffer;
            LoanReportingBuffer.Insert();
        until TempReportingBuffer.Next() = 0;
    end;
}