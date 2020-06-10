page 14135250 lvngPurchInvoicesImportJnl
{
    Caption = 'Purchase Invoice Import Journal';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngPurchInvHdrBuffer;
    CardPageId = lvngPurchInvoiceImportJnl;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.") { ApplicationArea = All; Style = Attention; StyleExpr = ErrorStyle; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Document Date"; "Document Date") { ApplicationArea = All; }
                field("Payment Method Code"; "Payment Method Code") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Posting Description"; "Posting Description") { ApplicationArea = All; }
                field("Buy From Vendor No."; "Buy From Vendor No.") { ApplicationArea = All; }
            }
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
        area(Reporting)
        {
            action(ImportTest)
            {
                Caption = 'Import Invoices';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchInvImport: XmlPort lvngPurchInvImport;
                begin
                    PurchInvImport.Run();
                    CurrPage.Update();
                end;
            }

            action(CreateInvoices)
            {
                ApplicationArea = All;
                Caption = 'Create Invoices';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = NewPurchaseInvoice;

                trigger OnAction()
                var
                    PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
                begin
                    if PurchInvImportMgmt.ValidateDocuments() then
                        PurchInvImportMgmt.CreateInvoices(false)
                    else
                        Error(ContainsErrorsErr);
                    CurrPage.Update();
                end;
            }

            action(CreateAndPost)
            {
                ApplicationArea = All;
                Caption = 'Create and Post Invoices';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PostTaxInvoice;

                trigger OnAction()
                var
                    PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
                    PurchInvHeaderBuffer: Record lvngPurchInvHdrBuffer;
                begin
                    PurchInvHeaderBuffer.Reset();
                    if Confirm(StrSubstNo(ConfirmMsg, Format(PurchInvHeaderBuffer.Count)), true) then
                        if PurchInvImportMgmt.ValidateDocuments() then
                            PurchInvImportMgmt.CreateInvoices(true)
                        else
                            Error(ContainsErrorsErr);
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        ContainsErrorsErr: Label 'One or more Invoices contain errors';
        ConfirmMsg: Label 'Post %1 Invoices?';
        [InDataSet]
        ErrorStyle: Boolean;

    trigger OnAfterGetRecord()
    var
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        ErrorStyle := false;
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Document No.", "No.");
        if InvoiceErrorDetail.FindSet() then
            ErrorStyle := true;
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.DeleteAll();
        PurchInvImportMgmt.ValidateHeaderEntries();
        PurchInvImportMgmt.ValidateLineEntries();
        CurrPage.Update(false);
    end;
}