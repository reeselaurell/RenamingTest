pageextension 14135400 "lvnAccountingPeriodsExtension" extends "Accounting Periods"
{
    layout
    {
        addafter("New Fiscal Year")
        {
            field(lvnFiscalQuarter; Rec.lvnFiscalQuarter)
            {
                Caption = 'Fiscal Quarter';
            }
        }
    }
}