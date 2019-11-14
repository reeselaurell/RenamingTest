codeunit 14135105 "lvngCreateFundedDocuments"
{
    procedure CreateDocuments(lvngLoanJournalBatchCode: Code[20])
    var
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        lvngValidateFundedJournal: Codeunit lvngValidateFundedJournal;
        lvngLoanManagement: Codeunit lvngLoanManagement;
        lvngLoanDocumentTemp: Record lvngLoanDocument temporary;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        lvngLoanDocument: Record lvngLoanDocument;
        lvngLoanDocumentLine: Record lvngLoanDocumentLine;
        lvngDocumentsCreated: Integer;
        lvngTotalEntries: Integer;
        lvngProcessResultLbl: Label '%1 of %2 documents were created';
    begin
        GetLoanVisionSetup();
        lvngValidateFundedJournal.ValidateFundedLines(lvngLoanJournalBatchCode);
        lvngLoanManagement.UpdateLoans(lvngLoanJournalBatchCode);
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code");
        lvngTotalEntries := lvngLoanJournalLine.Count();
        if lvngLoanJournalLine.FindSet() then begin
            repeat
                if not lvngLoanJournalErrorMgmt.HasError(lvngLoanJournalLine) then begin
                    lvngLoanDocumentTemp.reset;
                    lvngLoanDocumentTemp.DeleteAll();
                    lvngLoanDocumentLineTemp.reset;
                    lvngLoanDocumentLineTemp.DeleteAll();
                    CreateSingleDocument(lvngLoanJournalLine, lvngLoanDocumentTemp, lvngLoanDocumentLineTemp, false);
                    lvngLoanDocumentTemp.reset;
                    if lvngLoanDocumentTemp.FindSet() then begin
                        repeat
                            Clear(lvngLoanDocument);
                            lvngLoanDocument := lvngLoanDocumentTemp;
                            lvngLoanDocument.Insert();
                            lvngLoanDocumentLineTemp.reset;
                            if lvngLoanDocumentLineTemp.FindSet() then begin
                                repeat
                                    clear(lvngLoanDocumentLine);
                                    lvngLoanDocumentLine := lvngLoanDocumentLineTemp;
                                    lvngLoanDocumentLine.Insert();
                                until lvngLoanDocumentLineTemp.Next() = 0;
                            end;
                        until lvngLoanDocumentLineTemp.Next() = 0;
                        lvngLoanJournalLine.Mark(true);
                        lvngDocumentsCreated := lvngDocumentsCreated + 1;
                    end;
                end;
            until lvngLoanJournalLine.Next() = 0;
        end;
        lvngLoanJournalLine.MarkedOnly(true);
        lvngLoanJournalLine.DeleteAll(true);
        commit;
        Message(lvngProcessResultLbl, lvngTotalEntries, lvngDocumentsCreated);
    end;

    procedure CreateSingleDocument(lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLoanDocument: record lvngLoanDocument; var lvngLoanDocumentLine: Record lvngLoanDocumentLine; lvngPreview: Boolean)
    var
        lvngLoanProcessingSchema: Record lvngLoanProcessingSchema;
        lvngLoanProcessingSchemaLine: Record lvngLoanProcessingSchemaLine;
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanFundedDocument: Record lvngLoanFundedDocument;
        lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        TempDocumentLbl: Label 'XXXXXXXX';
        lvngLineNo: Integer;
        lvngDocumentAmount: Decimal;
    begin
        GetLoanVisionSetup();
        if lvngLoanVisionSetup."Funded Void Reason Code" <> '' then begin
            if (lvngLoanVisionSetup."Funded Void Reason Code" = lvngLoanJournalLine."Reason Code") then begin
                lvngLoanVisionSetup.TestField("Void Funded No. Series");
                lvngLoanFundedDocument.reset;
                lvngLoanFundedDocument.SetRange("Loan No.", lvngLoanJournalLine."Loan No.");
                lvngLoanFundedDocument.SetRange(Void, false);
                lvngLoanFundedDocument.FindLast();
                Clear(lvngLoanDocument);
                lvngLoanDocument.init;
                lvngLoanDocument.TransferFields(lvngLoanFundedDocument);
                lvngLoanDocument."Transaction Type" := lvngLoanDocument."Transaction Type"::lvngFunded;
                if not lvngPreview then begin
                    lvngLoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(lvngLoanVisionSetup."Void Funded No. Series", TODAY, true, false);
                end else begin
                    lvngLoanDocument."Document No." := TempDocumentLbl;
                end;
                if lvngLoanDocument."Document Type" = lvngLoanDocument."Document Type"::lvngCreditMemo then
                    lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngInvoice else
                    lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngCreditMemo;

                lvngLoanDocument.Void := true;
                lvngLoanDocument."Void Document No." := lvngLoanFundedDocument."Document No.";
                lvngLoanDocument.Insert();
                lvngLoanFundedDocumentLine.reset;
                lvngLoanFundedDocumentLine.SetRange("Document No.", lvngLoanFundedDocument."Document No.");
                lvngLoanFundedDocumentLine.FindSet();
                repeat
                    Clear(lvngLoanDocumentLine);
                    lvngLoanDocumentLine.TransferFields(lvngLoanFundedDocumentLine);
                    lvngLoanDocumentLine."Transaction Type" := lvngLoanDocument."Transaction Type";
                    lvngLoanDocumentLine."Document No." := lvngLoanDocument."Document No.";
                    lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;
                    lvngLoanDocumentLine.Insert();
                until lvngLoanFundedDocumentLine.Next() = 0;
                exit;
            end;
        end;
        lvngLoanJournalLine.TestField("Processing Schema Code");
        lvngLoanProcessingSchema.Get(lvngLoanJournalLine."Processing Schema Code");
        lvngLoanJournalBatch.Get(lvngLoanJournalLine."Loan Journal Batch Code");
        lvngExpressionValueBuffer.reset;
        lvngExpressionValueBuffer.DeleteAll();
        lvngConditionsMgmt.FillJournalFieldValues(lvngExpressionValueBuffer, lvngLoanJournalLine);
        lvngLineNo := 10000;
        clear(lvngLoanDocument);
        lvngLoanDocument.init;
        if not lvngPreview then begin
            if lvngLoanProcessingSchema."No. Series" <> '' then
                lvngLoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(lvngLoanProcessingSchema."No. Series", TODAY, true, false) else
                lvngLoanDocument."Document No." := NoSeriesManagement.DoGetNextNo(lvngLoanVisionSetup."Funded No. Series", TODAY, true, false);
        end else begin
            lvngLoanDocument."Document No." := TempDocumentLbl;
        end;
        lvngLoanDocument.Insert(true);
        lvngLoanDocument."Customer No." := lvngLoanJournalLine."Title Customer No.";
        lvngLoanDocument."Loan No." := lvngLoanJournalLine."Loan No.";
        lvngLoanDocument."Posting Date" := lvngLoanJournalLine."Date Funded";
        lvngLoanDocument."Warehouse Line Code" := lvngLoanJournalLine."Warehouse Line Code";
        AssignDimensions(lvngLoanDocument."Global Dimension 1 Code", lvngLoanProcessingSchema."Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code", lvngLoanProcessingSchema."Dimension 1 Rule");
        AssignDimensions(lvngLoanDocument."Global Dimension 2 Code", lvngLoanProcessingSchema."Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code", lvngLoanProcessingSchema."Dimension 2 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 3 Code", lvngLoanProcessingSchema."Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code", lvngLoanProcessingSchema."Dimension 3 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 4 Code", lvngLoanProcessingSchema."Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code", lvngLoanProcessingSchema."Dimension 4 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 5 Code", lvngLoanProcessingSchema."Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code", lvngLoanProcessingSchema."Dimension 5 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 6 Code", lvngLoanProcessingSchema."Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code", lvngLoanProcessingSchema."Dimension 6 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 7 Code", lvngLoanProcessingSchema."Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code", lvngLoanProcessingSchema."Dimension 7 Rule");
        AssignDimensions(lvngLoanDocument."Shortcut Dimension 8 Code", lvngLoanProcessingSchema."Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code", lvngLoanProcessingSchema."Dimension 8 Rule");
        AssignDimensions(lvngLoanDocument."Business Unit Code", lvngLoanProcessingSchema."Business Unit Code", lvngLoanJournalLine."Business Unit Code", lvngLoanProcessingSchema."Business Unit Rule");
        lvngLoanDocument.GenerateDimensionSetId();
        lvngLoanDocument.Modify(true);
        if lvngLoanProcessingSchema."Use Global Schema Code" <> '' then begin
            lvngLoanProcessingSchemaLine.reset;
            lvngLoanProcessingSchemaLine.SetRange("Balancing Entry", false);
            lvngLoanProcessingSchemaLine.Setfilter("Processing Source Type", '<>%1', lvngLoanProcessingSchemaLine."Processing Source Type"::lvngTag);
            lvngLoanProcessingSchemaLine.SetRange("Processing Code", lvngLoanProcessingSchema."Use Global Schema Code");
            if lvngLoanProcessingSchemaLine.FindSet() then begin
                repeat
                    CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
                until lvngLoanProcessingSchemaLine.Next() = 0;
            end;
        end;
        lvngLoanProcessingSchemaLine.reset;
        lvngLoanProcessingSchemaLine.SetRange("Processing Code", lvngLoanProcessingSchema.Code);
        lvngLoanProcessingSchemaLine.SetRange("Balancing Entry", false);
        lvngLoanProcessingSchemaLine.Setfilter("Processing Source Type", '<>%1', lvngLoanProcessingSchemaLine."Processing Source Type"::lvngTag);
        if lvngLoanProcessingSchemaLine.FindSet() then begin
            repeat
                CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
            until lvngLoanProcessingSchemaLine.Next() = 0;
        end;
        lvngLoanDocumentLineTemp.reset;
        lvngLoanDocumentLineTemp.DeleteAll();
        lvngLoanDocumentLine.reset;
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                Clear(lvngLoanDocumentLineTemp);
                lvngLoanDocumentLineTemp := lvngLoanDocumentLine;
                lvngLoanDocumentLineTemp.Insert();
            until lvngLoanDocumentLine.Next() = 0;
        end;
        if lvngLoanProcessingSchema."Use Global Schema Code" <> '' then begin
            lvngLoanProcessingSchemaLine.reset;
            lvngLoanProcessingSchemaLine.SetRange("Balancing Entry", true);
            lvngLoanProcessingSchemaLine.SetRange("Processing Code", lvngLoanProcessingSchema."Use Global Schema Code");
            if lvngLoanProcessingSchemaLine.FindSet() then begin
                repeat
                    CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
                until lvngLoanProcessingSchemaLine.Next() = 0;
            end;
        end;
        lvngLoanProcessingSchemaLine.reset;
        lvngLoanProcessingSchemaLine.SetRange("Processing Code", lvngLoanProcessingSchema.Code);
        lvngLoanProcessingSchemaLine.SetRange("Balancing Entry", true);
        if lvngLoanProcessingSchemaLine.FindSet() then begin
            repeat
                CreateDocumentLine(lvngLoanDocumentLine, lvngLoanDocument, lvngLoanProcessingSchemaLine, lvngLoanJournalLine, lvngLineNo);
            until lvngLoanProcessingSchemaLine.Next() = 0;
        end;
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange(Amount, 0);
        lvngLoanDocumentLine.DeleteAll();
        lvngLoanDocumentLine.reset;
        lvngLoanDocumentLine.SetRange("Balancing Entry", false);
        if lvngLoanDocumentLine.FindSet() then begin
            repeat
                lvngDocumentAmount := lvngDocumentAmount + lvngLoanDocumentLine.Amount;
            until lvngLoanDocumentLine.Next() = 0;
        end;
        //Option here
        case lvngLoanProcessingSchema."Document Type Option" of
            lvngloanprocessingschema."Document Type Option"::lvngInvoice:
                begin
                    lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngInvoice;
                end;
            lvngloanprocessingschema."Document Type Option"::lvngCreditMemo:
                begin
                    lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngCreditMemo;
                end;
            lvngloanprocessingschema."Document Type Option"::lvngAmountBased:
                begin
                    IF lvngDocumentAmount > 0 THEN BEGIN
                        lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngInvoice;
                    END ELSE BEGIN
                        lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngCreditMemo;
                        lvngLoanDocumentLine.reset;
                        lvngLoanDocumentLine.SetRange("Balancing Entry", false);
                        if lvngLoanDocumentLine.FindSet() then begin
                            repeat
                                lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;
                                lvngLoanDocumentLine.Modify();
                            until lvngLoanDocumentLine.Next() = 0;
                        end;
                    END;
                end;
            lvngloanprocessingschema."Document Type Option"::lvngAmountBasedReversed:
                begin
                    IF lvngDocumentAmount > 0 THEN BEGIN
                        lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngCreditMemo;
                    END ELSE BEGIN
                        lvngLoanDocument."Document Type" := lvngLoanDocument."Document Type"::lvngInvoice;
                        lvngLoanDocumentLine.reset;
                        lvngLoanDocumentLine.SetRange("Balancing Entry", false);
                        if lvngLoanDocumentLine.FindSet() then begin
                            repeat
                                lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;
                                lvngLoanDocumentLine.Modify();
                            until lvngLoanDocumentLine.Next() = 0;
                        end;
                    END;
                end;
        end;
        lvngLoanDocument.Modify();
    end;

    local procedure CreateDocumentLine(var lvngLoanDocumentLine: Record lvngLoanDocumentLine; lvngLoanDocument: record lvngLoanDocument; lvngLoanProcessingSchemaLine: Record lvngLoanProcessingSchemaLine; lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLineNo: integer)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngAccountNo: Code[20];
        lvngDecimalValue: Decimal;
    begin
        if CheckCondition(lvngLoanProcessingSchemaLine."Condition Code") then begin
            Clear(lvngLoanDocumentLine);
            lvngLoanDocumentLine.init;
            lvngLoanDocumentLine."Document No." := lvngLoanDocument."Document No.";
            lvngLoanDocumentLine."Transaction Type" := lvngLoanDocument."Transaction Type";
            lvngLoanDocumentLine."Line No." := lvngLineNo;
            lvngLoanDocumentLine."Processing Schema Code" := lvngLoanProcessingSchemaLine."Processing Code";
            lvngloandocumentline."Processing Schema Line No." := lvngLoanProcessingSchemaLine."Line No.";
            lvngLoanDocumentLine."Balancing Entry" := lvngLoanProcessingSchemaLine."Balancing Entry";
            lvngLoanDocumentLine."Tag Code" := lvngLoanProcessingSchemaLine."Tag Code";
            lvngLoanDocumentLine."Servicing Type" := lvngLoanProcessingSchemaLine."Servicing Type";
            lvngLineNo := lvngLineNo + 10000;
            lvngLoanDocumentLine.Insert();
            if lvngLoanProcessingSchemaLine."Override Reason Code" <> '' then begin
                lvngLoanDocumentLine."Reason Code" := lvngLoanProcessingSchemaLine."Override Reason Code";
            end else begin
                lvngLoanDocumentLine."Reason Code" := lvngLoanJournalLine."Reason Code";
            end;
            lvngLoanDocumentLine.Description := CopyStr(lvngLoanProcessingSchemaLine.Description, 1, MaxStrLen(lvngLoanDocumentLine.Description));
            lvngLoanDocumentLine."Account Type" := lvngLoanProcessingSchemaLine."Account Type";
            lvngLoanDocumentLine."Account No." := lvngLoanProcessingSchemaLine."Account No.";
            if lvngLoanProcessingSchemaLine."Account No. Switch Code" <> '' then begin
                lvngAccountNo := GetSwitchValue(lvngLoanProcessingSchemaLine."Account No. Switch Code");
                if lvngAccountNo <> '' then
                    lvngLoanDocumentLine."Account No." := lvngAccountNo;
            end;
            case lvngLoanProcessingSchemaLine."Processing Source Type" of
                lvngLoanProcessingSchemaLine."Processing Source Type"::lvngFunction:
                    begin
                        if Evaluate(lvngDecimalValue, GetFunctionValue(lvngLoanProcessingSchemaLine."Function Code")) then
                            lvngLoanDocumentLine.Amount := lvngDecimalValue;
                    end;
                lvngLoanProcessingSchemaLine."Processing Source Type"::lvngLoanJournalValue:
                    begin
                        lvngRecRef.GetTable(lvngLoanJournalLine);
                        lvngFieldRef := lvngRecRef.Field(lvngLoanProcessingSchemaLine."Field No.");
                        lvngLoanDocumentLine.Amount := lvngFieldRef.Value();
                        lvngRecRef.Close();
                    end;
                lvngLoanProcessingSchemaLine."Processing Source Type"::lvngLoanJournalVariableValue:
                    begin
                        if lvngLoanJournalValue.Get(lvngLoanJournalLine."Loan Journal Batch Code", lvngLoanJournalLine."Line No.", lvngLoanProcessingSchemaLine."Field No.") then begin
                            if Evaluate(lvngDecimalValue, lvngLoanJournalValue."Field Value") then
                                lvngLoanDocumentLine.Amount := lvngDecimalValue;
                        end;
                    end;
                lvngLoanProcessingSchemaLine."Processing Source Type"::lvngTag:
                    begin
                        Clear(lvngDecimalValue);
                        lvngLoanProcessingSchemaLine.TestField("Balancing Entry");
                        lvngLoanDocumentLineTemp.reset;
                        lvngLoanDocumentLineTemp.SetRange("Tag Code", lvngLoanProcessingSchemaLine."Tag Code");
                        if lvngLoanDocumentLineTemp.FindSet() then begin
                            repeat
                                lvngDecimalValue := lvngDecimalValue + lvngLoanDocumentLineTemp.Amount;
                            until lvngLoanDocumentLineTemp.Next() = 0;
                        end;
                        lvngLoanDocumentLine.Amount := lvngDecimalValue;
                    end;
            end;
            if lvngLoanProcessingSchemaLine."Reverse Sign" then
                lvngLoanDocumentLine.Amount := -lvngLoanDocumentLine.Amount;

            AssignDimensions(lvngLoanDocumentLine."Global Dimension 1 Code", lvngLoanProcessingSchemaLine."Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code", lvngLoanProcessingSchemaLine."Dimension 1 Rule");
            AssignDimensions(lvngLoanDocumentLine."Global Dimension 2 Code", lvngLoanProcessingSchemaLine."Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code", lvngLoanProcessingSchemaLine."Dimension 2 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 3 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code", lvngLoanProcessingSchemaLine."Dimension 3 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 4 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code", lvngLoanProcessingSchemaLine."Dimension 4 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 5 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code", lvngLoanProcessingSchemaLine."Dimension 5 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 6 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code", lvngLoanProcessingSchemaLine."Dimension 6 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 7 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code", lvngLoanProcessingSchemaLine."Dimension 7 Rule");
            AssignDimensions(lvngLoanDocumentLine."Shortcut Dimension 8 Code", lvngLoanProcessingSchemaLine."Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code", lvngLoanProcessingSchemaLine."Dimension 8 Rule");
            AssignDimensions(lvngLoanDocumentLine."Business Unit Code", lvngLoanProcessingSchemaLine."Business Unit Code", lvngLoanJournalLine."Business Unit Code", lvngLoanProcessingSchemaLine."Business Unit Rule");
            lvngLoanDocumentLine.GenerateDimensionSetId();
            lvngLoanDocumentLine.Modify();
        end;
    end;

    local procedure AssignDimensions(var AssignToDimension: Code[20]; lvngProcessingDimensionValueCode: Code[20]; lvngJournalDimensionValueCode: Code[20]; lvngProcessingDimensionRule: enum lvngProcessingDimensionRule)
    begin
        case lvngProcessingDimensionRule of
            lvngProcessingDimensionRule::lvngDefined:
                begin
                    AssignToDimension := lvngProcessingDimensionValueCode;
                end;
            lvngProcessingDimensionRule::lvngJournalLine:
                begin
                    AssignToDimension := lvngJournalDimensionValueCode;
                end;
        end;
    end;

    local procedure CheckCondition(lvngConditionCode: code[20]): Boolean
    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        if lvngConditionCode = '' then
            exit(true);
        ExpressionHeader.Get(lvngConditionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(lvngExpressionEngine.CheckCondition(ExpressionHeader, lvngExpressionValueBuffer));
    end;

    local procedure GetFunctionValue(lvngFunctionCode: code[20]): Text
    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
    begin
        ExpressionHeader.Get(lvngFunctionCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        exit(lvngExpressionEngine.CalculateFormula(ExpressionHeader, lvngExpressionValueBuffer));
    end;

    local procedure GetSwitchValue(lvngSwitchCode: code[20]): Code[20]
    var
        ConditionsMgmt: Codeunit lvngConditionsMgmt;
        ExpressionHeader: Record lvngExpressionHeader;
        lvngResult: Text;
    begin
        ExpressionHeader.Get(lvngSwitchCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        if not lvngExpressionEngine.SwitchCase(ExpressionHeader, lvngResult, lvngExpressionValueBuffer) then
            exit('');
        exit(copystr(lvngResult, 1, 20));

    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;

        lvngExpressionValueBuffer: record lvngExpressionValueBuffer temporary;
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionEngine: Codeunit lvngExpressionEngine;
        lvngLoanDocumentLineTemp: Record lvngLoanDocumentLine temporary;
        lvngLoanVisionSetupRetrieved: Boolean;
}