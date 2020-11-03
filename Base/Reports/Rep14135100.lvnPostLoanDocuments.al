report 14135100 "lvnPostLoanDocuments"
{
    Caption = 'Post Loan Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvnLoanDocument; lvnLoanDocument)
        {
            RequestFilterFields = "Transaction Type", "Posting Date", "Document Type", "Document No.", "Loan No.";
            trigger OnPreDataItem()
            begin
                if not Confirm(DocumentsPostingCountLbl, false, Count()) then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(lvnPostLoanDocument);
                if lvnPostLoanDocument.Run(lvnLoanDocument) then begin
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
        lvnPostLoanDocument: Codeunit lvnPostLoanDocument;
        DocumentsPostingCountLbl: Label 'Do You want to post %1 documents?';
        DocumentsPostingResultLbl: Label '%1 documents posted. %2 failed';
        PostedDocuments: Integer;
        FailedDocuments: Integer;
}