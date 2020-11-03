codeunit 14135105 "lvnCreateFundedDocuments"
{
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        TempLoanDocumentLine: Record lvnLoanDocumentLine temporary;
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        LoanVisionSetupRetrieved: Boolean;

    procedure CreateDocuments(LoanJournalBatchCode: Code[20])
    var
        LoanJournalLine: Record lvnLoanJournalLine;
        LoanJournalErrorMgmt: Codeunit lvnLoanJournalErrorMgmt;
        ValidateFundedJournal: Codeunit lvnValidateFundedJournal;
        LoanManagement: Codeunit lvnLoanManagement;
        TempLoanDocument: Record lvnLoanDocument temporary;
        TempLoanDocumentLine: Record lvnLoanDocumentLine temporary;
        LoanDocument: Record lvnLoanDocument;
        LoanDocumentLine: Record lvnLoanDocumentLine;
        DocumentsCreated: Integer;
        TotalEntries: Integer;
        ProcessResultMsg: Label '%1 of %2 documents were created';
    begin
        GetLoanVisionSetup();
        ValidateFundedJournal.ValidateFundedLines(LoanJournalBatchCode);
        LoanManagement.UpdateLoans(LoanJournalBatchCode);
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code");
        TotalEntries := LoanJournalLine.Count();
        if LoanJournalLine.FindSet() then
            repeat
                if not LoanJournalErrorMgmt.HasError(LoanJournalLine) then begin
                    TempLoanDocument.reset;
                    TempLoanDocument.DeleteAll();
                    TempLoanDocumentLine.reset;
                    TempLoanDocumentLine.DeleteAll();
                    CreateSingleDocument(LoanJournalLine, TempLoanDocument, TempLoanDocumentLine, false);
                    TempLoanDocument.Reset();
                    if TempLoanDocument.FindSet() then begin
                        repeat
                            Clear(LoanDocument);
                            LoanDocument := TempLoanDocument;
                            LoanDocument.Insert();
                            TempLoanDocumentLine.Reset();
                            if TempLoanDocumentLine.FindSet() then
                                repeat
                                    Clear(LoanDocumentLine);
                                    LoanDocumentLine := TempLoanDocumentLine;
                                    LoanDocumentLine.Insert();
                                until TempLoanDocumentLine.Next() = 0;
                        until TempLoanDocumentLine.Next() = 0;
                        LoanJournalLine.Mark(true);
                        DocumentsCreated := DocumentsCreated + 1;
                    end;
                end;
            until LoanJournalLine.Next() = 0;
        LoanJournalLine.MarkedOnly(true);
        LoanJournalLine.DeleteAll(true);
        Commit();
        Message(ProcessResultMsg, TotalEntries, DocumentsCreated);
    end;

    procedure CreateSingleDocument(LoanJournalLine: Record lvnLoanJournalLine; var LoanDocument: record lvnLoanDocument; var LoanDocumentLine: Record lvnLoanDocumentLine; Preview: Boolean)
    var
        LoanProcessingSchema: Record lvnLoanProcessingSchema;
        LoanProcessingSchemaLine: Record lvnLoanProcessingSchemaLine;
        LoanJournalBatch: Record lvnLoanJournalBatch;
        LoanFundedDocument: Record lvnLoanFundedDocument;
        LoanFundedDocumentLine: Record lvnLoanFundedDocumentLine;
        LoanJournalValue: Record lvnLoanJournalValue;
        ExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        TempDocumentLbl: Label 'XXXXXXXX';
        LineNo: Integer;
        DocumentAmount: Decimal;
        FieldSequenceNo: Integer;
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Funded Void Reason Code" <> '' then
            if (LoanVisionSetup."Funded Void Reason Code" = LoanJournalLine."Reason Code") then begin
                LoanVisionSetup.TestField("Void Funded No. Series");
                LoanFundedDocument.reset;
                LoanFundedDocument.SetRange("Loan No.", LoanJournalLine."Loan No.");
                LoanFundedDocument.SetRange(Void, false);
                LoanFundedDocument.FindLast();
                Clear(LoanDocument);
                LoanDocument.Init();
                LoanDocument.TransferFields(LoanFundedDocument);
                LoanDocument."Transaction Type" := LoanDocument."Transaction Type"::Funded;
                if not Preview then
                    LoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(LoanVisionSetup."Void Funded No. Series", Today(), true, false)
                else
                    LoanDocument."Document No." := TempDocumentLbl;
                if LoanDocument."Document Type" = LoanDocument."Document Type"::"Credit Memo" then
                    LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice
                else
                    LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo";
                LoanDocument.Void := true;
                LoanDocument."Void Document No." := LoanFundedDocument."Document No.";
                LoanDocument.Insert();
                LoanFundedDocumentLine.reset;
                LoanFundedDocumentLine.SetRange("Document No.", LoanFundedDocument."Document No.");
                LoanFundedDocumentLine.FindSet();
                repeat
                    Clear(LoanDocumentLine);
                    LoanDocumentLine.TransferFields(LoanFundedDocumentLine);
                    LoanDocumentLine."Transaction Type" := LoanDocument."Transaction Type";
                    LoanDocumentLine."Document No." := LoanDocument."Document No.";
                    LoanDocumentLine.Amount := -LoanDocumentLine.Amount;
                    LoanDocumentLine.Insert();
                until LoanFundedDocumentLine.Next() = 0;
                exit;
            end;
        LoanJournalLine.TestField("Processing Schema Code");
        LoanProcessingSchema.Get(LoanJournalLine."Processing Schema Code");
        LoanJournalBatch.Get(LoanJournalLine."Loan Journal Batch Code");
        ExpressionValueBuffer.Reset();
        ExpressionValueBuffer.DeleteAll();
        FieldSequenceNo := 0;
        ConditionsMgmt.FillJournalFieldValues(ExpressionValueBuffer, LoanJournalLine, FieldSequenceNo);
        Clear(ExpressionValueBuffer);
        FieldSequenceNo += 1;
        ExpressionValueBuffer.Number := FieldSequenceNo;
        ExpressionValueBuffer.Name := '!CalculationParameter';
        ExpressionValueBuffer.Value := '0';
        ExpressionValueBuffer.Type := 'Decimal';
        ExpressionValueBuffer.Insert();
        Clear(ExpressionValueBuffer);
        FieldSequenceNo += 1;
        ExpressionValueBuffer.Number := FieldSequenceNo;
        ExpressionValueBuffer.Name := '!ProcessingParameter';
        ExpressionValueBuffer.Value := '';
        ExpressionValueBuffer.Type := 'Text';
        ExpressionValueBuffer.Insert();
        LineNo := 10000;
        Clear(LoanDocument);
        LoanDocument.Init();
        if not Preview then
            if LoanProcessingSchema."No. Series" <> '' then
                LoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(LoanProcessingSchema."No. Series", Today(), true, false)
            else
                LoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(LoanVisionSetup."Funded No. Series", Today(), true, false)
        else
            LoanDocument."Document No." := TempDocumentLbl;
        LoanDocument.Insert(true);
        LoanDocument."Customer No." := LoanJournalLine."Title Customer No.";
        LoanDocument."Loan No." := LoanJournalLine."Loan No.";
        LoanDocument."Posting Date" := LoanJournalLine."Date Funded";
        LoanDocument."Warehouse Line Code" := LoanJournalLine."Warehouse Line Code";
        AssignDimensions(LoanDocument."Global Dimension 1 Code", LoanProcessingSchema."Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code", LoanProcessingSchema."Dimension 1 Rule");
        AssignDimensions(LoanDocument."Global Dimension 2 Code", LoanProcessingSchema."Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code", LoanProcessingSchema."Dimension 2 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 3 Code", LoanProcessingSchema."Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code", LoanProcessingSchema."Dimension 3 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 4 Code", LoanProcessingSchema."Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code", LoanProcessingSchema."Dimension 4 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 5 Code", LoanProcessingSchema."Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code", LoanProcessingSchema."Dimension 5 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 6 Code", LoanProcessingSchema."Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code", LoanProcessingSchema."Dimension 6 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 7 Code", LoanProcessingSchema."Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code", LoanProcessingSchema."Dimension 7 Rule");
        AssignDimensions(LoanDocument."Shortcut Dimension 8 Code", LoanProcessingSchema."Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code", LoanProcessingSchema."Dimension 8 Rule");
        AssignDimensions(LoanDocument."Business Unit Code", LoanProcessingSchema."Business Unit Code", LoanJournalLine."Business Unit Code", LoanProcessingSchema."Business Unit Rule");
        LoanDocument.GenerateDimensionSetId();
        if LoanProcessingSchema."External Document No. Field" <> 0 then begin
            if LoanJournalValue.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", LoanProcessingSchema."External Document No. Field") then begin
                LoanDocument."External Document No." := CopyStr(LoanJournalValue."Field Value", 1, MaxStrLen(LoanDocument."External Document No."));
            end;
        end;
        LoanDocument.Modify(true);
        if LoanProcessingSchema."Use Global Schema Code" <> '' then begin
            LoanProcessingSchemaLine.Reset();
            LoanProcessingSchemaLine.SetRange("Balancing Entry", false);
            LoanProcessingSchemaLine.Setfilter("Processing Source Type", '<>%1', LoanProcessingSchemaLine."Processing Source Type"::Tag);
            LoanProcessingSchemaLine.SetRange("Processing Code", LoanProcessingSchema."Use Global Schema Code");
            if LoanProcessingSchemaLine.FindSet() then
                repeat
                    CreateDocumentLine(LoanDocumentLine, LoanDocument, LoanProcessingSchemaLine, LoanJournalLine, LineNo, ExpressionValueBuffer);
                until LoanProcessingSchemaLine.Next() = 0;
        end;
        LoanProcessingSchemaLine.Reset();
        LoanProcessingSchemaLine.SetRange("Processing Code", LoanProcessingSchema.Code);
        LoanProcessingSchemaLine.SetRange("Balancing Entry", false);
        LoanProcessingSchemaLine.Setfilter("Processing Source Type", '<>%1', LoanProcessingSchemaLine."Processing Source Type"::Tag);
        if LoanProcessingSchemaLine.FindSet() then
            repeat
                CreateDocumentLine(LoanDocumentLine, LoanDocument, LoanProcessingSchemaLine, LoanJournalLine, LineNo, ExpressionValueBuffer);
            until LoanProcessingSchemaLine.Next() = 0;
        TempLoanDocumentLine.Reset();
        TempLoanDocumentLine.DeleteAll();
        LoanDocumentLine.Reset();
        if LoanDocumentLine.FindSet() then
            repeat
                Clear(TempLoanDocumentLine);
                TempLoanDocumentLine := LoanDocumentLine;
                TempLoanDocumentLine.Insert();
            until LoanDocumentLine.Next() = 0;
        if LoanProcessingSchema."Use Global Schema Code" <> '' then begin
            LoanProcessingSchemaLine.Reset();
            LoanProcessingSchemaLine.SetRange("Balancing Entry", true);
            LoanProcessingSchemaLine.SetRange("Processing Code", LoanProcessingSchema."Use Global Schema Code");
            if LoanProcessingSchemaLine.FindSet() then
                repeat
                    CreateDocumentLine(LoanDocumentLine, LoanDocument, LoanProcessingSchemaLine, LoanJournalLine, LineNo, ExpressionValueBuffer);
                until LoanProcessingSchemaLine.Next() = 0;
        end;
        LoanProcessingSchemaLine.Reset();
        LoanProcessingSchemaLine.SetRange("Processing Code", LoanProcessingSchema.Code);
        LoanProcessingSchemaLine.SetRange("Balancing Entry", true);
        if LoanProcessingSchemaLine.FindSet() then
            repeat
                CreateDocumentLine(LoanDocumentLine, LoanDocument, LoanProcessingSchemaLine, LoanJournalLine, LineNo, ExpressionValueBuffer);
            until LoanProcessingSchemaLine.Next() = 0;
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange(Amount, 0);
        LoanDocumentLine.DeleteAll();
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Balancing Entry", false);
        if LoanDocumentLine.FindSet() then
            repeat
                DocumentAmount := DocumentAmount + LoanDocumentLine.Amount;
            until LoanDocumentLine.Next() = 0;
        //Option here
        case LoanProcessingSchema."Document Type Option" of
            LoanProcessingSchema."Document Type Option"::Invoice:
                LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice;
            LoanProcessingSchema."Document Type Option"::"Credit Memo":
                LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo";
            LoanProcessingSchema."Document Type Option"::"Amount Based":
                begin
                    if DocumentAmount > 0 then
                        LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice
                    else begin
                        LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo";
                        LoanDocumentLine.Reset();
                        LoanDocumentLine.SetRange("Balancing Entry", false);
                        if LoanDocumentLine.FindSet() then
                            repeat
                                LoanDocumentLine.Amount := -LoanDocumentLine.Amount;
                                LoanDocumentLine.Modify();
                            until LoanDocumentLine.Next() = 0;
                    end;
                end;
            LoanProcessingSchema."Document Type Option"::"Amount Based Reversed":
                begin
                    if DocumentAmount > 0 then
                        LoanDocument."Document Type" := LoanDocument."Document Type"::"Credit Memo"
                    else begin
                        LoanDocument."Document Type" := LoanDocument."Document Type"::Invoice;
                        LoanDocumentLine.Reset();
                        LoanDocumentLine.SetRange("Balancing Entry", false);
                        if LoanDocumentLine.FindSet() then
                            repeat
                                LoanDocumentLine.Amount := -LoanDocumentLine.Amount;
                                LoanDocumentLine.Modify();
                            until LoanDocumentLine.Next() = 0;
                    end;
                end;
        end;
        LoanDocument.Modify();
    end;

    local procedure CreateDocumentLine(var LoanDocumentLine: Record lvnLoanDocumentLine; LoanDocument: record lvnLoanDocument; LoanProcessingSchemaLine: Record lvnLoanProcessingSchemaLine; LoanJournalLine: Record lvnLoanJournalLine; var LineNo: Integer; var ExpressionValueBuffer: Record lvnExpressionValueBuffer)
    var
        LoanJournalValue: Record lvnLoanJournalValue;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        AccountNo: Code[20];
        DecimalValue: Decimal;
    begin
        ExpressionValueBuffer.Reset();
        ExpressionValueBuffer.Ascending(false);
        ExpressionValueBuffer.FindSet(true);
        ExpressionValueBuffer.Value := LoanProcessingSchemaLine."Processing Parameter";
        ExpressionValueBuffer.Modify();
        ExpressionValueBuffer.Next();
        ExpressionValueBuffer.Value := Format(LoanProcessingSchemaLine."Calculation Parameter", 0, 9);
        ExpressionValueBuffer.Modify();
        if CheckCondition(LoanProcessingSchemaLine."Condition Code", ExpressionValueBuffer) then begin
            Clear(LoanDocumentLine);
            LoanDocumentLine.Init();
            LoanDocumentLine."Document No." := LoanDocument."Document No.";
            LoanDocumentLine."Transaction Type" := LoanDocument."Transaction Type";
            LoanDocumentLine."Line No." := LineNo;
            LoanDocumentLine."Processing Schema Code" := LoanProcessingSchemaLine."Processing Code";
            LoanDocumentLine."Processing Schema Line No." := LoanProcessingSchemaLine."Line No.";
            LoanDocumentLine."Balancing Entry" := LoanProcessingSchemaLine."Balancing Entry";
            LoanDocumentLine."Tag Code" := LoanProcessingSchemaLine."Tag Code";
            LoanDocumentLine."Servicing Type" := LoanProcessingSchemaLine."Servicing Type";
            LineNo := LineNo + 10000;
            LoanDocumentLine.Insert();
            if LoanProcessingSchemaLine."Override Reason Code" <> '' then
                LoanDocumentLine."Reason Code" := LoanProcessingSchemaLine."Override Reason Code"
            else
                LoanDocumentLine."Reason Code" := LoanJournalLine."Reason Code";
            LoanDocumentLine.Description := CopyStr(LoanProcessingSchemaLine.Description, 1, MaxStrLen(LoanDocumentLine.Description));
            LoanDocumentLine."Account Type" := LoanProcessingSchemaLine."Account Type";
            LoanDocumentLine."Account No." := LoanProcessingSchemaLine."Account No.";
            if LoanProcessingSchemaLine."Account No. Switch Code" <> '' then begin
                AccountNo := GetSwitchValue(LoanProcessingSchemaLine."Account No. Switch Code", ExpressionValueBuffer);
                if AccountNo <> '' then
                    LoanDocumentLine."Account No." := AccountNo;
            end;
            case LoanProcessingSchemaLine."Processing Source Type" of
                LoanProcessingSchemaLine."Processing Source Type"::Function:
                    if Evaluate(DecimalValue, GetFunctionValue(LoanProcessingSchemaLine."Function Code", ExpressionValueBuffer)) then
                        LoanDocumentLine.Amount := DecimalValue;
                LoanProcessingSchemaLine."Processing Source Type"::"Loan Journal Value":
                    begin
                        RecordReference.GetTable(LoanJournalLine);
                        FieldReference := RecordReference.Field(LoanProcessingSchemaLine."Field No.");
                        LoanDocumentLine.Amount := FieldReference.Value();
                        RecordReference.Close();
                    end;
                LoanProcessingSchemaLine."Processing Source Type"::"Loan Journal Variable Value":
                    if LoanJournalValue.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", LoanProcessingSchemaLine."Field No.") then
                        if Evaluate(DecimalValue, LoanJournalValue."Field Value") then
                            LoanDocumentLine.Amount := DecimalValue;
                LoanProcessingSchemaLine."Processing Source Type"::Tag:
                    begin
                        Clear(DecimalValue);
                        LoanProcessingSchemaLine.TestField("Balancing Entry");
                        TempLoanDocumentLine.Reset();
                        TempLoanDocumentLine.SetRange("Tag Code", LoanProcessingSchemaLine."Tag Code");
                        if TempLoanDocumentLine.FindSet() then
                            repeat
                                DecimalValue := DecimalValue + TempLoanDocumentLine.Amount;
                            until TempLoanDocumentLine.Next() = 0;
                        LoanDocumentLine.Amount := DecimalValue;
                    end;
            end;
            if LoanProcessingSchemaLine."Reverse Sign" then
                LoanDocumentLine.Amount := -LoanDocumentLine.Amount;

            AssignDimensions(LoanDocumentLine."Global Dimension 1 Code", LoanProcessingSchemaLine."Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code", LoanProcessingSchemaLine."Dimension 1 Rule");
            AssignDimensions(LoanDocumentLine."Global Dimension 2 Code", LoanProcessingSchemaLine."Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code", LoanProcessingSchemaLine."Dimension 2 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 3 Code", LoanProcessingSchemaLine."Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code", LoanProcessingSchemaLine."Dimension 3 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 4 Code", LoanProcessingSchemaLine."Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code", LoanProcessingSchemaLine."Dimension 4 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 5 Code", LoanProcessingSchemaLine."Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code", LoanProcessingSchemaLine."Dimension 5 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 6 Code", LoanProcessingSchemaLine."Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code", LoanProcessingSchemaLine."Dimension 6 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 7 Code", LoanProcessingSchemaLine."Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code", LoanProcessingSchemaLine."Dimension 7 Rule");
            AssignDimensions(LoanDocumentLine."Shortcut Dimension 8 Code", LoanProcessingSchemaLine."Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code", LoanProcessingSchemaLine."Dimension 8 Rule");
            AssignDimensions(LoanDocumentLine."Business Unit Code", LoanProcessingSchemaLine."Business Unit Code", LoanJournalLine."Business Unit Code", LoanProcessingSchemaLine."Business Unit Rule");
            LoanDocumentLine.GenerateDimensionSetId();
            LoanDocumentLine.Modify();
        end;
    end;

    local procedure AssignDimensions(var AssignToDimension: Code[20]; ProcessingDimensionValueCode: Code[20]; JournalDimensionValueCode: Code[20]; ProcessingDimensionRule: enum lvnProcessingDimensionRule)
    begin
        case ProcessingDimensionRule of
            ProcessingDimensionRule::Defined:
                AssignToDimension := ProcessingDimensionValueCode;
            ProcessingDimensionRule::"Journal Line":
                AssignToDimension := JournalDimensionValueCode;
        end;
    end;

    local procedure CheckCondition(ConditionCode: code[20]; var ExpressionValueBuffer: Record lvnExpressionValueBuffer): Boolean
    var
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionHeader: Record lvnExpressionHeader;
    begin
        if ConditionCode = '' then
            exit(true);
        ExpressionHeader.Get(ConditionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(ExpressionEngine.CheckCondition(ExpressionHeader, ExpressionValueBuffer));
    end;

    local procedure GetFunctionValue(FunctionCode: code[20]; var ExpressionValueBuffer: Record lvnExpressionValueBuffer): Text
    var
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionHeader: Record lvnExpressionHeader;
    begin
        ExpressionHeader.Get(FunctionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(ExpressionEngine.CalculateFormula(ExpressionHeader, ExpressionValueBuffer));
    end;

    local procedure GetSwitchValue(SwitchCode: code[20]; var ExpressionValueBuffer: Record lvnExpressionValueBuffer): Code[20]
    var
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionHeader: Record lvnExpressionHeader;
        Result: Text;
    begin
        ExpressionHeader.Get(SwitchCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        if not ExpressionEngine.SwitchCase(ExpressionHeader, Result, ExpressionValueBuffer) then
            exit('');
        exit(CopyStr(Result, 1, 20));
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;
}