xmlport 14135102 lvngPaymentsImport
{
    Caption = 'Payments Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';
    Permissions = tabledata "Vendor Ledger Entry" = rm;

    schema
    {
        textelement(Root)
        {
            tableelement(PaymentImportBuffer; lvngPaymentImportBuffer)
            {
                SourceTableView = sorting("Vendor No.", "Check No.", "Vendor Invoice No.");
                UseTemporary = true;

                fieldelement(CheckNo; PaymentImportBuffer."Check No.") { }
                fieldelement(PaymentDate; PaymentImportBuffer."Payment Date") { }
                fieldelement(VendorInvoiceNo; PaymentImportBuffer."Vendor Invoice No.") { }
                fieldelement(InvoiceAmount; PaymentImportBuffer."Invoice Amount") { }
                fieldelement(PaymentAmount; PaymentImportBuffer."Payment Amount") { }
                fieldelement(VendorNo; PaymentImportBuffer."Vendor No.") { }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameters)
                {
                    field(BankPaymentType; BankPaymentType) { Caption = 'Bank Payment Type'; ApplicationArea = All; }
                    field(BankAccountNo; BankAccountNo)
                    {
                        Caption = 'Bank Account No.';
                        ApplicationArea = All;
                        TableRelation = "Bank Account"."No.";

                        trigger OnValidate()
                        var
                            BankAccount: Record "Bank Account";
                        begin
                            BankAccount.Get(BankAccountNo);
                            BankAccountName := BankAccount.Name;
                        end;
                    }
                    field(BankAccountName; BankAccountName) { Caption = 'Bank Account Name'; ApplicationArea = All; Editable = false; }
                }
            }
        }
    }

    var
        CheckTotalAmountErr: Label 'Totals For Check %1 Amount %2 does not match invoices amount %3 for Vendor %4';
        TempChecksBuffer: Record lvngPaymentImportBuffer temporary;
        BankPaymentType: Enum lvngBankPaymentType;
        BankAccountNo: Code[20];
        BankAccountName: Text;
        JournalTemplate: Code[10];
        JournalBatch: Code[10];

    trigger OnPostXmlPort()
    begin
        PaymentImportBuffer.Reset();
        PaymentImportBuffer.FindSet();
        repeat
            Clear(TempChecksBuffer);
            if TempChecksBuffer.Get(PaymentImportBuffer."Vendor No.", PaymentImportBuffer."Check No.", '') then begin
                TempChecksBuffer."Invoice Amount" := TempChecksBuffer."Invoice Amount" + PaymentImportBuffer."Invoice Amount";
                TempChecksBuffer.Modify();
            end else begin
                Clear(TempChecksBuffer);
                TempChecksBuffer := PaymentImportBuffer;
                TempChecksBuffer."Vendor Invoice No." := '';
                TempChecksBuffer.Insert();
            end;
        until PaymentImportBuffer.Next() = 0;
        CreatePaymentJournal();
    end;

    procedure SetParams(pJournalTemplate: Code[10]; pJournalBatch: Code[10])
    begin
        JournalTemplate := pJournalTemplate;
        JournalBatch := pJournalBatch;
    end;

    local procedure CreatePaymentJournal()
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        LineNo: Integer;
        CompareAmount: Decimal;
    begin
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplate);
        GenJnlBatch.SetRange(Name, JournalBatch);
        GenJnlBatch.FindFirst();
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange(Name, GenJnlBatch."Journal Template Name");
        GenJnlTemplate.FindFirst();
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 1000
        else
            LineNo := 1000;
        TempChecksBuffer.Reset();
        TempChecksBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.Validate("Journal Template Name", GenJnlBatch."Journal Template Name");
            GenJnlLine.Validate("Journal Batch Name", GenJnlBatch.Name);
            GenJnlLine."Line No." := LineNo;
            LineNo := LineNo + 1000;
            GenJnlLine.Validate("Document Date", TempChecksBuffer."Payment Date");
            GenJnlLine.Validate("Posting Date", TempChecksBuffer."Payment Date");
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.Validate("Document No.", TempChecksBuffer."Check No.");
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.Validate("Account No.", TempChecksBuffer."Vendor No.");
            GenJnlLine.Validate(Amount, TempChecksBuffer."Payment Amount");
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.Validate("Bal. Account No.", BankAccountNo);
            GenJnlLine.Validate("Applies-to ID", GenJnlLine."Document No.");
            GenJnlLine.lvngDocumentGuid := CreateGuid();
            GenJnlLine.Validate("Bank Payment Type", BankPaymentType);
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.Insert(true);
            Clear(CompareAmount);
            PaymentImportBuffer.Reset();
            PaymentImportBuffer.SetRange("Vendor No.", TempChecksBuffer."Vendor No.");
            PaymentImportBuffer.SetRange("Check No.", TempChecksBuffer."Check No.");
            PaymentImportBuffer.FindSet();
            repeat
                VendLedgEntry.Reset();
                VendLedgEntry.SetRange("Vendor No.", TempChecksBuffer."Vendor No.");
                VendLedgEntry.SetRange("Document Type", VendLedgEntry."Document Type"::Invoice);
                VendLedgEntry.SetRange("External Document No.", PaymentImportBuffer."Vendor Invoice No.");
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.FindFirst();
                VendLedgEntry.Validate("Amount to Apply", -PaymentImportBuffer."Invoice Amount");
                VendLedgEntry.Validate("Applies-to ID", GenJnlLine."Applies-to ID");
                VendLedgEntry.Modify();
                CompareAmount := CompareAmount + PaymentImportBuffer."Invoice Amount";
            until PaymentImportBuffer.Next() = 0;
            if Abs(CompareAmount) <> Abs(TempChecksBuffer."Payment Amount") then
                Error(CheckTotalAmountErr, TempChecksBuffer."Check No.", TempChecksBuffer."Payment Amount", CompareAmount, TempChecksBuffer."Vendor No.");
        until TempChecksBuffer.Next() = 0;
    end;
}