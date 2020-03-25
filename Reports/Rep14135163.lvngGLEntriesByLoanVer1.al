report 14135163 lvngGLEntriesByLoanVer1
{
    Caption = 'G/L Entries By Loan';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135163.rdl';

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
            var
                Loan: Record lvngLoan;
                GLAccount: Record "G/L Account";
                VendorLedgerEntry: Record "Vendor Ledger Entry";
                CustLedgerEntry: Record "Cust. Ledger Entry";
                VendorLedgerEntry2: Record "Vendor Ledger Entry";
                CustLedgerEntry2: Record "Cust. Ledger Entry";
                BankAccount: Record "Bank Account";
                BankAccountPostingGroup: Record "Bank Account Posting Group";
                DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
                DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                Vendor: Record Vendor;
                Customer: Record Customer;
                GLEntry: Record "G/L Entry";
                GLEntry2: Record "G/L Entry";
                AccountNo: Code[20];
                EntryNo: Integer;
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
                if not TempLoan.Get(LoanNo) then
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
                    end
                else begin
                    TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + Amount;
                    TempLoan.Modify();
                end;
                Clear(TempGLAccountLoanBuffer);
                TempGLAccountLoanBuffer."View Code" := TempGLEntryBuffer."G/L Account No.";
                TempGLAccountLoanBuffer."Loan No." := TempGLEntryBuffer."Loan No.";
                if TempGLAccountLoanBuffer.Insert() then begin
                    GLAccount.Get(TempGLEntryBuffer."G/L Account No.");
                    TempGLAccountLoanBuffer."Text Value" := GLAccount.Name;
                    if MinDate <> 0D then begin
                        GLEntry.Reset();
                        GLEntry.SetCurrentKey(lvngLoanNo);
                        GLEntry.SetRange(lvngLoanNo, lvngLoanNo);
                        GLEntry.SetRange("Posting Date", 0D, MinDate);
                        GLEntry.SetRange("G/L Account No.", "G/L Account No.");
                        if GLEntry.FindSet() then
                            repeat
                                TempGLAccountLoanBuffer."Decimal Value" := TempGLAccountLoanBuffer."Decimal Value" + GLEntry.Amount;
                                TempLoan."Loan Amount" := TempLoan."Loan Amount" + GLEntry.Amount;
                            until GLEntry.Next() = 0;
                    end;
                    TempLoan.Modify();
                    TempGLAccountLoanBuffer.Modify();
                end;
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
                column(BeginningBalance; TempGLAccountLoanBuffer."Decimal Value") { }
                column(AccountName; TempGLAccountLoanBuffer."Text Value") { }

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
        TempLoan: Record lvngLoan temporary;
        TempGLAccountLoanBuffer: Record lvngGLAccountLoanBuffer temporary;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        CompanyInformation: Record "Company Information";
        Progress: Dialog;
        Counter: Integer;
        MinDate: Date;
        DimensionNo: Integer;
        CostCenter: Code[20];
        Description: Text;
        Filters: Text;
        SourceName: Text;

    trigger OnPreReport()
    var
        DimMgmt: Codeunit lvngDimensionsManagement;
    begin
        LoanVisionSetup.Get();
        CompanyInformation.Get();
        Filters := "G/L Entry".GetFilters;
        if LoanVisionSetup."Cost Center Dimension Code" <> '' then
            DimensionNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Cost Center Dimension Code");
        if "G/L Entry".GetFilters = '' then
            Error(NoFilterErr);
        if "G/L Entry".GetFilter("Posting Date") <> '' then
            MinDate := "G/L Entry".GetRangeMin("Posting Date") - 1;
    end;
}