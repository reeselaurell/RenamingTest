xmlport 14135104 "lvnImportLoanNumbers"
{
    Caption = 'Loans Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(ReportingBuffer; lvnLoanReportingBuffer)
            {
                SourceTableView = sorting("Loan No.");
                UseTemporary = true;

                fieldelement(LoanNo; ReportingBuffer."Loan No.") { }

            }

        }
    }

    procedure RetrieveData(var LoanReportingBuffer: Record lvnLoanReportingBuffer)
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