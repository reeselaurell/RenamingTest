page 14135255 lvngSalesInvoicesImportJnl
{
    Caption = 'Sales Invoice Import Journal';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngSalesInvHdrBuffer;
    CardPageId = lvngSalesInvoiceImportJnl;
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
                field("Sell-to Customer No."; "Sell-to Customer No.") { ApplicationArea = All; }
            }
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
                    SalesInvImport: XmlPort lvngSalesInvImport;
                begin
                    SalesInvImport.Run();
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
                Image = NewSalesInvoice;

                trigger OnAction()
                var
                    SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
                begin
                    if SalesInvImportMgmt.ValidateDocuments() then
                        SalesInvImportMgmt.CreateInvoices(false)
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
                    SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
                    SalesInvHeaderBuffer: Record lvngSalesInvHdrBuffer;
                begin
                    SalesInvHeaderBuffer.Reset();
                    if Confirm(StrSubstNo(ConfirmMsg, Format(SalesInvHeaderBuffer.Count)), true) then
                        if SalesInvImportMgmt.ValidateDocuments() then
                            SalesInvImportMgmt.CreateInvoices(true)
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
        SalesInvImportMgmt: Codeunit lvngSalesInvoiceImportMgmt;
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.DeleteAll();
        SalesInvImportMgmt.ValidateHeaderEntries();
        SalesInvImportMgmt.ValidateLineEntries();
        CurrPage.Update(false);
    end;


}