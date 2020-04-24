tableextension 14135109 lvngPurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; }
        field(14135101; lvngDocumentTotalCheck; Decimal) { Caption = 'Document Total (Check)'; DataClassification = CustomerContent; BlankZero = true; }
        field(14135102; lvngTotalAmount; Decimal) { Caption = 'Total Amount'; FieldClass = FlowField; CalcFormula = sum ("Purchase Line"."Line Amount" where("Document Type" = field("Document Type"), "Document No." = field("No."), Type = filter(<> ''))); Editable = false; }
        field(14135999; lvngDocumentGuid; Guid) { DataClassification = CustomerContent; }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;
}