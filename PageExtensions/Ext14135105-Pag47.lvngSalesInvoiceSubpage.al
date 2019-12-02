pageextension 14135105 lvngSalesInvoiceSubpage extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; }
            field(lvngServicingType; lvngServicingType) { ApplicationArea = All; }
        }
    }
}