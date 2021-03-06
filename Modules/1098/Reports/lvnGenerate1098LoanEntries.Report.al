report 14135104 "lvnGenerate1098LoanEntries"
{
    Caption = 'Generate 1098 Loan Entries';
    ProcessingOnly = true;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Reason Code", lvnServicingType, Reversed;

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(RemoveExistingDataField; RemoveExistingData) { ApplicationArea = All; Caption = 'Remove Existing Worksheet'; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if RemoveExistingData then begin
            Form1098Entry.Reset();
            Form1098Entry.DeleteAll();
        end;
        Form1098EligibleLoans.SetFilter(GLAccountFilter, GLEntry.GetFilter("G/L Account No."));
        Form1098EligibleLoans.SetFilter(ReasonCodeFilter, GLEntry.GetFilter("Reason Code"));
        Form1098EligibleLoans.SetFilter(DateFilter, GLEntry.GetFilter("Posting Date"));
        Form1098EligibleLoans.SetFilter(ServicingTypeFilter, GLEntry.GetFilter(lvnServicingType));
        Form1098EligibleLoans.SetFilter(Reversed, GLEntry.GetFilter(Reversed));
        Form1098EligibleLoans.Open();
        while Form1098EligibleLoans.Read() do
            if Form1098EligibleLoans.LoanNo <> '' then
                if Loan.Get(Form1098EligibleLoans.LoanNo) then
                    if not Form1098Entry.Get(Form1098EligibleLoans.LoanNo) then begin
                        Clear(Form1098Entry);
                        Form1098Entry.Validate("Loan No.", Form1098EligibleLoans.LoanNo);
                        Form1098Entry.Insert(true);
                    end;
        Form1098EligibleLoans.Close();
    end;

    var
        Form1098Entry: Record lvnForm1098Entry;
        Loan: Record lvnLoan;
        Form1098EligibleLoans: Query lvnForm1098EligibleLoans;
        RemoveExistingData: Boolean;
}