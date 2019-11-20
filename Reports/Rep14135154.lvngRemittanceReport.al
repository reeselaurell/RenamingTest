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
            column(ToCaption; Text001) { }
            dataitem(HeaderLooper; Integer)
            {
                DataItemTableView = sorting(Number);
                column(VendorNo; PurchaseHeaderBuffer."Pay-to Vendor No.") { }
                column(DocumentNo; PurchaseHeaderBuffer."No.") { }
                column(VendInvNo; PurchaseHeaderBuffer."Vendor Invoice No.") { }
                column(DocumentAmount; PurchaseHeaderBuffer."Document Total (Check)") { }
                column(DescriptionL; PurchaseHeaderBuffer."Posting Description") { }
                column(ExternalDocumentNo; PurchaseHeaderBuffer."Pay-to Contact") { }
                column(DueDate; format(PurchaseHeaderBuffer."Document Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(VendorBankAccountNo; VendorBankAccountNo) { }
                column(VendorBankTransitNo; VendorBankTransitNo) { }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, PurchaseHeaderBuffer.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        PurchaseHeaderBuffer.Find('-')
                    else
                        PurchaseHeaderBuffer.Next();
                    Vendor.Get(PurchaseHeaderBuffer."Pay-to Vendor No.");
                    VendorName := Vendor.Name;
                    VendorBankAccount.Reset();
                    VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
                    VendorBankAccount.SetRange("Use for Electronic Payments", true);
                    if VendorBankAccount.FindFirst() then begin
                        VendorBankAccountNo := VendorBankAccount."Bank Account No.";
                        if StrLen(VendorBankAccountNo) > 5 then begin
                            VendorBankAccountNo := Text002 + CopyStr(VendorBankAccountNo, StrLen(VendorBankAccountNo) - 3);
                        end;
                        VendorBankTransitNo := VendorBankAccount."Transit No.";
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                PurchaseHeaderBuffer.DeleteAll();
                Clear(BuyFromAddress);
                DocumentFound := false;
                if "Applies-to Doc. No." <> '' then begin
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
                        if PurchInvHeader.Get("Applies-to Doc. No.") then begin
                            Clear(PurchaseHeaderBuffer);
                            PurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                            Clear(PurchaseHeaderBuffer."Pay-to Contact");
                            PurchaseHeaderBuffer."Pay-to Contact" := PurchaseHeaderBuffer."Vendor Invoice No.";
                            PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                            PurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                            PurchaseHeaderBuffer.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(PurchaseHeaderBuffer);
                            PurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                            Clear(PurchaseHeaderBuffer."Pay-to Contact");
                            PurchaseHeaderBuffer."Pay-to Contact" := PurchaseHeaderBuffer."Vendor Cr. Memo No.";
                            PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                            PurchaseHeaderBuffer."Document Total (Check)" := -CollectData."Amount (LCY)";
                            PurchaseHeaderBuffer.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if not DocumentFound then begin
                        Clear(PurchaseHeaderBuffer);
                        Vendor.Get(CollectData."Account No.");
                        PurchaseHeaderBuffer."No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                        PurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                        PurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                        PurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                        PurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                        PurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                        PurchaseHeaderBuffer.Insert();
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
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer.TransferFields(PurchInvHeader);
                                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                                        PurchaseHeaderBuffer."Pay-to Contact" := PurchaseHeaderBuffer."Vendor Invoice No.";
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(PurchaseHeaderBuffer);
                                        Vendor.Get(CollectData."Account No.");
                                        PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        PurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                                        PurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if PurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                                            PurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        PurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        PurchaseHeaderBuffer.Insert();
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(PurchaseHeaderBuffer);
                                        PurchaseHeaderBuffer.TransferFields(PurchCrMemoHeader);
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                                        PurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if PurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                                            PurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        PurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::"Credit Memo";
                                        PurchaseHeaderBuffer.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(PurchaseHeaderBuffer);
                                        Vendor.Get(CollectData."Account No.");
                                        PurchaseHeaderBuffer."No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                                        PurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        PurchaseHeaderBuffer."Document Total (Check)" := -VendorLedgerEntry.Amount;
                                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                                        PurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                                        PurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                                        PurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                                        if PurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                                            PurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        PurchaseHeaderBuffer.Insert();
                                    end;
                                end;
                            until VendorLedgerEntry.Next() = 0;
                        end;
                    end else begin
                        Clear(PurchaseHeaderBuffer);
                        Vendor.Get(CollectData."Account No.");
                        PurchaseHeaderBuffer."No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Pay-to Vendor No." := CollectData."Account No.";
                        PurchaseHeaderBuffer."Pay-to Name" := Vendor.Name;
                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                        PurchaseHeaderBuffer."Vendor Invoice No." := CollectData."Document No.";
                        PurchaseHeaderBuffer."Document Total (Check)" := CollectData."Amount (LCY)";
                        PurchaseHeaderBuffer."Document Type" := PurchaseHeaderBuffer."Document Type"::Invoice;
                        PurchaseHeaderBuffer."Document Date" := CollectData."Document Date";
                        PurchaseHeaderBuffer."Posting Description" := CollectData.Description;
                        Clear(PurchaseHeaderBuffer."Pay-to Contact");
                        PurchaseHeaderBuffer."Pay-to Contact" := CollectData."External Document No.";
                        if PurchaseHeaderBuffer."Pay-to Contact" = '' then begin
                            PurchaseHeaderBuffer."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                        end;
                        PurchaseHeaderBuffer.Insert();
                    end;
                end;
                FormatAddress.FormatAddr(
                    BuyFromAddress, PurchaseHeaderBuffer."Pay-to Name", PurchaseHeaderBuffer."Pay-to Name 2", PurchaseHeaderBuffer."Pay-to Contact", PurchaseHeaderBuffer."Pay-to Address", PurchaseHeaderBuffer."Pay-to Address 2",
                    PurchaseHeaderBuffer."Pay-to City", PurchaseHeaderBuffer."Pay-to Post Code", PurchaseHeaderBuffer."Pay-to County", PurchaseHeaderBuffer."Pay-to Country/Region Code");
            end;
        }
    }

    requestpage
    {

    }
    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddress, CompanyInformation);
        CompanyAddress[6] := CompanyInformation."Phone No.";
        CompanyAddress[7] := CompanyInformation."Fax No.";
    end;

    var
        VendorBankAccount: Record "Vendor Bank Account";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        PurchaseHeaderBuffer: Record lvngPurchaseHeaderBuffer temporary;
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
        Text001: TextConst ENU = 'To:';
        Text002: TextConst ENU = 'XXXXXXXX';
}