report 14135102 "lvnVoidPostedSoldDocuments"
{
    Caption = 'Create Sold Void Loan Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvnLoanSoldDocument; lvnLoanSoldDocument)
        {
            RequestFilterFields = "Posting Date", "Document Type", "Document No.", "Loan No.";

            trigger OnPreDataItem()
            begin
                lvnLoanSoldDocument.setrange(Void, false);
                if not Confirm(DocumentsVoidCountLbl, false, Count()) then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                lvnLoanVoidDocument.CreateSoldVoidDocument(lvnLoanSoldDocument, false);
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
        DocumentsVoidCountLbl: Label 'Do You want to create %1 void documents?';
        DocumentsVoidResultLbl: Label '%1 void documents created';
        VoidsCreatedCount: Integer;
}