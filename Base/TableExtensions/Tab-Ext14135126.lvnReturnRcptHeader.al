tableextension 14135126 "lvnReturnRcptHeader" extends "Return Receipt Header"
{
    fields
    {
        field(14135100; lvnLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvnLoan;
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