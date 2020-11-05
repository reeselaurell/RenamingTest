tableextension 14135109 "lvnPurchaseHeader" extends "Purchase Header"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
        }
        field(14135101; lvnDocumentTotalCheck; Decimal)
        {
            Caption = 'Document Total (Check)';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
        field(14135102; lvnTotalAmount; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Direct Unit Cost" where("Document Type" = field("Document Type"), "Document No." = field("No."), Type = filter(<> '')));
            Editable = false;
        }
        field(14135999; lvnDocumentGuid; Guid)
        {
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        if lvnDocumentGuid = EmptyGuid then
            lvnDocumentGuid := CreateGuid();
    end;
}