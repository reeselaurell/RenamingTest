page 14135256 "lvnSalesInvoiceImportJnl"
{
    Caption = 'Sales Invoice Import Journal';
    PageType = Document;
    SourceTable = lvnSalesInvHdrBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; Style = Attention; StyleExpr = ErrorStyle; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Payment Method Code"; Rec."Payment Method Code") { ApplicationArea = All; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; }
                field("Posting Description"; Rec."Posting Description") { ApplicationArea = All; }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
            }
            part(SalesInvoiceImportSubform; lvnSalesInvoiceImportSubform) { ApplicationArea = All; SubPageLink = "Document No." = field("No."); }
        }

        area(FactBoxes)
        {
            part(HeaderError; lvnSalesInvHeaderErrorDetails)
            {
                ApplicationArea = All;
                SubPageView = sorting("Document No.", "Header Error", "Line No.") where("Header Error" = const(true));
                SubPageLink = "Document No." = field("No.");
            }

            part(LineError; lvnSalesInvLineErrorDetails)
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
                    SalesInvImportMgmt: Codeunit lvnSalesInvoiceImportMgmt;
                begin
                    Rec.Reset();
                    SalesInvLineBuffer.Reset();
                    CurrPage.SalesInvoiceImportSubform.Page.UpdateLines(SalesInvLineBuffer);
                    InvoiceErrorDetail.Reset();
                    InvoiceErrorDetail.DeleteAll();
                    SalesInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
                    SalesInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, SalesInvLineBuffer);
                    CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
                    CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
                    if InvoiceErrorDetail.IsEmpty() then
                        SalesInvImportMgmt.CreateInvoices(Rec, SalesInvLineBuffer, false)
                    else
                        Error(ContainsErrorsErr);
                    CurrPage.Close();
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
                    SalesInvImportMgmt: Codeunit lvnSalesInvoiceImportMgmt;
                begin
                    if Confirm(StrSubstNo(ConfirmMsg, Format(Rec.Count)), true) then begin
                        Rec.Reset();
                        SalesInvLineBuffer.Reset();
                        CurrPage.SalesInvoiceImportSubform.Page.UpdateLines(SalesInvLineBuffer);
                        InvoiceErrorDetail.Reset();
                        InvoiceErrorDetail.DeleteAll();
                        SalesInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
                        SalesInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, SalesInvLineBuffer);
                        CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
                        CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
                        if InvoiceErrorDetail.IsEmpty() then
                            SalesInvImportMgmt.CreateInvoices(Rec, SalesInvLineBuffer, true)
                        else
                            Error(ContainsErrorsErr);
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    var
        ConfirmMsg: Label 'Post %1 Invoices?';
        ContainsErrorsErr: Label 'One or more Invoices contain errors. Correct entries and Validate to proceed';
        SalesInvLineBuffer: Record lvnSalesInvLineBuffer;
        InvoiceErrorDetail: Record lvnInvoiceErrorDetail;
        [InDataSet]
        ErrorStyle: Boolean;

    trigger OnOpenPage()
    begin
        CurrPage.SalesInvoiceImportSubform.Page.SetSubform(SalesInvLineBuffer);
        CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
        CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
    end;

    trigger OnAfterGetRecord()
    begin
        ErrorStyle := false;
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Document No.", Rec."No.");
        if InvoiceErrorDetail.FindSet() then
            ErrorStyle := true;
    end;

    trigger OnAfterGetCurrRecord()
    var
        SalesInvImportMgmt: Codeunit lvnSalesInvoiceImportMgmt;
    begin
        Rec.Reset();
        SalesInvLineBuffer.Reset();
        CurrPage.SalesInvoiceImportSubform.Page.UpdateLines(SalesInvLineBuffer);
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Header Error", false);
        if InvoiceErrorDetail.FindSet() then
            InvoiceErrorDetail.DeleteAll();
        SalesInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, SalesInvLineBuffer);
        CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
        CurrPage.Update(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        SalesInvImportMgmt: Codeunit lvnSalesInvoiceImportMgmt;
    begin
        Rec.Modify();
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Header Error", true);
        if InvoiceErrorDetail.FindSet() then
            InvoiceErrorDetail.DeleteAll();
        SalesInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
        CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
        Rec.Reset();
        CurrPage.Update(false);
    end;

    procedure SetHeaderBuffer(var pSalesInvHdrBuffer: Record lvnSalesInvHdrBuffer)
    begin
        pSalesInvHdrBuffer.FindSet();
        Rec.Reset();
        Rec.DeleteAll();
        repeat
            Rec := pSalesInvHdrBuffer;
            Rec.Insert();
        until pSalesInvHdrBuffer.Next() = 0;
        if Rec.FindSet() then;
    end;

    procedure SetLineBuffer(var pSalesInvLineBuffer: Record lvnSalesInvLineBuffer)
    begin
        pSalesInvLineBuffer.FindSet();
        SalesInvLineBuffer.Reset();
        SalesInvLineBuffer.DeleteAll();
        repeat
            SalesInvLineBuffer := pSalesInvLineBuffer;
            SalesInvLineBuffer.Insert();
        until pSalesInvLineBuffer.Next() = 0;
        if SalesInvLineBuffer.FindSet() then;
    end;

    procedure SetErrors(var pInvoiceErrorDetail: Record lvnInvoiceErrorDetail)
    begin
        if pInvoiceErrorDetail.FindSet() then;
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.DeleteAll();
        repeat
            InvoiceErrorDetail := pInvoiceErrorDetail;
            InvoiceErrorDetail.Insert();
        until pInvoiceErrorDetail.Next() = 0;
        if InvoiceErrorDetail.FindSet() then;
    end;
}