report 14135103 "lvngPrepareServicingDocuments"
{
    Caption = 'Prepare Servicing Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngLoan; lvngLoan)
        {
            RequestFilterHeading = 'Loan';
            DataItemTableView = sorting("Loan No.") where(Blocked = const(false), "Servicing Finished" = const(false));
            RequestFilterFields = "Date Funded", "Date Sold", "First Payment Due", "Global Dimension 1 Code", "Global Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code", "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code";

            trigger OnAfterGetRecord()
            begin
                Clear(lvngServicingWorksheet);
                lvngServicingWorksheet.Validate(lvngLoanNo, "Loan No.");
                lvngServicingWorksheet.Insert(true);
            end;
        }
    }

    var
        lvngServicingWorksheet: Record lvngServicingWorksheet;
}