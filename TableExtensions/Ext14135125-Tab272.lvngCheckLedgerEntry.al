tableextension 14135125 lvngCheckLedgerEntry extends "Check Ledger Entry"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
    }
}