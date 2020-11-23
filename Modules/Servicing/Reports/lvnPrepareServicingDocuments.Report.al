report 14135103 "lvnPrepareServicingDocuments"
{
    Caption = 'Prepare Servicing Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvnLoan; lvnLoan)
        {
            RequestFilterHeading = 'Loan';
            DataItemTableView = sorting("No.") where(Blocked = const(false), "Servicing Finished" = const(false));
            RequestFilterFields = "Date Funded", "Date Sold", "First Payment Due", "Global Dimension 1 Code", "Global Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code", "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code";

            trigger OnAfterGetRecord()
            begin
                Clear(lvnServicingWorksheet);
                lvnServicingWorksheet.Validate("Loan No.", "No.");
                lvnServicingWorksheet.Insert(true);
            end;
        }
    }

    var
        lvnServicingWorksheet: Record lvnServicingWorksheet;
}