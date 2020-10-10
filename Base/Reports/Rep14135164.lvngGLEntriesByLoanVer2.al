report 14135164 lvngGLEntriesByLoanVer2
{
    Caption = 'G/L Entries by Loan';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135164.rdl';

    dataset
    {
        dataitem(LoanFilters; lvngLoan)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Date Funded";

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = sorting(lvngLoanNo) order(ascending);
                DataItemLink = lvngLoanNo = field("No.");
                RequestFilterFields = "Posting Date";

                trigger OnPreDataItem()
                begin
                    if GuiAllowed then begin
                        Progress.Open(ProgressMsg);
                        Progress.Update(2, Count());
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                    GLAccount: Record "G/L Account";
                    Loan: Record lvngLoan;
                    GLEntry: Record "G/L Entry";
                    Counter: Integer;
                begin
                    Clear(TempGenLedgBuffer);
                    EntryNo := EntryNo + 1;
                    TempGenLedgBuffer."Entry No." := EntryNo;
                    TempGenLedgBuffer."Reference No." := Format(Counter);
                    TempGenLedgBuffer."Payment Due Date" := "Posting Date";
                    TempGenLedgBuffer."Document No." := "Document No.";
                    TempGenLedgBuffer."Debit Amount" := "Debit Amount";
                    TempGenLedgBuffer."Credit Amount" := "Credit Amount";
                    TempGenLedgBuffer."Current Balance" := Amount;
                    TempGenLedgBuffer."Investor Name" := lvngSourceName;
                    TempGenLedgBuffer."Shortcut Dimension 1" := "Global Dimension 1 Code";
                    TempGenLedgBuffer."Shortcut Dimension 2" := "Global Dimension 2 Code";
                    TempGenLedgBuffer."Shortcut Dimension 3" := lvngShortcutDimension3Code;
                    TempGenLedgBuffer."Shortcut Dimension 4" := lvngShortcutDimension4Code;
                    TempGenLedgBuffer."Shortcut Dimension 5" := lvngShortcutDimension5Code;
                    TempGenLedgBuffer."Shortcut Dimension 6" := lvngShortcutDimension6Code;
                    TempGenLedgBuffer."Shortcut Dimension 7" := lvngShortcutDimension7Code;
                    TempGenLedgBuffer."Shortcut Dimension 8" := lvngShortcutDimension8Code;
                    TempGenLedgBuffer.Name := Description;
                    TempGenLedgBuffer."Reason Code" := "Reason Code";
                    TempGenLedgBuffer."External Document No." := "External Document No.";
                    TempGenLedgBuffer."G/L Entry No." := "Entry No.";
                    TempGenLedgBuffer."G/L Account No." := "G/L Account No.";
                    TempGenLedgBuffer."Loan No." := lvngLoanNo;
                    TempGenLedgBuffer.Insert();
                    if not TempLoan.Get(lvngLoanNo) then begin
                        Clear(TempLoan);
                        if Loan.Get(lvngLoanNo) then begin
                            TempLoan := Loan;
                            Clear(TempLoan."Loan Amount");
                            Clear(TempLoan."Commission Base Amount");
                            TempLoan."Commission Base Amount" := Amount;
                            TempLoan.Insert();
                        end else begin
                            TempLoan."Commission Base Amount" := Amount;
                            TempLoan."No." := lvngLoanNo;
                            TempLoan.Insert();
                        end;
                    end else begin
                        TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + Amount;
                        TempLoan.Modify();
                    end;
                    Clear(TempGLAccountLoanBuffer);
                    TempGLAccountLoanBuffer."View Code" := TempGenLedgBuffer."G/L Account No.";
                    TempGLAccountLoanBuffer."Loan No." := TempGenLedgBuffer."Loan No.";
                    if TempGLAccountLoanBuffer.Insert() then begin
                        GLAccount.GET(TempGenLedgBuffer."G/L Account No.");
                        TempGLAccountLoanBuffer."Text Value" := GLAccount.Name;
                        if MinDate <> 0D then begin
                            GLEntry.Reset();
                            GLEntry.SetCurrentKey(lvngLoanNo);
                            GLEntry.SetRange(lvngLoanNo, lvngLoanNo);
                            GLEntry.SetRange("Posting Date", 0D, MinDate);
                            GLEntry.SetRange("G/L Account No.", "G/L Account No.");
                            if not GLEntry.IsEmpty() then
                                if GLEntry.FindSet() then
                                    repeat
                                        TempGLAccountLoanBuffer."Decimal Value" := TempGLAccountLoanBuffer."Decimal Value" + GLEntry.Amount;
                                        TempLoan."Loan Amount" := TempLoan."Loan Amount" + GLEntry.Amount;
                                    until GLEntry.Next() = 0;
                        end;
                        TempLoan.Modify();
                        TempGLAccountLoanBuffer.Modify();
                    end;
                    TempLoan."Commission Base Amount" := TempLoan."Commission Base Amount" + TempGenLedgBuffer."Current Balance";
                    TempLoan.Modify();
                    Counter := Counter + 1;
                    if GuiAllowed then
                        Progress.Update(1, Counter);
                end;

                trigger OnPostDataItem()
                begin
                    if GuiAllowed then
                        Progress.Close();
                end;
            }
        }

        dataitem(LoanNoLoop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CompanyName; CompanyInformation.Name) { }
            column(ReportFilters; Filters) { }
            column(LoanNo; TempLoan."No.") { }
            column(BorrowerName; BorrowerName) { }
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

                    column(PostingDate; TempGenLedgBuffer."Payment Due Date") { }
                    column(Description; Description) { }
                    column(DebitAmount; TempGenLedgBuffer."Debit Amount") { }
                    column(CreditAmount; TempGenLedgBuffer."Credit Amount") { }
                    column(ReasonCode; TempGenLedgBuffer."Reason Code") { }
                    column(DocumentNo; TempGenLedgBuffer."Document No.") { }
                    column(ExternalDocumentNo; TempGenLedgBuffer."External Document No.") { }
                    column(ReferenceNo; TempGenLedgBuffer."Reference No.") { }
                    column(CostCenter; CostCenter) { }
                    column(GLEntryNo; TempGenLedgBuffer."G/L Entry No.") { }

                    trigger OnPreDataItem()
                    begin
                        TempGenLedgBuffer.Reset();
                        TempGenLedgBuffer.SetRange("G/L Account No.", TempGLAccountLoanBuffer."View Code");
                        TempGenLedgBuffer.SetRange("Loan No.", TempGLAccountLoanBuffer."Loan No.");
                        SetRange(Number, 1, TempGenLedgBuffer.Count());
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            TempGenLedgBuffer.FindSet()
                        else
                            TempGenLedgBuffer.Next();
                        case DimensionNo of
                            1:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 1";
                            2:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 2";
                            3:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 3";
                            4:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 4";
                            5:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 5";
                            6:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 6";
                            7:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 7";
                            8:
                                CostCenter := TempGenLedgBuffer."Shortcut Dimension 8";
                        end;
                        if TempGenLedgBuffer."Investor Name" <> '' then
                            Description := TempGenLedgBuffer."Investor Name" + '|' + TempGenLedgBuffer.Name
                        else
                            Description := TempGenLedgBuffer.Name;
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
                Clear(BorrowerName);
                BorrowerName := lvngLoanManagement.GetBorrowerName(TempLoan);
            end;
        }
    }

    var
        NoDateFilterErr: Label 'Please define Filter for Loan No. or Funded Date';
        ProgressMsg: Label 'Processing entries #1####### of #2########';
        CompanyInformation: Record "Company Information";
        TempLoan: Record lvngLoan temporary;
        TempGenLedgBuffer: Record lvngGenLedgerReconcile temporary;
        TempGLAccountLoanBuffer: Record lvngGLAccountLoanBuffer temporary;
        lvngLoanManagement: Codeunit lvngLoanManagement;
        Filters: Text;
        EntryNo: Integer;
        Progress: Dialog;
        CostCenter: Code[20];
        DimensionNo: Integer;
        MinDate: Date;
        Description: Text;
        BorrowerName: Text;

    trigger OnPreReport()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        DimMgmt: Codeunit lvngDimensionsManagement;
    begin
        TempGenLedgBuffer.Reset();
        TempGenLedgBuffer.DeleteAll();
        LoanVisionSetup.Get();
        GLSetup.Get();
        CompanyInformation.Get();
        Filters := LoanFilters.GetFilters();
        if "G/L Entry".GetFilters() <> '' then
            Filters := Filters + ' | ' + "G/L Entry".GetFilters();
        if LoanVisionSetup."Cost Center Dimension Code" <> '' then
            DimensionNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Cost Center Dimension Code");
        if LoanFilters.GetFilters() = '' then
            Error(NoDateFilterErr);
        if "G/L Entry".GetFilter("Posting Date") <> '' then
            MinDate := "G/L Entry".GetRangeMin("Posting Date") - 1;
    end;
}