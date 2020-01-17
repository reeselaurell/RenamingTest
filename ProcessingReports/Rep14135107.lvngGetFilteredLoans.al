report 14135107 lvngGetFilteredLoans
{
    Caption = 'Get Filtered Loans';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Loan; lvngLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Alternative Loan No.", "Date Funded", "Date Sold", "Global Dimension 1 Code", "Global Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Business Unit Code";

            trigger OnAfterGetRecord()
            begin
                Clear(ReportingBuffer);
                ReportingBuffer."Loan No." := "No.";
                ReportingBuffer.Insert();
            end;
        }
    }

    var
        ReportingBuffer: Record lvngLoanReportingBuffer temporary;

    procedure RetrieveData(var LoanReportingBuffer: Record lvngLoanReportingBuffer)
    begin
        LoanReportingBuffer.Reset();
        LoanReportingBuffer.DeleteAll();
        ReportingBuffer.Reset();
        ReportingBuffer.FindSet();
        repeat
            Clear(LoanReportingBuffer);
            LoanReportingBuffer := ReportingBuffer;
            LoanReportingBuffer.Insert();
        until ReportingBuffer.Next() = 0;
    end;
}