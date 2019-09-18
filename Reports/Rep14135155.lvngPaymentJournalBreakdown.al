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
                            Clear(TempPurchHeader);
                            TempPurchHeader.TransferFields(PurchInvHeader);
                            TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::Invoice;
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindFirst() then begin
                                TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";//Amount;//PurchInvHeader."Amount Including VAT";
                            end else begin
                                TempPurchHeader.lvngDocumentTotalCheck := PurchInvHeader."Amount Including VAT";
                            end;
                            TempPurchHeader."Document Date" := "Due Date";
                            TempPurchHeader."Applies-to Doc. No." := "Document No.";
                            TempPurchHeader."Posting Description" := PurchInvHeader."Posting Description";
                            if TempPurchHeader.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(TempPurchHeader);
                                    TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::Invoice;
                                    TempPurchHeader."No." := VendorLedgerEntry."Document No.";
                                    TempPurchHeader."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchHeader."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";
                                    TempPurchHeader."Document Date" := VendorLedgerEntry."Due Date";
                                    TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                    TempPurchHeader."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                    if TempPurchHeader.Insert() then;
                                until VendorLedgerEntry.Next() = 0;
                            end;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchHeader);
                            TempPurchHeader.TransferFields(PurchCrMemoHeader);
                            TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::"Credit Memo";
                            TempPurchHeader.lvngDocumentTotalCheck := -PurchCrMemoHeader."Amount Including VAT";
                            TempPurchHeader."Applies-to Doc. No." := "Document No.";
                            TempPurchHeader."Document Date" := "Due Date";
                            TempPurchHeader."Posting Description" := PurchCrMemoHeader."Posting Description";
                            if TempPurchHeader.Insert() then;
                        end else begin
                            VendorLedgerEntry.Reset();
                            VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                            VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                            VendorLedgerEntry.SetRange("Document No.", "Applies-to Doc. No.");
                            if VendorLedgerEntry.FindSet() then begin
                                repeat
                                    Clear(TempPurchHeader);
                                    TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::"Credit Memo";
                                    TempPurchHeader."No." := VendorLedgerEntry."Document No.";
                                    TempPurchHeader."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchHeader."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                    TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                    VendorLedgerEntry.CalcFields(Amount);
                                    TempPurchHeader.lvngDocumentTotalCheck := -Amount;//-VendorLedgerEntry.Amount;
                                    TempPurchHeader."Document Date" := VendorLedgerEntry."Due Date";
                                    TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                    TempPurchHeader."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                    if TempPurchHeader.Insert() then;
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
                                        Clear(TempPurchHeader);
                                        TempPurchHeader.TransferFields(PurchInvHeader);
                                        TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";//Amount;//PurchInvHeader."Amount Including VAT";
                                        TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::Invoice;
                                        TempPurchHeader."Document Date" := "Due Date";
                                        TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                        TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                        if TempPurchHeader.Insert() then;
                                    end else begin
                                        Clear(TempPurchHeader);
                                        TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::Invoice;
                                        TempPurchHeader."No." := VendorLedgerEntry."Document No.";
                                        TempPurchHeader."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchHeader."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                        TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchHeader."Document Date" := VendorLedgerEntry."Due Date";
                                        TempPurchHeader."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        if TempPurchHeader.Insert() then;
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(TempPurchHeader);
                                        TempPurchHeader.TransferFields(PurchCrMemoHeader);
                                        TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";//Amount;//-PurchCrMemoHeader."Amount Including VAT";
                                        TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::"Credit Memo";
                                        TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                        TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchHeader."Document Date" := "Due Date";
                                        if TempPurchHeader.Insert() then;
                                    end else begin
                                        Clear(TempPurchHeader);
                                        TempPurchHeader."Document Type" := TempPurchHeader."Document Type"::"Credit Memo";
                                        TempPurchHeader."No." := VendorLedgerEntry."Document No.";
                                        TempPurchHeader."Buy-from Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchHeader."Pay-to Vendor No." := VendorLedgerEntry."Vendor No.";
                                        TempPurchHeader."Posting Description" := VendorLedgerEntry.Description;
                                        TempPurchHeader."Applies-to Doc. No." := "Document No.";
                                        TempPurchHeader."Vendor Invoice No." := VendorLedgerEntry."External Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchHeader.lvngDocumentTotalCheck := -VendorLedgerEntry."Amount to Apply";//Amount;//-VendorLedgerEntry.Amount;
                                        TempPurchHeader."Document Date" := VendorLedgerEntry."Due Date";
                                        if TempPurchHeader.Insert() then;
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
            column(VendorNo; TempPurchHeader."Pay-to Vendor No.")
            {

            }
            column(DocumentNo; TempPurchHeader."No.")
            {

            }
            column(DocumentAmount; TempPurchHeader.lvngDocumentTotalCheck)
            {

            }
            column(DueDate; TempPurchHeader."Document Date")
            {

            }
            column(VendorInvoiceNo; TempPurchHeader."Vendor Invoice No.")
            {

            }
            column(AppliesToDocNo; TempPurchHeader."Applies-to Doc. No.")
            {

            }
            column(PostingDescription; TempPurchHeader."Posting Description")
            {

            }
            column(VendorName; VendorName)
            {

            }
            column(ShowInvDet; ShowInvDet)
            {

            }
            column(ShowDet; ShowInvDetail)
            {

            }
            column(SHowCostDet; ShowGlCOstDetail)
            {

            }
            dataitem(LineLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(GLAccountNo; TempPurchLine."No.")
                {

                }
                column(CostCenter; TempPurchLine."Shortcut Dimension 1 Code")
                {

                }
                column(LineDescription; TempPurchLine.Description)
                {

                }
                column(LineAmount; TempPurchLine."Amount Including VAT")
                {

                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempPurchLine.COUNT);
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
                SetRange(Number, 1, TempPurchHeader.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    TempPurchHeader.Find('-');
                end else begin
                    TempPurchHeader.Next();
                end;
                Vendor.Get(TempPurchHeader."Pay-to Vendor No.");
                VendorName := Vendor.Name;
                TempPurchLine.Reset();
                TempPurchLine.DeleteAll();
                case TempPurchHeader."Document Type" of
                    TempPurchHeader."Document Type"::Invoice:
                        begin
                            if ShowGlCostDetail then begin
                                PurchInvLine.Reset();
                                PurchInvLine.SetRange("Document No.", TempPurchHeader."No.");
                                if PurchInvLine.FindSet() then begin
                                    repeat
                                        Clear(TempPurchLine);
                                        TempPurchLine.TransferFields(PurchInvLine);
                                        TempPurchLine.Insert();
                                    until PurchInvLine.Next() = 0;
                                end;
                            end else begin
                                Clear(TempPurchLine);
                                TempPurchLine.Description := TempPurchHeader."Posting Description";
                                TempPurchLine."Amount Including VAT" := TempPurchHeader.lvngDocumentTotalCheck;
                                TempPurchLine.Insert();
                            end;
                        end;
                    TempPurchHeader."Document Type"::"Credit Memo":
                        begin
                            if ShowGlCostDetail then begin
                                PurchCrMemoLine.Reset();
                                PurchCrMemoLine.SetRange("Document No.", TempPurchHeader."No.");
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
                                TempPurchLine.Description := TempPurchHeader."Posting Description";
                                TempPurchLine."Amount Including VAT" := TempPurchHeader.lvngDocumentTotalCheck;
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
        ShowInvDet: Option ,"Show Invoice Details","SHow G/L & Cost Detail";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Vendor: Record Vendor;
        VendorName: Text;
        TempPurchHeader: Record "Purchase Header" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ShowInvDetail: Boolean;
        ShowGlCostDetail: Boolean;

}