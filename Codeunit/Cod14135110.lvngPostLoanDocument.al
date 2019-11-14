codeunit 14135110 "lvngPostLoanDocument"
{
    TableNo = lvngLoanDocument;

    trigger OnRun()
    begin
        lvngLoanDocumentSave := Rec;
        Post(lvngLoanDocumentSave);
        DeleteAfterPosting();
        Rec := lvngLoanDocumentSave;
    end;

    procedure Post(lvngLoanDocument: Record lvngLoanDocument)
    var
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        lvngLoanSoldDocument: Record lvngLoanSoldDocument;
        lvngLoanSoldDocumentLine: Record lvngLoanSoldDocumentLine;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DocumentAmount: Decimal;
        SourceCodeBlankLbl: Label 'Source Code can not be blank';
    begin
        GetLoanVisionSetup();
        case lvngLoanDocument."Transaction Type" of
            lvngLoanDocument."Transaction Type"::lvngFunded:
                lvngSourceCode := lvngLoanVisionSetup."Funded Source Code";
            lvngLoanDocument."Transaction Type"::lvngSold:
                lvngSourceCode := lvngLoanVisionSetup."Sold Source Code";
            lvngLoanDocument."Transaction Type"::lvngServiced:
                begin
                    GetLoanServicingSetup();
                    lvngSourceCode := lvngLoanServicingSetup.lvngServicedSourceCode;
                end;
        end;
        if lvngSourceCode = '' then
            Error(SourceCodeBlankLbl);
        if lvngLoanDocument.Void then
            lvngLoanDocument.TestField("Void Document No.");
        DocumentAmount := -PrepareDocumentLinesBuffer(lvngLoanDocument, lvngLoanDocumentLineTemp);

        lvngLoanDocumentLineTemp.reset;
        lvngLoanDocumentLineTemp.SetRange("Transaction Type", lvngLoanDocument."Transaction Type");
        lvngLoanDocumentLineTemp.SetRange("Document No.", lvngLoanDocument."Document No.");
        lvngLoanDocumentLineTemp.SetRange("Balancing Entry", false);
        if lvngLoanDocumentLineTemp.FindSet() then begin
            repeat
                clear(GenJnlLine);
                GenJnlLine.InitNewLine(lvngLoanDocument."Posting Date", lvngLoanDocument."Posting Date", lvngLoanDocumentLineTemp.Description, lvngLoanDocumentLineTemp."Global Dimension 1 Code", lvngLoanDocumentLineTemp."Global Dimension 2 Code", lvngLoanDocumentLineTemp."Dimension Set ID", lvngLoanDocumentLineTemp."Reason Code");
                CreateGenJnlLine(lvngLoanDocument, lvngLoanDocumentLineTemp, GenJnlLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(lvngLoanDocumentLineTemp);
            until lvngLoanDocumentLineTemp.Next() = 0;
        end;

        clear(GenJnlLine);
        GenJnlLine.InitNewLine(lvngLoanDocument."Posting Date", lvngLoanDocument."Posting Date", lvngLoanDocument."Loan No.", lvngLoanDocument."Global Dimension 1 Code", lvngLoanDocument."Global Dimension 2 Code", lvngLoanDocument."Dimension Set ID", lvngLoanDocument."Reason Code");
        CreateCustomerGenJnlLine(lvngLoanDocument, GenJnlLine, DocumentAmount);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        TransferDocumentHeaderToPosted(lvngLoanDocument);

        lvngLoanDocumentLineTemp.SetRange("Balancing Entry", true);
        if lvngLoanDocumentLineTemp.FindSet() then begin
            repeat
                Clear(GenJnlLine);
                GenJnlLine.InitNewLine(lvngLoanDocument."Posting Date", lvngLoanDocument."Posting Date", lvngLoanDocumentLineTemp.Description, lvngLoanDocumentLineTemp."Global Dimension 1 Code", lvngLoanDocumentLineTemp."Global Dimension 2 Code", lvngLoanDocumentLineTemp."Dimension Set ID", lvngLoanDocumentLineTemp."Reason Code");
                CreateBalancingGenJnlLine(lvngLoanDocument, lvngLoanDocumentLineTemp, GenJnlLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(lvngLoanDocumentLineTemp);
            until lvngLoanDocumentLineTemp.Next() = 0;
        end;
        if lvngLoanDocument.Void then begin
            VoidLedgerEntries(lvngLoanDocument."Document No.", lvngLoanDocument."Posting Date");
            VoidLedgerEntries(lvngLoanDocument."Void Document No.", lvngLoanDocument."Posting Date");
        end;
    end;

    local procedure DeleteAfterPosting()
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange("Transaction Type", lvngLoanDocumentSave."Transaction Type");
        lvngLoanDocumentLine.SetRange("Document No.", lvngLoanDocumentSave."Document No.");
        lvngLoanDocumentLine.DeleteAll();
        lvngLoanDocumentSave.Delete();
    end;

    local procedure PrepareDocumentLinesBuffer(lvngLoanDocument: Record lvngLoanDocument; var lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine): Decimal
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        DocumentAmount: Decimal;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange("Transaction Type", lvngLoanDocument."Transaction Type");
        lvngLoanDocumentLine.SetRange("Document No.", lvngLoanDocument."Document No.");
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLineTemp);
                lvngLoanDocumentLineTemp := lvngLoanDocumentLine;
                lvngLoanDocumentLineTemp.Insert();
                if not lvngLoanDocumentLine."Balancing Entry" then
                    DocumentAmount := DocumentAmount + lvngLoanDocumentLine.Amount;
            until lvngLoanDocumentLine.Next() = 0;
        end;
        exit(DocumentAmount);
    end;

    local procedure CreateCustomerGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; var GenJnlLine: Record "Gen. Journal Line"; Amount: Decimal)
    begin

        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::lvngInvoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document Type" := GenJnlLine."Document Type";
        GenJnlLine."Document No." := lvngLoanDocument."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := lvngLoanDocument."Customer No.";
        GenJnlLine.lvngLoanNo := lvngLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvngLoanDocument."Reason Code";
        GenJnlLine.Amount := Amount;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine."System-Created Entry" := true;
    end;



    local procedure CreateGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line")
    begin
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::lvngInvoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document No." := lvngLoanDocument."Document No.";
        case lvngLoanDocumentLine."Account Type" of
            lvngloandocumentline."Account Type"::"G/L Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvngLoanDocumentLine."Account Type"::"Bank Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;
        GenJnlLine."Account No." := lvngLoanDocumentLine."Account No.";
        GenJnlLine.Amount := lvngLoanDocumentLine.Amount;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvngLoanDocument."Reason Code";
        GenJnlLine.lvngServicingType := lvngLoanDocumentLine."Servicing Type";
    end;

    local procedure CreateBalancingGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."Document No." := lvngLoanDocument."Document No.";
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::lvngCreditMemo then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        case lvngLoanDocumentLine."Account Type" of
            lvngloandocumentline."Account Type"::"G/L Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvngLoanDocumentLine."Account Type"::"Bank Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;

        GenJnlLine."Account No." := lvngLoanDocumentLine."Account No.";
        GenJnlLine.Amount := lvngLoanDocumentLine.Amount;
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
        GenJnlLine."Bal. Account No." := lvngLoanDocument."Customer No.";
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::lvngCreditMemo then
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo" else
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Invoice";
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvngLoanDocument."Reason Code";
    end;

    local procedure TransferDocumentHeaderToPosted(lvngLoanDocument: Record lvngLoanDocument)
    var
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanSoldDocument: Record lvngLoanSoldDocument;
    begin
        case lvngLoanDocument."Transaction Type" of
            lvngLoanDocument."Transaction Type"::lvngFunded:
                begin
                    Clear(lvngLoanFundedDocument);
                    lvngLoanFundedDocument.TransferFields(lvngLoanDocument);
                    lvngLoanFundedDocument.Insert(true);
                    if lvngLoanDocument.Void then begin
                        lvngLoanFundedDocument.Get(lvngLoanDocument."Void Document No.");
                        lvngLoanFundedDocument.Void := true;
                        lvngLoanFundedDocument."Void Document No." := lvngLoanDocument."Document No.";
                        lvngLoanFundedDocument.Modify();
                    end;
                end;
            lvngLoanDocument."Transaction Type"::lvngSold:
                begin
                    Clear(lvngLoanSoldDocument);
                    lvngLoanSoldDocument.TransferFields(lvngLoanDocument);
                    lvngLoanSoldDocument.Insert(true);
                    if lvngLoanDocument.Void then begin
                        lvngLoanSoldDocument.Get(lvngLoanDocument."Void Document No.");
                        lvngLoanSoldDocument.Void := true;
                        lvngLoanSoldDocument."Void Document No." := lvngLoanDocument."Document No.";
                        lvngLoanSoldDocument.Modify();
                    end;
                end;
        end;
    end;

    local procedure TransferDocumentLineToPosted(lvngLoanDocumentLine: Record lvngLoanDocumentLine)
    var
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        lvngLoanSoldDocumentLine: Record lvngLoanSoldDocumentLine;
    begin
        case lvngLoanDocumentLine."Transaction Type" of
            lvngLoanDocumentLine."Transaction Type"::lvngFunded:
                begin
                    Clear(lvngLoanFundedDocumentLine);
                    lvngLoanFundedDocumentLine.TransferFields(lvngLoanDocumentLine);
                    lvngLoanFundedDocumentLine.Insert(true);
                end;
            lvngLoanDocumentLine."Transaction Type"::lvngSold:
                begin
                    Clear(lvngLoanSoldDocumentLine);
                    lvngLoanSoldDocumentLine.TransferFields(lvngLoanDocumentLine);
                    lvngLoanSoldDocumentLine.Insert(true);
                end;
        end;
    end;

    local procedure VoidLedgerEntries(lvngDocumentNo: Code[20]; lvngPostingDate: Date)
    var
        GLEntry: Record "G/L Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        lvngLedgerVoidEntry: Record lvngLedgerVoidEntry;
    begin
        GLEntry.reset;
        GLEntry.SetCurrentKey("Document No.", "Posting Date");
        GLEntry.SetRange("Document No.", lvngDocumentNo);
        GLEntry.SetRange("Posting Date", lvngPostingDate);
        if GLEntry.FindSet() then begin
            repeat
                Clear(lvngLedgerVoidEntry);
                lvngLedgerVoidEntry.InsertFromGLEntry(GLEntry);
            until GLEntry.Next() = 0;
        end;
        CustLedgerEntry.reset;
        CustLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        CustLedgerEntry.SetRange("Document No.", lvngDocumentNo);
        CustLedgerEntry.SetRange("Posting Date", lvngPostingDate);
        if CustLedgerEntry.FindSet() then begin
            repeat
                Clear(lvngLedgerVoidEntry);
                lvngLedgerVoidEntry.InsertFromCustLedgEntry(CustLedgerEntry);
            until CustLedgerEntry.Next() = 0;
        end;
        BankAccountLedgerEntry.reset;
        BankAccountLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        BankAccountLedgerEntry.SetRange("Document No.", lvngDocumentNo);
        BankAccountLedgerEntry.SetRange("Posting Date", lvngPostingDate);
        if BankAccountLedgerEntry.FindSet() then begin
            repeat
                Clear(lvngLedgerVoidEntry);
                lvngLedgerVoidEntry.InsertFromBankAccountLedgerEntry(BankAccountLedgerEntry);
            until BankAccountLedgerEntry.Next() = 0;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetup.TestField("Funded Source Code");
            lvngLoanVisionSetup.TestField("Sold Source Code");
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    local procedure GetLoanServicingSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanServicingSetup.Get();
            lvngLoanServicingSetup.TestField(lvngServicedSourceCode);
            lvngLoanServicingSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanServicingSetup: Record lvngLoanServicingSetup;
        lvngLoanVisionSetupRetrieved: Boolean;
        lvngLoanServicingSetupRetrieved: Boolean;
        lvngLoanDocumentSave: Record lvngLoanDocument;
        lvngSourceCode: Code[20];
}