report 14135154 lvngRemittanceReport
{
    Caption = 'Remittance Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135154.rdl';

    dataset
    {
        dataitem(CollectData; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";

            column(CompanyAddress_1_; CompanyAddress[1]) { }
            column(CompanyAddress_2_; CompanyAddress[2]) { }
            column(CompanyAddress_3_; CompanyAddress[3]) { }
            column(CompanyAddress_4_; CompanyAddress[4]) { }
            column(CompanyAddress_5_; CompanyAddress[5]) { }
            column(CompanyAddress_6_; CompanyAddress[6]) { }
            column(CompanyAddress_7_; CompanyAddress[7]) { }
            column(CompanyAddress_8_; CompanyAddress[8]) { }
            column(BuyFromAddress_1_; BuyFromAddress[1]) { }
            column(BuyFromAddress_2_; BuyFromAddress[2]) { }
            column(BuyFromAddress_3_; BuyFromAddress[3]) { }
            column(BuyFromAddress_4_; BuyFromAddress[4]) { }
            column(BuyFromAddress_5_; BuyFromAddress[5]) { }
            column(BuyFromAddress_6_; BuyFromAddress[6]) { }
            column(BuyFromAddress_7_; BuyFromAddress[7]) { }
            column(BuyFromAddress_8_; BuyFromAddress[8]) { }
            column(ToCaption; ToCaptionLbl) { }

            dataitem(HeaderLooper; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VendorNo; TempPurchaseHeaderBuffer."Pay-to Vendor No.") { }
                column(DocumentNo; TempPurchaseHeaderBuffer."No.") { }
                column(VendInvNo; TempPurchaseHeaderBuffer."Vendor Invoice No.") { }
                column(DocumentAmount; TempPurchaseHeaderBuffer."Document Total (Check)") { }
                column(DescriptionL; TempPurchaseHeaderBuffer."Posting Description") { }
                column(ExternalDocumentNo; TempPurchaseHeaderBuffer."Pay-to Contact") { }
                column(DueDate; Format(TempPurchaseHeaderBuffer."Document Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(VendorBankAccountNo; VendorBankAccountNo) { }
                column(VendorBankTransitNo; VendorBankTransitNo) { }

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
                    VendorBankAccount.Reset();
                    VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
                    VendorBankAccount.SetRange("Use for Electronic Payments", true);
                    if VendorBankAccount.FindFirst() then begin
                        VendorBankAccountNo := VendorBankAccount."Bank Account No.";
                        if StrLen(VendorBankAccountNo) > 5 then
                            VendorBankAccountNo := VendBankAcctNoTxt + CopyStr(VendorBankAccountNo, StrLen(VendorBankAccountNo) - 3);
                        VendorBankTransitNo := VendorBankAccount."Transit No.";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempPurchaseHeaderBuffer.DeleteAll();
                Clear(BuyFromAddress);
                DocumentFound := false;
                if "Applies-to Doc. No." <> '' then begin
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
                        if PurchInvHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchaseHeaderBuffer);
                            TempPurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                            TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                            TempPurchaseHeaderBuffer."Pay-to Contact" := TempPurchaseHeaderBuffer."Vendor Invoice No.";
                            TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                            TempPurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                            TempPurchaseHeaderBuffer.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchaseHeaderBuffer);
                            TempPurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                            TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                            TempPurchaseHeaderBuffer."Pay-to Contact" := TempPurchaseHeaderBuffer."Vendor Cr. Memo No.";
                            TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                            TempPurchaseHeaderBuffer."Document Total (Check)" := -CollectData."Amount (LCY)";
                            TempPurchaseHeaderBuffer.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if not DocumentFound then begin
                        Clear(TempPurchaseHeaderBuffer);
                        Vendor.Get(CollectData."Account No.");
                        TempPurchaseHeaderBuffer."No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                        TempPurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                        TempPurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                        TempPurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                        TempPurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                        TempPurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                        TempPurchaseHeaderBuffer.Insert();
                    end;
                end else begin
                    if "Applies-to ID" <> '' then begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID");
                        VendorLedgerEntry.SetRange("Vendor No.", "Account No.");
                        VendorLedgerEntry.SetRange("Applies-to ID", "Applies-to ID");
                        VendorLedgerEntry.SetFilter("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::Invoice, VendorLedgerEntry."Document Type"::"Credit Memo");
                        if VendorLedgerEntry.FindSet() then begin
                            repeat
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then begin
                                    if PurchInvHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := TempPurchaseHeaderBuffer."Vendor Invoice No.";
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        Vendor.Get(CollectData."Account No.");
                                        TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        TempPurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                                            TempPurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        TempPurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        TempPurchaseHeaderBuffer.Insert();
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        TempPurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeaderBuffer."Pay-to Contact" = '' then
                                            TempPurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        TempPurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        TempPurchaseHeaderBuffer.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(TempPurchaseHeaderBuffer);
                                        Vendor.Get(CollectData."Account No.");
                                        TempPurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        TempPurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                                        TempPurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                                        TempPurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                                        TempPurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                                            TempPurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        TempPurchaseHeaderBuffer.Insert();
                                    end;
                                end;
                            until VendorLedgerEntry.Next() = 0;
                        end;
                    end else begin
                        Clear(TempPurchaseHeaderBuffer);
                        Vendor.Get(CollectData."Account No.");
                        TempPurchaseHeaderBuffer."No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                        TempPurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                        TempPurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                        TempPurchaseHeaderBuffer."Document Type" := TempPurchaseHeaderBuffer."Document Type"::Invoice;
                        TempPurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                        TempPurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                        TempPurchaseHeaderBuffer."Pay-to Contact" := '';
                        TempPurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                        if TempPurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                            TempPurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                        end;
                        TempPurchaseHeaderBuffer.Insert();
                    end;
                end;
                FormatAddress.FormatAddr(
                    BuyFromAddress, TempPurchaseHeaderBuffer."Pay-to Name", TempPurchaseHeaderBuffer."Pay-to Name 2", TempPurchaseHeaderBuffer."Pay-to Contact", TempPurchaseHeaderBuffer."Pay-to Address", TempPurchaseHeaderBuffer."Pay-to Address 2",
                    TempPurchaseHeaderBuffer."Pay-to City", TempPurchaseHeaderBuffer."Pay-to Post Code", TempPurchaseHeaderBuffer."Pay-to County", TempPurchaseHeaderBuffer."Pay-to Country/Region Code");
            end;
        }
    }

    var
        ToCaptionLbl: Label 'To:';
        VendBankAcctNoTxt: Label 'XXXXXXXX';
        VendorBankAccount: Record "Vendor Bank Account";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        TempPurchaseHeaderBuffer: Record lvngPurchaseHeaderBuffer temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompanyInformation: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        DocNo: Integer;
        DocumentFound: Boolean;
        VendorName: Text;
        DescriptionL: Text[50];
        CompanyAddress: Array[8] of Text;
        BuyFromAddress: Array[8] of Text;
        VendorBankAccountNo: Text;
        VendorBankTransitNo: Text;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddress, CompanyInformation);
        CompanyAddress[6] := CompanyInformation."Phone No.";
        CompanyAddress[7] := CompanyInformation."Fax No.";
    end;
}