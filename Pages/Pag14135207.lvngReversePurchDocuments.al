page 14135207 lvngReversePurchaseDocuments
{
    Caption = 'Reverse Purchase Documents';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;
    InsertAllowed = false;
    Permissions = TableData "G/L Entry" = rm, TableData "Vendor Ledger Entry" = rm, TableData "Purch. Inv. Header" = rm, TableData "Purch. Inv. Line" = rm, TableData "Purch. Cr. Memo Hdr." = rm, TableData "Purch. Cr. Memo Line" = rm;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type") { ApplicationArea = All; Editable = false; }
                field("No."; "No.") { ApplicationArea = All; Editable = false; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; Editable = false; }
                field("Sell-to Customer No."; "Sell-to Customer No.") { ApplicationArea = All; Editable = false; }
                field("Buy-from Vendor No."; "Buy-from Vendor No.") { ApplicationArea = All; Editable = false; }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name") { ApplicationArea = All; Editable = false; }
                field(ReverseTransaction; Correction) { ApplicationArea = All; Caption = 'Reverse Transaction'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetInvoices)
            {
                Caption = 'Get Invoices to Reverse';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    FPBuilder: FilterPageBuilder;
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    Clear(PurchInvHeader);
                    FPBuilder.AddRecord(InvoiceDocTxt, PurchInvHeader);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 3);
                    FPBuilder.AddFieldNo(InvoiceDocTxt, 20);
                    if FPBuilder.RunModal() then begin
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetView(FPBuilder.GetView(InvoiceDocTxt, false));
                        if PurchInvHeader.FindSet() then
                            repeat
                                Clear(Rec);
                                Rec.TransferFields(PurchInvHeader, false);
                                Rec."Document Type" := Rec."Document Type"::Invoice;
                                Rec."No." := PurchInvHeader."No.";
                                if Rec.Insert() then;
                            until PurchInvHeader.Next() = 0;
                    end;
                end;
            }

            action(ReverseDocuments)
            {
                Caption = 'Reverse Selected Documents';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostBatch;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    PurchHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    RecordsCount: Integer;
                    Progress: Dialog;
                    LoanNoLength: Integer;
                    LastSymbolOfLoanNo: Text;
                begin
                    Reset();
                    SetRange(Correction, true);
                    RecordsCount := 0;
                    Progress.Open(ProgressMsg);
                    if FindSet() then
                        repeat
                            RecordsCount := RecordsCount + 1;
                            Progress.Update(1, "No.");
                            if "Document Type" = "Document Type"::Invoice then begin
                                Clear(CopyDocumentMgt);
                                Clear(PurchHeader);
                                PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
                                PurchHeader.Insert(true);
                                CopyDocumentMgt.SetPropertiesForCreditMemoCorrection;
                                CopyDocumentMgt.CopyPurchDoc(7, "No.", PurchHeader);
                                PurchHeader."Vendor Cr. Memo No." := "Vendor Invoice No.";
                                PurchHeader.Modify();
                            end;
                        until Next() = 0;
                    Progress.Close();
                    DeleteAll();
                    Reset();
                    CurrPage.Update(false);
                    Message(CompleteMsg, RecordsCount);
                end;
            }
        }
    }

    var
        InvoiceDocTxt: Label 'Invoice Documents';
        ProgressMsg: Label 'Document #1#############';
        CompleteMsg: Label '%1 Documents were reversed';
}