tableextension 14135124 lvngBankAccountLedgerEntry extends "Bank Account Ledger Entry"
{
    fields
    {
        field(14135100; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135501; Voided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
    }
}