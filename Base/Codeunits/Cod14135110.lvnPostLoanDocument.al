codeunit 14135110 "lvnPostLoanDocument"
{
    TableNo = lvnLoanDocument;

    trigger OnRun()
    var
        LoanDocumentSave: Record lvnLoanDocument;
    begin
        LoanDocumentSave := Rec;
        Post(LoanDocumentSave);
        DeleteAfterPosting(LoanDocumentSave);
        Rec := LoanDocumentSave;
    end;

    local procedure Post(LoanDocument: Record lvnLoanDocument)
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        LoanServicingSetup: Record lvnLoanServicingSetup;
        LoanFundedDocument: Record lvnLoanFundedDocument;
        LoanFundedDocumentLine: Record lvnLoanFundedDocumentLine;
        LoanSoldDocument: Record lvnLoanSoldDocument;
        LoanSoldDocumentLine: Record lvnLoanSoldDocumentLine;
        TempLoanDocumentLine: Record lvnLoanDocumentLine temporary;
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

    local procedure DeleteAfterPosting(var LoanDocumentHeader: Record lvnLoanDocument)
    var
        LoanDocumentLine: Record lvnLoanDocumentLine;
    begin
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Transaction Type", LoanDocumentHeader."Transaction Type");
        LoanDocumentLine.SetRange("Document No.", LoanDocumentHeader."Document No.");
        LoanDocumentLine.DeleteAll();
        LoanDocumentHeader.Delete();
    end;

    local procedure PrepareDocumentLinesBuffer(lvnLoanDocument: Record lvnLoanDocument; var lvnLoanDocumentLineTemp: Record lvnLoanDocumentLine): Decimal
    var
        lvnLoanDocumentLine: Record lvnLoanDocumentLine;
        DocumentAmount: Decimal;
    begin
        lvnLoanDocumentLine.reset;
        lvnLoanDocumentLine.SetRange("Transaction Type", lvnLoanDocument."Transaction Type");
        lvnLoanDocumentLine.SetRange("Document No.", lvnLoanDocument."Document No.");
        if lvnLoanDocumentLine.FindSet() then begin
            repeat
                Clear(lvnLoanDocumentLineTemp);
                lvnLoanDocumentLineTemp := lvnLoanDocumentLine;
                lvnLoanDocumentLineTemp.Insert();
                if not lvnLoanDocumentLine."Balancing Entry" then
                    DocumentAmount := DocumentAmount + lvnLoanDocumentLine.Amount;
            until lvnLoanDocumentLine.Next() = 0;
        end;
        exit(DocumentAmount);
    end;

    local procedure CreateCustomerGenJnlLine(lvnLoanDocument: Record lvnLoanDocument; var GenJnlLine: Record "Gen. Journal Line"; Amount: Decimal; SourceCode: Code[20])
    begin

        if lvnLoanDocument."Document Type" = lvnLoanDocument."Document Type"::Invoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document Type" := GenJnlLine."Document Type";
        GenJnlLine."Document No." := lvnLoanDocument."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := lvnLoanDocument."Customer No.";
        GenJnlLine.lvnLoanNo := lvnLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvnLoanDocument."Reason Code";
        GenJnlLine.Amount := Amount;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."External Document No." := lvnLoanDocument."External Document No.";
    end;



    local procedure CreateGenJnlLine(lvnLoanDocument: Record lvnLoanDocument; lvnLoanDocumentLine: Record lvnLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line"; SourceCode: Code[20])
    begin
        if lvnLoanDocument."Document Type" = lvnLoanDocument."Document Type"::Invoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document No." := lvnLoanDocument."Document No.";
        case lvnLoanDocumentLine."Account Type" of
            lvnloandocumentline."Account Type"::"G/L Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvnLoanDocumentLine."Account Type"::"Bank Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;
        GenJnlLine."Account No." := lvnLoanDocumentLine."Account No.";
        GenJnlLine.Amount := lvnLoanDocumentLine.Amount;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.lvnLoanNo := lvnLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvnLoanDocument."Reason Code";
        GenJnlLine.lvnServicingType := lvnLoanDocumentLine."Servicing Type";
        GenJnlLine."External Document No." := lvnLoanDocument."External Document No.";
    end;

    local procedure CreateBalancingGenJnlLine(lvnLoanDocument: Record lvnLoanDocument; lvnLoanDocumentLine: Record lvnLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line"; SourceCode: Code[20])
    begin
        GenJnlLine."Document No." := lvnLoanDocument."Document No.";
        if lvnLoanDocument."Document Type" = lvnLoanDocument."Document Type"::"Credit Memo" then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        case lvnLoanDocumentLine."Account Type" of
            lvnloandocumentline."Account Type"::"G/L Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvnLoanDocumentLine."Account Type"::"Bank Account":
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;

        GenJnlLine."Account No." := lvnLoanDocumentLine."Account No.";
        GenJnlLine.Amount := lvnLoanDocumentLine.Amount;
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
        GenJnlLine."Bal. Account No." := lvnLoanDocument."Customer No.";
        if lvnLoanDocument."Document Type" = lvnLoanDocument."Document Type"::"Credit Memo" then
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo" else
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Invoice";
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.lvnLoanNo := lvnLoanDocument."Loan No.";
        GenJnlLine."Reason Code" := lvnLoanDocument."Reason Code";
        GenJnlLine."External Document No." := lvnLoanDocument."External Document No.";
    end;

    local procedure TransferDocumentHeaderToPosted(lvnLoanDocument: Record lvnLoanDocument)
    var
        lvnLoanFundedDocument: Record lvnLoanFundedDocument;
        lvnLoanSoldDocument: Record lvnLoanSoldDocument;
    begin
        case lvnLoanDocument."Transaction Type" of
            lvnLoanDocument."Transaction Type"::Funded:
                begin
                    Clear(lvnLoanFundedDocument);
                    lvnLoanFundedDocument.TransferFields(lvnLoanDocument);
                    lvnLoanFundedDocument.Insert(true);
                    if lvnLoanDocument.Void then begin
                        lvnLoanFundedDocument.Get(lvnLoanDocument."Void Document No.");
                        lvnLoanFundedDocument.Void := true;
                        lvnLoanFundedDocument."Void Document No." := lvnLoanDocument."Document No.";
                        lvnLoanFundedDocument.Modify();
                    end;
                end;
            lvnLoanDocument."Transaction Type"::Sold:
                begin
                    Clear(lvnLoanSoldDocument);
                    lvnLoanSoldDocument.TransferFields(lvnLoanDocument);
                    lvnLoanSoldDocument.Insert(true);
                    if lvnLoanDocument.Void then begin
                        lvnLoanSoldDocument.Get(lvnLoanDocument."Void Document No.");
                        lvnLoanSoldDocument.Void := true;
                        lvnLoanSoldDocument."Void Document No." := lvnLoanDocument."Document No.";
                        lvnLoanSoldDocument.Modify();
                    end;
                end;
        end;
    end;

    local procedure TransferDocumentLineToPosted(lvnLoanDocumentLine: Record lvnLoanDocumentLine)
    var
        lvnLoanFundedDocumentLine: Record lvnLoanFundedDocumentLine;
        lvnLoanSoldDocumentLine: Record lvnLoanSoldDocumentLine;
    begin
        case lvnLoanDocumentLine."Transaction Type" of
            lvnLoanDocumentLine."Transaction Type"::Funded:
                begin
                    Clear(lvnLoanFundedDocumentLine);
                    lvnLoanFundedDocumentLine.TransferFields(lvnLoanDocumentLine);
                    lvnLoanFundedDocumentLine.Insert(true);
                end;
            lvnLoanDocumentLine."Transaction Type"::Sold:
                begin
                    Clear(lvnLoanSoldDocumentLine);
                    lvnLoanSoldDocumentLine.TransferFields(lvnLoanDocumentLine);
                    lvnLoanSoldDocumentLine.Insert(true);
                end;
        end;
    end;

    local procedure VoidLedgerEntries(lvnDocumentNo: Code[20]; lvnPostingDate: Date)
    var
        GLEntry: Record "G/L Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        lvnLedgerVoidEntry: Record lvnLedgerVoidEntry;
    begin
        GLEntry.reset;
        GLEntry.SetCurrentKey("Document No.", "Posting Date");
        GLEntry.SetRange("Document No.", lvnDocumentNo);
        GLEntry.SetRange("Posting Date", lvnPostingDate);
        if GLEntry.FindSet() then begin
            repeat
                Clear(lvnLedgerVoidEntry);
                lvnLedgerVoidEntry.InsertFromGLEntry(GLEntry);
            until GLEntry.Next() = 0;
        end;
        CustLedgerEntry.reset;
        CustLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        CustLedgerEntry.SetRange("Document No.", lvnDocumentNo);
        CustLedgerEntry.SetRange("Posting Date", lvnPostingDate);
        if CustLedgerEntry.FindSet() then begin
            repeat
                Clear(lvnLedgerVoidEntry);
                lvnLedgerVoidEntry.InsertFromCustLedgEntry(CustLedgerEntry);
            until CustLedgerEntry.Next() = 0;
        end;
        BankAccountLedgerEntry.reset;
        BankAccountLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        BankAccountLedgerEntry.SetRange("Document No.", lvnDocumentNo);
        BankAccountLedgerEntry.SetRange("Posting Date", lvnPostingDate);
        if BankAccountLedgerEntry.FindSet() then begin
            repeat
                Clear(lvnLedgerVoidEntry);
                lvnLedgerVoidEntry.InsertFromBankAccountLedgerEntry(BankAccountLedgerEntry);
            until BankAccountLedgerEntry.Next() = 0;
        end;
    end;
}