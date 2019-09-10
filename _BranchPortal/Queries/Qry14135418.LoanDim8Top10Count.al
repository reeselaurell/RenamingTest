query 14135418 lvngLoanDim8Top10Count
{
    QueryType = Normal;
    TopNumberOfRows = 10;
    OrderBy = descending (LoanCount);

    elements
    {
        dataitem(Loan; lvngLoan)
        {
            filter(DateApplicationFilter; lvngApplicationDate) { }
            filter(DateFundedFilter; lvngDateFunded) { }
            filter(DateSoldFilter; lvngDateSold) { }
            filter(DateLockedFilter; lvngDateLocked) { }
            filter(DateClosedFilter; lvngDateClosed) { }
            filter(Dimension1Filter; lvngGlobalDimension1Code) { }
            filter(Dimension2Filter; lvngGlobalDimension2Code) { }
            filter(Dimension3Filter; lvngShortcutDimension3Code) { }
            filter(Dimension4Filter; lvngShortcutDimension4Code) { }
            filter(Dimension5Filter; lvngShortcutDimension5Code) { }
            filter(Dimension6Filter; lvngShortcutDimension6Code) { }
            filter(Dimension7Filter; lvngShortcutDimension7Code) { }
            filter(Dimension8Filter; lvngShortcutDimension8Code) { }
            filter(BusinessUnitFilter; lvngBusinessUnitCode) { }
            column(Code; lvngShortcutDimension8Code) { }
            column(LoanCount) { Method = Count; }
        }
    }
}