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
        case lvngLoanDocument.lvngTransactionType of
            lvngLoanDocument.lvngTransactionType::lvngFunded:
                lvngSourceCode := lvngLoanVisionSetup.lvngFundedSourceCode;
            lvngLoanDocument.lvngTransactionType::lvngSold:
                lvngSourceCode := lvngLoanVisionSetup.lvngSoldSourceCode;
            lvngLoanDocument.lvngTransactionType::lvngServiced:
                begin
                    GetLoanServicingSetup();
                    lvngSourceCode := lvngLoanServicingSetup.lvngServicedSourceCode;
                end;
        end;
        if lvngSourceCode = '' then
            Error(SourceCodeBlankLbl);
        if lvngLoanDocument.lvngVoid then
            lvngLoanDocument.TestField(lvngVoidDocumentNo);
        DocumentAmount := -PrepareDocumentLinesBuffer(lvngLoanDocument, lvngLoanDocumentLineTemp);

        lvngLoanDocumentLineTemp.reset;
        lvngLoanDocumentLineTemp.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType);
        lvngLoanDocumentLineTemp.SetRange(lvngDocumentNo, lvngLoanDocument.lvngDocumentNo);
        lvngLoanDocumentLineTemp.SetRange(lvngBalancingEntry, false);
        if lvngLoanDocumentLineTemp.FindSet() then begin
            repeat
                clear(GenJnlLine);
                GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocumentLineTemp.lvngDescription, lvngLoanDocumentLineTemp.lvngGlobalDimension1Code, lvngLoanDocumentLineTemp.lvngGlobalDimension2Code,
                        lvngLoanDocumentLineTemp.lvngDimensionSetID, lvngLoanDocumentLineTemp.lvngReasonCode);
                CreateGenJnlLine(lvngLoanDocument, lvngLoanDocumentLineTemp, GenJnlLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(lvngLoanDocumentLineTemp);
            until lvngLoanDocumentLineTemp.Next() = 0;
        end;

        clear(GenJnlLine);
        GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngLoanNo, lvngLoanDocument.lvngGlobalDimension1Code, lvngLoanDocument.lvngGlobalDimension2Code,
        lvngLoanDocument.lvngDimensionSetID, lvngLoanDocument.lvngReasonCode);
        CreateCustomerGenJnlLine(lvngLoanDocument, GenJnlLine, DocumentAmount);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        TransferDocumentHeaderToPosted(lvngLoanDocument);

        lvngLoanDocumentLineTemp.SetRange(lvngBalancingEntry, true);
        if lvngLoanDocumentLineTemp.FindSet() then begin
            repeat
                Clear(GenJnlLine);
                GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocumentLineTemp.lvngDescription, lvngLoanDocumentLineTemp.lvngGlobalDimension1Code, lvngLoanDocumentLineTemp.lvngGlobalDimension2Code,
                        lvngLoanDocumentLineTemp.lvngDimensionSetID, lvngLoanDocumentLineTemp.lvngReasonCode);
                CreateBalancingGenJnlLine(lvngLoanDocument, lvngLoanDocumentLineTemp, GenJnlLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);
                TransferDocumentLineToPosted(lvngLoanDocumentLineTemp);
            until lvngLoanDocumentLineTemp.Next() = 0;
        end;
        if lvngLoanDocument.lvngVoid then begin
            VoidLedgerEntries(lvngLoanDocument.lvngDocumentNo, lvngLoanDocument.lvngPostingDate);
            VoidLedgerEntries(lvngLoanDocument.lvngVoidDocumentNo, lvngLoanDocument.lvngPostingDate);
        end;
    end;

    local procedure DeleteAfterPosting()
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(lvngTransactionType, lvngLoanDocumentSave.lvngTransactionType);
        lvngLoanDocumentLine.SetRange(lvngDocumentNo, lvngLoanDocumentSave.lvngDocumentNo);
        lvngLoanDocumentLine.DeleteAll();
        lvngLoanDocumentSave.Delete();
    end;

    local procedure PrepareDocumentLinesBuffer(lvngLoanDocument: Record lvngLoanDocument; var lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine): Decimal
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        DocumentAmount: Decimal;
    begin
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType);
        lvngLoanDocumentLine.SetRange(lvngDocumentNo, lvngLoanDocument.lvngDocumentNo);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLineTemp);
                lvngLoanDocumentLineTemp := lvngLoanDocumentLine;
                lvngLoanDocumentLineTemp.Insert();
                if not lvngLoanDocumentLine.lvngBalancingEntry then
                    DocumentAmount := DocumentAmount + lvngLoanDocumentLine.lvngAmount;
            until lvngLoanDocumentLine.Next() = 0;
        end;
        exit(DocumentAmount);
    end;

    local procedure CreateCustomerGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; var GenJnlLine: Record "Gen. Journal Line"; Amount: Decimal)
    begin

        if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngInvoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document Type" := GenJnlLine."Document Type";
        GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := lvngLoanDocument.lvngCustomerNo;
        GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
        GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
        GenJnlLine.Amount := Amount;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine."System-Created Entry" := true;
    end;



    local procedure CreateGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line")
    begin
        if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngInvoice then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
        case lvngLoanDocumentLine.lvngAccountType of
            lvngloandocumentline.lvngAccountType::lvngGLAccount:
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvngLoanDocumentLine.lvngAccountType::lvngBankAccount:
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;
        GenJnlLine."Account No." := lvngLoanDocumentLine.lvngAccountNo;
        GenJnlLine.Amount := lvngLoanDocumentLine.lvngAmount;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
        GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
        GenJnlLine.lvngServicingType := lvngLoanDocumentLine.lvngServicingType;
    end;

    local procedure CreateBalancingGenJnlLine(lvngLoanDocument: Record lvngLoanDocument; lvngLoanDocumentLine: Record lvngLoanDocumentLine; var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
        if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngCreditMemo then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        case lvngLoanDocumentLine.lvngAccountType of
            lvngloandocumentline.lvngAccountType::lvngGLAccount:
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                end;
            lvngLoanDocumentLine.lvngAccountType::lvngBankAccount:
                begin
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                end;
        end;

        GenJnlLine."Account No." := lvngLoanDocumentLine.lvngAccountNo;
        GenJnlLine.Amount := lvngLoanDocumentLine.lvngAmount;
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
        GenJnlLine."Bal. Account No." := lvngLoanDocument.lvngCustomerNo;
        if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngCreditMemo then
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo" else
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Invoice";
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := lvngSourceCode;
        GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
        GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
    end;

    local procedure TransferDocumentHeaderToPosted(lvngLoanDocument: Record lvngLoanDocument)
    var
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanSoldDocument: Record lvngLoanSoldDocument;
    begin
        case lvngLoanDocument.lvngTransactionType of
            lvngLoanDocument.lvngTransactionType::lvngFunded:
                begin
                    Clear(lvngLoanFundedDocument);
                    lvngLoanFundedDocument.TransferFields(lvngLoanDocument);
                    lvngLoanFundedDocument.Insert(true);
                    if lvngLoanDocument.lvngVoid then begin
                        lvngLoanFundedDocument.Get(lvngLoanDocument.lvngVoidDocumentNo);
                        lvngLoanFundedDocument.lvngVoid := true;
                        lvngLoanFundedDocument.lvngVoidDocumentNo := lvngLoanDocument.lvngDocumentNo;
                        lvngLoanFundedDocument.Modify();
                    end;
                end;
            lvngLoanDocument.lvngTransactionType::lvngSold:
                begin
                    Clear(lvngLoanSoldDocument);
                    lvngLoanSoldDocument.TransferFields(lvngLoanDocument);
                    lvngLoanSoldDocument.Insert(true);
                    if lvngLoanDocument.lvngVoid then begin
                        lvngLoanSoldDocument.Get(lvngLoanDocument.lvngVoidDocumentNo);
                        lvngLoanSoldDocument.lvngVoid := true;
                        lvngLoanSoldDocument.lvngVoidDocumentNo := lvngLoanDocument.lvngDocumentNo;
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
        case lvngLoanDocumentLine.lvngTransactionType of
            lvngLoanDocumentLine.lvngTransactionType::lvngFunded:
                begin
                    Clear(lvngLoanFundedDocumentLine);
                    lvngLoanFundedDocumentLine.TransferFields(lvngLoanDocumentLine);
                    lvngLoanFundedDocumentLine.Insert(true);
                end;
            lvngLoanDocumentLine.lvngTransactionType::lvngSold:
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
            lvngLoanVisionSetup.TestField(lvngFundedSourceCode);
            lvngLoanVisionSetup.TestField(lvngSoldSourceCode);
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