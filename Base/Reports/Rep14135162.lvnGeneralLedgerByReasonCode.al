report 14135162 "lvnGeneralLedgerByReasonCode"
{
    Caption = 'General Ledger by Reason Code';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135162.rdl';

    dataset
    {
        dataitem(ReasonCodeLoop; "Reason Code")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Code;

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break();
            end;
        }

        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Date Filter";

            column(BeginningBalance; GLEntry.Amount) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(ReasonFilter; ReasonFilter) { }
            column(GLAccountFilter; GLAccountFilter) { }
            column(DateFilter; DateFilter) { }

            dataitem(Loop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(GLAccountNo; TempGLEntryBuffer."G/L Account No.") { }
                column(ReasonCode; TempGLEntryBuffer."Reason Code") { }
                column(SourceCode; TempGLEntryBuffer."Source Code") { }
                column(DebitAmount; TempGLEntryBuffer."Debit Amount") { }
                column(CreditAmount; TempGLEntryBuffer."Credit Amount") { }
                column(Amount; TempGLEntryBuffer."Current Balance") { }
                column(GLAccountName; GLAccountName) { }

                trigger OnPreDataItem()
                begin
                    TempGLEntryBuffer.Reset();
                    TempGLEntryBuffer.SetRange("G/L Account No.", GLAccount."No.");
                    SetRange(Number, 1, TempGLEntryBuffer.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    GLAccount2: Record "G/L Account";
                begin
                    if Number = 1 then
                        TempGLEntryBuffer.FindFirst()
                    else
                        TempGLEntryBuffer.Next();
                    GLAccountName := '';
                    if GLAccount2.Get(TempGLEntryBuffer."G/L Account No.") then
                        GLAccountName := GLAccount2.Name;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.Reset();
                if DateOption = DateOption::"Posting Date" then begin
                    GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    GLEntry.SetFilter("Posting Date", '%1..%2', 0D, MaxDate);
                end else begin
                    GLEntry.SetCurrentKey("G/L Account No.", lvnEntryDate);
                    GLEntry.SetFilter(lvnEntryDate, '%1..%2', 0D, MaxDate);
                end;
                GLEntry.SetRange("G/L Account No.", "No.");
                GLEntry.CalcSums(Amount);
                TempGLEntryBuffer.Reset();
                TempGLEntryBuffer.SetRange("G/L Account No.", GLAccount."No.");
                if TempGLEntryBuffer.IsEmpty() then
                    CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(DateOption; DateOption) { Caption = 'Date'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        TempGLEntryBuffer: Record lvnGLEntryBuffer temporary;
        CompanyInformation: Record "Company Information";
        GLEntry: Record "G/L Entry";
        GLPerReasonCode: Query lvnGLReportPerReasonCode;
        DateFilter: Text;
        ReasonFilter: Text;
        GLAccountFilter: Text;
        LineNo: Integer;
        MaxDate: Date;
        GLAccountName: Text;
        DateOption: Enum lvnDocumentDateTypes;

    trigger OnPreReport()
    var
        DateFilterErr: Label 'Please provide a date filter';
    begin
        CompanyInformation.Get();
        LineNo := 1;
        DateFilter := GLAccount.GetFilter("Date Filter");
        if DateFilter = '' then
            Error(DateFilterErr);
        ReasonFilter := ReasonCodeLoop.GetFilter(Code);
        GLAccountFilter := GLAccount.GetFilter("No.");
        MaxDate := GLAccount.GetRangeMin("Date Filter");
        if DateOption = DateOption::"Posting Date" then
            GLPerReasonCode.SetFilter(PostingDateFilter, DateFilter)
        else
            GLPerReasonCode.SetFilter(EntryDateFilter, DateFilter);
        GLPerReasonCode.SetFilter(ReasonCodeFilter, ReasonFilter);
        GLPerReasonCode.SetFilter(GLAccountNoFilter, GLAccountFilter);
        GLPerReasonCode.Open();
        while GLPerReasonCode.Read() do begin
            Clear(TempGLEntryBuffer);
            TempGLEntryBuffer."Entry No." := LineNo;
            LineNo += 1;
            TempGLEntryBuffer."Reason Code" := GLPerReasonCode.ReasonCode;
            TempGLEntryBuffer."Source Code" := GLPerReasonCode.SourceCode;
            TempGLEntryBuffer."G/L Account No." := GLPerReasonCode.GLAccountNo;
            TempGLEntryBuffer."Debit Amount" := GLPerReasonCode.DebitAmount;
            TempGLEntryBuffer."Credit Amount" := GLPerReasonCode.CreditAmount;
            TempGLEntryBuffer."Current Balance" := GLPerReasonCode.Amount;
            TempGLEntryBuffer.Insert();
        end;
        GLPerReasonCode.Close();
    end;
}