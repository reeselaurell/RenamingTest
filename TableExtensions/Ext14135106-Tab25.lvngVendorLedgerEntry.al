tableextension 14135106 lvngVendorLedgerEntry extends "Vendor Ledger Entry"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135107; "Entry Date"; Date) { Caption = 'Entry Date'; DataClassification = CustomerContent; }
        field(14135501; Voided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
    }
}