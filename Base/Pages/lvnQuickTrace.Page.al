page 14135162 "lvnQuickTrace"
{
    Caption = 'Quick Trace';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnLoanReportingBuffer;
    SourceTableView = sorting("Loan No.");
    CardPageId = lvnLoanCard;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;
    DataCaptionFields = "Loan No.";
    SourceTableTemporary = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            group(Search)
            {
                Caption = 'Search';

                field(LoanNo; LoanNo)
                {
                    Caption = 'Loan No.';
                    TableRelation = lvnLoan;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.DeleteAll();
                        Rec."Loan No." := LoanNo;
                        Rec.Insert();
                        Rec.FindFirst();
                        CurrPage.Update(false);
                        DoSearch();
                    end;
                }
            }
            group(PostedDocCaption)
            {
                Caption = 'Posted Document';

                grid(PostedDocuments)
                {
                    GridLayout = Rows;

                    cuegroup(Invoices)
                    {
                        Caption = 'Invoices';

                        field(FundedInvoices; FundedInvoices)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if FundedInvoices <> 0 then
                                    Page.RunModal(0, SalesInvHeaderLF);
                            end;
                        }
                        field(SoldInvoices; SoldInvoices)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if SoldInvoices <> 0 then
                                    Page.RunModal(0, SalesInvHeaderLP)
                            end;
                        }
                        field(ServicedInvoices; ServicedInvoices)
                        {
                            Caption = 'Serviced';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if ServicedInvoices <> 0 then
                                    Page.RunModal(0, SalesInvHeaderLS);
                            end;
                        }
                    }
                    cuegroup(CreditMemos)
                    {
                        Caption = 'Credit Memos';

                        field(FundedCreditMemos; FundedCreditMemos)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if FundedCreditMemos <> 0 then
                                    Page.RunModal(0, SalesCrMemoHeaderLF);
                            end;
                        }
                        field(SoldCreditMemos; SoldCreditMemos)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if SoldCreditMemos <> 0 then
                                    Page.RunModal(0, SalesCrMemoHeaderLP);
                            end;
                        }
                        field(ServicedCreditMemos; ServicedCreditMemos)
                        {
                            Caption = 'Serviced';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if ServicedCreditMemos <> 0 then
                                    Page.RunModal(0, SalesCrMemoHeaderLS);
                            end;
                        }
                    }
                }
            }
            group(PostedLoanDocCaption)
            {
                Caption = 'Posted Loan Documents';

                grid(PostedLoanDocs)
                {
                    GridLayout = Rows;

                    cuegroup(LoanDocInvoices)
                    {
                        Caption = 'Invoices';

                        field(FundedLoanDocInvoices; FundedLoanDocInvoices)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if FundedLoanDocInvoices <> 0 then
                                    Page.RunModal(14135129, LoanDocInvoiceLF);
                            end;
                        }
                        field(SoldLoanDocInvoices; SoldLoanDocInvoices)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if SoldLoanDocInvoices <> 0 then
                                    Page.RunModal(14135133, LoanDocInvoiceLP);
                            end;
                        }
                    }
                    cuegroup(LoanDocCrMemos)
                    {
                        Caption = 'Credit Memos';

                        field(FundedLoanDocCrMemos; FundedLoanDocCrMemos)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if FundedLoanDocCrMemos <> 0 then
                                    Page.RunModal(14135129, LoanDocCreditLF);
                            end;
                        }
                        field(SoldLoanDocCrMemos; SoldLoanDocCrMemos)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if SoldLoanDocCrMemos <> 0 then
                                    Page.RunModal(14135133, LoanDocCreditLP);
                            end;
                        }
                    }
                }
            }
            group(PostedTransactionsCaption)
            {
                Caption = 'Posted Transactions';

                grid(PostedTransactions)
                {
                    GridLayout = Rows;

                    cuegroup(PostedTransactionCue)
                    {
                        ShowCaption = false;

                        field(GeneralLedgerTransactions; GeneralLedgerTransactions)
                        {
                            Caption = 'General Ledger';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if GeneralLedgerTransactions <> 0 then
                                    Page.RunModal(0, GLEntry);
                            end;
                        }
                        field(CustomerTransactions; CustomerTransactions)
                        {
                            Caption = 'Customer Ledger';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if CustomerTransactions <> 0 then
                                    Page.RunModal(0, CustLedgerEntry);
                            end;
                        }
                        field(VendorTransactions; VendorTransactions)
                        {
                            Caption = 'Vendor Ledger';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if VendorTransactions <> 0 then
                                    Page.RunModal(0, VendLedgerEntry);
                            end;
                        }
                        field(BankTransactions; BankTransactions)
                        {
                            Caption = 'Bank Ledger';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if BankTransactions <> 0 then
                                    Page.RunModal(0, BankLedgEntry);
                            end;
                        }
                    }
                }
            }
            group(OpenDocumentsCaption)
            {
                Caption = 'Open Documents';

                grid(OpenDocuments)
                {
                    GridLayout = Rows;

                    cuegroup(OpenInvoices)
                    {
                        Caption = 'Open Invoices';

                        field(OpenFundedInvoices; OpenFundedInvoices)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenFundedInvoices <> 0 then
                                    Page.RunModal(0, SalesHeaderInvoiceLF);
                            end;
                        }
                        field(OpenSoldInvoices; OpenSoldInvoices)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenSoldInvoices <> 0 then
                                    Page.RunModal(0, SalesHeaderInvoiceLP);
                            end;
                        }
                        field(OpenServInvoices; OpenServInvoices)
                        {
                            Caption = 'Serviced';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenServInvoices <> 0 then
                                    Page.RunModal(0, SalesHeaderInvoiceLS);
                            end;
                        }
                    }
                    cuegroup(OpenCreditMemos)
                    {
                        Caption = 'Open Credit Memos';

                        field(OpenFundedCrMemos; OpenFundedCrMemos)
                        {
                            Caption = 'Funded';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenFundedCrMemos <> 0 then
                                    Page.RunModal(0, SalesHeaderCreditLF);
                            end;
                        }
                        field(OpenSoldCrMemos; OpenSoldCrMemos)
                        {
                            Caption = 'Sold';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenSoldCrMemos <> 0 then
                                    Page.RunModal(0, SalesHeaderCreditLP)
                            end;
                        }
                        field(OpenServCrMemos; OpenServCrMemos)
                        {
                            Caption = 'Serviced';
                            ApplicationArea = All;
                            Editable = false;
                            Importance = Promoted;

                            trigger OnDrillDown()
                            begin
                                if OpenServCrMemos <> 0 then
                                    Page.RunModal(0, SalesHeaderCreditLS);
                            end;
                        }
                    }
                }
            }
        }
        area(FactBoxes)
        {
            part(LoanFactBox; lvnLoanInfoBox)
            {
                Caption = 'Information';
                SubPageView = sorting("No.") order(ascending);
                SubPageLink = "No." = field("Loan No.");
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoanVisionSetup.Get();
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        LoanServicingSetup: Record lvnLoanServicingSetup;
        SalesInvHeaderLF: Record "Sales Invoice Header";
        SalesCrMemoHeaderLF: Record "Sales Cr.Memo Header";
        SalesHeaderCreditLF: Record "Sales Header";
        SalesHeaderInvoiceLF: Record "Sales Header";
        SalesInvHeaderLP: Record "Sales Invoice Header";
        SalesCrMemoHeaderLP: Record "Sales Cr.Memo Header";
        SalesHeaderCreditLP: Record "Sales Header";
        SalesHeaderInvoiceLP: Record "Sales Header";
        SalesInvHeaderLS: Record "Sales Invoice Header";
        SalesCrMemoHeaderLS: Record "Sales Cr.Memo Header";
        SalesHeaderCreditLS: Record "Sales Header";
        SalesHeaderInvoiceLS: Record "Sales Header";
        LoanDocInvoiceLF: Record lvnLoanFundedDocument;
        LoanDocCreditLF: Record lvnLoanFundedDocument;
        LoanDocInvoiceLP: Record lvnLoanSoldDocument;
        LoanDocCreditLP: Record lvnLoanSoldDocument;
        BankLedgEntry: Record "Bank Account Ledger Entry";
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        LoanNo: Code[20];
        FundedInvoices: Integer;
        FundedCreditMemos: Integer;
        SoldInvoices: Integer;
        ServicedInvoices: Integer;
        SoldCreditMemos: Integer;
        ServicedCreditMemos: Integer;
        CustomerTransactions: Integer;
        VendorTransactions: Integer;
        GeneralLedgerTransactions: Integer;
        BankTransactions: Integer;
        OpenFundedInvoices: Integer;
        OpenFundedCrMemos: Integer;
        OpenSoldInvoices: Integer;
        OpenSoldCrMemos: Integer;
        OpenServInvoices: Integer;
        OpenServCrMemos: Integer;
        FundedLoanDocInvoices: Integer;
        FundedLoanDocCrMemos: Integer;
        SoldLoanDocInvoices: Integer;
        SoldLoanDocCrMemos: Integer;

    procedure DoSearch()
    begin
        LoanVisionSetup.Get();
        LoanServicingSetup.Get();
        FundedInvoices := 0;
        FundedCreditMemos := 0;
        SoldInvoices := 0;
        SoldCreditMemos := 0;
        ServicedInvoices := 0;
        ServicedCreditMemos := 0;
        CustomerTransactions := 0;
        VendorTransactions := 0;
        GeneralLedgerTransactions := 0;
        BankTransactions := 0;
        OpenFundedInvoices := 0;
        OpenFundedCrMemos := 0;
        OpenSoldInvoices := 0;
        OpenSoldCrMemos := 0;
        OpenServInvoices := 0;
        OpenServCrMemos := 0;
        FundedLoanDocInvoices := 0;
        FundedLoanDocCrMemos := 0;
        SoldLoanDocInvoices := 0;
        SoldLoanDocCrMemos := 0;

        SalesInvHeaderLF.Reset();
        SalesInvHeaderLF.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesInvHeaderLF.SetRange(lvnLoanNo, LoanNo);
        SalesInvHeaderLF.SetFilter("Reason Code", '%1', LoanVisionSetup."Funded Reason Code");
        FundedInvoices := SalesInvHeaderLF.Count();

        SalesCrMemoHeaderLF.Reset();
        SalesCrMemoHeaderLF.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesCrMemoHeaderLF.SetRange(lvnLoanNo, LoanNo);
        SalesCrMemoHeaderLF.SetFilter("Reason Code", '%1', LoanVisionSetup."Funded Reason Code");
        FundedCreditMemos := SalesCrMemoHeaderLF.Count();

        SalesInvHeaderLP.Reset();
        SalesInvHeaderLP.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesInvHeaderLP.SetRange(lvnLoanNo, LoanNo);
        SalesInvHeaderLP.SetFilter("Reason Code", '%1', LoanVisionSetup."Sold Reason Code");
        SoldInvoices := SalesInvHeaderLP.Count();

        SalesCrMemoHeaderLP.Reset();
        SalesCrMemoHeaderLP.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesCrMemoHeaderLP.SetRange(lvnLoanNo, LoanNo);
        SalesCrMemoHeaderLP.SetFilter("Reason Code", '%1', LoanVisionSetup."Sold Reason Code");
        SoldCreditMemos := SalesCrMemoHeaderLP.Count();

        SalesInvHeaderLS.Reset();
        SalesInvHeaderLS.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesInvHeaderLS.SetRange(lvnLoanNo, LoanNo);
        SalesInvHeaderLS.SetFilter("Reason Code", '%1', LoanServicingSetup."Serviced Reason Code");
        ServicedInvoices := SalesInvHeaderLS.Count();

        SalesCrMemoHeaderLS.Reset();
        SalesCrMemoHeaderLS.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesCrMemoHeaderLS.SetRange(lvnLoanNo, LoanNo);
        SalesCrMemoHeaderLS.SetFilter("Reason Code", '%1', LoanServicingSetup."Serviced Reason Code");
        ServicedCreditMemos := SalesCrMemoHeaderLS.Count();

        SalesHeaderInvoiceLF.Reset();
        SalesHeaderInvoiceLF.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderInvoiceLF.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::Invoice);
        SalesHeaderInvoiceLF.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderInvoiceLF.SetFilter("Reason Code", '%1', LoanVisionSetup."Funded Reason Code");
        OpenFundedInvoices := SalesHeaderInvoiceLF.Count();

        SalesHeaderCreditLF.Reset();
        SalesHeaderCreditLF.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderCreditLF.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::"Credit Memo");
        SalesHeaderCreditLF.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderCreditLF.SetFilter("Reason Code", '%1', LoanVisionSetup."Funded Reason Code");
        OpenFundedCrMemos := SalesHeaderCreditLF.Count();

        SalesHeaderInvoiceLP.Reset();
        SalesHeaderInvoiceLP.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderInvoiceLP.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::Invoice);
        SalesHeaderInvoiceLP.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderInvoiceLP.SetFilter("Reason Code", '%1', LoanVisionSetup."Sold Reason Code");
        OpenSoldInvoices := SalesHeaderInvoiceLP.Count();

        SalesHeaderCreditLP.Reset();
        SalesHeaderCreditLP.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderCreditLP.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::"Credit Memo");
        SalesHeaderCreditLP.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderCreditLP.SetFilter("Reason Code", '%1', LoanVisionSetup."Sold Reason Code");
        OpenSoldCrMemos := SalesHeaderCreditLP.Count();

        SalesHeaderInvoiceLS.Reset();
        SalesHeaderInvoiceLS.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderInvoiceLS.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::Invoice);
        SalesHeaderInvoiceLS.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderInvoiceLS.SetFilter("Reason Code", '%1', LoanServicingSetup."Serviced Reason Code");
        OpenServInvoices := SalesHeaderInvoiceLS.Count();

        SalesHeaderCreditLS.Reset();
        SalesHeaderCreditLS.SetCurrentKey(lvnLoanNo, "Reason Code");
        SalesHeaderCreditLS.SetRange("Document Type", SalesHeaderInvoiceLF."Document Type"::"Credit Memo");
        SalesHeaderCreditLS.SetRange(lvnLoanNo, LoanNo);
        SalesHeaderCreditLS.SetFilter("Reason Code", '%1', LoanServicingSetup."Serviced Reason Code");
        OpenServCrMemos := SalesHeaderCreditLS.Count();

        LoanDocInvoiceLF.Reset();
        LoanDocInvoiceLF.SetCurrentKey("Loan No.", "Reason Code");
        LoanDocInvoiceLF.SetRange("Document Type", LoanDocInvoiceLF."Document Type"::Invoice);
        LoanDocInvoiceLF.SetRange("Loan No.", LoanNo);
        FundedLoanDocInvoices := LoanDocInvoiceLF.Count();

        LoanDocCreditLF.Reset();
        LoanDocCreditLF.SetCurrentKey("Loan No.", "Reason Code");
        LoanDocCreditLF.SetRange("Document Type", LoanDocCreditLF."Document Type"::"Credit Memo");
        LoanDocCreditLF.SetRange("Loan No.", LoanNo);
        FundedLoanDocCrMemos := LoanDocCreditLF.Count();

        LoanDocInvoiceLP.Reset();
        LoanDocInvoiceLP.SetCurrentKey("Loan No.", "Reason Code");
        LoanDocInvoiceLP.SetRange("Document Type", LoanDocInvoiceLP."Document Type"::Invoice);
        LoanDocInvoiceLP.SetRange("Loan No.", LoanNo);
        SoldLoanDocInvoices := LoanDocInvoiceLP.Count();

        LoanDocCreditLP.Reset();
        LoanDocCreditLP.SetCurrentKey("Loan No.", "Reason Code");
        LoanDocCreditLP.SetRange("Document Type", LoanDocCreditLP."Document Type"::"Credit Memo");
        LoanDocCreditLP.SetRange("Loan No.", LoanNo);
        SoldLoanDocCrMemos := LoanDocCreditLP.Count();

        BankLedgEntry.Reset();
        BankLedgEntry.SetCurrentKey(lvnLoanNo);
        BankLedgEntry.SetRange(lvnLoanNo, LoanNo);
        BankTransactions := BankLedgEntry.Count();

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey(lvnLoanNo);
        CustLedgerEntry.SetRange(lvnLoanNo, LoanNo);
        CustomerTransactions := CustLedgerEntry.Count();

        VendLedgerEntry.Reset();
        VendLedgerEntry.SetCurrentKey(lvnLoanNo);
        VendLedgerEntry.SetRange(lvnLoanNo, LoanNo);
        VendorTransactions := VendLedgerEntry.Count();

        GLEntry.Reset();
        GLEntry.SetCurrentKey(lvnLoanNo);
        GLEntry.SetRange(lvnLoanNo, LoanNo);
        GeneralLedgerTransactions := GLEntry.Count();

        CurrPage.Update(false);
    end;

    procedure AssignLoanNo(pLoanNo: Code[20])
    begin
        Rec.DeleteAll();
        LoanNo := pLoanNo;
        Rec."Loan No." := LoanNo;
        Rec.Insert();
        Rec.FindFirst();
        CurrPage.Update(false);
        DoSearch();
    end;
}