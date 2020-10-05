page 14135256 lvngSalesInvoiceImportJnl
{
    Caption = 'Sales Invoice Import Journal';
    PageType = Document;
    SourceTable = lvngSalesInvHdrBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Payment Method Code"; Rec."Payment Method Code") { ApplicationArea = All; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; }
                field("Posting Description"; Rec."Posting Description") { ApplicationArea = All; }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.") { ApplicationArea = All; }
            }

            part(SalesInvoiceImportSubform; lvngSalesInvoiceImportSubform) { ApplicationArea = All; SubPageLink = "Document No." = field("No."); }
        }

        area(FactBoxes)
        {
            part(HeaderError; lvngSalesInvHeaderErrorDetails)
            {
                ApplicationArea = All;
                SubPageView = sorting("Document No.", "Header Error", "Line No.") where("Header Error" = const(true));
                SubPageLink = "Document No." = field("No.");
            }

            part(LineError; lvngSalesInvLineErrorDetails)
            {
                ApplicationArea = All;
                SubPageView = sorting("Document No.", "Header Error", "Line No.") where("Header Error" = const(false));
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GroupLines)
            {
                Caption = 'Group Lines';
                ToolTip = 'Groups lines by Account No., Loan No. and Dimensions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CollapseDepositLines;

                trigger OnAction()
                var
                    SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
                begin
                    SalesInvImportMgmt.GroupLines();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
    begin
        SalesInvImportMgmt.ValidateHeaderEntries();
        SalesInvImportMgmt.ValidateLineEntries();
        CurrPage.Update(false);
    end;
}