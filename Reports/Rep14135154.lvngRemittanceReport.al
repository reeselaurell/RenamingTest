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

            column(CompanyAddress_1_; CompanyAddress[1])
            {

            }
            column(CompanyAddress_2_; CompanyAddress[2])
            {

            }
            column(CompanyAddress_3_; CompanyAddress[3])
            {

            }
            column(CompanyAddress_4_; CompanyAddress[4])
            {

            }
            column(CompanyAddress_5_; CompanyAddress[5])
            {

            }
            column(CompanyAddress_6_; CompanyAddress[6])
            {

            }
            column(CompanyAddress_7_; CompanyAddress[7])
            {

            }
            column(CompanyAddress_8_; CompanyAddress[8])
            {

            }
            dataitem(HeaderLooper; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VendorNo; TempPurchaseHeader."Pay-to Vendor No.")
                {

                }
                column(DocumentNo; TempPurchaseHeader."No.")
                {

                }
                column(VendInvNo; TempPurchaseHeader."Vendor Invoice No.")
                {

                }
                column(DocumentAmount; TempPurchaseHeader.lvngDocumentTotalCheck)
                {

                }
                column(DescriptionL; TempPurchaseHeader."Posting Description")
                {

                }
                column(ExternalDocumentNo; TempPurchaseHeader."Pay-to Contact")
                {

                }
                column(DueDate; format(TempPurchaseHeader."Document Date", 0, '<Month,2>/<Day,2>/<Year4>'))
                {

                }
                column(VendorBankAccountNo; VendorBankAccountNo)
                {

                }
                column(VendorBankTransitNo; VendorBankTransitNo)
                {

                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempPurchaseHeader.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempPurchaseHeader.Find('-')
                    else
                        TempPurchaseHeader.Next();
                    Vendor.Get(TempPurchaseHeader."Pay-to Vendor No.");
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
                TempPurchaseHeader.DeleteAll();
                Clear(BuyFromAddress);
                DocumentFound := false;
                if "Applies-to Doc. No." <> '' then begin
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice then begin
                        if PurchInvHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchaseHeader);
                            TempPurchaseHeader.TransferFields(PurchInvHeader);
                            Clear(TempPurchaseHeader."Pay-to Contact");
                            TempPurchaseHeader."Pay-to Contact" := TempPurchaseHeader."Vendor Invoice No.";
                            TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                            TempPurchaseHeader.lvngDocumentTotalCheck := CollectData."Amount (LCY)";
                            TempPurchaseHeader.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if "Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo" then begin
                        if PurchCrMemoHeader.Get("Applies-to Doc. No.") then begin
                            Clear(TempPurchaseHeader);
                            TempPurchaseHeader.TransferFields(PurchCrMemoHeader);
                            Clear(TempPurchaseHeader."Pay-to Contact");
                            TempPurchaseHeader."Pay-to Contact" := TempPurchaseHeader."Vendor Cr. Memo No.";
                            TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::"Credit Memo";
                            TempPurchaseHeader.lvngDocumentTotalCheck := -CollectData."Amount (LCY)";
                            TempPurchaseHeader.Insert();
                            DocumentFound := true;
                        end;
                    end;
                    if NOT DocumentFound then begin
                        Clear(TempPurchaseHeader);
                        Vendor.Get(CollectData."Account No.");
                        TempPurchaseHeader."No." := CollectData."Document No.";
                        TempPurchaseHeader."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                        TempPurchaseHeader."Pay-to Name" := Vendor.Name;
                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                        TempPurchaseHeader."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeader.lvngDocumentTotalCheck := CollectData."Amount (LCY)";
                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                        TempPurchaseHeader."Document Date" := CollectData."Document Date";
                        Clear(TempPurchaseHeader."Pay-to Contact");
                        TempPurchaseHeader."Pay-to Contact" := CollectData."External Document No.";
                        TempPurchaseHeader."Posting Description" := CollectData.Description;
                        TempPurchaseHeader.Insert();
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
                                        Clear(TempPurchaseHeader);
                                        TempPurchaseHeader.TransferFields(PurchInvHeader);
                                        Clear(TempPurchaseHeader."Pay-to Contact");
                                        TempPurchaseHeader."Pay-to Contact" := TempPurchaseHeader."Vendor Invoice No.";
                                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeader.lvngDocumentTotalCheck := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                                        TempPurchaseHeader.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(TempPurchaseHeader);
                                        Vendor.Get(CollectData."Account No.");
                                        TempPurchaseHeader."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeader."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                                        TempPurchaseHeader."Pay-to Name" := Vendor.Name;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                                        TempPurchaseHeader."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeader.lvngDocumentTotalCheck := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                                        TempPurchaseHeader."Document Date" := CollectData."Document Date";
                                        Clear(TempPurchaseHeader."Pay-to Contact");
                                        TempPurchaseHeader."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeader."Pay-to Contact" = '' then begin
                                            TempPurchaseHeader."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        TempPurchaseHeader."Posting Description" := CollectData.Description;
                                        TempPurchaseHeader.Insert();
                                    end;
                                end;
                                if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then begin
                                    if PurchCrMemoHeader.Get(VendorLedgerEntry."Document No.") then begin
                                        Clear(TempPurchaseHeader);
                                        TempPurchaseHeader.TransferFields(PurchCrMemoHeader);
                                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                                        Clear(TempPurchaseHeader."Pay-to Contact");
                                        TempPurchaseHeader."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeader."Pay-to Contact" = '' then begin
                                            TempPurchaseHeader."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        TempPurchaseHeader."Posting Description" := CollectData.Description;
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeader.lvngDocumentTotalCheck := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::"Credit Memo";
                                        TempPurchaseHeader.Insert();
                                        DocumentFound := true;
                                    end else begin
                                        Clear(TempPurchaseHeader);
                                        Vendor.Get(CollectData."Account No.");
                                        TempPurchaseHeader."No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeader."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                                        TempPurchaseHeader."Pay-to Name" := Vendor.Name;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                                        TempPurchaseHeader."Vendor Invoice No." := VendorLedgerEntry."Document No.";
                                        VendorLedgerEntry.CalcFields(Amount);
                                        TempPurchaseHeader.lvngDocumentTotalCheck := -VendorLedgerEntry.Amount;
                                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                                        TempPurchaseHeader."Document Date" := CollectData."Document Date";
                                        TempPurchaseHeader."Posting Description" := CollectData.Description;
                                        Clear(TempPurchaseHeader."Pay-to Contact");
                                        TempPurchaseHeader."Pay-to Contact" := CollectData."External Document No.";
                                        if TempPurchaseHeader."Pay-to Contact" = '' then begin
                                            TempPurchaseHeader."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                                        end;
                                        TempPurchaseHeader.Insert();
                                    end;
                                end;
                            until VendorLedgerEntry.Next() = 0;
                        end;
                    end else begin
                        Clear(TempPurchaseHeader);
                        Vendor.Get(CollectData."Account No.");
                        TempPurchaseHeader."No." := CollectData."Document No.";
                        TempPurchaseHeader."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeader."Pay-to Vendor No." := CollectData."Account No.";
                        TempPurchaseHeader."Pay-to Name" := Vendor.Name;
                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                        TempPurchaseHeader."Vendor Invoice No." := CollectData."Document No.";
                        TempPurchaseHeader.lvngDocumentTotalCheck := CollectData."Amount (LCY)";
                        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Invoice;
                        TempPurchaseHeader."Document Date" := CollectData."Document Date";
                        TempPurchaseHeader."Posting Description" := CollectData.Description;
                        Clear(TempPurchaseHeader."Pay-to Contact");
                        TempPurchaseHeader."Pay-to Contact" := CollectData."External Document No.";
                        if TempPurchaseHeader."Pay-to Contact" = '' then begin
                            TempPurchaseHeader."Pay-to Contact" := VendorLedgerEntry."External Document No.";
                        end;
                        TempPurchaseHeader.Insert();
                    end;
                end;
                FormatAddress.FormatAddr(
                    BuyFromAddress, TempPurchaseHeader."Pay-to Name", TempPurchaseHeader."Pay-to Name 2", TempPurchaseHeader."Pay-to Contact", TempPurchaseHeader."Pay-to Address", TempPurchaseHeader."Pay-to Address 2",
                    TempPurchaseHeader."Pay-to City", TempPurchaseHeader."Pay-to Post Code", TempPurchaseHeader."Pay-to County", TempPurchaseHeader."Pay-to Country/Region Code");
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
        TempPurchaseHeader: Record "Purchase Header" temporary;
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