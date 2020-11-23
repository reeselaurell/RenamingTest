report 14135108 "lvnGetLoansWithActivity"
{
    Caption = 'Get Loans with Activity';
    ProcessingOnly = true;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = lvnEntryDate, "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code", lvnShortcutDimension3Code, lvnShortcutDimension4Code, "Business Unit Code", "Reason Code", "G/L Account No.";

            trigger OnPreDataItem()
            begin
                GLEntry.SetFilter(lvnLoanNo, '<>%1', '');
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
                Clear(TempReportingBuffer);
                TempReportingBuffer."Loan No." := lvnLoanNo;
                TempReportingBuffer.Insert();
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    ProgressDialog.Close();
            end;
        }
    }

    var
        TempReportingBuffer: Record lvnLoanReportingBuffer temporary;
        ProgressDialog: Dialog;
        Counter: Integer;
        ProcessingEntryLbl: Label 'Processing Entry #1########## of #2###########', Comment = '#1 = Processed Entries; #2 = Total Entires';

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