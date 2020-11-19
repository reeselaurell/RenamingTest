page 14135172 "lvnQuickPayWorksheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnQuickPayBuffer;
    Caption = 'Quick Pay Worksheet';
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    SourceTableTemporary = true;
    Permissions = tabledata "Vendor Ledger Entry" = rm;

    layout
    {
        area(Content)
        {
            group(Main)
            {
                ShowCaption = false;

                group(Filters)
                {
                    Caption = 'Filters';

                    field(InvoicesPostedPostingDate; InvoicesPostedPostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoices Posted';
                    }
                    field(DueDateBefore; DueDateBefore)
                    {
                        ApplicationArea = All;
                        Caption = 'Due Date Before';
                    }
                    field(QuickPayPresetCode; QuickPayPresetCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter Preset';
                        TableRelation = lvnQuickPayFilterPreset.Code;
                    }
                }
                group(Payment)
                {
                    Caption = 'Payment';

                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Date';
                    }
                    field(PaymentMethodCode; PaymentMethodCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Method';
                        Visible = false;
                        TableRelation = "Payment Method".Code;
                    }
                    field(BankPaymentType; BankPaymentType)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Payment Type';
                    }
                    field(BankAccountNo; BankAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Account No.';
                        TableRelation = "Bank Account"."No.";

                        trigger OnValidate()
                        var
                            BankAccount: Record "Bank Account";
                        begin
                            BankAccount.Get(BankAccountNo);
                            if DueDateBefore <> 0D then
                                BankAccount.SetRange("Date Filter", 0D, DueDateBefore);
                            BankAccount.CalcFields("Balance at Date");
                            BankAccountBalance := BankAccount."Balance at Date";
                            BankAccountName := BankAccount.Name;
                        end;
                    }
                    field(BankAccountName; BankAccountName)
                    {
                        Caption = 'Bank Account Name';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(GroupPerVendor; GroupPerVendor)
                    {
                        ApplicationArea = All;
                        Caption = 'Group per Vendor';
                    }
                }
            }
            repeater(Group)
            {
                field(Pay; Rec.Pay)
                {
                    ApplicationArea = All;
                    Caption = 'Pay';

                    trigger OnValidate()
                    begin
                        TempQuickPayBuffer.Get(Rec."Entry No.");
                        TempQuickPayBuffer := Rec;
                        TempQuickPayBuffer.Modify();
                        TempQuickPayBuffer.Reset();
                        TempQuickPayBuffer.CalcSums("Amount to Pay");
                        TotalAmountToPay := TempQuickPayBuffer."Amount to Pay";
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method Code';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Caption = 'Loan No.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Amount';
                    Editable = false;
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Pay';
                    Editable = Rec.Pay;

                    trigger OnValidate()
                    begin
                        TempQuickPayBuffer.Get(Rec."Entry No.");
                        TempQuickPayBuffer := Rec;
                        TempQuickPayBuffer.Modify();
                        TempQuickPayBuffer.Reset();
                        TempQuickPayBuffer.CalcSums("Amount to Pay");
                        TotalAmountToPay := TempQuickPayBuffer."Amount to Pay";
                    end;
                }
            }
            group(Bank)
            {
                Caption = 'Bank';

                field(BankAccountBalance; BankAccountBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Balance';
                    Editable = false;
                }
                field(TotalAmountToPay; TotalAmountToPay)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount to Pay';
                    Editable = false;
                }
                field(EndBalance; BankAccountBalance - TotalAmountToPay)
                {
                    ApplicationArea = All;
                    Caption = 'End Balance';
                }
            }
        }
        area(FactBoxes)
        {
            part(VendorStats; "Vendor Statistics FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vendor Statistics';
                SubPageView = sorting("No.");
                SubPageLink = "No." = field("Vendor No.");
            }
            part(Dimensions; "Dimension Set Entries FactBox")
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                SubPageView = sorting("Dimension Set ID", "Dimension Code");
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
            }
            part(Documents; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
                Caption = 'Documents';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RetrieveInvoicesAction)
            {
                ApplicationArea = All;
                Caption = 'Retrieve Invoices to Pay';
                Image = GetEntries;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    RetrieveInvoices();
                    RefreshView();
                end;
            }
            action(SelectAllAction)
            {
                ApplicationArea = All;
                Caption = 'Select All To Pay';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SelectAll();
                end;
            }
            action(ClearSelectionAction)
            {
                ApplicationArea = All;
                Caption = 'Clear Selection';
                Image = AllLines;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                begin
                    ClearSelection();
                end;
            }
            action(CreateJournal)
            {
                ApplicationArea = All;
                Caption = 'Create Payment Journal';
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreatePaymentJournal();
                end;
            }
            action(ShowAll)
            {
                ApplicationArea = All;
                Caption = 'Show All Documents';
                Image = FilterLines;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                Visible = ShowAll;

                trigger OnAction()
                begin
                    ShowDocuments();
                end;
            }
            action(ShowNonApplied)
            {
                ApplicationArea = All;
                Caption = 'Show Non-Applied Documents';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowNonApplied;

                trigger OnAction()
                begin
                    ShowDocuments();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowAll := false;
        ShowNonApplied := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document GUID" := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Documents.Page.ReloadDocuments(Rec."Document GUID");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        exit(Confirm(CloseWorksheetQst));
    end;

    var
        TempQuickPayBuffer: Record lvnQuickPayBuffer temporary;
        InvoicesPostedPostingDate: Date;
        DueDateBefore: Date;
        QuickPayPresetCode: Code[20];
        PostingDate: Date;
        PaymentMethodCode: Code[10];
        BankPaymentType: Option " ","Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";
        BankAccountNo: Code[20];
        BankAccountName: Text[250];
        GroupPerVendor: Boolean;
        BankAccountBalance: Decimal;
        TotalAmountToPay: Decimal;
        ShowAll: Boolean;
        ShowNonApplied: Boolean;
        RemoveSelectionQst: Label 'Do you want to remove current selection?';
        CloseWorksheetQst: Label 'Do You want to Close Quick Pay Worksheet?';
        ConfirmJournalCreateQst: Label 'Do you want to create payment journal?';

    local procedure RefreshView()
    begin
        if not ShowAll then
            Rec.SetRange("Applies-to ID")
        else
            Rec.SetRange("Applies-to ID", '');
        CurrPage.Update(false);
    end;

    local procedure ShowDocuments()
    begin
        ShowAll := not ShowAll;
        ShowNonApplied := not ShowNonApplied;
        RefreshView();
    end;

    local procedure SelectAll()
    begin
        Rec.Reset();
        CurrPage.SetSelectionFilter(Rec);
        Rec.FindSet();
        repeat
            Rec.Validate(Pay, true);
            Rec.Modify();
            TempQuickPayBuffer.Get(Rec."Entry No.");
            TempQuickPayBuffer := Rec;
            TempQuickPayBuffer.Modify();
        until Rec.Next() = 0;
        Rec.Reset();
        Rec.FindFirst();
        TempQuickPayBuffer.Reset();
        TempQuickPayBuffer.CalcSums("Amount to Pay");
        TotalAmountToPay := TempQuickPayBuffer."Amount to Pay";
    end;

    local procedure ClearSelection()
    begin
        Rec.Reset();
        Rec.FindSet();
        repeat
            Rec.Validate(Pay, false);
            Rec.Modify();
            TempQuickPayBuffer.Get(Rec."Entry No.");
            TempQuickPayBuffer := Rec;
            TempQuickPayBuffer.Modify();
        until Rec.Next() = 0;
        Rec.Reset();
        Rec.FindFirst();
        TempQuickPayBuffer.Reset();
        TempQuickPayBuffer.CalcSums("Amount to Pay");
        TotalAmountToPay := TempQuickPayBuffer."Amount to Pay";
    end;

    local procedure RetrieveInvoices()
    var
        Vendor: Record Vendor;
        GenJnlLine: Record "Gen. Journal Line";
        QuickPayPreset: Record lvnQuickPayFilterPreset;
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        QuickPayData: Query lvnQuickPayData;
        FilterText: Text;
    begin
        Rec.Reset();
        if not Rec.IsEmpty() then
            if Confirm(RemoveSelectionQst, false) then
                Rec.DeleteAll(true);
        if QuickPayPreset.Get(QuickPayPresetCode) then
            if QuickPayPreset.ApplyVendorLedgerEntries(TempVendorLedgerEntry) then begin
                FilterText := TempVendorLedgerEntry.GetFilter("Global Dimension 1 Code");
                if FilterText <> '' then
                    QuickPayData.SetFilter(Dim1Filter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter("Global Dimension 2 Code");
                if FilterText <> '' then
                    QuickPayData.SetFilter(Dim2Filter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter("Vendor Posting Group");
                if FilterText <> '' then
                    QuickPayData.SetFilter(VendorPostingGroupFilter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter("Payment Method Code");
                if FilterText <> '' then
                    QuickPayData.SetFilter(PaymentMethodFilter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter("Reason Code");
                if FilterText <> '' then
                    QuickPayData.SetFilter(ReasonCodeFilter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter("User ID");
                if FilterText <> '' then
                    QuickPayData.SetFilter(UserIdFilter, FilterText);
                FilterText := TempVendorLedgerEntry.GetFilter(lvnEntryDate);
                if FilterText <> '' then
                    QuickPayData.SetFilter(EntryDateFilter, FilterText);
            end;
        if DueDateBefore <> 0D then
            QuickPayData.SetRange(DueDateFilter, 0D, DueDateBefore);
        if InvoicesPostedPostingDate <> 0D then
            QuickPayData.SetRange(PostingDateFilter, InvoicesPostedPostingDate);
        QuickPayData.Open();
        while QuickPayData.Read() do
            if not Rec.Get(QuickPayData.EntryNo) then begin
                Rec.Init();
                Rec."Entry No." := QuickPayData.EntryNo;
                Rec."Remaining Amount" := QuickPayData.RemainingAmount;
                Rec.Description := QuickPayData.Description;
                Rec."Dimension Set ID" := QuickPayData.DimensionSetID;
                Rec."Document GUID" := QuickPayData.DocumentGUID;
                Rec."Document No." := QuickPayData.DocumentNo;
                Rec."External Document No." := QuickPayData.ExternalDocumentNo;
                Rec."Due Date" := QuickPayData.DueDate;
                Rec."Posting Date" := QuickPayData.PostingDate;
                Rec."Vendor No." := QuickPayData.VendorNo;
                Rec."Payment Method Code" := QuickPayData.PaymentMethodCode;
                Rec."Loan No." := QuickPayData.LoanNo;
                Vendor.Get(Rec."Vendor No.");
                Rec."Vendor Name" := Vendor.Name;
                Rec."Applies-to ID" := QuickPayData.AppliesToID;
                if Rec."Applies-to ID" = '' then begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                    GenJnlLine.SetRange("Applies-to Doc. No.", Rec."Document No.");
                    GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.SetRange("Account No.", Rec."Vendor No.");
                    if not GenJnlLine.IsEmpty() then
                        Rec."Applies-to ID" := Rec."Document No.";
                end;
                Rec.Insert();
            end;
        QuickPayData.Close();
        Rec.Reset();
        TempQuickPayBuffer.Reset();
        TempQuickPayBuffer.DeleteAll();
        if Rec.FindSet() then
            repeat
                TempQuickPayBuffer := Rec;
                TempQuickPayBuffer.Insert();
            until Rec.Next() = 0;
        TempQuickPayBuffer.CalcSums("Amount to Pay");
        TotalAmountToPay := TempQuickPayBuffer."Amount to Pay";
    end;

    local procedure CreatePaymentJournal()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine1: Record "Gen. Journal Line" temporary;
        TempGenJnlLine2: Record "Gen. Journal Line" temporary;
        VendLedgEntry: Record "Vendor Ledger Entry";
        UserSetup: Record "User Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BatchName: Code[20];
        LineNo: Integer;
        Idx: Integer;
    begin
        PurchasesPayablesSetup.Get();
        case PurchasesPayablesSetup.lvnQuickPayBatchSelection of
            PurchasesPayablesSetup.lvnQuickPayBatchSelection::"One Batch":
                begin
                    PurchasesPayablesSetup.TestField(lvnQuickPayDefaultBatch);
                    BatchName := PurchasesPayablesSetup.lvnQuickPayDefaultBatch;
                end;
            PurchasesPayablesSetup.lvnQuickPayBatchSelection::"Defined in User Setup":
                begin
                    UserSetup.Get(UserId());
                    UserSetup.TestField(lvnDefaultPaymentJournalBatch);
                    BatchName := UserSetup.lvnDefaultPaymentJournalBatch;
                end;
            PurchasesPayablesSetup.lvnQuickPayBatchSelection::Selectable:
                begin
                    GenJnlBatch.Reset();
                    GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::Payments);
                    if Page.RunModal(0, GenJnlBatch) = Action::LookupOK then
                        BatchName := GenJnlBatch.Name
                    else
                        exit;
                end;
        end;
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::Payments);
        GenJnlBatch.SetRange(Name, BatchName);
        GenJnlBatch.FindFirst();
        GenJnlBatch.TestField("No. Series");
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange(Name, GenJnlBatch."Journal Template Name");
        GenJnlTemplate.FindFirst();
        if Confirm(ConfirmJournalCreateQst, true) then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name);
            if GenJnlLine.FindLast() then
                LineNo := GenJnlLine."Line No." + 1000
            else
                LineNo := 1000;
            Rec.Reset();
            Rec.SetCurrentKey("Vendor Name", "External Document No.");
            Rec.SetRange(Pay, true);
            Rec.FindSet();
            if GroupPerVendor then begin
                TempGenJnlLine1.Reset();
                TempGenJnlLine1.DeleteAll();
                TempGenJnlLine2.Reset();
                TempGenJnlLine2.DeleteAll();
                Idx := 10000;
                repeat
                    Clear(TempGenJnlLine1);
                    TempGenJnlLine1."Line No." := Idx;
                    Idx += 10000;
                    TempGenJnlLine1."Account Type" := GenJnlLine."Account Type"::Vendor;
                    TempGenJnlLine1."Account No." := Rec."Vendor No.";
                    TempGenJnlLine1.Amount := Rec."Amount to Pay";
                    TempGenJnlLine1."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    TempGenJnlLine1."Applies-to Doc. No." := Rec."Document No.";
                    TempGenJnlLine1."External Document No." := Rec."External Document No.";
                    TempGenJnlLine1.Insert();
                    TempGenJnlLine2.Reset();
                    TempGenJnlLine2.SetRange("Account No.", Rec."Vendor No.");
                    if TempGenJnlLine2.FindFirst() then begin
                        TempGenJnlLine2.Amount += Rec."Amount to Pay";
                        TempGenJnlLine2.Modify();
                    end else begin
                        TempGenJnlLine2 := TempGenJnlLine1;
                        TempGenJnlLine2.Insert();
                    end;
                until Rec.Next() = 0;
                TempGenJnlLine2.Reset();
                TempGenJnlLine2.FindSet();
                repeat
                    Clear(GenJnlLine);
                    GenJnlLine.Validate("Journal Template Name", GenJnlBatch."Journal Template Name");
                    GenJnlLine.Validate("Journal Batch Name", GenJnlBatch.Name);
                    GenJnlLine."Line No." := LineNo;
                    LineNo += 1000;
                    GenJnlLine.Validate("Document Date", PostingDate);
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    Clear(NoSeriesManagement);
                    GenJnlLine.Validate("Document No.", NoSeriesManagement.GetNextNo(GenJnlBatch."No. Series", Today(), true));
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.Validate("Account No.", TempGenJnlLine2."Account No.");
                    GenJnlLine.Validate(Amount, TempGenJnlLine2.Amount);
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAccountNo);
                    GenJnlLine.Validate("Applies-to ID", GenJnlLine."Document No.");
                    GenJnlLine.Description := GenJnlLine.lvnSourceName;
                    GenJnlLine.lvnDocumentGuid := CreateGuid();
                    GenJnlLine.Validate("Bank Payment Type", BankPaymentType);
                    GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                    GenJnlLine.Insert(true);
                    TempGenJnlLine1.Reset();
                    TempGenJnlLine1.SetRange("Account No.", TempGenJnlLine2."Account No.");
                    TempGenJnlLine1.FindSet();
                    repeat
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange("Vendor No.", TempGenJnlLine2."Account No.");
                        VendLedgEntry.SetRange("Document Type", TempGenJnlLine1."Applies-to Doc. Type");
                        VendLedgEntry.SetRange("Document No.", TempGenJnlLine1."Applies-to Doc. No.");
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.FindFirst();
                        VendLedgEntry.Validate("Amount to Apply", -TempGenJnlLine1.Amount);
                        VendLedgEntry."Applies-to ID" := GenJnlLine."Applies-to ID";
                        VendLedgEntry.Modify();
                    until TempGenJnlLine1.Next() = 0;
                until TempGenJnlLine2.Next() = 0;
            end else
                repeat
                    Clear(GenJnlLine);
                    GenJnlLine.Validate("Journal Template Name", GenJnlBatch."Journal Template Name");
                    GenJnlLine.Validate("Journal Batch Name", GenJnlBatch.Name);
                    GenJnlLine."Line No." := LineNo;
                    LineNo += 1000;
                    GenJnlLine.Validate("Document Date", PostingDate);
                    GenJnlLine.Validate("Posting Date", PostingDate);
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    Clear(NoSeriesManagement);
                    GenJnlLine.Validate("Document No.", NoSeriesManagement.GetNextNo(GenJnlBatch."No. Series", Today(), true));
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.Validate("Account No.", Rec."Vendor No.");
                    GenJnlLine.Validate(Amount, Rec."Amount to Pay");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", BankAccountNo);
                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := Rec."Document No.";
                    GenJnlLine.Description := Rec.Description;
                    GenJnlLine."External Document No." := Rec."External Document No.";
                    GenJnlLine.lvnDocumentGuid := Rec."Document GUID";
                    GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                    GenJnlLine.Validate("Bank Payment Type", BankPaymentType);
                    GenJnlLine.lvnLoanNo := Rec."Loan No.";
                    GenJnlLine.Insert(true);
                until Rec.Next() = 0;
            Commit();
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate.Name);
            GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name);
            GenJnlLine.FindFirst();
            Page.RunModal(Page::"Payment Journal", GenJnlLine);
            Rec.Reset();
            Rec.DeleteAll();
            TempQuickPayBuffer.Reset();
            TempQuickPayBuffer.DeleteAll();
        end;
    end;
}