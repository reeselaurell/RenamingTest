page 14135196 "lvnReversePurchaseDocuments"
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
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ReverseTransaction; Rec.Correction)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Transaction';
                }
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
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                    FPBuilder: FilterPageBuilder;
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
                    PurchHeader: Record "Purchase Header";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    RecordsCount: Integer;
                    Progress: Dialog;
                    PurchDocTypeFrom: Enum "Purchase Document Type From";
                begin
                    Rec.Reset();
                    Rec.SetRange(Correction, true);
                    RecordsCount := 0;
                    Progress.Open(ProgressMsg);
                    if Rec.FindSet() then
                        repeat
                            RecordsCount := RecordsCount + 1;
                            Progress.Update(1, Rec."No.");
                            if Rec."Document Type" = Rec."Document Type"::Invoice then begin
                                Clear(CopyDocumentMgt);
                                Clear(PurchHeader);
                                PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
                                PurchHeader.Insert(true);
                                CopyDocumentMgt.SetPropertiesForCreditMemoCorrection();
                                CopyDocumentMgt.CopyPurchDoc(PurchDocTypeFrom::"Posted Invoice", Rec."No.", PurchHeader);
                                PurchHeader."Vendor Cr. Memo No." := Rec."Vendor Invoice No.";
                                PurchHeader.Modify();
                            end;
                        until Rec.Next() = 0;
                    Progress.Close();
                    Rec.DeleteAll();
                    Rec.Reset();
                    CurrPage.Update(false);
                    Message(CompleteMsg, RecordsCount);
                end;
            }
        }
    }

    var
        InvoiceDocTxt: Label 'Invoice Documents';
        ProgressMsg: Label 'Document #1#############', Comment = '%1 = Document No.';
        CompleteMsg: Label '%1 Documents were reversed', Comment = '%1 = Document Count';
}