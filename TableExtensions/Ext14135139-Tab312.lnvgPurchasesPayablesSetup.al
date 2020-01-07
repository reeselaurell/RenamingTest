tableextension 14135139 lvngPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(14135103; lvngQuickPayDefaultBatch; Code[20]) { DataClassification = CustomerContent; Caption = 'Quick Pay Default Batch'; TableRelation = "Gen. Journal Batch".Name where("Template Type" = const(Payments)); }
        field(14135104; lvngQuickPayBatchSelection; Enum lvngQuickPayBatchSelection) { DataClassification = CustomerContent; Caption = 'Quick Pay Batch Selection'; }
    }
}