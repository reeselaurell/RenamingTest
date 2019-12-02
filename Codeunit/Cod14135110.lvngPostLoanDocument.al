codeunit 14135110 lvngPostLoanDocument
{
    TableNo = lvngLoanDocument;

    trigger OnRun()
    var
        LoanDocumentSave: Record lvngLoanDocument;
    begin
        LoanDocumentSave := Rec;
        Post(LoanDocumentSave);
        DeleteAfterPosting(LoanDocumentSave);
        Rec := LoanDocumentSave;
    end;

    local procedure Post(LoanDocument: Record lvngLoanDocument)
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanServicingSetup: Record lvngLoanServicingSetup;
        LoanFundedDocument: Record lvngLoanFundedDocument;
        LoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        LoanSoldDocument: Record lvngLoanSoldDocument;
        LoanSoldDocumentLine: Record lvngLoanSoldDocumentLine;
        TempLoanDocumentLine: Record lvngLoanDocumentLine temporary;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SourceCode: Code[20];
        DocumentAmount: Decimal;
        SourceCodeBlankLbl: Label 'Source Code can not be blank';
    begin
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Funded Source Code");
        LoanVisionSetup.TestField("Sold Source Code");
        case LoanDocument."Transaction Type" of
            LoanDocument."Transaction Type"::Funded:
                SourceCode := LoanVisionSetup."Funded Source Code";
            LoanDocument."Transaction Type"::Sold:
                SourceCode := LoanVisionSetup."Sold Source Code";
            LoanDocument."Transaction Type"::Serviced:
                begin
                    LoanServicingSetup.Get();
                    LoanServicingSetup.TestField("Serviced Source Code");
                    SourceCode := LoanServicingSetup."Serviced Source Code";
                end;
        end;
        if SourceCode = '' then
            Error(SourceCodeBlankLbl);
        if LoanDocument.Void then
            LoanDocument.TestField("Void Document No.");
        DocumentAmount := -PrepareDocumentLinesBuffer(LoanDocument, TempLoanDocumentLine);

        TempLoanDocumentLine.Reset();
        TempLoanDocumentLine.SetRange("Transaction Type", LoanDocument."Transaction Type");
        TempLoanDocumentLine.SetRange("Document No.", LoanDocument."Document No.");
        TempLoanDocumentLine.SetRange("Balancing Entry", false);
        if TempLoanDocumentLine.FindSet() then begin
            repeat
                clear(GenJnlLine);
                GenJnlLine.InitNewLine(LoanDocument."Posting Date", LoanDocument."Posting Date", TempLoanDocumentLine.Description, TempLoanDocumentLine."Global Dimension 1 Code", TempLoanDocumentLine."Global Dimension 2 Code", TempLoanDocumentLine."Dimension Set ID", TempLoanDocumentLine."Reason Code");
                CreateGenJnlLine(LoanDocument, TempLoanDocumentLine, GenJnlLine, SourceCode);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(TempLoanDocumentLine);
            until TempLoanDocumentLine.Next() = 0;
        end;

        clear(GenJnlLine);
        GenJnlLine.InitNewLine(LoanDocument."Posting Date", LoanDocument."Posting Date", LoanDocument."Loan No.", LoanDocument."Global Dimension 1 Code", LoanDocument."Global Dimension 2 Code", LoanDocument."Dimension Set ID", LoanDocument."Reason Code");
        CreateCustomerGenJnlLine(LoanDocument, GenJnlLine, DocumentAmount, SourceCode);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        TransferDocumentHeaderToPosted(LoanDocument);

        TempLoanDocumentLine.SetRange("Balancing Entry", true);
        if TempLoanDocumentLine.FindSet() then begin
            repeat
                Clear(GenJnlLine);
                GenJnlLine.InitNewLine(LoanDocument."Posting Date", LoanDocument."Posting Date", TempLoanDocumentLine.Description, TempLoanDocumentLine."Global Dimension 1 Code", TempLoanDocumentLine."Global Dimension 2 Code", TempLoanDocumentLine."Dimension Set ID", TempLoanDocumentLine."Reason Code");
                CreateBalancingGenJnlLine(LoanDocument, TempLoanDocumentLine, GenJnlLine, SourceCode);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(TempLoanDocumentLine);
            until TempLoanDocumentLine.Next() = 0;
        end;
        if LoanDocument.Void then begin
            VoidLedgerEntries(LoanDocument."Document No.", LoanDocument."Posting Date");
            VoidLedgerEntries(LoanDocument."Void Document No.", LoanDocument."Posting Date");
        end;
    end;

    local procedure DeleteAfterPosting(var LoanDocumentHeader: Record lvngLoanDocument)
    var
        LoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Transaction Type", LoanDocumentHeader."Transaction Type");
        LoanDocumentLine.SetRange("Document No.", LoanDocumentHeader."Document No.");
        LoanDocumentLine.DeleteAll();
        LoanDocumentHeader.Delete();
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

    local procedure CreateCustomerGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; var GenJnlLine: Record "Gen. Journal Line"; Amount: Decimal; SourceCode: Code[20])
    begin

        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::Invoice then
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
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."System-Created Entry" := true;
    end;



    local procedure CreateGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line"; SourceCode: Code[20])
    begin
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::Invoice then
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
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvngLoanDocument."Reason Code";
        GenJnlLine.lvngServicingType := lvngLoanDocumentLine."Servicing Type";
    end;

    local procedure CreateBalancingGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line"; SourceCode: Code[20])
    begin
        GenJnlLine."Document No." := lvngLoanDocument."Document No.";
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::"Credit Memo" then
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
        if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::"Credit Memo" then
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo" else
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Invoice";
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvngLoanDocument."Reason Code";
    end;

    local procedure TransferDocumentHeaderToPosted(lvngLoanDocument: Record lvngLoanDocument)
    var
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanSoldDocument: Record lvngLoanSoldDocument;
    begin
        case lvngLoanDocument."Transaction Type" of
            lvngLoanDocument."Transaction Type"::Funded:
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
            lvngLoanDocument."Transaction Type"::Sold:
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
            lvngLoanDocumentLine."Transaction Type"::Funded:
                begin
                    Clear(lvngLoanFundedDocumentLine);
                    lvngLoanFundedDocumentLine.TransferFields(lvngLoanDocumentLine);
                    lvngLoanFundedDocumentLine.Insert(true);
                end;
            lvngLoanDocumentLine."Transaction Type"::Sold:
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
}