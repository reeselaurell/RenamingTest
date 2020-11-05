page 14135251 "lvnPurchInvoiceImportJnl"
{
    Caption = 'Purchase Invoice Import Journal';
    PageType = Document;
    SourceTable = lvnPurchInvHdrBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = ErrorStyle;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Buy From Vendor No."; Rec."Buy From Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
            part(PurchInvoiceImportSubform; lvnPurchInvoiceImportSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(HeaderError; lvnPurchInvHeaderErrorDetails)
            {
                ApplicationArea = All;
                SubPageView = sorting("Document No.", "Header Error", "Line No.") where("Header Error" = const(true));
                SubPageLink = "Document No." = field("No.");
            }
            part(LineError; lvnPurchInvLineErrorDetails)
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
                Image = NewPurchaseInvoice;

                trigger OnAction()
                var
                    PurchInvImportMgmt: Codeunit lvnPurchInvoiceImportMgmt;
                begin
                    Rec.Reset();
                    PurchInvLineBuffer.Reset();
                    CurrPage.PurchInvoiceImportSubform.Page.UpdateLines(PurchInvLineBuffer);
                    InvoiceErrorDetail.Reset();
                    InvoiceErrorDetail.DeleteAll();
                    PurchInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
                    PurchInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, PurchInvLineBuffer);
                    CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
                    CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
                    if InvoiceErrorDetail.IsEmpty() then
                        PurchInvImportMgmt.CreateInvoices(Rec, PurchInvLineBuffer, false)
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
                    PurchInvImportMgmt: Codeunit lvnPurchInvoiceImportMgmt;
                begin
                    if Confirm(StrSubstNo(ConfirmMsg, Format(Rec.Count)), true) then begin
                        Rec.Reset();
                        PurchInvLineBuffer.Reset();
                        CurrPage.PurchInvoiceImportSubform.Page.UpdateLines(PurchInvLineBuffer);
                        InvoiceErrorDetail.Reset();
                        InvoiceErrorDetail.DeleteAll();
                        PurchInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
                        PurchInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, PurchInvLineBuffer);
                        CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
                        CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
                        if InvoiceErrorDetail.IsEmpty() then
                            PurchInvImportMgmt.CreateInvoices(Rec, PurchInvLineBuffer, true)
                        else
                            Error(ContainsErrorsErr);
                        CurrPage.Close();
                    end
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.PurchInvoiceImportSubform.Page.SetSubform(PurchInvLineBuffer);
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
        PurchInvImportMgmt: Codeunit lvnPurchInvoiceImportMgmt;
    begin
        Rec.Reset();
        PurchInvLineBuffer.Reset();
        CurrPage.PurchInvoiceImportSubform.Page.UpdateLines(PurchInvLineBuffer);
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Header Error", false);
        if InvoiceErrorDetail.FindSet() then
            InvoiceErrorDetail.DeleteAll();
        PurchInvImportMgmt.ValidateLineEntries(InvoiceErrorDetail, PurchInvLineBuffer);
        CurrPage.LineError.Page.SetLineErrors(InvoiceErrorDetail);
        CurrPage.Update(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        PurchInvImportMgmt: Codeunit lvnPurchInvoiceImportMgmt;
    begin
        Rec.Modify();
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Header Error", true);
        if InvoiceErrorDetail.FindSet() then
            InvoiceErrorDetail.DeleteAll();
        PurchInvImportMgmt.ValidateHeaderEntries(InvoiceErrorDetail, Rec);
        CurrPage.HeaderError.Page.SetHeaderErrors(InvoiceErrorDetail);
        Rec.Reset();
        CurrPage.Update(false);
    end;

    var
        PurchInvLineBuffer: Record lvnPurchInvLineBuffer;
        InvoiceErrorDetail: Record lvnInvoiceErrorDetail;
        [InDataSet]
        ErrorStyle: Boolean;
        ConfirmMsg: Label 'Post %1 Invoices?';
        ContainsErrorsErr: Label 'One or more Invoices contain errors. Correct entries and Validate to proceed';

    procedure SetHeaderBuffer(var pPurchInvHdrBuffer: Record lvnPurchInvHdrBuffer)
    begin
        pPurchInvHdrBuffer.FindSet();
        Rec.Reset();
        Rec.DeleteAll();
        repeat
            Rec := pPurchInvHdrBuffer;
            Rec.Insert();
        until pPurchInvHdrBuffer.Next() = 0;
        if Rec.FindSet() then;
    end;

    procedure SetLineBuffer(var pPurchInvLineBuffer: Record lvnPurchInvLineBuffer)
    begin
        pPurchInvLineBuffer.FindSet();
        PurchInvLineBuffer.Reset();
        PurchInvLineBuffer.DeleteAll();
        repeat
            PurchInvLineBuffer := pPurchInvLineBuffer;
            PurchInvLineBuffer.Insert();
        until pPurchInvLineBuffer.Next() = 0;
        if PurchInvLineBuffer.FindSet() then;
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