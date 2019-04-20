page 14135126 "lvngLoanDocumentsList"
{
    Caption = 'Loan Documents';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngLoanDocument;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
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
                field(lvngCustomerNo; lvngCustomerNo)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngWarehouseLineCode; lvngWarehouseLineCode)
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
                field(lvngBorrowerSearchName; lvngBorrowerSearchName)
                {
                    ApplicationArea = All;
                }
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
    }

    actions
    {
        area(Processing)
        {
            action(lvngShowDocument)
            {
                Caption = 'Show Document';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    case lvngTransactionType of
                        lvngTransactionType::lvngFunded:
                            begin
                                page.Run(Page::lvngFundedDocument, Rec);
                            end;
                        lvngTransactionType::lvngSold:
                            begin
                                page.Run(Page::lvngSoldDocument, Rec);
                            end;
                    end;
                end;
            }
            action(lvngPost)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
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

            action(lvngBatchPost)
            {
                Caption = 'Post Batch';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostBatch;
                RunObject = report lvngPostLoanDocuments;
            }

            action(lvngPrint)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Print;
                RunObject = report lvngLoanDocument;
            }
        }
    }

}