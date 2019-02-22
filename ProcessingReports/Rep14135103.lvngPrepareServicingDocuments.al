report 14135103 "lvngPrepareServicingDocuments"
{
    Caption = 'Prepare Servicing Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngLoan; lvngLoan)
        {
            RequestFilterHeading = 'Loan';
            DataItemTableView = sorting (lvngLoanNo) where (lvngBlocked = const (false), lvngServicingFinished = const (false));
            RequestFilterFields = lvngDateFunded, lvngDateSold, lvngFirstPaymentDue, lvngGlobalDimension1Code, lvngGlobalDimension2Code, lvngShortcutDimension3Code, lvngShortcutDimension4Code, lvngShortcutDimension5Code, lvngShortcutDimension6Code, lvngShortcutDimension7Code, lvngShortcutDimension8Code;

            trigger OnAfterGetRecord()
            begin
                Clear(lvngServicingWorksheet);
                lvngServicingWorksheet.Validate(lvngLoanNo, lvngLoanNo);
                lvngServicingWorksheet.Insert(true);
            end;
        }
    }

    var
        lvngServicingWorksheet: Record lvngServicingWorksheet;
}