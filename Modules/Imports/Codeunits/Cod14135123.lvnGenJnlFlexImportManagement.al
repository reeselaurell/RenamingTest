codeunit 14135123 "lvnGenJnlFlexImportManagement"
{
    var
        FieldSeparatorLbl: Label '<TAB>';
        OpenFileLbl: Label 'Open File for Import';
        ReadingToStreamErr: Label 'Error reading file to stream';
        NotSupportedExpressionType: Label 'Expression type is not supported: %1';
        SchemaEmptyErr: Label 'Import schema is empty';
        PostingDateIsBlankErr: Label 'Posting Date is Blank';
        PostingDateIsNotValidErr: Label '%1 Posting Date is not within allowed date ranges';
        AccountNoBlankOrMissingErr: Label 'Account %1 %2 is blank or missing';
        BalAccountNoBlankOrMissingErr: Label 'Bal. Account %1 %2 is missing';
        LoanNoNotFoundErr: Label 'Loan No. %1 not found';
        DimensionValueCodeMissingErr: Label 'Dimension Value Code %1 is missing';
        DimensionValueCodeBlockedErr: Label 'Dimension Value Code %1 is blocked';
        FlexibleImportSchema: Record lvnFlexibleImportSchema;
        TempCSVBuffer: Record "CSV Buffer" temporary;

    procedure ManualFileImport(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; var ImportBufferError: Record lvnImportBufferError): Boolean
    var
        FlexibleImportSchemaLine: Record lvnFlexibleImportSchemaLine;
    begin
        FlexibleImportSchema.Reset();
        if Page.RunModal(0, FlexibleImportSchema) = Action::LookupOK then begin
            FlexibleImportSchemaLine.Reset();
            FlexibleImportSchemaLine.SetRange("Schema Code", FlexibleImportSchema.Code);
            if FlexibleImportSchemaLine.IsEmpty() then
                Error(SchemaEmptyErr);
            ReadCSVStream();
            GenJnlImportBuffer.Reset();
            GenJnlImportBuffer.DeleteAll();
            ProcessImportCSVBuffer(GenJnlImportBuffer);
            ValidateEntries(GenJnlImportBuffer, ImportBufferError);
            exit(true);
        end else
            exit(false);
    end;

    procedure CreateJournalLines(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; GenJnlTemplateCode: Code[10]; GenJnlBatchCode: Code[10]; ImportID: Guid)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DimensionMgmt: Codeunit lvnDimensionsManagement;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        GenJnlTemplate.Get(GenJnlTemplateCode);
        GenJnlBatch.Get(GenJnlTemplateCode, GenJnlBatchCode);
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplateCode);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatchCode);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 100
        else
            LineNo := 100;
        GenJnlImportBuffer.Reset();
        GenJnlImportBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine.lvnImportID := ImportID;
            GenJnlLine.Validate("Journal Template Name", GenJnlTemplateCode);
            GenJnlLine.Validate("Journal Batch Name", GenJnlBatchCode);
            GenJnlLine.Validate("Line No.", LineNo);
            GenJnlLine.Validate("Source Code", GenJnlTemplate."Source Code"); //new regular only before insert
            LineNo += 100;
            GenJnlLine.Insert(true);
            GenJnlLine.Validate("Document Type", GenJnlImportBuffer."Document Type");
            GenJnlLine.Validate("Posting Date", GenJnlImportBuffer."Posting Date");
            GenJnlLine."Account Type" := GenJnlImportBuffer."Account Type";
            GenJnlLine.Validate("Account No.", GenJnlImportBuffer."Account No.");
            GenJnlLine."Bal. Account Type" := GenJnlImportBuffer."Bal. Account Type";
            GenJnlLine.Validate("Bal. Account No.", GenJnlImportBuffer."Bal. Account No.");
            GenJnlLine.lvnServicingType := GenJnlImportBuffer."Servicing Type";
            GenJnlLine.Validate(lvnLoanNo, GenJnlImportBuffer."Loan No.");
            GenJnlLine.Validate("Shortcut Dimension 1 Code", GenJnlImportBuffer."Global Dimension 1 Code");
            GenJnlLine.Validate("Shortcut Dimension 2 Code", GenJnlImportBuffer."Global Dimension 2 Code");
            GenJnlLine.ValidateShortcutDimCode(3, GenJnlImportBuffer."Shortcut Dimension 3 Code");
            GenJnlLine.ValidateShortcutDimCode(4, GenJnlImportBuffer."Shortcut Dimension 4 Code");
            GenJnlLine.ValidateShortcutDimCode(5, GenJnlImportBuffer."Shortcut Dimension 5 Code");
            GenJnlLine.ValidateShortcutDimCode(6, GenJnlImportBuffer."Shortcut Dimension 6 Code");
            GenJnlLine.ValidateShortcutDimCode(7, GenJnlImportBuffer."Shortcut Dimension 7 Code");
            GenJnlLine.ValidateShortcutDimCode(8, GenJnlImportBuffer."Shortcut Dimension 8 Code");
            GenJnlLine.Validate("Business Unit Code", GenJnlImportBuffer."Business Unit Code");
            GenJnlLine.Validate(Amount, GenJnlImportBuffer.Amount);
            if GenJnlImportBuffer."Use Dimension Hierarchy" then
                DimensionMgmt.ValidateDimensionHierarchyGenJnlLine(GenJnlLine);
            if FlexibleImportSchema."Use Document No. From Series" then
                GenJnlLine.Validate("Document No.", NoSeriesManagement.GetNextNo(GenJnlBatch."No. Series", Today(), true))
            else
                GenJnlLine.Validate("Document No.", GenJnlImportBuffer."Document No.");
            GenJnlLine.Validate("Document Date", GenJnlImportBuffer."Document Date");
            if FlexibleImportSchema."Default Reason Code" <> '' then
                GenJnlLine.Validate("Reason Code", FlexibleImportSchema."Default Reason Code");
            if GenJnlImportBuffer.Description <> '' then
                GenJnlLine.Validate(Description, GenJnlImportBuffer.Description);
            if GenJnlImportBuffer."External Document No." <> '' then
                GenJnlLine.Validate("External Document No.", GenJnlImportBuffer."External Document No.");
            GenJnlLine.Validate(Comment, GenJnlImportBuffer.Comment);
            GenJnlLine.Modify(true);
        until GenJnlImportBuffer.Next() = 0;
    end;

    local procedure ValidateEntries(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; var ImportBufferError: Record lvnImportBufferError)
    var
        FlexibleImportSchemaLine: Record lvnFlexibleImportSchemaLine;
        ValueBuffer: Record lvnExpressionValueBuffer temporary;
        Loan: Record lvnLoan;
        UserSetupMgmt: Codeunit "User Setup Management";
        LoanExists: Boolean;
        ValueAssignType: Enum lvnFlexImportAssignTarget;
    begin
        ImportBufferError.Reset();
        ImportBufferError.DeleteAll();
        GenJnlImportBuffer.Reset();
        if GenJnlImportBuffer.FindSet() then
            repeat
                FlexibleImportSchemaLine.Get(FlexibleImportSchema.Code, GenJnlImportBuffer."Flexible Line No.");
                LoanExists := Loan.Get(GenJnlImportBuffer."Loan No.");
                if not LoanExists then
                    Clear(Loan);
                ValueBuffer.Reset();
                ValueBuffer.DeleteAll();
                //Amount
                if FlexibleImportSchemaLine."Reverse Amount" then
                    GenJnlImportBuffer.Amount := -GenJnlImportBuffer.Amount;
                //Posting Date
                if GenJnlImportBuffer."Posting Date" = 0D then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, PostingDateIsBlankErr)
                else
                    if not UserSetupMgmt.IsPostingDateValid(GenJnlImportBuffer."Posting Date") then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, strsubstno(PostingDateIsNotValidErr, GenJnlImportBuffer."Posting Date"));
                if GenJnlImportBuffer."Document Date" = 0D then
                    GenJnlImportBuffer."Document Date" := GenJnlImportBuffer."Posting Date";
                //Account Type and Account No.
                GenJnlImportBuffer."Account Type" := FlexibleImportSchemaLine."Account Type";
                GenJnlImportBuffer."Account No." := FlexibleImportSchemaLine."Account No.";
                if LoanExists then
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Account No.", GenJnlImportBuffer."Account No.");
                if not CheckAccountNo(GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Account No.") then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(AccountNoBlankOrMissingErr, GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Account No."));
                //Bal. Account Type and Bal. Account No.
                GenJnlImportBuffer."Bal. Account Type" := FlexibleImportSchemaLine."Bal. Account Type";
                GenJnlImportBuffer."Bal. Account No." := FlexibleImportSchemaLine."Bal. Account No.";
                if LoanExists then
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Bal. Account No.", GenJnlImportBuffer."Bal. Account No.");
                if GenJnlImportBuffer."Bal. Account No." <> '' then
                    if not CheckAccountNo(GenJnlImportBuffer."Bal. Account Type", GenJnlImportBuffer."Bal. Account No.") then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(BalAccountNoBlankOrMissingErr, GenJnlImportBuffer."Bal. Account Type", GenJnlImportBuffer."Bal. Account No."));
                //Dimensions
                GenJnlImportBuffer."Servicing Type" := FlexibleImportSchemaLine."Servicing Type";

                AssignDimensionValues(FlexibleImportSchemaLine."Dimension Validation Rule 1", GenJnlImportBuffer, FlexibleImportSchemaLine, LoanExists, Loan, ImportBufferError);
                AssignDimensionValues(FlexibleImportSchemaLine."Dimension Validation Rule 2", GenJnlImportBuffer, FlexibleImportSchemaLine, LoanExists, Loan, ImportBufferError);
                AssignDimensionValues(FlexibleImportSchemaLine."Dimension Validation Rule 3", GenJnlImportBuffer, FlexibleImportSchemaLine, LoanExists, Loan, ImportBufferError);
                if LoanExists then begin
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 1", GenJnlImportBuffer."Global Dimension 1 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 2", GenJnlImportBuffer."Global Dimension 2 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 3", GenJnlImportBuffer."Shortcut Dimension 3 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 4", GenJnlImportBuffer."Shortcut Dimension 4 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 5", GenJnlImportBuffer."Shortcut Dimension 5 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 6", GenJnlImportBuffer."Shortcut Dimension 6 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 7", GenJnlImportBuffer."Shortcut Dimension 7 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Dimension 8", GenJnlImportBuffer."Shortcut Dimension 8 Code");
                    CheckConditionAssignments(FlexibleImportSchemaLine, Loan, ValueBuffer, ValueAssignType::"Business Unit", GenJnlImportBuffer."Business Unit Code");
                end;
                ValidateDimension(GenJnlImportBuffer, 1, GenJnlImportBuffer."Global Dimension 1 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 2, GenJnlImportBuffer."Global Dimension 2 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 3, GenJnlImportBuffer."Shortcut Dimension 3 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 4, GenJnlImportBuffer."Shortcut Dimension 4 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 5, GenJnlImportBuffer."Shortcut Dimension 5 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 6, GenJnlImportBuffer."Shortcut Dimension 6 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 7, GenJnlImportBuffer."Shortcut Dimension 7 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer, 8, GenJnlImportBuffer."Shortcut Dimension 8 Code", ImportBufferError);
                if FlexibleImportSchemaLine."Custom Description" <> '' then
                    GenJnlImportBuffer.Description := FlexibleImportSchemaLine."Custom Description";
                GenJnlImportBuffer.Modify();

            until GenJnlImportBuffer.Next() = 0;
    end;

    local procedure AssignDimensionValues(Source: Enum lvnFlexImportDimValidationRule; var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; var FlexibleImportSchemaLine: Record lvnFlexibleImportSchemaLine; LoanExists: Boolean; var Loan: Record lvnLoan; var ImportBufferError: Record lvnImportBufferError)
    begin
        case Source of
            Source::"From File":
                begin
                    if GenJnlImportBuffer."Global Dimension 1 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 1 Code" := CopyStr(GenJnlImportBuffer."Global Dimension 1 Value", 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 1 Code"));
                    if GenJnlImportBuffer."Global Dimension 2 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 2 Code" := CopyStr(GenJnlImportBuffer."Global Dimension 2 Value", 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 2 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 3 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 3 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 3 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 3 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 4 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 4 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 4 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 4 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 5 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 5 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 5 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 5 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 6 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 6 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 6 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 6 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 7 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 7 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 7 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 7 Code"));
                    if GenJnlImportBuffer."Shortcut Dimension 8 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 8 Code" := CopyStr(GenJnlImportBuffer."Shortcut Dimension 8 Value", 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 8 Code"));
                    if GenJnlImportBuffer."Business Unit Code" = '' then
                        GenJnlImportBuffer."Business Unit Code" := CopyStr(GenJnlImportBuffer."Business Unit Value", 1, MaxStrLen(GenJnlImportBuffer."Business Unit Code"));
                end;
            Source::"From Schema":
                begin
                    if GenJnlImportBuffer."Global Dimension 1 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 1 Code" := FlexibleImportSchemaLine."Global Dimension 1 Code";
                    if GenJnlImportBuffer."Global Dimension 2 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 2 Code" := FlexibleImportSchemaLine."Global Dimension 2 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 3 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 3 Code" := FlexibleImportSchemaLine."Shortcut Dimension 3 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 4 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 4 Code" := FlexibleImportSchemaLine."Shortcut Dimension 4 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 5 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 5 Code" := FlexibleImportSchemaLine."Shortcut Dimension 5 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 6 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 6 Code" := FlexibleImportSchemaLine."Shortcut Dimension 6 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 7 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 7 Code" := FlexibleImportSchemaLine."Shortcut Dimension 7 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 8 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 8 Code" := FlexibleImportSchemaLine."Shortcut Dimension 8 Code";
                    if GenJnlImportBuffer."Business Unit Code" = '' then
                        GenJnlImportBuffer."Business Unit Code" := FlexibleImportSchemaLine."Business Unit Code";
                end;
            Source::"From Loan":
                begin
                    if not LoanExists then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(LoanNoNotFoundErr, GenJnlImportBuffer."Loan No."));
                    if GenJnlImportBuffer."Global Dimension 1 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                    if GenJnlImportBuffer."Global Dimension 2 Code" = '' then
                        GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 3 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 4 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 5 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 6 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 7 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                    if GenJnlImportBuffer."Shortcut Dimension 8 Code" = '' then
                        GenJnlImportBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                end;
        end;
    end;

    local procedure CheckAccountNo(GenJnlAccountType: Enum lvnGenJnlAccountType; AccountNo: Code[20]): Boolean
    var
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        ICPartner: Record "IC Partner";
    begin
        if AccountNo = '' then
            exit(false);
        case GenJnlAccountType of
            GenJnlAccountType::"G/L Account":
                exit(GLAccount.Get(AccountNo) and (GLAccount."Account Type" = GLAccount."Account Type"::Posting));
            GenJnlAccountType::"Bank Account":
                exit(BankAccount.Get(AccountNo));
            GenJnlAccountType::Customer:
                exit(Customer.Get(AccountNo));
            GenJnlAccountType::Vendor:
                exit(Vendor.Get(AccountNo));
            GenJnlAccountType::"Fixed Asset":
                exit(FixedAsset.Get(AccountNo));
            GenJnlAccountType::"IC Partner":
                exit(ICPartner.Get(AccountNo));
            else
                exit(false);
        end;
    end;

    local procedure ValidateDimension(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; DimensionNo: Integer; DimensionValueCode: Code[20]; var ImportBufferError: Record lvnImportBufferError)
    var
        DimensionValue: Record "Dimension Value";
    begin
        if DimensionValueCode <> '' then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Global Dimension No.", DimensionNo);
            DimensionValue.SetRange(Code, DimensionValueCode);
            if not DimensionValue.FindFirst() then
                AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(DimensionValueCodeMissingErr, DimensionValueCode))
            else
                if DimensionValue.Blocked then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(DimensionValueCodeBlockedErr, DimensionValueCode));
        end;
    end;

    local procedure CheckConditionAssignments(var FlexibleImportSchemaLine: Record lvnFlexibleImportSchemaLine; var Loan: Record lvnLoan; var ValueBuffer: Record lvnExpressionValueBuffer; AssignValueType: Enum lvnFlexImportAssignTarget; var ValueToAssign: Code[20])
    var
        FlexImportSchemaExpression: Record lvnFlexImportSchemaExpression;
        ExpressionHeader: Record lvnExpressionHeader;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        Value: Text;
    begin
        FlexImportSchemaExpression.Reset();
        FlexImportSchemaExpression.SetRange("Schema Code", FlexibleImportSchemaLine."Schema Code");
        FlexImportSchemaExpression.SetRange("Amount Column No.", FlexibleImportSchemaLine."Amount Column No.");
        FlexImportSchemaExpression.SetRange("Assign Result To Field", AssignValueType);
        if FlexImportSchemaExpression.FindSet() then begin
            if ValueBuffer.IsEmpty() then
                ConditionsMgmt.FillLoanFieldValues(ValueBuffer, Loan);
            repeat
                ExpressionHeader.Get(FlexImportSchemaExpression."Expression Code", ConditionsMgmt.GetConditionsMgmtConsumerId());
                case ExpressionHeader.Type of
                    ExpressionHeader.Type::Condition:
                        if ExpressionEngine.CheckCondition(ExpressionHeader, ValueBuffer) then
                            ValueToAssign := FlexImportSchemaExpression.Value;
                    ExpressionHeader.Type::Switch:
                        if ExpressionEngine.SwitchCase(ExpressionHeader, Value, ValueBuffer) then
                            ValueToAssign := Value;
                    else
                        Error(NotSupportedExpressionType, ExpressionHeader.Type);
                end;
            until FlexImportSchemaExpression.Next() = 0;
        end;
    end;

    local procedure AddErrorLine(GenJnlImportBuffer: Record lvnGenJnlImportBuffer; var ImportBufferError: Record lvnImportBufferError; ErrorText: Text)
    var
        ErrorLineNo: Integer;
    begin
        ImportBufferError.Reset();
        ImportBufferError.SetRange("Line No.", GenJnlImportBuffer."Line No.");
        if ImportBufferError.FindLast() then
            ErrorLineNo := ImportBufferError."Error No." + 100
        else
            ErrorLineNo := 100;
        Clear(ImportBufferError);
        ImportBufferError."Line No." := GenJnlImportBuffer."Line No.";
        ImportBufferError."Error No." := ErrorLineNo;
        ImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(ImportBufferError.Description));
        ImportBufferError.Insert();
    end;

    local procedure ReadCSVStream()
    var
        TabChar: Char;
        FileName: Text;
        ImportStream: InStream;
    begin
        TabChar := 9;
        if FlexibleImportSchema."Field Separator Character" = FieldSeparatorLbl then
            FlexibleImportSchema."Field Separator Character" := TabChar;
        if UploadIntoStream(OpenFileLbl, '', '', FileName, ImportStream) then begin
            TempCSVBuffer.LoadDataFromStream(ImportStream, FlexibleImportSchema."Field Separator Character");
            TempCSVBuffer.ResetFilters();
            TempCSVBuffer.SetRange("Line No.", 0, FlexibleImportSchema."Skip Rows");
            TempCSVBuffer.DeleteAll();
        end else
            Error(ReadingToStreamErr);
    end;

    local procedure ProcessImportCSVBuffer(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer);
    var
        FlexibleImportSchemaLine: Record lvnFlexibleImportSchemaLine;
        BaseGenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
        AccountValueMap: Dictionary of [Integer, Decimal];
        CurrRow: Integer;
        EndRow: Integer;
        LineNo: Integer;
        FieldNo: Integer;
        RawValue: Text;
        DecimalValue: Decimal;
    begin
        GenJnlImportBuffer.Reset();
        GenJnlImportBuffer.DeleteAll();
        TempCSVBuffer.ResetFilters();
        TempCSVBuffer.FindFirst();
        CurrRow := TempCSVBuffer."Line No.";
        EndRow := TempCSVBuffer.GetNumberOfLines();
        LineNo := 100;
        repeat
            Clear(BaseGenJnlImportBuffer);
            Clear(AccountValueMap);
            TempCSVBuffer.ResetFilters();
            TempCSVBuffer.SetRange("Line No.", CurrRow);
            TempCSVBuffer.FindSet();
            repeat
                RawValue := DelChr(TempCSVBuffer.Value, '<>', ' ');
                if RawValue <> '' then begin
                    case TempCSVBuffer."Field No." of
                        FlexibleImportSchema."Document Type Column No.":
                            if not Evaluate(BaseGenJnlImportBuffer."Document Type", RawValue) then
                                BaseGenJnlImportBuffer."Document Type" := BaseGenJnlImportBuffer."Document Type"::" ";
                        FlexibleImportSchema."Document No. Column No.":
                            BaseGenJnlImportBuffer."Document No." := FlexibleImportSchema."Document No. Prefix" + RawValue;
                        FlexibleImportSchema."Posting Date Column No.":
                            if not Evaluate(BaseGenJnlImportBuffer."Posting Date", RawValue) then
                                BaseGenJnlImportBuffer."Posting Date" := 0D;
                        FlexibleImportSchema."Document Date Column No.":
                            if not Evaluate(BaseGenJnlImportBuffer."Document Date", RawValue) then
                                BaseGenJnlImportBuffer."Document Date" := 0D;
                        FlexibleImportSchema."Dimension 1 Code Column No.":
                            BaseGenJnlImportBuffer."Global Dimension 1 Value" := RawValue;
                        FlexibleImportSchema."Dimension 2 Code Column No.":
                            BaseGenJnlImportBuffer."Global Dimension 2 Value" := RawValue;
                        FlexibleImportSchema."Dimension 3 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 3 Value" := RawValue;
                        FlexibleImportSchema."Dimension 4 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 4 Value" := RawValue;
                        FlexibleImportSchema."Dimension 5 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 5 Value" := RawValue;
                        FlexibleImportSchema."Dimension 6 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 6 Value" := RawValue;
                        FlexibleImportSchema."Dimension 7 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 7 Value" := RawValue;
                        FlexibleImportSchema."Dimension 8 Code Column No.":
                            BaseGenJnlImportBuffer."Shortcut Dimension 8 Value" := RawValue;
                        FlexibleImportSchema."Business Unit Code Column No.":
                            BaseGenJnlImportBuffer."Business Unit Value" := RawValue;
                        FlexibleImportSchema."Loan No. Column No.":
                            BaseGenJnlImportBuffer."Loan No." := FlexibleImportSchema."Loan No. Prefix" + RawValue;
                        FlexibleImportSchema."External Document Column No.":
                            BaseGenJnlImportBuffer."External Document No." := RawValue;
                        FlexibleImportSchema."Comment Column No.":
                            BaseGenJnlImportBuffer.Comment := RawValue;
                        else
                            if FlexibleImportSchemaLine.Get(FlexibleImportSchema.Code, TempCSVBuffer."Field No.") then begin
                                if Evaluate(DecimalValue, RawValue) then
                                    if DecimalValue <> 0 then
                                        AccountValueMap.Add(TempCSVBuffer."Field No.", DecimalValue);
                            end;
                    end;
                end;
            until TempCSVBuffer.Next() = 0;
            foreach FieldNo in AccountValueMap.Keys() do begin
                Clear(GenJnlImportBuffer);
                GenJnlImportBuffer.TransferFields(BaseGenJnlImportBuffer, false);
                GenJnlImportBuffer."Line No." := LineNo;
                GenJnlImportBuffer.Amount := AccountValueMap.Get(FieldNo);
                GenJnlImportBuffer."Flexible Line No." := FieldNo;
                GenJnlImportBuffer.Insert();
                LineNo += 100;
            end;
            CurrRow += 1;
        until CurrRow > EndRow;
    end;
}