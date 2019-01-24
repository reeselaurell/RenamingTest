report 14135100 "lvngPostLoanDocuments"
{
    Caption = 'Post Loan Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngLoanDocument; lvngLoanDocument)
        {
            RequestFilterFields = lvngTransactionType, lvngPostingDate, lvngDocumentType, lvngDocumentNo, lvngLoanNo;
            trigger OnPreDataItem()
            begin
                if not Confirm(DocumentsPostingCountLbl, false, Count()) then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(lvngPostLoanDocument);
                if lvngPostLoanDocument.Run(lvngLoanDocument) then begin
                    PostedDocuments := PostedDocuments + 1;
                end else begin
                    FailedDocuments := FailedDocuments + 1;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Message(DocumentsPostingResultLbl, PostedDocuments, FailedDocuments);
            end;
        }
    }

    var
        lvngPostLoanDocument: Codeunit lvngPostLoanDocument;
        DocumentsPostingCountLbl: Label 'Do You want to post %1 documents?';
        DocumentsPostingResultLbl: Label '%1 documents posted. %2 failed';
        PostedDocuments: Integer;
        FailedDocuments: Integer;
}