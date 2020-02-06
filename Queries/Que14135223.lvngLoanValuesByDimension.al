query 14135223 lvngLoanValuesByDimension
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
            filter(DateCommissionFilter; "Commission Date") { }
            filter(Dimension1Filter; "Global Dimension 1 Code") { }
            filter(Dimension2Filter; "Global Dimension 2 Code") { }
            filter(Dimension3Filter; "Shortcut Dimension 3 Code") { }
            filter(Dimension4Filter; "Shortcut Dimension 4 Code") { }
            filter(Dimension5Filter; "Shortcut Dimension 5 Code") { }
            filter(Dimension6Filter; "Shortcut Dimension 6 Code") { }
            filter(Dimension7Filter; "Shortcut Dimension 7 Code") { }
            filter(Dimension8Filter; "Shortcut Dimension 8 Code") { }
            filter(BusinessUnitFilter; "Business Unit Code") { }
            dataitem(LoanValue; lvngLoanValue)
            {
                DataItemLink = "Loan No." = Loan."No.";
                filter(FieldNo; "Field No.") { }
                column(DecimalValue; "Decimal Value") { Method = Sum; }
                column(IntegerValue; "Integer Value") { Method = Sum; }
                column(Count) { Method = Count; }
            }
        }
    }
}