pageextension 14135144 lvngSalesInvoiceList extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Invoice)
        {
            action(ImportInvoices)
            {
                Caption = 'Import Invoices';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = xmlport lvngSalesInvImport;
            }
        }
    }
}