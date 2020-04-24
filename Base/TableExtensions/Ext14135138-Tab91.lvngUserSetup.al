tableextension 14135138 lvngUserSetup extends "User Setup"
{
    fields
    {
        field(14135102; lvngDefaultPaymentJournalBatch; Code[10]) { DataClassification = CustomerContent; Caption = 'Default Payment Journal Batch'; TableRelation = "Gen. Journal Batch".Name where("Template Type" = const(Payments)); }
    }
}