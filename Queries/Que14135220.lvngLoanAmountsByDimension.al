query 14135220 lvngLoanAmountsByDimension
{
    QueryType = Normal;

    elements
    {
        dataitem(Loan; lvngLoan)
        {
            filter(DateApplicationFilter; "Application Date") { }
            filter(DateFundedFilter; "Date Funded") { }
            filter(DateSoldFilter; "Date Sold") { }
            filter(DateLockedFilter; "Date Locked") { }
            filter(DateClosedFilter; "Date Closed") { }
            filter(Dimension1Filter; "Global Dimension 1 Code") { }
            filter(Dimension2Filter; "Global Dimension 2 Code") { }
            filter(Dimension3Filter; "Shortcut Dimension 3 Code") { }
            filter(Dimension4Filter; "Shortcut Dimension 4 Code") { }
            filter(Dimension5Filter; "Shortcut Dimension 5 Code") { }
            filter(Dimension6Filter; "Shortcut Dimension 6 Code") { }
            filter(Dimension7Filter; "Shortcut Dimension 7 Code") { }
            filter(Dimension8Filter; "Shortcut Dimension 8 Code") { }
            filter(BusinessUnitFilter; "Business Unit Code") { }
            column(LoanAmount; "Loan Amount") { Method = Sum; }
            column(LoanCount) { Method = Count; }
        }
    }
}