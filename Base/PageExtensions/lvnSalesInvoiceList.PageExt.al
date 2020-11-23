pageextension 14135144 "lvnSalesInvoiceList" extends "Sales Invoice List"
{
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
                RunObject = xmlport lvnSalesInvImport;
            }
        }
    }
}