tableextension 14135106 "lvnVendorLedgerEntry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(14135107; lvnEntryDate; Date) { Caption = 'Entry Date'; DataClassification = CustomerContent; }
        field(14135501; lvnVoided; Boolean) { Caption = 'Voided'; DataClassification = CustomerContent; }
        field(14135999; lvnDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}