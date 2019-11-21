report 14135155 lvngPaymentJournalBreakdown
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
                            Clear(TempPurchaseHeaderBuffer);
                            TempPurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                            TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindFirst() then
                                TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply"//Amount;//PurchInvHeader."Amount Including VAT";
                            else
                                TempPurchaseHeaderBuffer."Document Total (Check)" := PurchInvHeader."Amount Including VAT";

                            TempPurchaseHeaderBuffer."Document Date" := "Due Date";
                            TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                            TempPurchaseHeaderBuffer."Posting Description" := PurchInvHeader."Posting Description";
                            if TempPurchaseHeaderBuffer.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(TempPurchaseHeaderBuffer);
                                    TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                    TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                    TempPurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";
                                    TempPurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                    TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                    TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                    if TempPurchaseHeaderBuffer.Insert() then;
                                until VendorLedgerEntry.Next() = 0;
                            end;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchaseHeaderBuffer);
                            TempPurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                            TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                            TempPurchaseHeaderBuffer."Document Total (Check)" := -PurchCrMemoHeader."Amount Including VAT";
                            TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                            TempPurchaseHeaderBuffer."Document Date" := "Due Date";
                            TempPurchaseHeaderBuffer."Posting Description" := PurchCrMemoHeader."Posting Description";
                            if TempPurchaseHeaderBuffer.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(TempPurchaseHeaderBuffer);
                                    TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                    TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                    TempPurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    TempPurchaseHeaderBuffer."Document Total (Check)" := -Amount;//-VendorLedgerEntry.Amount;
                                    TempPurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                    TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                    TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    if TempPurchaseHeaderBuffer.Insert() then;
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
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//PurchInvHeader."Amount Including VAT";
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."Document Date" := "Due Date";
                                        TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        if TempPurchaseHeaderBuffer.Insert() then;
                                    end else begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        if TempPurchaseHeaderBuffer.Insert() then;
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-PurchCrMemoHeader."Amount Including VAT";
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchaseHeaderBuffer."Document Date" := "Due Date";
                                        if TempPurchaseHeaderBuffer.Insert() then;
                                    end else begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchaseHeaderBuffer."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchaseHeaderBuffer."Applies-to Doc. No." := "Document No.";
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Document Date" := VendorLedgerEntry."Due Date";
                                        if TempPurchaseHeaderBuffer.Insert() then;
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
            DataItemTableView = sorting(Number);

            column(VendorNo; TempPurchaseHeaderBuffer."Pay-to Vendor No.") { }
            column(DocumentNo; TempPurchaseHeaderBuffer."No.") { }
            column(DocumentAmount; TempPurchaseHeaderBuffer."Document Total (Check)") { }
            column(DueDate; TempPurchaseHeaderBuffer."Document Date") { }
            column(VendorInvoiceNo; TempPurchaseHeaderBuffer."Vendor Invoice No.") { }
            column(AppliesToDocNo; TempPurchaseHeaderBuffer."Applies-to Doc. No.") { }
            column(PostingDescription; TempPurchaseHeaderBuffer."Posting Description") { }
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
                        TempPurchLine.FindSet()
                    else
                        TempPurchLine.Next();
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, TempPurchaseHeaderBuffer.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempPurchaseHeaderBuffer.FindSet()
                else
                    TempPurchaseHeaderBuffer.Next();
                Vendor.Get(TempPurchaseHeaderBuffer."Pay-to Vendor No.");
                VendorName := Vendor.Name;
                TempPurchLine.Reset();
                TempPurchLine.DeleteAll();
                case TempPurchaseHeaderBuffer."Document Type" of
                    TempPurchaseHeaderBuffer."Document Type"::Invoice:
                        begin
                            if ShowGlCostDetail then begin
                                PurchInvLine.Reset();
                                PurchInvLine.SetRange("Document No.", TempPurchaseHeaderBuffer."No.");
                                if PurchInvLine.FindSet() then begin
                                    repeat
                                        Clear(TempPurchLine);
                                        TempPurchLine.TransferFields(PurchInvLine);
                                        TempPurchLine.Insert();
                                    until PurchInvLine.Next() = 0;
                                end;
                            end else begin
                                Clear(TempPurchLine);
                                TempPurchLine.Description := TempPurchaseHeaderBuffer."Posting Description";
                                TempPurchLine."Amount Including VAT" := TempPurchaseHeaderBuffer."Document Total (Check)";
                                TempPurchLine.Insert();
                            end;
                        end;
                    TempPurchaseHeaderBuffer."Document Type"::"Credit Memo":
                        begin
                            if ShowGlCostDetail then begin
                                PurchCrMemoLine.Reset();
                                PurchCrMemoLine.SetRange("Document No.", TempPurchaseHeaderBuffer."No.");
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
                                TempPurchLine.Description := TempPurchaseHeaderBuffer."Posting Description";
                                TempPurchLine."Amount Including VAT" := TempPurchaseHeaderBuffer."Document Total (Check)";
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
                    field(ShowInvDetail; ShowInvDetail)
                    {
                        Caption = 'Show Invoice Detail';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if not ShowInvDetail then
                                ShowGlCostDetail := false;
                        end;
                    }
                    field(ShowGlCostDetail; ShowGlCostDetail) { Caption = 'Show G/L & Cost Detail'; ApplicationArea = All; Editable = ShowInvDetail; }
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
        TempPurchaseHeaderBuffer: Record lvngPurchaseHeaderBuffer temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ShowInvDetail: Boolean;
        ShowGlCostDetail: Boolean;
}