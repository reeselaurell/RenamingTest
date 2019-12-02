report 14135157 lvngGLEntriesByLoanVer1
{
    Caption = 'G/L Entries By Loan Version 1';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135157.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting(lvngLoanNo) order(ascending);
            RequestFilterFields = lvngLoanNo, "Posting Date";

            trigger OnPreDataItem()
            begin
                if "G/L Entry".GetFilter(lvngLoanNo) = '' then
                    "G/L Entry".SetFilter(lvngLoanNo, '<>%1', '');
                if GuiAllowed() then begin
                    Progress.Open(ProcessingMsg);
                    Progress.Update(2, Count());
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(TempGLEntryBuffer);
                EntryNo := EntryNo + 1;
                TempGLEntryBuffer."Entry No." := EntryNo;
                TempGLEntryBuffer."Reference No." := Format(Counter);
                TempGLEntryBuffer."Payment Due Date" := "Posting Date";
                TempGLEntryBuffer."Document No." := "Document No.";
                TempGLEntryBuffer."Debit Amount" := "Debit Amount";
                TempGLEntryBuffer."Credit Amount" := "Credit Amount";
                TempGLEntryBuffer."Current Balance" := Amount;
                if "Source Type" = "Source Type"::Vendor then begin
                    Vendor.Get("Source No.");
                    SourceName := Vendor.Name;
                end;
                if "Source Type" = "Source Type"::Customer then begin
                    Customer.Get("Source No.");
                    SourceName := Customer.Name;
                end;
                TempGLEntryBuffer."Investor Name" := SourceName;
                TempGLEntryBuffer."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                TempGLEntryBuffer."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                TempGLEntryBuffer."Shortcut Dimension 3 Code" := lvngShortcutDimension3Code;
                TempGLEntryBuffer."Shortcut Dimension 4 Code" := lvngShortcutDimension4Code;
                TempGLEntryBuffer."Shortcut Dimension 5 Code" := lvngShortcutDimension5Code;
                TempGLEntryBuffer."Shortcut Dimension 6 Code" := lvngShortcutDimension6Code;
                TempGLEntryBuffer."Shortcut Dimension 7 Code" := lvngShortcutDimension7Code;
                TempGLEntryBuffer."Shortcut Dimension 8 Code" := lvngShortcutDimension8Code;
                TempGLEntryBuffer.Name := Description;
                TempGLEntryBuffer."Reason Code" := "Reason Code";
                TempGLEntryBuffer."External Document No." := "External Document No.";
                TempGLEntryBuffer."G/L Entry No." := "Entry No.";
                TempGLEntryBuffer."G/L Account No." := "G/L Account No.";
                TempGLEntryBuffer."Loan No." := lvngLoanNo;
                TempGLEntryBuffer.Insert();
                if not TempLoan.Get(LoanNo) then begin
                    if Loan.Get(LoanNo) then begin
                        TempLoan := Loan;
                        TempLoan."Loan Amount" := 0;
                        TempLoan."Commission Base Amount" := Amount;
                        TempLoan.Insert();
                    end else begin
                        Clear(TempLoan);
                        TempLoan."Commission Base Amount" := Amount;
                        TempLoan."No." := lvngLoanNo;
                        TempLoan.Insert();
                    end;
                end else begin
                    TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + Amount;
                    TempLoan.Modify();
                end;
                Clear(TempGLAccountLoanBuffer);
                TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                if TempGLAccountLoanBuffer.Insert() then begin
                    GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                    TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                    if MinDate <> 0D then begin
                        GLEntry.Reset();
                        GLEntry.SetCurrentKey(lvngLoanNo);
                        GLEntry.SetRange(lvngLoanNo, lvngLoanNo);
                        GLEntry.SetRange("Posting Date", 0D, MinDate);
                        GLEntry.SetRange("G/L Account No.", "G/L Account No.");
                        if GLEntry.FindSet() then
                            repeat
                                TempGLAccountLoanBuffer."Custom Decimal 1" := TempGLAccountLoanBuffer."Custom Decimal 1" + GLEntry.Amount;
                                TempLoan."Loan Amount" := TempLoan."Loan Amount" + GLEntry.Amount;
                            until GLEntry.Next() = 0;
                    end;
                    TempLoan.Modify();
                    TempGLAccountLoanBuffer.Modify();
                end;
                if "G/L Entry".GetFilter("G/L Account No.") = '' then begin
                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Document No.", "Document No.");
                    VendorLedgerEntry.SetRange("Document Type", "Document Type");
                    VendorLedgerEntry.SetRange("Transaction No.", "Transaction No.");
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            DetailedVendorLedgEntry.Reset();
                            DetailedVendorLedgEntry.SetRange("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            DetailedVendorLedgEntry.SetRange("Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);
                            if DetailedVendorLedgEntry.FindLast() then begin
                                AccountNo := '';
                                VendorLedgerEntry2.Get(DetailedVendorLedgEntry."Applied Vend. Ledger Entry No.");
                                if VendorLedgerEntry2."Bal. Account Type" = VendorLedgerEntry2."Bal. Account Type"::"Bank Account" then begin
                                    if BankAccount.Get(VendorLedgerEntry2."Bal. Account No.") then begin
                                        BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");
                                        AccountNo := BankAccountPostingGroup."G/L Account No.";
                                    end;
                                end else
                                    AccountNo := VendorLedgerEntry2."Bal. Account No.";
                                GLEntry.Reset();
                                GLEntry.SetRange("Transaction No.", DetailedVendorLedgEntry."Transaction No.");
                                GLEntry.SetRange("G/L Account No.", AccountNo);
                                if GLEntry.FindSet() then
                                    repeat
                                        with GLEntry do begin
                                            Clear(TempGLEntryBuffer);
                                            EntryNo := EntryNo + 1;
                                            TempGLEntryBuffer."Entry No." := EntryNo;
                                            TempGLEntryBuffer."Payment Due Date" := "Posting Date";
                                            TempGLEntryBuffer."Document No." := "Document No.";
                                            if "Source Type" = "Source Type"::Vendor then begin
                                                Vendor.Get("Source No.");
                                                SourceName := Vendor.Name;
                                            end;
                                            if "Source Type" = "Source Type"::Customer then begin
                                                Customer.Get("Source No.");
                                                SourceName := Customer.Name;
                                            end;
                                            TempGLEntryBuffer."Investor Name" := SourceName;
                                            TempGLEntryBuffer."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                            TempGLEntryBuffer."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                            TempGLEntryBuffer."Shortcut Dimension 3 Code" := lvngShortcutDimension3Code;
                                            TempGLEntryBuffer."Shortcut Dimension 4 Code" := lvngShortcutDimension4Code;
                                            TempGLEntryBuffer."Shortcut Dimension 5 Code" := lvngShortcutDimension5Code;
                                            TempGLEntryBuffer."Shortcut Dimension 6 Code" := lvngShortcutDimension6Code;
                                            TempGLEntryBuffer."Shortcut Dimension 7 Code" := lvngShortcutDimension7Code;
                                            TempGLEntryBuffer."Shortcut Dimension 8 Code" := lvngShortcutDimension8Code;
                                            TempGLEntryBuffer."Reference No." := Format(Counter);
                                            TempGLEntryBuffer.Name := Description;
                                            TempGLEntryBuffer."Reason Code" := "Reason Code";
                                            TempGLEntryBuffer."External Document No." := "External Document No.";
                                            TempGLEntryBuffer."G/L Entry No." := GLEntry."Entry No.";
                                            TempGLEntryBuffer."G/L Account No." := "G/L Account No.";
                                            TempGLEntryBuffer."Current Balance" := -"G/L Entry".Amount;
                                            if "G/L Entry"."Debit Amount" <> 0 then
                                                TempGLEntryBuffer."Credit Amount" := "G/L Entry"."Debit Amount"
                                            else
                                                TempGLEntryBuffer."Debit Amount" := "G/L Entry"."Credit Amount";
                                            TempGLEntryBuffer."Loan No." := "G/L Entry".lvngLoanNo;
                                            TempGLEntryBuffer.Insert();
                                            TempLoan.Modify();
                                        end;
                                        Clear(TempGLAccountLoanBuffer);
                                        TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                                        TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                                        if TempGLAccountLoanBuffer.Insert() then begin
                                            GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                                            TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                                            TempGLAccountLoanBuffer.Modify();
                                        end;
                                        GLEntry2.Reset();
                                        GLEntry2.SetRange(lvngLoanNo, '');
                                        GLEntry2.SetRange("Transaction No.", GLEntry."Transaction No.");
                                        GLEntry2.SetFilter("Entry No.", '<>%1', GLEntry."Entry No.");
                                        if GLEntry2.FindSet() then
                                            repeat
                                                Clear(TempGLEntryBuffer);
                                                EntryNo := EntryNo + 1;
                                                TempGLEntryBuffer."Entry No." := EntryNo;
                                                TempGLEntryBuffer."Payment Due Date" := GLEntry2."Posting Date";
                                                TempGLEntryBuffer."Document No." := GLEntry2."Document No.";
                                                if GLEntry2."Source Type" = "Source Type"::Vendor then begin
                                                    Vendor.Get("Source No.");
                                                    SourceName := Vendor.Name;
                                                end;
                                                if GLEntry2."Source Type" = "Source Type"::Customer then begin
                                                    Customer.Get("Source No.");
                                                    SourceName := Customer.Name;
                                                end;
                                                TempGLEntryBuffer."Investor Name" := SourceName;
                                                TempGLEntryBuffer."Shortcut Dimension 1 Code" := GLEntry2."Global Dimension 1 Code";
                                                TempGLEntryBuffer."Shortcut Dimension 2 Code" := GLEntry2."Global Dimension 2 Code";
                                                TempGLEntryBuffer."Shortcut Dimension 3 Code" := GLEntry2.lvngShortcutDimension3Code;
                                                TempGLEntryBuffer."Shortcut Dimension 4 Code" := GLEntry2.lvngShortcutDimension4Code;
                                                TempGLEntryBuffer."Shortcut Dimension 5 Code" := GLEntry2.lvngShortcutDimension5Code;
                                                TempGLEntryBuffer."Shortcut Dimension 6 Code" := GLEntry2.lvngShortcutDimension6Code;
                                                TempGLEntryBuffer."Shortcut Dimension 7 Code" := GLEntry2.lvngShortcutDimension7Code;
                                                TempGLEntryBuffer."Shortcut Dimension 8 Code" := GLEntry2.lvngShortcutDimension8Code;
                                                TempGLEntryBuffer."Reference No." := Format(Counter);
                                                TempGLEntryBuffer.Name := GLEntry2.Description;
                                                TempGLEntryBuffer."Reason Code" := GLEntry2."Reason Code";
                                                TempGLEntryBuffer."External Document No." := GLEntry2."External Document No.";
                                                TempGLEntryBuffer."G/L Entry No." := GLEntry2."Entry No.";
                                                TempGLEntryBuffer."G/L Account No." := GLEntry2."G/L Account No.";
                                                TempGLEntryBuffer."Current Balance" := -"G/L Entry".Amount;
                                                TempGLEntryBuffer."Debit Amount" := "G/L Entry"."Debit Amount";
                                                TempGLEntryBuffer."Credit Amount" := "G/L Entry"."Credit Amount";
                                                TempGLEntryBuffer."Loan No." := GLEntry.lvngLoanNo;
                                                TempGLEntryBuffer.Insert();
                                                TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGLEntryBuffer."Current Balance";
                                                Clear(TempGLAccountLoanBuffer);
                                                TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                                                TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                                                if TempGLAccountLoanBuffer.Insert() then begin
                                                    GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                                                    TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                                                    TempGLAccountLoanBuffer.Modify();
                                                end;
                                            until GLEntry2.Next() = 0;
                                    until GLEntry.Next() = 0;
                            end;
                        until VendorLedgerEntry.Next() = 0
                end;

                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("Document No.", "Document No.");
                CustLedgerEntry.SetRange("Document Type", "Document Type");
                CustLedgerEntry.SetRange("Transaction No.", "Transaction No.");
                if CustLedgerEntry.FindSet() then
                    repeat
                        DetailedCustLedgEntry.Reset();
                        DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
                        if DetailedCustLedgEntry.FindLast() then begin
                            AccountNo := '';
                            CustLedgerEntry2.Get(DetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                            if CustLedgerEntry2."Bal. Account Type" = CustLedgerEntry2."Bal. Account Type"::"Bank Account" then begin
                                BankAccount.Get(CustLedgerEntry2."Bal. Account No.");
                                BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");
                                AccountNo := BankAccountPostingGroup."G/L Account No.";
                            end else
                                AccountNo := CustLedgerEntry2."Bal. Account No.";
                            GLEntry.Reset();
                            GLEntry.SetRange("Transaction No.", DetailedCustLedgEntry."Transaction No.");
                            GLEntry.SetRange("G/L Account No.", AccountNo);
                            if GLEntry.FindSet() then
                                repeat
                                    with GLEntry do begin
                                        Clear(TempGLEntryBuffer);
                                        EntryNo := EntryNo + 1;
                                        TempGLEntryBuffer."Entry No." := EntryNo;
                                        TempGLEntryBuffer."Payment Due Date" := "Posting Date";
                                        TempGLEntryBuffer."Document No." := "Document No.";
                                        if "Source Type" = "Source Type"::Vendor then begin
                                            Vendor.Get("Source No.");
                                            SourceName := Vendor.Name;
                                        end;
                                        if "Source Type" = "Source Type"::Customer then begin
                                            Customer.Get("Source No.");
                                            SourceName := Customer.Name;
                                        end;
                                        TempGLEntryBuffer."Investor Name" := SourceName;
                                        TempGLEntryBuffer."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                        TempGLEntryBuffer."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                        TempGLEntryBuffer."Shortcut Dimension 3 Code" := lvngShortcutDimension3Code;
                                        TempGLEntryBuffer."Shortcut Dimension 4 Code" := lvngShortcutDimension4Code;
                                        TempGLEntryBuffer."Shortcut Dimension 5 Code" := lvngShortcutDimension5Code;
                                        TempGLEntryBuffer."Shortcut Dimension 6 Code" := lvngShortcutDimension6Code;
                                        TempGLEntryBuffer."Shortcut Dimension 7 Code" := lvngShortcutDimension7Code;
                                        TempGLEntryBuffer."Shortcut Dimension 8 Code" := lvngShortcutDimension8Code;
                                        TempGLEntryBuffer."Reference No." := Format(Counter);
                                        TempGLEntryBuffer.Name := Description;
                                        TempGLEntryBuffer."Reason Code" := "Reason Code";
                                        TempGLEntryBuffer."External Document No." := "External Document No.";
                                        TempGLEntryBuffer."G/L Entry No." := GLEntry."Entry No.";
                                        TempGLEntryBuffer."G/L Account No." := GLEntry."G/L Account No.";
                                        TempGLEntryBuffer."Current Balance" := -"G/L Entry".Amount;
                                        if GLEntry."Debit Amount" <> 0 then
                                            TempGLEntryBuffer."Credit Amount" := "G/L Entry"."Debit Amount"
                                        else
                                            TempGLEntryBuffer."Debit Amount" := "G/L Entry"."Credit Amount";
                                        TempGLEntryBuffer."Loan No." := "G/L Entry".lvngLoanNo;
                                        TempGLEntryBuffer.Insert();
                                        TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGLEntryBuffer."Current Balance";
                                        TempLoan.Modify();
                                    end;
                                    Clear(TempGLAccountLoanBuffer);
                                    TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                                    TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                                    if TempGLAccountLoanBuffer.Insert() then begin
                                        GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                                        TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                                        TempGLAccountLoanBuffer.Modify();
                                    end;
                                    GLEntry2.Reset();
                                    GLEntry2.SetRange(lvngLoanNo, '');
                                    GLEntry2.SetRange("Transaction No.", GLEntry."Transaction No.");
                                    GLEntry2.SetFilter("Entry No.", '<>%1', GLEntry."Entry No.");
                                    if GLEntry2.FindSet() then
                                        repeat
                                            Clear(TempGLEntryBuffer);
                                            EntryNo := EntryNo + 1;
                                            TempGLEntryBuffer."Entry No." := EntryNo;
                                            TempGLEntryBuffer."Payment Due Date" := GLEntry2."Posting Date";
                                            TempGLEntryBuffer."Document No." := GLEntry2."Document No.";
                                            if GLEntry2."Source Type" = "Source Type"::Vendor then begin
                                                Vendor.Get("Source No.");
                                                SourceName := Vendor.Name;
                                            end;
                                            if GLEntry2."Source Type" = "Source Type"::Customer then begin
                                                Customer.Get("Source No.");
                                                SourceName := Customer.Name;
                                            end;
                                            TempGLEntryBuffer."Investor Name" := SourceName;
                                            TempGLEntryBuffer."Shortcut Dimension 1 Code" := GLEntry2."Global Dimension 1 Code";
                                            TempGLEntryBuffer."Shortcut Dimension 2 Code" := GLEntry2."Global Dimension 2 Code";
                                            TempGLEntryBuffer."Shortcut Dimension 3 Code" := GLEntry2.lvngShortcutDimension3Code;
                                            TempGLEntryBuffer."Shortcut Dimension 4 Code" := GLEntry2.lvngShortcutDimension4Code;
                                            TempGLEntryBuffer."Shortcut Dimension 5 Code" := GLEntry2.lvngShortcutDimension5Code;
                                            TempGLEntryBuffer."Shortcut Dimension 6 Code" := GLEntry2.lvngShortcutDimension6Code;
                                            TempGLEntryBuffer."Shortcut Dimension 7 Code" := GLEntry2.lvngShortcutDimension7Code;
                                            TempGLEntryBuffer."Shortcut Dimension 8 Code" := GLEntry2.lvngShortcutDimension8Code;
                                            TempGLEntryBuffer."Reference No." := Format(Counter);
                                            TempGLEntryBuffer.Name := GLEntry2.Description;
                                            TempGLEntryBuffer."Reason Code" := GLEntry2."Reason Code";
                                            TempGLEntryBuffer."External Document No." := GLEntry2."External Document No.";
                                            TempGLEntryBuffer."G/L Entry No." := GLEntry2."Entry No.";
                                            TempGLEntryBuffer."G/L Account No." := GLEntry2."G/L Account No.";
                                            TempGLEntryBuffer."Current Balance" := -"G/L Entry".Amount;
                                            TempGLEntryBuffer."Credit Amount" := "G/L Entry"."Debit Amount";
                                            TempGLEntryBuffer."Debit Amount" := "G/L Entry"."Credit Amount";
                                            TempGLEntryBuffer."Loan No." := "G/L Entry".lvngLoanNo;
                                            TempGLEntryBuffer.Insert();
                                            TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGLEntryBuffer."Current Balance";
                                            Clear(TempGLAccountLoanBuffer);
                                            TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                                            TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                                            if TempGLAccountLoanBuffer.Insert() then begin
                                                GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                                                TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                                                TempGLAccountLoanBuffer.Modify();
                                            end;
                                        until GLEntry2.Next() = 0;
                                until GLEntry.Next() = 0;
                        end;
                    until CustLedgerEntry.Next() = 0;
                GLEntry2.Reset();
                GLEntry2.SetRange(lvngLoanNo, '');
                GLEntry2.SetRange("Transaction No.", "Transaction No.");
                GLEntry2.SetRange("Gen. Posting Type", "Gen. Posting Type"::" ");
                if GLEntry2.FindSet() then
                    repeat
                        Clear(TempGLEntryBuffer);
                        EntryNo := EntryNo + 1;
                        TempGLEntryBuffer."Entry No." := EntryNo;
                        TempGLEntryBuffer."Payment Due Date" := "Posting Date";
                        TempGLEntryBuffer."Document No." := "Document No.";
                        if "Source Type" = "Source Type"::Vendor then begin
                            Vendor.Get("Source No.");
                            SourceName := Vendor.Name;
                        end;
                        if "Source Type" = "Source Type"::Customer then begin
                            Customer.Get("Source No.");
                            SourceName := Customer.Name;
                        end;
                        TempGLEntryBuffer."Investor Name" := SourceName;
                        TempGLEntryBuffer."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        TempGLEntryBuffer."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        TempGLEntryBuffer."Shortcut Dimension 3 Code" := lvngShortcutDimension3Code;
                        TempGLEntryBuffer."Shortcut Dimension 4 Code" := lvngShortcutDimension4Code;
                        TempGLEntryBuffer."Shortcut Dimension 5 Code" := lvngShortcutDimension5Code;
                        TempGLEntryBuffer."Shortcut Dimension 6 Code" := lvngShortcutDimension6Code;
                        TempGLEntryBuffer."Shortcut Dimension 7 Code" := lvngShortcutDimension7Code;
                        TempGLEntryBuffer."Shortcut Dimension 8 Code" := lvngShortcutDimension8Code;
                        TempGLEntryBuffer."Reference No." := Format(Counter);
                        TempGLEntryBuffer.Name := GLEntry2.Description;
                        TempGLEntryBuffer."Reason Code" := GLEntry2."Reason Code";
                        TempGLEntryBuffer."External Document No." := GLEntry2."External Document No.";
                        TempGLEntryBuffer."G/L Entry No." := GLEntry2."Entry No.";
                        TempGLEntryBuffer."G/L Account No." := GLEntry2."G/L Account No.";
                        TempGLEntryBuffer."Current Balance" := -"G/L Entry".Amount;
                        if GLEntry."Credit Amount" = 0 then
                            TempGLEntryBuffer."Credit Amount" := "G/L Entry"."Debit Amount"
                        else
                            TempGLEntryBuffer."Debit Amount" := "G/L Entry"."Credit Amount";
                        TempGLEntryBuffer."Loan No." := "G/L Entry".lvngLoanNo;
                        TempGLEntryBuffer.Insert();
                        TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGLEntryBuffer."Current Balance";
                        Clear(TempGLAccountLoanBuffer);
                        TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                        TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                        if TempGLAccountLoanBuffer.Insert() then begin
                            GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                            TempGLAccountLoanBuffer."Custom Text 1" := GLAccount.Name;
                            TempGLAccountLoanBuffer.Modify();
                        end;
                    until GLEntry2.Next() = 0;

                TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGLEntryBuffer."Current Balance";
                TempLoan.Modify();
                Counter := Counter + 1;
                if GuiAllowed then
                    Progress.Update(1, Counter);
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed() then
                    Progress.Close();
            end;
        }

        dataitem(LoanNo; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; CompanyInformation.Name) { }
            column(ReportFilters; Filters) { }
            column(LoanNo; TempLoan."No.") { }
            column(BorrowerFirstName; TempLoan."Borrower First Name") { }
            column(BorrowerMiddleName; TempLoan."Borrower Middle Name") { }
            column(BorrowerLastName; TempLoan."Borrower Last Name") { }
            column(LoanBalanceStart; TempLoan."Loan Amount") { }

            dataitem(GLAccountLoanNo; Integer)
            {
                DataItemTableView = sorting(Number);

                column(GLAccountNo; TempGLAccountLoanBuffer."View Code") { }
                column(BeginningBalance; TempGLAccountLoanBuffer."Custom Decimal 1") { }
                column(AccountName; TempGLAccountLoanBuffer."Custom Text 1") { }

                dataitem(GLEntries; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(PostingDate; TempGLEntryBuffer."Payment Due Date") { }
                    column(Description; Description) { }
                    column(Amount; TempGLEntryBuffer."Current Balance") { }
                    column(DebitAmount; TempGLEntryBuffer."Debit Amount") { }
                    column(CreditAmount; TempGLEntryBuffer."Credit Amount") { }
                    column(ReasonCode; TempGLEntryBuffer."Reason Code") { }
                    column(DocumentNo; TempGLEntryBuffer."Document No.") { }
                    column(ExternalDocumentNo; TempGLEntryBuffer."External Document No.") { }
                    column(ReferenceNo; TempGLEntryBuffer."Reference No.") { }
                    column(CostCenter; CostCenter) { }

                    trigger OnPreDataItem()
                    begin
                        TempGLEntryBuffer.Reset();
                        TempGLEntryBuffer.SetRange("G/L Account No.", TempGLAccountLoanBuffer."View Code");
                        TempGLEntryBuffer.SetRange("Loan No.", TempGLAccountLoanBuffer."Loan No.");
                        SetRange(Number, 1, TempGLEntryBuffer.Count());
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempGLEntryBuffer.FindSet()
                        else
                            TempGLEntryBuffer.Next();
                        case DimensionNo of
                            1:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 1 Code";
                            2:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 2 Code";
                            3:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 3 Code";
                            4:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 4 Code";
                            5:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 5 Code";
                            6:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 6 Code";
                            7:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 7 Code";
                            8:
                                CostCenter := TempGLEntryBuffer."Shortcut Dimension 8 Code";
                        end;
                        if TempGLEntryBuffer."Investor Name" <> '' then
                            Description := TempGLEntryBuffer."Investor Name" + ' | ' + TempGLEntryBuffer.Name
                        else
                            Description := TempGLEntryBuffer.Name;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    TempGLAccountLoanBuffer.Reset();
                    TempGLAccountLoanBuffer.SetRange("Loan No.", TempLoan."No.");
                    SetRange(Number, 1, TempGLAccountLoanBuffer.Count());
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempGLAccountLoanBuffer.FindSet()
                    else
                        TempGLAccountLoanBuffer.Next();
                end;
            }

            trigger OnPreDataItem()
            begin
                TempLoan.Reset();
                SetRange(Number, 1, TempLoan.Count());
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempLoan.FindSet()
                else
                    TempLoan.Next();
            end;
        }
    }

    var
        NoFilterErr: Label 'Please define Date or Loan No. filter';
        ProcessingMsg: Label 'Processing entries #1####### of #2########';
        TempGLEntryBuffer: Record lvngGLEntryBuffer temporary;
        Loan: Record lvngLoan;
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        TempLoan: Record lvngLoan temporary;
        TempGLAccountLoanBuffer: Record lvngGLAccountLoanBuffer temporary;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CompanyInformation: Record "Company Information";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Progress: Dialog;
        Counter: Integer;
        MinDate: Date;
        DimensionNo: Integer;
        CostCenter: Code[20];
        AccountNo: Code[20];
        EntryNo: Integer;
        Description: Text;
        Filters: Text;
        SourceName: Text;

    trigger OnPreReport()
    begin
        LoanVisionSetup.Get();
        GLSetup.Get();
        CompanyInformation.Get();
        Filters := "G/L Entry".GetFilters;
        if LoanVisionSetup."Cost Center Dimension Code" <> '' then
            case LoanVisionSetup."Cost Center Dimension Code" of
                GLSetup."Shortcut Dimension 1 Code":
                    DimensionNo := 1;
                GLSetup."Shortcut Dimension 2 Code":
                    DimensionNo := 2;
                GLSetup."Shortcut Dimension 3 Code":
                    DimensionNo := 3;
                GLSetup."Shortcut Dimension 4 Code":
                    DimensionNo := 4;
                GLSetup."Shortcut Dimension 5 Code":
                    DimensionNo := 5;
                GLSetup."Shortcut Dimension 6 Code":
                    DimensionNo := 6;
                GLSetup."Shortcut Dimension 7 Code":
                    DimensionNo := 7;
                GLSetup."Shortcut Dimension 8 Code":
                    DimensionNo := 8;
            end;
        if "G/L Entry".GetFilters = '' then
            Error(NoFilterErr);
        if "G/L Entry".GetFilter("Posting Date") <> '' then
            MinDate := "G/L Entry".GetRangeMin("Posting Date") - 1;
    end;
}