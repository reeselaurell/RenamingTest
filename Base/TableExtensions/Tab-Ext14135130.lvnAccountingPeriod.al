tableextension 14135130 "lvnAccountingPeriod" extends "Accounting Period"
{
    fields
    {
        field(14135100; lvnFiscalQuarter; Boolean)
        {
            Caption = 'Fiscal Quarter';
            DataClassification = CustomerContent;
        }
    }
}