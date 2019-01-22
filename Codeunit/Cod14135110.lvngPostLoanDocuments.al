codeunit 14135110 "lvngPostLoanDocuments"
{
    procedure PostLoanDocument(lvngLoanDocument: Record lvngLoanDocument)
    var
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DocumentAmount: Decimal;
    begin
        GetLoanVisionSetup();
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType);
        lvngLoanDocumentLine.SetRange(lvngDocumentNo, lvngLoanDocument.lvngDocumentNo);
        lvngLoanDocumentLine.SetRange(lvngBalancingEntry, false);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                DocumentAmount := DocumentAmount + lvngLoanDocumentLine.lvngAmount;
            until lvngLoanDocumentLine.Next() = 0;
        end;
        DocumentAmount := -DocumentAmount;
        GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngLoanNo, lvngLoanDocument.lvngGlobalDimension1Code, lvngLoanDocument.lvngGlobalDimension2Code,
        lvngLoanDocument.lvngDimensionSetID, lvngLoanDocument.lvngReasonCode);
        GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
        if lvngLoanDocument.lvngDocumentType = lvngLoanDocument.lvngDocumentType::lvngInvoice then
            TempGenJnlLine."Document Type" := TempGenJnlLine."Document Type"::Invoice
        else
            TempGenJnlLine."Document Type" := TempGenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine."Document Type" := TempGenJnlLine."Document Type";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := lvngLoanDocument.lvngCustomerNo;
        GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
        GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
        GenJnlLine.Amount := DocumentAmount;
        GenJnlLine."Source Code" := lvngLoanVisionSetup.lvngFundedSourceCode;
        GenJnlLine."System-Created Entry" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocumentLine.lvngDescription, lvngLoanDocumentLine.lvngGlobalDimension1Code, lvngLoanDocumentLine.lvngGlobalDimension2Code,
                        lvngLoanDocumentLine.lvngDimensionSetID, lvngLoanDocumentLine.lvngReasonCode);
                GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
                GenJnlLine."Document Type" := TempGenJnlLine."Document Type";
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
                GenJnlLine."Source Code" := lvngLoanVisionSetup.lvngFundedSourceCode;
                GenJnlLine."Account No." := lvngLoanDocumentLine.lvngAccountNo;
                GenJnlLine.Amount := lvngLoanDocumentLine.lvngAmount;
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
                GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            until lvngLoanDocumentLine.Next() = 0;
        end;
        lvngLoanDocumentLine.SetRange(lvngBalancingEntry, true);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                /*GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocumentLine.lvngDescription, lvngLoanDocumentLine.lvngGlobalDimension1Code, lvngLoanDocumentLine.lvngGlobalDimension2Code,
                        lvngLoanDocumentLine.lvngDimensionSetID, lvngLoanDocumentLine.lvngReasonCode);
                GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
                if TempGenJnlLine."Document Type" = TempGenJnlLine."Document Type"::"Credit Memo" then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := lvngLoanDocument.lvngCustomerNo;
                GenJnlLine."Source Code" := lvngLoanVisionSetup.lvngFundedSourceCode;
                GenJnlLine.Amount := -lvngLoanDocumentLine.lvngAmount;
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
                GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
                GenJnlPostLine.RunWithCheck(GenJnlLine);*/

                GenJnlLine.InitNewLine(lvngLoanDocument.lvngPostingDate, lvngLoanDocument.lvngPostingDate, lvngLoanDocumentLine.lvngDescription, lvngLoanDocumentLine.lvngGlobalDimension1Code, lvngLoanDocumentLine.lvngGlobalDimension2Code,
                        lvngLoanDocumentLine.lvngDimensionSetID, lvngLoanDocumentLine.lvngReasonCode);
                GenJnlLine."Document No." := lvngLoanDocument.lvngDocumentNo;
                if TempGenJnlLine."Document Type" = TempGenJnlLine."Document Type"::"Credit Memo" then
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
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Source Code" := lvngLoanVisionSetup.lvngFundedSourceCode;
                GenJnlLine.lvngLoanNo := lvngLoanDocument.lvngLoanNo;
                GenJnlLine."Reason Code" := lvngLoanDocument.lvngReasonCode;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
                GenJnlLine."Bal. Account No." := lvngLoanDocument.lvngCustomerNo;
                GenJnlLine."Applies-to Doc. Type" := TempGenJnlLine."Document Type";
                GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            until lvngLoanDocumentLine.Next() = 0;
        end;

    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetup.TestField(lvngFundedSourceCode);
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanVisionSetupRetrieved: Boolean;
}