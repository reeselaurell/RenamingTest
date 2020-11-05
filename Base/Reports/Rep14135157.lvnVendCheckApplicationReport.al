report 14135157 "lvnVendCheckApplicationReport"
{
    Caption = 'Vendor Check Application Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135157.rdl';

    dataset
    {
        dataitem("Check Ledger Entry"; "Check Ledger Entry")
        {
            DataItemTableView = sorting("Bank Account No.", "Check Date") where("Entry Status" = filter(<> Voided & <> "Financially Voided"), "Document Type" = const(Payment));
            RequestFilterFields = "Bank Account No.", "Posting Date", "Check Date", "Check No.";

            column(Filters; GetFilters())
            {
            }
            column(CheckNo; "Check No.")
            {
            }
            column(CheckDate; "Check Date")
            {
            }
            column(CheckAmount; Amount)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                DataItemLink = "Entry No." = field("Bank Account Ledger Entry No.");

                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemTableView = sorting("Entry No.");
                    DataItemLink = "Posting Date" = field("Posting Date"), "Document No." = field("Document No."), "Document Type" = field("Document Type");

                    dataitem(AppliedLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(LoanNo; TempVendLedgerEntry.lvnLoanNo)
                        {
                        }
                        column(BorrowerName; BorrowerName)
                        {
                        }
                        column(DocumentNo; TempVendLedgerEntry."Document No.")
                        {
                        }
                        column(ExternalDocNo; TempVendLedgerEntry."External Document No.")
                        {
                        }
                        column(PostingDate; TempVendLedgerEntry."Posting Date")
                        {
                        }
                        column(Amount; -TempVendLedgerEntry.Amount)
                        {
                        }
                        column(PaidAmount; TempVendLedgerEntry."Closed by Amount")
                        {
                        }
                        column(VendorName; VendorName)
                        {
                        }
                        column(HideCheckSummaryGroup; HideCheckSummaryGroup)
                        {
                        }
                        dataitem(LoanDetails; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            column(LineLoanNo; TempPurchInvLine.lvnLoanNo)
                            {
                            }
                            column(Dimension1Code; TempPurchInvLine."Shortcut Dimension 1 Code")
                            {
                            }
                            column(Dimension2Code; TempPurchInvLine."Shortcut Dimension 2 Code")
                            {
                            }
                            column(LineAmount; TempPurchInvLine.Amount)
                            {
                            }
                            column(LineBorrowerName; LineBorrowerName)
                            {
                            }
                            column(GLAccountNo; TempPurchInvLine."No.")
                            {
                            }
                            column(Description; TempPurchInvLine.Description)
                            {
                            }
                            column(HideDocumentDetails; HideDocumentDetails)
                            {
                            }
                            trigger OnPreDataItem()
                            begin
                                SetRange(Number, 1, TempPurchInvLine.Count());
                            end;

                            trigger OnAfterGetRecord()
                            var
                                Loan: Record lvnLoan;
                            begin
                                if Number = 1 then
                                    TempPurchInvLine.FindSet()
                                else
                                    TempPurchInvLine.Next();
                                LineBorrowerName := '';
                                if Loan.Get(TempPurchInvLine."No.") then
                                    LineBorrowerName := lvnLoanManagement.GetBorrowerName(Loan);
                                if Number > 1 then
                                    TempVendLedgerEntry."Closed by Amount" := 0;
                            end;
                        }
                        trigger OnPreDataItem()
                        begin
                            TempVendLedgerEntry.Reset();
                            SetRange(Number, 1, TempVendLedgerEntry.Count());
                        end;

                        trigger OnAfterGetRecord()
                        var
                            TempLoan: Record lvnLoan temporary;
                            PurchInvLine: Record "Purch. Inv. Line";
                            Vendor: Record Vendor;
                            Loan: Record lvnLoan;
                        begin
                            if Number = 1 then
                                TempVendLedgerEntry.FindSet()
                            else
                                TempVendLedgerEntry.Next();
                            TempVendLedgerEntry.CalcFields(Amount);
                            BorrowerName := '';
                            VendorName := '';
                            if Vendor.Get(TempVendLedgerEntry."Vendor No.") then
                                VendorName := Vendor.Name;
                            TempLoan.Reset();
                            TempLoan.DeleteAll();
                            TempPurchInvLine.Reset();
                            TempPurchInvLine.DeleteAll();
                            PurchInvLine.Reset();
                            PurchInvLine.SetRange("Document No.", TempVendLedgerEntry."Document No.");
                            PurchInvLine.SetFilter(Amount, '<>%1', 0);
                            if PurchInvLine.FindSet() then begin
                                repeat
                                    Clear(TempPurchInvLine);
                                    TempPurchInvLine := PurchInvLine;
                                    TempPurchInvLine.Insert();
                                    Clear(TempLoan);
                                    if PurchInvLine.lvnLoanNo <> '' then begin
                                        TempLoan."No." := PurchInvLine.lvnLoanNo;
                                        if TempLoan.Insert() then;
                                    end;
                                until PurchInvLine.Next() = 0;
                                TempLoan.Reset();
                                if TempLoan.Count() = 1 then begin
                                    TempLoan.FindFirst();
                                    if Loan.Get(TempLoan."No.") then begin
                                        TempVendLedgerEntry.lvnLoanNo := Loan."No.";
                                        BorrowerName := lvnLoanManagement.GetBorrowerName(Loan);
                                    end;
                                    TempPurchInvLine.Reset();
                                    TempPurchInvLine.DeleteAll();
                                end else
                                    if TempLoan.IsEmpty() then begin
                                        TempPurchInvLine.Reset();
                                        TempPurchInvLine.DeleteAll();
                                        if Loan.Get(TempVendLedgerEntry.lvnLoanNo) then begin
                                            TempVendLedgerEntry.lvnLoanNo := Loan."No.";
                                            BorrowerName := lvnLoanManagement.GetBorrowerName(Loan);
                                        end;
                                    end else
                                        TempVendLedgerEntry.lvnLoanNo := 'MULTIPLE';
                            end else
                                if Loan.Get(TempVendLedgerEntry.lvnLoanNo) then
                                    BorrowerName := lvnLoanManagement.GetBorrowerName(Loan);
                        end;
                    }
                    trigger OnAfterGetRecord()
                    var
                        WorkVendorLedgerEntry: Record "Vendor Ledger Entry";
                    begin
                        TempVendLedgerEntry.Reset();
                        TempVendLedgerEntry.DeleteAll();
                        FindAppliedEntries("Vendor Ledger Entry");
                        WorkVendorLedgerEntry.Reset();
                        WorkVendorLedgerEntry.SetCurrentKey("Closed by Entry No.");
                        WorkVendorLedgerEntry.SetRange("Closed by Entry No.", "Entry No.");
                        if WorkVendorLedgerEntry.FindSet() then
                            repeat
                                TempVendLedgerEntry := WorkVendorLedgerEntry;
                                if TempVendLedgerEntry.Insert() then;
                            until WorkVendorLedgerEntry.Next() = 0;
                    end;
                }
            }
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
                    field(HideCheckSummaryGroup; HideCheckSummaryGroup) { Caption = 'Hide Check Summary Group'; ApplicationArea = All; }
                    field(HideDocumentDetails; HideDocumentDetails) { Caption = 'Hide Document Details'; ApplicationArea = All; }
                }
            }
        }
    }

    var
        TempVendLedgerEntry: Record "Vendor Ledger Entry" temporary;
        TempPurchInvLine: Record "Purch. Inv. Line" temporary;
        lvnLoanManagement: Codeunit lvnLoanManagement;
        BorrowerName: Text;
        VendorName: Text;
        LineBorrowerName: Text;
        HideCheckSummaryGroup: Boolean;
        HideDocumentDetails: Boolean;

    local procedure FindAppliedEntries(var MasterVendLedgerEntry: Record "Vendor Ledger Entry")
    var
        DetVendLedgerEntry1: Record "Detailed Vendor Ledg. Entry";
        DetVendLedgerEntry2: Record "Detailed Vendor Ledg. Entry";
        AppliedVendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        DetVendLedgerEntry1.Reset();
        DetVendLedgerEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DetVendLedgerEntry1.SetRange("Vendor Ledger Entry No.", MasterVendLedgerEntry."Entry No.");
        DetVendLedgerEntry1.SetRange(Unapplied, false);
        DetVendLedgerEntry1.SetLoadFields("Vendor Ledger Entry No.", "Applied Vend. Ledger Entry No.");
        if DetVendLedgerEntry1.FindSet() then
            repeat
                if DetVendLedgerEntry1."Vendor Ledger Entry No." = DetVendLedgerEntry1."Applied Vend. Ledger Entry No." then begin
                    DetVendLedgerEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DetVendLedgerEntry2.SetRange("Applied Vend. Ledger Entry No.", DetVendLedgerEntry1."Applied Vend. Ledger Entry No.");
                    DetVendLedgerEntry2.SetRange(Unapplied, false);
                    DetVendLedgerEntry2.SetLoadFields("Vendor Ledger Entry No.", "Applied Vend. Ledger Entry No.");
                    if DetVendLedgerEntry2.FindSet() then
                        repeat
                            if DetVendLedgerEntry2."Vendor Ledger Entry No." <> DetVendLedgerEntry2."Applied Vend. Ledger Entry No." then
                                if AppliedVendLedgerEntry.Get(DetVendLedgerEntry2."Vendor Ledger Entry No.") then begin
                                    TempVendLedgerEntry := AppliedVendLedgerEntry;
                                    TempVendLedgerEntry."Closed by Amount" := DetVendLedgerEntry2.Amount;
                                    if TempVendLedgerEntry.Insert() then;
                                end;
                        until DetVendLedgerEntry2.Next() = 0;
                end else
                    if AppliedVendLedgerEntry.Get(DetVendLedgerEntry1."Applied Vend. Ledger Entry No.") then begin
                        TempVendLedgerEntry := AppliedVendLedgerEntry;
                        if TempVendLedgerEntry.Insert() then;
                    end;
            until DetVendLedgerEntry1.Next() = 0;
    end;
}