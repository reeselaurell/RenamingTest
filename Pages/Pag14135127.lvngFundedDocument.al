page 14135127 "lvngFundedDocument"
{
    Caption = 'Funded Document';
    PageType = Card;
    SourceTable = lvngLoanDocument;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
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
            part(lvngFundedDocumentSubpage; lvngFundedDocumentSubpage)
            {
                Caption = 'Lines';
                SubPageLink = lvngTransactionType = field (lvngTransactionType), lvngDocumentNo = field (lvngDocumentNo);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngPost)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    lvngPostLoanDocument: Codeunit lvngPostLoanDocument;
                    PostConfirmationLbl: Label 'Do You want to Post Document?';
                begin
                    if Confirm(PostConfirmationLbl, false) then begin
                        lvngPostLoanDocument.Run(Rec);
                    end;
                end;
            }
            action(lvngPrint)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                trigger OnAction()
                var
                    lvngLoanDocumentReport: Report lvngLoanDocument;
                    lvngLoanDocumentView: Record lvngLoanDocument;
                begin
                    lvngLoanDocumentView := Rec;
                    lvngLoanDocumentView.SetRecFilter();
                    lvngLoanDocumentReport.SetTableView(lvngLoanDocumentView);
                    lvngLoanDocumentReport.Run();
                end;
            }
        }
    }
}