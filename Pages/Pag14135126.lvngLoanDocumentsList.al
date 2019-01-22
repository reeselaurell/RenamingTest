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
                field(lvngVoid; lvngVoid)
                {
                    ApplicationArea = All;
                }
                field(lvngBorrowerSearchName; lvngBorrowerSearchName)
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
                    end;
                end;
            }
        }
    }

}