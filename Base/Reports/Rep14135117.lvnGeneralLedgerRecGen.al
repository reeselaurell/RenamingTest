report 14135117 "lvnGeneralLedgerRecGen"
{
    Caption = 'General Ledger Reconciliation';
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.", "Date Filter";
            PrintOnlyIfDetail = true;

            dataitem(Cycle; Integer)
            {
                DataItemTableView = sorting(Number);

                trigger OnPreDataItem()
                begin
                    TempGenRec.Reset();
                    SetRange(Number, 1, TempGenRec.COUNT);
                end;

                trigger OnAfterGetRecord()
                var
                    Loan: Record lvnLoan;
                    GLAccount: Record "G/L Account";
                begin
                    if Number = 1 then
                        TempGenRec.FindSet()
                    else
                        TempGenRec.Next();
                    LastTransaction := 0D;
                    Clear(Loan);
                    Clear(DefaultDimension);
                    if TempGenRec."Loan No." = '' then begin
                        TempGenRec."Loan No." := 'BLANK';
                        TempGenRec.Modify();
                    end else begin
                        GLEntry.Reset();
                        GLEntry.SetCurrentKey(lvnLoanNo, "Posting Date");
                        GLEntry.SetRange("G/L Account No.", TempGenRec."G/L Account No.");
                        GLEntry.SetRange(lvnLoanNo, TempGenRec."Loan No.");
                        GLEntry.SetFilter("Posting Date", DateFilter);
                        if not GLEntry.IsEmpty() then begin
                            GLEntry.FindLast();
                            TempGenRec."Shortcut Dimension 1" := GLEntry."Global Dimension 1 Code";
                            TempGenRec."Shortcut Dimension 2" := GLEntry."Global Dimension 2 Code";
                            GLEntry.SetFilter("Global Dimension 2 Code", '<>%1', TempGenRec."Shortcut Dimension 2");
                            if not GLEntry.IsEmpty() then
                                TempGenRec."Shortcut Dimension 2" := 'MULTIPLE';
                            GLEntry.SetRange("Global Dimension 2 Code");
                            GLEntry.FindLast();
                            TempGenRec."Last Transaction Date" := GLEntry."Posting Date";
                            TempGenRec.Modify();
                        end;
                    end;
                    GLAccount.Get(TempGenRec."G/L Account No.");
                    if Loan.Get(TempGenRec."Loan No.") then begin
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 3" := DefaultDimension."Dimension Value Code";
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 4" := DefaultDimension."Dimension Value Code";
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 5" := DefaultDimension."Dimension Value Code";
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 6" := DefaultDimension."Dimension Value Code";
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 7" := DefaultDimension."Dimension Value Code";
                        DefaultDimension.Reset();
                        DefaultDimension.SetRange("Table ID", Database::lvnLoan);
                        DefaultDimension.SetRange("No.", TempGenRec."Loan No.");
                        DefaultDimension.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                        if DefaultDimension.FindFirst() then
                            TempGenRec."Shortcut Dimension 8" := DefaultDimension."Dimension Value Code";
                        TempGenRec.Modify();
                    end;
                end;
            }

            trigger OnPreDataItem()
            var
                VendorLedgerEntry: Record "Vendor Ledger Entry";
                VendorLedgerEntry2: Record "Vendor Ledger Entry";
                DetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                Loan: Record lvnLoan;
                GLEntry2: Record "G/L Entry";
                Customer: Record Customer;
                Index: Integer;
            begin
                Clear(QuerySum);
                TempGenRec.Reset();
                TempGenRec.DeleteAll();
                QuerySum.SetFilter(GLAccountNoFilter, GLFilter);
                QuerySum.SetFilter(PostingDateFilter, DateFilter);
                QuerySum.SetFilter(LoanNoFilter, LoanNoFilter);
                QuerySum.Open();
                Index := 1;
                while QuerySum.Read() do
                    if (QuerySum.DebitAmount <> 0) or (QuerySum.CreditAmount <> 0) then begin
                        if HideZeroBalance then begin
                            if QuerySum.DebitAmount - QuerySum.CreditAmount <> 0 then begin
                                Clear(TempGenRec);
                                TempGenRec."Entry No." := Index;
                                TempGenRec."Loan No." := QuerySum.LoanNo;
                                TempGenRec."Debit Amount" := QuerySum.DebitAmount;
                                TempGenRec."Credit Amount" := QuerySum.CreditAmount;
                                TempGenRec.Name := QuerySum.BorrowerFirstName + ' ' + QuerySum.BorrowerMiddleName + ' ' + QuerySum.BorrowerLastName;
                                TempGenRec."Date Funded" := QuerySum.DateFunded;
                                TempGenRec."Current Balance" := QuerySum.DebitAmount - QuerySum.CreditAmount;
                                TempGenRec."G/L Account No." := QuerySum.GLAccount;
                                TempGenRec."Date Filter" := DateFilter;
                                TempGenRec."Date Sold" := QuerySum.DateSold;
                                if Customer.Get(QuerySum.InvestorCustomerNo) then
                                    TempGenRec."Investor Name" := Customer.Name;
                                TempGenRec.Insert();
                            end;
                        end else begin
                            Clear(TempGenRec);
                            TempGenRec."Entry No." := Index;
                            TempGenRec."Loan No." := QuerySum.LoanNo;
                            TempGenRec."Debit Amount" := QuerySum.DebitAmount;
                            TempGenRec."Credit Amount" := QuerySum.CreditAmount;
                            TempGenRec.Name := QuerySum.BorrowerFirstName + ' ' + QuerySum.BorrowerMiddleName + ' ' + QuerySum.BorrowerLastName;
                            TempGenRec."Date Funded" := QuerySum.DateFunded;
                            TempGenRec."Current Balance" := QuerySum.DebitAmount - QuerySum.CreditAmount;
                            TempGenRec."G/L Account No." := QuerySum.GLAccount;
                            TempGenRec."Date Filter" := DateFilter;
                            TempGenRec."Date Sold" := QuerySum.DateSold;
                            if Customer.Get(QuerySum.InvestorCustomerNo) then
                                TempGenRec."Investor Name" := Customer.Name;
                            TempGenRec.Insert();
                        end;
                        Index := Index + 1;
                    end;
                QuerySum.Close();
                if DisableMultipaySearch then begin
                    GLEntry.Reset();
                    GLEntry.SetFilter("G/L Account No.", GLFilter);
                    GLEntry.SetFilter("Posting Date", DateFilter);
                    GLEntry.SetRange(lvnLoanNo, '');
                    if GLEntry.FindSet() then
                        repeat
                            if GLEntry."Document Type" = GLEntry."Document Type"::Payment then begin
                                VendorLedgerEntry.Reset();
                                VendorLedgerEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                                VendorLedgerEntry.SetRange("Document Type", GLEntry."Document Type");
                                VendorLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                                if VendorLedgerEntry.FindSet() then
                                    if not VendorLedgerEntry.Open then begin
                                        DetVendLedgEntry.Reset();
                                        DetVendLedgEntry.SetRange("Applied Vend. Ledger Entry No.", VendorLedgerEntry."Entry No.");
                                        DetVendLedgEntry.SetRange("Entry Type", DetVendLedgEntry."Entry Type"::Application);
                                        DetVendLedgEntry.SetRange("Initial Document Type", DetVendLedgEntry."Initial Document Type"::Invoice);
                                        DetVendLedgEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                                        DetVendLedgEntry.SetRange("Document No.", VendorLedgerEntry."Document No.");
                                        DetVendLedgEntry.SetFilter("Vendor Ledger Entry No.", '<>%1', VendorLedgerEntry."Entry No.");
                                        DetVendLedgEntry.SetRange(Unapplied, false);
                                        DetVendLedgEntry.SetLoadFields("Vendor Ledger Entry No.");
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
                                                        if GLEntry2.lvnLoanNo <> '' then begin
                                                            TempGenRec.Reset();
                                                            TempGenRec.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                                                            TempGenRec.SetRange("Loan No.", GLEntry2.lvnLoanNo);
                                                            if TempGenRec.FindFirst() then begin
                                                                TempGenRec."Debit Amount" := TempGenRec."Debit Amount" + GLEntry2."Credit Amount";
                                                                TempGenRec."Credit Amount" := TempGenRec."Credit Amount" + GLEntry2."Debit Amount";
                                                                TempGenRec."Current Balance" := TempGenRec."Debit Amount" - TempGenRec."Credit Amount";
                                                                TempGenRec."Invoice Ledger Entry No." := VendorLedgerEntry2."Entry No.";
                                                                TempGenRec."Payment Ledger Entry No." := VendorLedgerEntry."Entry No.";
                                                                TempGenRec."Includes Multi-Payment" := true;
                                                                TempGenRec.Modify();
                                                            end else begin
                                                                Clear(TempGenRec);
                                                                TempGenRec."Entry No." := Index;
                                                                TempGenRec."Loan No." := GLEntry2.lvnLoanNo;
                                                                TempGenRec."Debit Amount" := GLEntry2."Credit Amount";
                                                                TempGenRec."Credit Amount" := GLEntry2."Debit Amount";
                                                                TempGenRec."Invoice Ledger Entry No." := VendorLedgerEntry2."Entry No.";
                                                                TempGenRec."Payment Ledger Entry No." := VendorLedgerEntry."Entry No.";
                                                                TempGenRec."Includes Multi-Payment" := true;
                                                                if Loan.Get(GLEntry2.lvnLoanNo) then begin
                                                                    TempGenRec.Name := lvnLoanManagement.GetBorrowerName(Loan);
                                                                    TempGenRec."Date Funded" := Loan."Date Funded";
                                                                    TempGenRec."Date Sold" := Loan."Date Sold";
                                                                    if Customer.Get(Loan."Investor Customer No.") then
                                                                        TempGenRec."Investor Name" := Customer.Name;
                                                                end;
                                                                TempGenRec."Current Balance" := TempGenRec."Debit Amount" - TempGenRec."Credit Amount";
                                                                TempGenRec."G/L Account No." := GLEntry."G/L Account No.";
                                                                TempGenRec."Date Filter" := DateFilter;
                                                                TempGenRec.Insert();
                                                            end;
                                                            TempGenRec.Reset();
                                                            TempGenRec.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                                                            TempGenRec.SetRange("Loan No.", '');
                                                            if TempGenRec.FindFirst() then begin
                                                                TempGenRec."Debit Amount" := TempGenRec."Debit Amount" - GLEntry2."Credit Amount";
                                                                TempGenRec."Credit Amount" := TempGenRec."Credit Amount" - GLEntry2."Debit Amount";
                                                                TempGenRec."Current Balance" := TempGenRec."Debit Amount" - TempGenRec."Credit Amount";
                                                                TempGenRec.Modify();
                                                            end else begin
                                                                Index := Index + 1;
                                                                TempGenRec."Entry No." := Index;
                                                                TempGenRec."Loan No." := '';
                                                                TempGenRec."Debit Amount" := -GLEntry2."Credit Amount";
                                                                TempGenRec."Credit Amount" := -GLEntry2."Debit Amount";
                                                                TempGenRec."Current Balance" := TempGenRec."Debit Amount" - TempGenRec."Credit Amount";
                                                                TempGenRec."G/L Account No." := GLEntry."G/L Account No.";
                                                                TempGenRec."Date Filter" := DateFilter;
                                                                TempGenRec.Insert();
                                                            end;
                                                            Index := Index + 1;
                                                        end;
                                                    until GLEntry2.Next() = 0;
                                            until DetVendLedgEntry.Next() = 0;
                                    end;
                            end;
                        until GLEntry.Next() = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break();
            end;
        }

        dataitem(LoanFilters; lvnLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
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
                    field(DisableMultiPaySearch; DisableMultiPaySearch) { Caption = 'Disable Multipay Search'; ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            HideZeroBalance := true;
        end;
    }

    var
        DateFilterErr: Label 'Please provide a date filter';
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        DefaultDimension: Record "Default Dimension";
        TempGenRec: Record lvnGenLedgerReconcile temporary;
        QuerySum: Query lvnGLEntriesByLoanSums;
        lvnLoanManagement: Codeunit lvnLoanManagement;
        DateFilter: Text;
        GLFilter: Text;
        LoanNoFilter: Text;
        DisableMultiPaySearch: Boolean;
        HideZeroBalance: Boolean;
        LastTransaction: Date;

    trigger OnPreReport()
    begin
        GLSetup.Get();
        if "G/L Account".GetFilter("Date Filter") = '' then
            Error(DateFilterErr);
        DateFilter := "G/L Account".GetFilter("Date Filter");
        GLFilter := "G/L Account".GetFilter("No.");
        LoanNoFilter := LoanFilters.GetFilter("No.");
    end;

    procedure GetDateFilter(): Text
    begin
        exit(DateFilter);
    end;

    procedure GetAccountNumber(): Text
    begin
        exit(GLFilter);
    end;

    procedure GetData(var CopyDataTo: Record lvnGenLedgerReconcile)
    begin
        TempGenRec.Reset();
        if TempGenRec.Findset() then
            repeat
                Clear(CopyDataTo);
                CopyDataTo := TempGenRec;
                CopyDataTo.Insert();
            until TempGenRec.Next() = 0;
    end;
}