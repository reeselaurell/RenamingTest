pageextension 14135105 lvngSalesInvoiceSubpage extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngLoanNo; "Loan No.") { ApplicationArea = All; }
            field(lvngServicingType; "Servicing Type") { ApplicationArea = All; }
        }
    }
}