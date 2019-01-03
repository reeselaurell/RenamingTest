page 14135120 "lvngPreviewLoanDocument"
{
    PageType = Card;
    SourceTable = lvngLoanDocument;
    SourceTableTemporary = true;
    Caption = 'Document Preview';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                field(lvngLoanDocumentType; lvngLoanDocumentType)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; lvngDocumentNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngCustomerNo; lvngCustomerNo)
                {
                    ApplicationArea = All;
                }
            }
            part(lvngLines; lvngPreviewLoanDocumentLines)
            {
                Caption = 'Lines';
                Editable = false;
            }
        }
    }

    procedure SetJournalLine(lvngLoanJournalLine: Record lvngLoanJournalLine)
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        lvngCreateFundedDocuments: Codeunit lvngCreateFundedDocuments;
    begin
        lvngCreateFundedDocuments.CreateSingleDocument(lvngLoanJournalLine, Rec, lvngLoanDocumentLine, true);
        CurrPage.lvngLines.Page.SetLines(lvngLoanDocumentLine);
    end;
}