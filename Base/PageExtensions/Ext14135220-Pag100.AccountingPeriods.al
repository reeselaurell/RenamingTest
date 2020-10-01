pageextension 14135400 lvngAccountingPeriodsExtension extends "Accounting Periods"
{
    layout
    {
        addafter("New Fiscal Year")
        {
            field(lvngFiscalQuarter; Rec.lvngFiscalQuarter) { Caption = 'Fiscal Quarter'; }
        }
    }
}