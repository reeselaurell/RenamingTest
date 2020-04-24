report 14135108 lvngGetLoansWithActivity
{
    Caption = 'Get Loans with Activity';
    ProcessingOnly = true;


    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = lvngEntryDate, "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code", lvngShortcutDimension3Code, lvngShortcutDimension4Code, "Business Unit Code", "Reason Code", "G/L Account No.";

            trigger OnPreDataItem()
            begin
                GLEntry.SetFilter(lvngLoanNo, '<>%1', '');
                if GuiAllowed then begin
                    ProgressDialog.Open(ProcessingEntryLbl);
                    ProgressDialog.Update(2, GLEntry.Count());
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then begin
                    Counter := Counter + 1;
                    if Counter mod 100 = 0 then
                        ProgressDialog.Update(1, Counter);
                end;
                Clear(ReportingBuffer);
                ReportingBuffer."Loan No." := lvngLoanNo;
                ReportingBuffer.Insert();
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    ProgressDialog.Close();
            end;
        }
    }

    var
        ReportingBuffer: Record lvngLoanReportingBuffer temporary;
        ProgressDialog: Dialog;
        Counter: Integer;
        ProcessingEntryLbl: Label 'Processing Entry #1########## of #2###########';


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