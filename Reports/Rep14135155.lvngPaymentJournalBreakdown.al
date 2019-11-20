report 14135155 "lvngPaymentJournalBreakdown"
{
    Caption = 'Payment Journal Breakdown';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135155.rdl';
    dataset
    {
        dataitem(CollectData; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            trigger OnAfterGetRecord()
            begin
                if "Applies-to Doc. No." <> '' then begin
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
                        if PurchInvHeader.Get("Applies-to Doc. No.") then begin
                            Clear(PurchaseHeaderBuffer);
                            PurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                            PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindFirst() then begin
                                PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//PurchInvHeader."Amount Including VAT";
                            end else begin
                                PurchaseHeaderBuffer."Document Total (Check)" := PurchInvHeader."Amount Including VAT";
                            end;
                            PurchaseHeaderBuffer."Document Date" := "Due Date";
                            PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                            PurchaseHeaderBuffer."Posting Description" := PurchInvHeader."Posting Description";
                            if PurchaseHeaderBuffer.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(PurchaseHeaderBuffer);
                                    PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                    PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                    PurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    PurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";
                                    PurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                    PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                    PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                    if PurchaseHeaderBuffer.Insert() then;
                                until VendorLedgerEntry.Next() = 0;
                            end;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(PurchaseHeaderBuffer);
                            PurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                            PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                            PurchaseHeaderBuffer."Document Total (Check)" := -PurchCrMemoHeader."Amount Including VAT";
                            PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                            PurchaseHeaderBuffer."Document Date" := "Due Date";
                            PurchaseHeaderBuffer."Posting Description" := PurchCrMemoHeader."Posting Description";
                            if PurchaseHeaderBuffer.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(PurchaseHeaderBuffer);
                                    PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                    PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                    PurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    PurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    PurchaseHeaderBuffer."Document Total (Check)" := -Amount;//-VendorLedgerEntry.Amount;
                                    PurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                    PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                    PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    if PurchaseHeaderBuffer.Insert() then;
                                until VendorLedgerEntry.Next() = 0;
                            end;
                        end;
                    end;
                end else begin
                    if "Applies-to ID" <> '' then begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                        VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                        VendorLedgerEntry.SetRange("Applies-to ID", "Applies-to ID");
                        if VendorLedgerEntry.FindSet() then begin
                            repeat
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then begin
                                    if PurchInvHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//PurchInvHeader."Amount Including VAT";
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."Document Date" := "Due Date";
                                        PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        if PurchaseHeaderBuffer.Insert() then;
                                    end else begin
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        PurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        if PurchaseHeaderBuffer.Insert() then;
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-PurchCrMemoHeader."Amount Including VAT";
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        PurchaseHeaderBuffer."Document Date" := "Due Date";
                                        if PurchaseHeaderBuffer.Insert() then;
                                    end else begin
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        PurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        PurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                        if PurchaseHeaderBuffer.Insert() then;
                                    end;
                                end;
                            until VendorLedgerEntry.Next() = 0;
                        end;
                    end;
                end;
            end;
        }
        dataitem(HeaderLoop; Integer)
        {
            DataItemTableView = Sorting(Number);
            column(VendorNo; PurchaseHeaderBuffer."Pay-to Vendor No.") { }
            column(DocumentNo; PurchaseHeaderBuffer."No.") { }
            column(DocumentAmount; PurchaseHeaderBuffer."Document Total (Check)") { }
            column(DueDate; PurchaseHeaderBuffer."Document Date") { }
            column(VendorInvoiceNo; PurchaseHeaderBuffer."Vendor Invoice No.") { }
            column(AppliesToDocNo; PurchaseHeaderBuffer."Applies-to Doc. No.") { }
            column(PostingDescription; PurchaseHeaderBuffer."Posting Description") { }
            column(VendorName; VendorName) { }
            column(ShowInvDet; ShowInvDet) { }
            column(ShowDet; ShowInvDetail) { }
            column(ShowCostDet; ShowGlCostDetail) { }
            dataitem(LineLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(GLAccountNo; TempPurchLine."No.") { }
                column(CostCenter; TempPurchLine."Shortcut Dimension 1 Code") { }
                column(LineDescription; TempPurchLine.Description) { }
                column(LineAmount; TempPurchLine."Amount Including VAT") { }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempPurchLine.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempPurchLine.Find('-')
                    else
                        TempPurchLine.Next();
                end;
            }
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, PurchaseHeaderBuffer.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    PurchaseHeaderBuffer.Find('-');
                end else begin
                    PurchaseHeaderBuffer.Next();
                end;
                Vendor.Get(PurchaseHeaderBuffer."Pay-to Vendor No.");
                VendorName := Vendor.Name;
                TempPurchLine.Reset();
                TempPurchLine.DeleteAll();
                case PurchaseHeaderBuffer."Document Type" of
                    PurchaseHeaderBuffer."Document Type"::Invoice:
                        begin
                            if ShowGlCostDetail then begin
                                PurchInvLine.Reset();
                                PurchInvLine.SetRange("Document No.", PurchaseHeaderBuffer."No.");
                                if PurchInvLine.FindSet() then begin
                                    repeat
                                        Clear(TempPurchLine);
                                        TempPurchLine.TransferFields(PurchInvLine);
                                        TempPurchLine.Insert();
                                    until PurchInvLine.Next() = 0;
                                end;
                            end else begin
                                Clear(TempPurchLine);
                                TempPurchLine.Description := PurchaseHeaderBuffer."Posting Description";
                                TempPurchLine."Amount Including VAT" := PurchaseHeaderBuffer."Document Total (Check)";
                                TempPurchLine.Insert();
                            end;
                        end;
                    PurchaseHeaderBuffer."Document Type"::"Credit Memo":
                        begin
                            if ShowGlCostDetail then begin
                                PurchCrMemoLine.Reset();
                                PurchCrMemoLine.SetRange("Document No.", PurchaseHeaderBuffer."No.");
                                if PurchCrMemoLine.FindSet() then begin
                                    repeat
                                        Clear(TempPurchLine);
                                        TempPurchLine.TransferFields(PurchCrMemoLine);
                                        TempPurchLine."Line Amount" := -TempPurchLine."Line Amount";
                                        TempPurchLine.Insert();
                                    until PurchCrMemoLine.Next() = 0;
                                end;
                            end else begin
                                Clear(TempPurchLine);
                                TempPurchLine.Description := PurchaseHeaderBuffer."Posting Description";
                                TempPurchLine."Amount Including VAT" := PurchaseHeaderBuffer."Document Total (Check)";
                                TempPurchLine.Insert();
                            end;
                        end;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowInvDetail; ShowInvDetail)
                    {
                        Caption = 'Show Invoice Detail';
                        trigger OnValidate()
                        begin
                            if not ShowInvDetail then
                                ShowGlCostDetail := false;
                        end;
                    }
                    field(ShowGlCostDetail; ShowGlCostDetail)
                    {
                        Caption = 'Show G/L & Cost Detail';
                        Editable = ShowInvDetail;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            if not ShowInvDetail then
                ShowGlCostDetail := false;
            ShowInvDetail := true;
            ShowGlCostDetail := false;
        end;
    }
    var
        ShowInvDet: Option ,"Show Invoice Details","Show G/L & Cost Detail";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Vendor: Record Vendor;
        VendorName: Text;
        PurchaseHeaderBuffer: Record lvngPurchaseHeaderBuffer temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ShowInvDetail: Boolean;
        ShowGlCostDetail: Boolean;
}