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
                ExportTextColumn('Posting Date', true);
                ExportTextColumn('Invoice No.', true);
                ExportTextColumn('Loan No.', true);
                ExportTextColumn('Vendor Posting Group', true);
                ExportTextColumn('Date Paid', true);
                ExportTextColumn('Check #', true);
                ExportTextColumn('Amount', true);
                ExportTextColumn('Vendor No.', true);
                ExportTextColumn('Vendor Name', true);
                ExportTextColumn('Vendor Address', true);
                ExportTextColumn('Payment Method', true);
                ExportTextColumn('Date Cleared', true);
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
                        if PostedBankRecHeader.Get(CheckLedgerEntry."Bank Account No.", CheckLedgerEntry."Statement No.") then begin
                            ClearedDate := PostedBankRecHeader."Statement Date";
                        end;
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
                        ExportTextColumn(Vendor.City + ', ' + Vendor.Address, false);
                        ExportTextColumn("Payment Method Code", false);
                        if ClearedDate <> 0D then begin
                            ExportDateColumn(ClearedDate);
                        end;
                    until DetailedVendLedgEntry.Next() = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuffer.CreateBookAndOpenExcel(TemporaryPath + 'Export.xlsx', 'Data', '', CompanyName, '');
            end;
        }
    }

    requestpage
    {
        layout
        {

        }
    }
    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        CheckLedgerEntry: Record "Check Ledger Entry";
        PostedBankRecHeader: Record "Posted Bank Rec. Header";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ColumnNo: Integer;
        RowNo: Integer;
        ExcelBuffer: Record "Excel Buffer";
        ClearedDate: Date;


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
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := '0.00';
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;

    local procedure ExportIntColumn(Value: Decimal)
    begin
        Clear(ExcelBuffer);
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColumnNo);
        ExcelBuffer.Validate("Cell Value as Text", Format(Value));
        ExcelBuffer.Validate("Cell Type", ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.NumberFormat := '0';
        ExcelBuffer.Insert(true);
        ColumnNo := ColumnNo + 1;
    end;
}