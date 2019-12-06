report 14135181 "lvngDisbursementDataExport"
{
    Caption = 'Disbursement Data Export';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngVendorLedgerEntry; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Document Type", "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code")
                where("Document Type" = const(Payment));
            RequestFilterFields = "Vendor No.", "Posting Date";

            trigger OnPreDataItem()
            begin
                RowNo := 1;
                ColumnNo := 1;
                ExportTextColumn(PostingDateLbl, true);
                ExportTextColumn(InvoiceNoLbl, true);
                ExportTextColumn(LoanNoLbl, true);
                ExportTextColumn(VendorPostingGroupLbl, true);
                ExportTextColumn(DatePaidLbl, true);
                ExportTextColumn(CheckNoLbl, true);
                ExportTextColumn(AmountLbl, true);
                ExportTextColumn(VendorNoLbl, true);
                ExportTextColumn(VendorNameLbl, true);
                ExportTextColumn(VendorAddressLbl, true);
                ExportTextColumn(PaymentMethodLbl, true);
                ExportTextColumn(DateClearedLbl, true);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(ClearedDate);
                Vendor.Get("Vendor No.");
                BankAccountLedgerEntry.Reset();
                BankAccountLedgerEntry.SetRange("Transaction No.", "Transaction No.");
                BankAccountLedgerEntry.SetRange("Document Type", "Document Type");
                BankAccountLedgerEntry.SetRange("Document No.", "Document No.");
                if BankAccountLedgerEntry.FindFirst() then begin
                    CheckLedgerEntry.Reset();
                    CheckLedgerEntry.SetCurrentKey("Bank Account Ledger Entry No.");
                    CheckLedgerEntry.SetRange("Bank Account Ledger Entry No.", BankAccountLedgerEntry."Entry No.");
                    if CheckLedgerEntry.FindFirst() then begin
                        PostedBankRecHeader.Reset();
                        if PostedBankRecHeader.Get(CheckLedgerEntry."Bank Account No.", CheckLedgerEntry."Statement No.") then
                            ClearedDate := PostedBankRecHeader."Statement Date";
                    end;
                end;
                DetailedVendLedgEntry.Reset();
                DetailedVendLedgEntry.SetRange("Applied Vend. Ledger Entry No.", "Entry No.");
                DetailedVendLedgEntry.SetRange("Entry Type", DetailedVendLedgEntry."Entry Type"::Application);
                DetailedVendLedgEntry.SetRange("Initial Document Type", DetailedVendLedgEntry."Initial Document Type"::Invoice);
                if DetailedVendLedgEntry.FindSet() then begin
                    repeat
                        NewRow;
                        VendorLedgerEntry.Get(DetailedVendLedgEntry."Vendor Ledger Entry No.");
                        ExportDateColumn(DetailedVendLedgEntry."Posting Date");
                        ExportTextColumn(VendorLedgerEntry."External Document No.", false);
                        ExportTextColumn(VendorLedgerEntry.lvngLoanNo, false);
                        ExportTextColumn(VendorLedgerEntry."Vendor Posting Group", false);
                        ExportDateColumn("Posting Date");
                        ExportTextColumn("Document No.", false);
                        VendorLedgerEntry.CalcFields(Amount);
                        ExportDecimalColumn(VendorLedgerEntry.Amount);
                        ExportTextColumn("Vendor No.", false);
                        ExportTextColumn(Vendor.Name, false);
                        ExportTextColumn(StrSubstNo(AddressTemplateLbl, Vendor.City, Vendor.Address), false);
                        ExportTextColumn("Payment Method Code", false);
                        if ClearedDate <> 0D then
                            ExportDateColumn(ClearedDate);
                    until DetailedVendLedgEntry.Next() = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuffer.CreateNewBook(ExportNameLbl);
                ExcelBuffer.WriteSheet(ExportNameLbl, CompanyName, UserId);
                ExcelBuffer.CloseBook();
                ExcelBuffer.OpenExcel();
            end;
        }
    }

    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        CheckLedgerEntry: Record "Check Ledger Entry";
        PostedBankRecHeader: Record "Posted Bank Rec. Header";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ExcelBuffer: Record "Excel Buffer" temporary;
        ColumnNo: Integer;
        RowNo: Integer;
        ClearedDate: Date;
        ExportNameLbl: Label 'Export';
        PostingDateLbl: Label 'Posting Date';
        InvoiceNoLbl: Label 'Invoice No.';
        LoanNoLbl: Label 'Loan No.';
        VendorPostingGroupLbl: Label 'Vendor Posting Group';
        DatePaidLbl: Label 'Date Paid';
        CheckNoLbl: Label 'Check #';
        AmountLbl: Label 'Amount';
        VendorNoLbl: Label 'Vendor No.';
        VendorNameLbl: Label 'Vendor Name';
        VendorAddressLbl: Label 'Vendor Address';
        PaymentMethodLbl: Label 'Payment Method';
        DateClearedLbl: Label 'Date Cleared';
        AddressTemplateLbl: Label '%1, %2';

    local procedure NewRow()
    begin
        ColumnNo := 1;
        RowNo := RowNo + 1;
    end;

    local procedure ExportTextColumn(Value: Text; Bold: Boolean)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Value);
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.Validate(Bold, Bold);
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;

    local procedure ExportDateColumn(Value: Date)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;

    local procedure ExportDecimalColumn(Value: Decimal)
    var
        NumberFormatTxt: Label '0.00';
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := NumberFormatTxt;
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;

    local procedure ExportIntColumn(Value: Decimal)
    var
        NumberFormatTxt: Label '0';
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := NumberFormatTxt;
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;
}