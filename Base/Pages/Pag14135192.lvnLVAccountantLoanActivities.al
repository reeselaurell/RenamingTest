page 14135192 "lvnLVAccountantLoanActivities"
{
    PageType = CardPart;
    Caption = 'Loan Activities';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(FundingAndSales)
            {
                Caption = 'Funding and Sales';

                field(UnpostedFundings; UnpostedFundingsCount())
                {
                    Caption = 'Unposted Fundings';
                    ApplicationArea = All;
                    ToolTip = 'Unposted Loan Funding Documents';

                    trigger OnDrillDown()
                    var
                        LoanDoc: Record lvnLoanDocument;
                    begin
                        LoanDoc.Reset();
                        LoanDoc.SetRange("Transaction Type", LoanDoc."Transaction Type"::Funded);
                        if LoanDoc.FindSet() then
                            Page.Run(Page::lvnLoanDocumentsList, LoanDoc);
                    end;
                }
                field(UnpostedSales; UnpostedSalesCount())
                {
                    Caption = 'Unposted Sales';
                    ApplicationArea = All;
                    ToolTip = 'Unposted Loan Sold Documents';

                    trigger OnDrillDown()
                    var
                        LoanDoc: Record lvnLoanDocument;
                    begin
                        LoanDoc.Reset();
                        LoanDoc.SetRange("Transaction Type", LoanDoc."Transaction Type"::Sold);
                        if LoanDoc.FindSet() then
                            Page.Run(Page::lvnLoanDocumentsList, LoanDoc);
                    end;
                }
            }

            cuegroup(Purchases)
            {
                field(OpenInvoices; OpenInvoicesCount())
                {
                    Caption = 'Open Invoices';
                    ApplicationArea = All;
                    ToolTip = 'Open Purchase Invoices Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }
                field(InvoicesPendingApproval; InvoicesPendingApprovalCount())
                {
                    Caption = 'Pending Approval';
                    ApplicationArea = All;
                    Visible = ApprovalsIDExists;
                    ToolTip = 'Purchase Invoices Pending Approval Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::"Pending Approval");
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }
                field(ApprovedNotPosted; ApprovedNotPostedCount())
                {
                    Caption = 'Approved not Posted';
                    ApplicationArea = All;
                    Visible = ApprovalsIDExists;
                    ToolTip = 'Purchase Invoices Approved, but not Posted Count';

                    trigger OnDrillDown()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
                        PurchHeader.SetRange(Status, PurchHeader.Status::Released);
                        if PurchHeader.FindSet() then
                            Page.Run(Page::"Purchase Invoices", PurchHeader);
                    end;
                }
                field(InvoicesPaidToday; InvoicesPaidTodayCount())
                {
                    Caption = 'Invoices Paid Today';
                    ApplicationArea = All;
                    ToolTip = 'Purchase Invoices Paid Today Count';

                    trigger OnDrillDown()
                    var
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                    begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                        VendorLedgerEntry.SetRange("Closed at Date", CalcDate('0D'));
                        if VendorLedgerEntry.FindSet() then
                            Page.Run(Page::"Vendor Ledger Entries", VendorLedgerEntry);
                    end;
                }
            }

            cuegroup(Journals)
            {
                field(GeneralJournal; CalculateGenJnlEntriesCount())
                {
                    Caption = 'General Journal';
                    ApplicationArea = All;
                    ToolTip = 'General Journal Entries Count';

                    trigger OnDrillDown()
                    begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::General);
                        if GenJnlBatch.FindFirst() then
                            GenJnlMgmt.TemplateSelectionFromBatch(GenJnlBatch);
                    end;
                }
                field(PaymentJournal; CalculatePaymentJnlEntriesCount())
                {
                    Caption = 'Payment Journal';
                    ApplicationArea = All;
                    ToolTip = 'Payment Journal Entries Count';

                    trigger OnDrillDown()
                    begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::Payments);
                        if GenJnlBatch.FindFirst() then
                            GenJnlMgmt.TemplateSelectionFromBatch(GenJnlBatch);
                    end;
                }
                field(PurchaseJournal; CalculatePurchJnlEntriesCount())
                {
                    Caption = 'Purchase Journal';
                    ApplicationArea = All;
                    ToolTip = 'Purchase Journal Entries Count';

                    trigger OnDrillDown()
                    begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::Purchases);
                        if GenJnlBatch.FindFirst() then
                            GenJnlMgmt.TemplateSelectionFromBatch(GenJnlBatch);
                    end;
                }
                field(CashReceiptJournal; CalculateCashJnlEntriesCount())
                {
                    Caption = 'Cash Receipt Journal';
                    ApplicationArea = All;
                    ToolTip = 'Cash Receipt Journal Entries Count';

                    trigger OnDrillDown()
                    begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetRange("Template Type", GenJnlBatch."Template Type"::"Cash Receipts");
                        if GenJnlBatch.FindFirst() then
                            GenJnlMgmt.TemplateSelectionFromBatch(GenJnlBatch);
                    end;
                }
            }
        }
    }

    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlMgmt: Codeunit GenJnlManagement;
        ApprovalsIDExists: Boolean;

    trigger OnOpenPage()
    begin
        CheckApprovals();
    end;

    local procedure CheckApprovals()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("Approver ID", UserId);
        ApprovalsIDExists := UserSetup.FindFirst();
    end;

    local procedure CalculateGenJnlEntriesCount(): Integer
    begin
        GenJournalTemplate.Reset();
        GenJournalTemplate.SetRange(Type, GenJournalTemplate.Type::General);
        if GenJournalTemplate.FindFirst() then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", GenJournalTemplate.Name);
            if GenJournalLine.FindSet() then
                exit(GenJournalLine.Count());
        end;
    end;

    local procedure CalculatePaymentJnlEntriesCount(): Integer
    begin
        GenJournalTemplate.Reset();
        GenJournalTemplate.SetRange(Type, GenJournalTemplate.Type::Payments);
        if GenJournalTemplate.FindFirst() then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", GenJournalTemplate.Name);
            if GenJournalLine.FindSet() then
                exit(GenJournalLine.Count());
        end;
    end;

    local procedure CalculatePurchJnlEntriesCount(): Integer
    begin
        GenJournalTemplate.Reset();
        GenJournalTemplate.SetRange(Type, GenJournalTemplate.Type::Purchases);
        if GenJournalTemplate.FindFirst() then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", GenJournalTemplate.Name);
            if GenJournalLine.FindSet() then
                exit(GenJournalLine.Count());
        end;
    end;

    local procedure CalculateCashJnlEntriesCount(): Integer
    begin
        GenJournalTemplate.Reset();
        GenJournalTemplate.SetRange(Type, GenJournalTemplate.Type::"Cash Receipts");
        if GenJournalTemplate.FindFirst() then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", GenJournalTemplate.Name);
            if GenJournalLine.FindSet() then
                exit(GenJournalLine.Count());
        end;
    end;

    local procedure UnpostedFundingsCount(): Integer
    var
        LoanDoc: Record lvnLoanDocument;
    begin
        LoanDoc.Reset();
        LoanDoc.SetRange("Transaction Type", LoanDoc."Transaction Type"::Funded);
        exit(LoanDoc.Count());
    end;

    local procedure UnpostedSalesCount(): Integer
    var
        LoanDoc: Record lvnLoanDocument;
    begin
        LoanDoc.Reset();
        LoanDoc.SetRange("Transaction Type", LoanDoc."Transaction Type"::Sold);
        exit(LoanDoc.Count());
    end;

    local procedure OpenInvoicesCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        exit(PurchHeader.Count());
    end;

    local procedure InvoicesPaidTodayCount(): Integer
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Closed at Date", CalcDate('0D'));
        exit(VendorLedgerEntry.Count());
    end;

    local procedure InvoicesPendingApprovalCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::"Pending Approval");
        exit(PurchHeader.Count());
    end;

    local procedure ApprovedNotPostedCount(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SetRange(Status, PurchHeader.Status::Released);
        exit(PurchHeader.Count());
    end;
}