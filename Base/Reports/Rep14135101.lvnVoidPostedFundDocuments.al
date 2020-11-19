report 14135101 "lvnVoidPostedFundDocuments"
{
    Caption = 'Create Funded Void Loan Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvnLoanFundedDocument; lvnLoanFundedDocument)
        {
            RequestFilterFields = "Posting Date", "Document Type", "Document No.", "Loan No.";

            trigger OnPreDataItem()
            begin
                lvnLoanFundedDocument.SetRange(Void, false);
                if not Confirm(DocumentsVoidCountLbl, false, Count()) then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                lvnLoanVoidDocument.CreateFundedVoidDocument(lvnLoanFundedDocument, false);
                VoidsCreatedCount := VoidsCreatedCount + 1;
            end;

            trigger OnPostDataItem()
            begin
                Message(DocumentsVoidResultLbl, VoidsCreatedCount);
            end;
        }
    }

    var
        lvnLoanVoidDocument: Codeunit lvnLoanVoidDocument;
        VoidsCreatedCount: Integer;
        DocumentsVoidCountLbl: Label 'Do You want to create %1 void documents?', Comment = '%1 = Document Count';
        DocumentsVoidResultLbl: Label '%1 void documents created', Comment = '%1 = Documents Created Count';
}