tableextension 14135139 "lvnPurchasesPayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(14135103; lvnQuickPayDefaultBatch; Code[20]) { DataClassification = CustomerContent; Caption = 'Quick Pay Default Batch'; TableRelation = "Gen. Journal Batch".Name where("Template Type" = const(Payments)); }
        field(14135104; lvnQuickPayBatchSelection; Enum lvnQuickPayBatchSelection) { DataClassification = CustomerContent; Caption = 'Quick Pay Batch Selection'; }
    }
}