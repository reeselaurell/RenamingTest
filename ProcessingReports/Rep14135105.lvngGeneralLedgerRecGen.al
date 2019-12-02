report 14135105 lvngGeneralLedgerRecGen
{
    ProcessingOnly = true;
    Caption = 'General Ledger Reconciliation';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Date Filter";
            PrintOnlyIfDetail = true;

            trigger OnPreDataItem()
            var
                LoanSums: Query lvngGLEntriesByLoanSums;
            begin
                Clear(LoanSums);
                TempLoan.Reset();
                TempLoan.DeleteAll();
                LoanSums.SetFilter(GLAccountNoFilter, GLFilter);
                LoanSums.SetFilter(PostingDateFilter, DateFilter);
                LoanSums.SetFilter(LoanNoFilter, LoanNoFilter);
                LoanSums.Open();
                Counter := 1;
                while LoanSums.Read() do begin
                    if (LoanSums.DebitAmount <> 0) or (LoanSums.CreditAmount <> 0) then
                        if not HideZeroBalance or (LoanSums.DebitAmount <> LoanSums.CreditAmount) then begin
                            Clear(TempLoan);
                            TempLoan."Entry No." := Counter;
                            TempLoan."Loan No." := LoanSums.LoanNo;
                            TempLoan."Debit Amount" := LoanSums.DebitAmount;
                            TempLoan."Credit Amount" := LoanSums.CreditAmount;
                            TempLoan.Name := LoanSums.BorrowerFirstName + ' ' + LoanSums.BorrowerMiddleName + ' ' + LoanSums.BorrowerLastName;
                            TempLoan."Date Funded" := LoanSums.DateFunded;
                            TempLoan."Current Balance" := LoanSums.DebitAmount - LoanSums.CreditAmount;
                            TempLoan."G/L Account No." := LoanSums.GLAccount;
                            TempLoan."Date Filter" := DateFilter;
                            TempLoan."Date Sold" := LoanSums.DateSold;
                            if Customer.Get(LoanSums.InvestorCustomerNo) then
                                TempLoan."Investor Name" := Customer.Name;
                            TempLoan.Insert();
                        end;
                    Counter := Counter + 1;
                end;
                LoanSums.Close();
                if DisableMultipaySearch then begin
                    GLEntry.Reset();
                    GLEntry.SetFilter("G/L Account No.", GLFilter);
                    GLEntry.SetFilter("Posting Date", DateFilter);
                    GLEntry.SetRange("Loan No.", '');
                    if GLEntry.FindSet() then
                        repeat
                            if GLEntry."Document Type" = GLEntry."Document Type"::Payment then begin
                                VendorLedgerEntry.Reset();
                                VendorLedgerEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                                VendorLedgerEntry.SetRange("Document Type", GLEntry."Document Type");
                                VendorLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                                if VendorLedgerEntry.FindFirst() then
                                    if not VendorLedgerEntry.Open then begin
                                        DetVendLedgEntry.Reset();
                                        DetVendLedgEntry.SetRange("Applied Vend. Ledger Entry No.", VendorLedgerEntry."Entry No.");
                                        DetVendLedgEntry.SetRange("Entry Type", DetVendLedgEntry."Entry Type"::Application);
                                        DetVendLedgEntry.SetRange("Initial Document Type", DetVendLedgEntry."Initial Document Type"::Invoice);
                                        DetVendLedgEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                                        DetVendLedgEntry.SetRange("Document No.", VendorLedgerEntry."Document No.");
                                        DetVendLedgEntry.SetFilter("Vendor Ledger Entry No.", '<>%1', VendorLedgerEntry."Entry No.");
                                        DetVendLedgEntry.SetRange(Unapplied, false);
                                        if DetVendLedgEntry.FindSet() then
                                            repeat
                                                VendorLedgerEntry2.Get(DetVendLedgEntry."Vendor Ledger Entry No.");
                                                GLEntry2.Reset();
                                                GLEntry2.SetRange("Transaction No.", VendorLedgerEntry2."Transaction No.");
                                                GLEntry2.SetRange("Document Type", VendorLedgerEntry2."Document Type");
                                                GLEntry2.SetRange("Document No.", VendorLedgerEntry2."Document No.");
                                                if GLEntry.Amount > 0 then
                                                    GLEntry2.SetFilter(Amount, '<%1', 0)
                                                else
                                                    GLEntry2.SetFilter(Amount, '>%1', 0);
                                                if GLEntry2.FindSet() then
                                                    repeat
                                                        if GLEntry2."Loan No." <> '' then begin
                                                            TempLoan.Reset();
                                                            TempLoan.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                                                            TempLoan.SetRange("Loan No.", GLEntry2."Loan No.");
                                                            if TempLoan.FindFirst() then begin
                                                                TempLoan."Debit Amount" := TempLoan."Debit Amount" + GLEntry2."Credit Amount";
                                                                TempLoan."Credit Amount" := TempLoan."Credit Amount" + GLEntry2."Debit Amount";
                                                                TempLoan."Current Balance" := TempLoan."Debit Amount" - TempLoan."Credit Amount";
                                                                TempLoan."Invoice Ledger Entry No." := VendorLedgerEntry2."Entry No.";
                                                                TempLoan."Payment Ledger Entry No." := VendorLedgerEntry."Entry No.";
                                                                TempLoan."Includes Multi-Payment" := true;
                                                                TempLoan.Modify();
                                                            end else begin
                                                                Clear(TempLoan);
                                                                TempLoan."Entry No." := Counter;
                                                                TempLoan."Loan No." := GLEntry2."Loan No.";
                                                                TempLoan."Debit Amount" := GLEntry2."Credit Amount";
                                                                TempLoan."Credit Amount" := GLEntry2."Debit Amount";
                                                                TempLoan."Invoice Ledger Entry No." := VendorLedgerEntry2."Entry No.";
                                                                TempLoan."Payment Ledger Entry No." := VendorLedgerEntry."Entry No.";
                                                                TempLoan."Includes Multi-Payment" := true;
                                                                if Loan.Get(GLEntry2."Loan No.") then begin
                                                                    TempLoan.Name := Loan."Borrower First Name" + ' ' + Loan."Borrower Middle Name" + ' ' + Loan."Borrower Last Name";
                                                                    TempLoan."Date Funded" := Loan."Date Funded";
                                                                    TempLoan."Date Sold" := Loan."Date Sold";
                                                                    if Customer.Get(Loan."Investor Customer No.") then
                                                                        TempLoan."Investor Name" := Customer.Name;
                                                                end;
                                                                TempLoan."Current Balance" := TempLoan."Debit Amount" - TempLoan."Credit Amount";
                                                                TempLoan."G/L Account No." := GLEntry."G/L Account No.";
                                                                TempLoan."Date Filter" := DateFilter;
                                                                TempLoan.Insert();
                                                            end;
                                                            TempLoan.Reset();
                                                            TempLoan.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                                                            TempLoan.SetRange("Loan No.", '');
                                                            if TempLoan.FindFirst() then begin
                                                                TempLoan."Debit Amount" := TempLoan."Debit Amount" - GLEntry2."Credit Amount";
                                                                TempLoan."Credit Amount" := TempLoan."Credit Amount" - GLEntry2."Debit Amount";
                                                                TempLoan."Current Balance" := TempLoan."Debit Amount" - TempLoan."Credit Amount";
                                                                TempLoan.Modify();
                                                            end else begin
                                                                Counter := Counter + 1;
                                                                TempLoan."Entry No." := Counter;
                                                                TempLoan."Loan No." := '';
                                                                TempLoan."Debit Amount" := -GLEntry2."Credit Amount";
                                                                TempLoan."Credit Amount" := -GLEntry2."Debit Amount";
                                                                TempLoan."G/L Account No." := GLEntry."G/L Account No.";
                                                                TempLoan."Date Filter" := DateFilter;
                                                                TempLoan.Insert();
                                                            end;
                                                            Counter := Counter + 1;
                                                        end;
                                                    until GLEntry2.Next() = 0;
                                            until DetVendLedgEntry.Next() = 0;
                                    end;
                            end;
                            if GLEntry."Document Type" = GLEntry."Document Type"::Refund then;
                        until GLEntry.Next() = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break();
            end;
        }

        dataitem(Cycle; Integer)
        {
            DataItemTableView = sorting(Number);

            trigger OnPreDataItem()
            begin
                TempLoan.Reset();
                SetRange(Number, 1, TempLoan.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempLoan.FindSet()
                else
                    TempLoan.Next();
                LastTransaction := 0D;
                Clear(Loan);
                Clear(DefaultDimension);
                if TempLoan."Loan No." = '' then begin
                    TempLoan."Loan No." := BlankTxt;
                    TempLoan.Modify();
                end else begin
                    GLEntry.Reset();
                    GLEntry.SetCurrentKey("Loan No.", "Posting Date");
                    GLEntry.SetRange("G/L Account No.", TempLoan."G/L Account No.");
                    GLEntry.SetRange("Loan No.", TempLoan."Loan No.");
                    GLEntry.SetFilter("Posting Date", DateFilter);
                    if not GLEntry.IsEmpty() then begin
                        GLEntry.FindLast();
                        TempLoan."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                        TempLoan."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                        GLEntry.SetFilter("Global Dimension 2 Code", '<>%1', TempLoan."Shortcut Dimension 2 Code");
                        if not GLEntry.IsEmpty() then
                            TempLoan."Shortcut Dimension 2 Code" := MultipleTxt;
                        GLEntry.SetRange("Global Dimension 2 Code");
                        GLEntry.FindLast();
                        TempLoan."Last Transaction Date" := GLEntry."Posting Date";
                        TempLoan.Modify();
                    end;
                end;
                GLAccount.Get(TempLoan."G/L Account No.");
                if Loan.Get(TempLoan."Loan No.") then begin
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 3 Code" := DefaultDimension."Dimension Value Code";
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 4 Code" := DefaultDimension."Dimension Value Code";
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 5 Code" := DefaultDimension."Dimension Value Code";
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 6 Code" := DefaultDimension."Dimension Value Code";
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 7 Code" := DefaultDimension."Dimension Value Code";
                    DefaultDimension.Reset();
                    DefaultDimension.SetRange("Table ID", Database::lvngLoan);
                    DefaultDimension.SetRange("No.", TempLoan."Loan No.");
                    DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                    if DefaultDimension.FindFirst() then
                        TempLoan."Shortcut Dimension 8 Code" := DefaultDimension."Dimension Value Code";
                    TempLoan.Modify();
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
                    field(HideZeroBalance; HideZeroBalance) { Caption = 'Hide Zero Balance Entries'; ApplicationArea = All; }
                    field(DisableMultipaySearch; DisableMultipaySearch) { Caption = 'Disable Multipay Search'; ApplicationArea = All; }
                    field(LoanNoFilter; LoanNoFilter) { Caption = 'Loan No.'; ApplicationArea = All; TableRelation = lvngLoan; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            HideZeroBalance := true;
        end;
    }

    var
        DateFilterIsBlankErr: Label 'Date Filter can''t be blank';
        BlankTxt: Label 'BLANK';
        MultipleTxt: Label 'MULTIPLE';
        LoanSetup: Record lvngLoanVisionSetup;
        DefaultDimension: Record "Default Dimension";
        GLEntry: Record "G/L Entry";
        TempLoan: Record lvngGenLedgerReconcile temporary;
        GLSetup: Record "General Ledger Setup";
        Loan: Record lvngLoan;
        LoanValues: Record lvngLoanValue;
        GLAccount: Record "G/L Account";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GLEntry2: Record "G/L Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
        Customer: Record Customer;
        HideZeroBalance: Boolean;
        DisableMultipaySearch: Boolean;
        LastTransaction: Date;
        DateFilter: Text;
        Counter: Integer;
        GLFilter: Text;
        LoanNoFilter: Text;

    trigger OnPreReport()
    begin
        GLSetup.Get();
        if "G/L Account".GetFilter("Date Filter") = '' then
            Error(DateFilterIsBlankErr);
        DateFilter := "G/L Account".GetFilter("Date Filter");
        GLFilter := "G/L Account".GetFilter("No.");
        // LoanNoFilter := "G/L Account".GetFilter("Loan No. Filter");
    end;

    procedure GetDateFilter(): Text
    begin
        exit(DateFilter);
    end;

    procedure GetAccountNumber(): Text
    begin
        exit(GLFilter);
    end;

    procedure GetData(var CopyDataTo: Record lvngGenLedgerReconcile)
    begin
        TempLoan.Reset();
        if TempLoan.FindSet() then
            repeat
                CopyDataTo := TempLoan;
                CopyDataTo.Insert();
            until TempLoan.Next = 0;
    end;
}