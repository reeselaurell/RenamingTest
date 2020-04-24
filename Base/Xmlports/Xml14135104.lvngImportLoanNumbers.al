xmlport 14135104 lvngImportLoanNumbers
{
    Caption = 'Loans Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';

    schema
    {
        textelement(Root)
        {
            tableelement(ReportingBuffer; lvngLoanReportingBuffer)
            {
                SourceTableView = sorting("Loan No.");
                UseTemporary = true;

                fieldelement(LoanNo; ReportingBuffer."Loan No.") { }

            }

        }
    }

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