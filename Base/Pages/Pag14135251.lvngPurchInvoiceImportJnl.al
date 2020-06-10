page 14135251 lvngPurchInvoiceImportJnl
{
    Caption = 'Purchase Invoice Import Journal';
    PageType = Document;
    SourceTable = lvngPurchInvHdrBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("No."; "No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Document Date"; "Document Date") { ApplicationArea = All; }
                field("Payment Method Code"; "Payment Method Code") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Posting Description"; "Posting Description") { ApplicationArea = All; }
                field("Buy From Vendor No."; "Buy From Vendor No.") { ApplicationArea = All; }
            }

            part(PurchInvoiceImportSubform; lvngPurchInvoiceImportSubform) { ApplicationArea = All; SubPageLink = "Document No." = field("No."); }
        }

        area(FactBoxes)
        {
            part(HeaderError; lvngPurchInvHeaderErrorDetails)
            {
                ApplicationArea = All;
                SubPageView = sorting("Document No.", "Header Error", "Line No.") where("Header Error" = const(true));
                SubPageLink = "Document No." = field("No.");
            }

            part(LineError; lvngPurchInvLineErrorDetails)
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
                    PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
                begin
                    PurchInvImportMgmt.GroupLines();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
    begin
        PurchInvImportMgmt.ValidateHeaderEntries();
        PurchInvImportMgmt.ValidateLineEntries();
        CurrPage.Update(false);
    end;
}