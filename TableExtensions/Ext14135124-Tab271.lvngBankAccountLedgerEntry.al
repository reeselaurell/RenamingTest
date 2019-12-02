tableextension 14135124 lvngBankAccountLedgerEntry extends "Bank Account Ledger Entry"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135501; lvngVoided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
    }
}