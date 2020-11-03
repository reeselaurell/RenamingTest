tableextension 14135107 "lvnSalesHeader" extends "Sales Header"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvnLoan; }
        field(14135101; lvnTotalAmount; Decimal) { Caption = 'Total Amount'; FieldClass = FlowField; CalcFormula = sum("Sales Line"."Line Amount" where("Document Type" = field("Document Type"), "Document No." = field("No."), Type = filter(<> ''))); Editable = false; }
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