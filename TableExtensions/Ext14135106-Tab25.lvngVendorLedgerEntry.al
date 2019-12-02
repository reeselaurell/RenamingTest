tableextension 14135106 lvngVendorLedgerEntry extends "Vendor Ledger Entry"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135107; lvngEntryDate; Date) { Caption = 'Entry Date'; DataClassification = CustomerContent; }
        field(14135501; lvngVoided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
    }
}