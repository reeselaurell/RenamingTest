page 14135120 "lvngPreviewLoanDocument"
{
    PageType = Card;
    SourceTable = lvngLoanDocument;
    SourceTableTemporary = true;
    Caption = 'Document Preview';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
                field(lvngTransactionType; lvngTransactionType)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentType; lvngDocumentType)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; lvngDocumentNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; lvngPostingDate)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; lvngReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngVoid; lvngVoid)
                {
                    ApplicationArea = All;
                }
                field(lvngVoidDocumentNo; lvngVoidDocumentNo)
                {
                    ApplicationArea = All;
                }
                field(lvngCustomerNo; lvngCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerSearchName; lvngBorrowerSearchName)
                {
                    ApplicationArea = All;
                }
                group(lvngDimensions)
                {
                    Caption = 'Dimensions';
                    field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                    {
                        ApplicationArea = All;
                    }
                }

            }
            part(lvngLines; lvngPreviewLoanDocumentLines)
            {
                ApplicationArea = All;
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