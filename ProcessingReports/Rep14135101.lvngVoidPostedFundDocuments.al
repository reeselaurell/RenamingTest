report 14135101 "lvngVoidPostedFundDocuments"
{
    Caption = 'Create Funded Void Loan Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngLoanFundedDocument; lvngLoanFundedDocument)
        {
            RequestFilterFields = lvngPostingDate, lvngDocumentType, lvngDocumentNo, lvngLoanNo;

            trigger OnPreDataItem()
            begin
                lvngLoanFundedDocument.setrange(lvngVoid, false);
                if not Confirm(DocumentsVoidCountLbl, false, Count()) then
                    CurrReport.Break();
            end;

            trigger OnAfterGetRecord()
            begin
                lvngLoanVoidDocument.CreateFundedVoidDocument(lvngLoanFundedDocument, false);
                VoidsCreatedCount := VoidsCreatedCount + 1;
            end;

            trigger OnPostDataItem()
            begin
                Message(DocumentsVoidResultLbl, VoidsCreatedCount);
            end;
        }
    }

    var
        lvngLoanVoidDocument: Codeunit lvngLoanVoidDocument;
        DocumentsVoidCountLbl: Label 'Do You want to create %1 void documents?';
        DocumentsVoidResultLbl: Label '%1 void documents created';
        VoidsCreatedCount: Integer;
}