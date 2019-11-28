codeunit 14135115 lvngGenJnlFileImportManagement
{
    var
        FileImportSchema: Record lvngFileImportSchema;
        FileImportJnlLine: Record lvngFileImportJnlLine;
        TempFileImportJnlLine: Record lvngFileImportJnlLine temporary;
        TempCSVBuffer: Record "CSV Buffer" temporary;
        DimensionsManagement: Codeunit lvngDimensionsManagement;
        MainDimensionCode: Code[20];
        HierarchyDimensionsUsage: array[5] of Boolean;
        MainDimensionNo: Integer;
        ImportStream: InStream;
        FileName: Text;
        ImportToStream: Boolean;
        OpenFileLbl: Label 'Open File for Import';
        ReadingToStreamErr: Label 'Error reading file to stream';

    procedure CreateJournalLines(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; GenJnlTemplateCode: Code[10]; GenJnlBatchCode: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        GenJnlTemplate.Get(GenJnlTemplateCode);
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
            GenJnlLine.Validate("Journal Template Name", GenJnlTemplateCode);
            GenJnlLine.Validate("Journal Batch Name", GenJnlBatchCode);
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.Insert();
            GenJnlLine."Account Type" := GenJnlImportBuffer."Account Type";
            GenJnlLine.Validate("Account No.", GenJnlImportBuffer."Account No.");
            if GenJnlImportBuffer.Description <> '' then
                GenJnlLine.Description := GenJnlImportBuffer.Description;
            GenJnlLine.Validate("Document Type", GenJnlImportBuffer."Document Type");
            GenJnlLine.Validate("Document No.", GenJnlImportBuffer."Document No.");
            GenjnlLine.Validate("External Document No.", GenJnlImportBuffer."External Document No.");
            GenJnlLine.Validate("Document No.", GenJnlImportBuffer."Document No.");
            GenJnlLine.Validate("Posting Date", GenJnlImportBuffer."Posting Date");
            GenJnlLine.Validate("Document Date", GenJnlImportBuffer."Document Date");
            GenJnlLine.Validate(Amount, GenJnlImportBuffer.Amount);
            GenJnlLine."Applies-to Doc. Type" := GenJnlImportBuffer."Applies-To Doc. Type";
            GenJnlLine."Applies-to Doc. No." := GenJnlImportBuffer."Applies-To Doc. No.";
            GenJnlLine."Bal. Account Type" := GenJnlImportBuffer."Bal. Account Type";
            GenJnlLine.Validate("Bal. Account No.", GenJnlImportBuffer."Bal. Account No.");
            GenJnlLine."Bank Payment Type" := GenJnlImportBuffer."Bank Payment Type";
            GenJnlLine.Comment := GenJnlImportBuffer.Comment;
            GenJnlLine.Validate("Depreciation Book Code", GenJnlImportBuffer."Depreciation Book Code");
            if GenJnlImportBuffer."Due Date" <> 0D then
                GenJnlLine."Due Date" := GenJnlImportBuffer."Due Date";
            GenJnlLine."FA Posting Type" := GenJnlImportBuffer."FA Posting Type";
            if GenJnlImportBuffer."Posting Group" <> '' then
                GenjnlLine.Validate("Posting Group", GenJnlImportBuffer."Posting Group");
            GenJnlLine."Recurring Frequency" := GenJnlImportBuffer."Recurring Frequency";
            GenJnlLine."Recurring Method" := GenJnlImportBuffer."Recurring Method";
            GenJnlLine."Loan No." := GenJnlImportBuffer."Loan No.";
            GenJnlLine.Validate("Reason Code", GenJnlImportBuffer."Reason Code");
            GenJnlLine."Shortcut Dimension 1 Code" := GenJnlImportBuffer."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := GenJnlImportBuffer."Global Dimension 2 Code";
            GenJnlLine."Business Unit Code" := GenJnlImportBuffer."Business Unit Code";
            if GenJnlImportBuffer."Global Dimension 1 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, GenJnlImportBuffer."Global Dimension 1 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Global Dimension 2 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, GenJnlImportBuffer."Global Dimension 2 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 3 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, GenJnlImportBuffer."Shortcut Dimension 3 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 4 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, GenJnlImportBuffer."Shortcut Dimension 4 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 5 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, GenJnlImportBuffer."Shortcut Dimension 5 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 6 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, GenJnlImportBuffer."Shortcut Dimension 6 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 7 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, GenJnlImportBuffer."Shortcut Dimension 7 Code", GenJnlLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 8 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, GenJnlImportBuffer."Shortcut Dimension 8 Code", GenJnlLine."Dimension Set ID");
            GenJnlLine.Modify();
            LineNo := LineNo + 100;
        until GenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError): Boolean
    begin
        FileImportSchema.Reset();
        FileImportSchema.SetRange("File Import Type", FileImportSchema."File Import Type"::"General Journal");
        if Page.RunModal(0, FileImportSchema) = Action::LookupOK then begin
            GenJnlImportBuffer.Reset();
            GenJnlImportBuffer.DeleteAll();
            FileImportSchema.Get(FileImportSchema.Code);
            FileImportJnlLine.Reset();
            FileImportJnlLine.SetRange(Code, FileImportSchema.Code);
            FileImportJnlLine.FindSet();
            repeat
                Clear(TempFileImportJnlLine);
                TempFileImportJnlLine := FileImportJnlLine;
                TempFileImportJnlLine.Insert();
            until FileImportJnlLine.Next() = 0;
            ReadCSVStream();
            ProcessImportCSVBuffer(GenJnlImportBuffer);
            ValidateEntries(GenJnlImportBuffer, ImportBufferError);
            exit(true);
        end;
    end;

    local procedure ReadCSVStream()
    var
        TabChar: Char;
    begin
        TabChar := 9;
        if FileImportSchema."Field Separator" = '<TAB>' then
            FileImportSchema."Field Separator" := TabChar;
        ImportToStream := UploadIntoStream(OpenFileLbl, '', '', FileName, ImportStream);
        if ImportToStream then begin
            TempCSVBuffer.LoadDataFromStream(ImportStream, FileImportSchema."Field Separator");
            TempCSVBuffer.ResetFilters();
            TempCSVBuffer.SetRange("Line No.", 0, FileImportSchema."Skip Rows");
            TempCSVBuffer.DeleteAll();
        end else
            Error(ReadingToStreamErr);
    end;

    local procedure ProcessImportCSVBuffer(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        StartLine: Integer;
        EndLine: Integer;
        Value: Text;
        Value2: Text;
        Pos: Integer;
    begin
        GenJnlImportBuffer.Reset();
        GenJnlImportBuffer.DeleteAll();
        TempCSVBuffer.ResetFilters();
        TempCSVBuffer.FindFirst();
        StartLine := TempCSVBuffer."Line No.";
        EndLine := TempCSVBuffer.GetNumberOfLines();
        TempCSVBuffer.ResetFilters();
        repeat
            Clear(GenJnlImportBuffer);
            GenJnlImportBuffer."Line No." := StartLine;
            GenJnlImportBuffer.Insert(true);
            TempFileImportJnlLine.Reset();
            TempFileImportJnlLine.SetRange(Code, FileImportSchema.Code);
            TempFileImportJnlLine.SetFilter("Import Field Type", '<>%1', FileImportJnlLine."Import Field Type"::Dummy);
            TempFileImportJnlLine.FindSet();
            repeat
                Value := TempCSVBuffer.GetValue(StartLine, TempFileImportJnlLine."Column No.");
                if Value <> '' then begin
                    case TempFileImportJnlLine."Import Field Type" of
                        TempFileImportJnlLine."Import Field Type"::"Account No.":
                            begin
                                GenJnlImportBuffer."Account Value" := copystr(Value, 1, maxstrlen(GenJnlImportBuffer."Account Value"));
                                if TempFileImportJnlLine."Dimension Split" then
                                    if TempFileImportJnlLine."Dimension Split Character" <> '' then begin
                                        Pos := StrPos(Value, TempFileImportJnlLine."Dimension Split Character");
                                        if Pos <> 0 then begin
                                            Value2 := CopyStr(Value, Pos + 1);
                                            Value := CopyStr(Value, 1, Pos - 1);
                                            GenJnlImportBuffer."Account Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Account Value"));
                                            case TempFileImportJnlLine."Split Dimension No." of
                                                1:
                                                    GenJnlImportBuffer."Global Dimension 1 Value" := Value2;
                                                2:
                                                    GenJnlImportBuffer."Global Dimension 2 Value" := Value2;
                                                3:
                                                    GenJnlImportBuffer."Shortcut Dimension 3 Value" := Value2;
                                                4:
                                                    GenJnlImportBuffer."Shortcut Dimension 4 Value" := Value2;
                                                5:
                                                    GenJnlImportBuffer."Shortcut Dimension 5 Value" := Value2;
                                                6:
                                                    GenJnlImportBuffer."Shortcut Dimension 6 Value" := Value2;
                                                7:
                                                    GenJnlImportBuffer."Shortcut Dimension 7 Value" := Value2;
                                                8:
                                                    GenJnlImportBuffer."Shortcut Dimension 8 Value" := Value2;
                                            end;
                                        end;
                                    end;
                            end;
                        TempFileImportJnlLine."Import Field Type"::"Account Type":
                            Evaluate(GenJnlImportBuffer."Account Type", Value);
                        TempFileImportJnlLine."Import Field Type"::Amount:
                            Evaluate(GenJnlImportBuffer.Amount, Value);
                        TempFileImportJnlLine."Import Field Type"::"Applies-To Doc. No.":
                            GenJnlImportBuffer."Applies-To Doc. No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Applies-To Doc. No."));
                        TempFileImportJnlLine."Import Field Type"::"Applies-To Doc. Type":
                            Evaluate(GenJnlImportBuffer."Applies-To Doc. Type", Value);
                        TempFileImportJnlLine."Import Field Type"::"Bal. Account No.":
                            GenJnlImportBuffer."Bal. Account Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Bal. Account Value"));
                        TempFileImportJnlLine."Import Field Type"::"Bal. Account Type":
                            Evaluate(GenJnlImportBuffer."Bal. Account Type", Value);
                        TempFileImportJnlLine."Import Field Type"::"Bank Payment Type":
                            Evaluate(GenJnlImportBuffer."Bank Payment Type", Value);
                        TempFileImportJnlLine."Import Field Type"::"Business Unit Code":
                            GenJnlImportBuffer."Business Unit Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Business Unit Code"));
                        TempFileImportJnlLine."Import Field Type"::Comment:
                            GenJnlImportBuffer.Comment := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer.Comment));
                        TempFileImportJnlLine."Import Field Type"::"Depreciation Book Code":
                            GenJnlImportBuffer."Depreciation Book Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Depreciation Book Code"));
                        TempFileImportJnlLine."Import Field Type"::Description:
                            GenJnlImportBuffer.Description := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer.Description));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 1 Code":
                            GenJnlImportBuffer."Global Dimension 1 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 1 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 2 Code":
                            GenJnlImportBuffer."Global Dimension 2 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 2 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 3 Code":
                            GenJnlImportBuffer."Shortcut Dimension 3 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 3 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 4 Code":
                            GenJnlImportBuffer."Shortcut Dimension 4 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 4 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 5 Code":
                            GenJnlImportBuffer."Shortcut Dimension 5 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 5 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 6 Code":
                            GenJnlImportBuffer."Shortcut Dimension 6 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 6 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 7 Code":
                            GenJnlImportBuffer."Shortcut Dimension 7 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 7 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Dimension 8 Code":
                            GenJnlImportBuffer."Shortcut Dimension 8 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 8 Value"));
                        TempFileImportJnlLine."Import Field Type"::"Document Date":
                            Evaluate(GenJnlImportBuffer."Document Date", Value);
                        TempFileImportJnlLine."Import Field Type"::"Document No.":
                            GenJnlImportBuffer."Document No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Document No."));
                        TempFileImportJnlLine."Import Field Type"::"Document Type":
                            Evaluate(GenJnlImportBuffer."Document Type", Value);
                        TempFileImportJnlLine."Import Field Type"::"Due Date":
                            Evaluate(GenJnlImportBuffer."Due Date", Value);
                        TempFileImportJnlLine."Import Field Type"::"External Document No.":
                            GenJnlImportBuffer."External Document No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."External Document No."));
                        TempFileImportJnlLine."Import Field Type"::"FA Posting Type":
                            Evaluate(GenJnlImportBuffer."FA Posting Type", Value);
                        TempFileImportJnlLine."Import Field Type"::"Loan No.":
                            GenJnlImportBuffer."Loan No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Loan No."));
                        TempFileImportJnlLine."Import Field Type"::"Payment Method Code":
                            GenJnlImportBuffer."Payment Method Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Payment Method Code"));
                        TempFileImportJnlLine."Import Field Type"::"Posting Date":
                            Evaluate(GenJnlImportBuffer."Posting Date", Value);
                        TempFileImportJnlLine."Import Field Type"::"Posting Group Code":
                            GenJnlImportBuffer."Posting Group" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Posting Group"));
                        TempFileImportJnlLine."Import Field Type"::"Reason Code":
                            GenJnlImportBuffer."Reason Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Reason Code"));
                    end;
                end;
            until TempFileImportJnlLine.Next() = 0;
            GenJnlImportBuffer.Modify();
            StartLine := StartLine + 1;
        until (StartLine > EndLine);
    end;

    local procedure ValidateEntries(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError)
    var
        PostingDateIsBlankErr: Label 'Posting Date is Blank';
        PostingDateIsNotValidErr: Label '%1 Posting Date is not within allowed date ranges';
        AccountNoBlankOrMissingErr: Label 'Account %1 %2 is missing or blank';
        BalAccountNoBlankOrMissingErr: Label 'Bal. Account %1 %2 is missing or blank';
        LoanNoNotFoundErr: Label 'Loan No. %1 not found';
        PostingGroupMissingErr: Label '%1 %2 Posting Group is not available';
        ReasonCodeMissingErr: Label '%1 Reason Code is not available';
        PaymentMethodCodeMissingErr: Label '%1 Payment Method Code is not available';
        ExternalDocNoAlreadyPostedErr: Label 'Document with External Document No. %1 for Vendor %2 is already posted';
        ExternalDocNoIsBlankErr: Label 'External Document No. cannot be blank';
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        UserSetupMgmt: codeunit "User Setup Management";
        GLAccount: Record "G/L Account";
        DocumentNo: Code[20];
    begin
        MainDimensionCode := DimensionsManagement.GetMainHierarchyDimensionCode();
        MainDimensionNo := DimensionsManagement.GetMainHierarchyDimensionNo();
        DimensionsManagement.GetHierarchyDimensionsUsage(HierarchyDimensionsUsage);
        if MainDimensionNo <> 0 then
            HierarchyDimensionsUsage[MainDimensionNo] := false;
        ImportBufferError.Reset();
        ImportBufferError.DeleteAll();
        GenJnlImportBuffer.Reset();
        if GenJnlImportBuffer.FindSet() then
            repeat
                //Amount
                if FileImportSchema."Reverse Amount Sign" then
                    GenJnlImportBuffer.Amount := -GenJnlImportBuffer.Amount;
                //Document Type
                if FileImportSchema."Document Type Option" = FileImportSchema."Document Type Option"::Predefined then
                    GenJnlImportBuffer."Document Type" := FileImportSchema."Document Type";
                //Posting Date
                if GenJnlImportBuffer."Posting Date" = 0D then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, PostingDateIsBlankErr)
                else
                    if not UserSetupMgmt.IsPostingDateValid(GenJnlImportBuffer."Posting Date") then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, strsubstno(PostingDateIsNotValidErr, GenJnlImportBuffer."Posting Date"));
                if GenJnlImportBuffer."Document Date" = 0D then
                    GenJnlImportBuffer."Document Date" := GenJnlImportBuffer."Posting Date";
                //Account Type and Account No.
                FindAccountNo(GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Account Value", GenJnlImportBuffer."Account No.");
                if FileImportSchema."Default Account No." <> '' then begin
                    GenJnlImportBuffer."Account Type" := FileImportSchema."Gen. Jnl. Account Type";
                    GenJnlImportBuffer."Account No." := FileImportSchema."Default Account No.";
                end;
                if GenJnlImportBuffer."Account No." = '' then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(AccountNoBlankOrMissingErr, GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Account Value"))
                else
                    if FileImportSchema."Subs. G/L With Bank Acc." then
                        if GLAccount.Get(GenJnlImportBuffer."Account No.") then begin
                            GenJnlImportBuffer."Account Type" := GenJnlImportBuffer."Account Type"::"Bank Account";
                            GenJnlImportBuffer."Account No." := GLAccount."Linked Bank Account No.";
                        end;
                //Bal. Account Type and Bal. Account No.
                if FileImportSchema."Default Bal. Account No." <> '' then begin
                    GenJnlImportBuffer."Bal. Account Type" := FileImportSchema."Gen. Jnl. Bal. Account Type";
                    GenJnlImportBuffer."Bal. Account No." := FileImportSchema."Default Bal. Account No.";
                end else
                    if GenJnlImportBuffer."Bal. Account Value" <> '' then begin
                        FindAccountNo(GenJnlImportBuffer."Bal. Account Type", GenJnlImportBuffer."Bal. Account Value", GenJnlImportBuffer."Bal. Account No.");
                        if GenJnlImportBuffer."Bal. Account No." = '' then
                            AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(BalAccountNoBlankOrMissingErr, GenJnlImportBuffer."Bal. Account Type", GenJnlImportBuffer."Bal. Account Value"));
                    end;
                //Loan No.
                if GenJnlImportBuffer."Loan No." <> '' then begin
                    if not CheckLoanNo(GenJnlImportBuffer."Loan No.") then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(LoanNoNotFoundErr, GenJnlImportBuffer."Loan No."));
                    if GenJnlImportBuffer."Loan No." <> '' then
                        case FileImportSchema."Dimension Validation Rule" of
                            FileImportSchema."Dimension Validation Rule"::"All Loan Dimensions":
                                AssignLoanDimensions(GenJnlImportBuffer);
                            FileImportSchema."Dimension Validation Rule"::"Empty Dimensions":
                                AssignEmptyLoanDimensions(GenJnlImportBuffer);
                            FileImportSchema."Dimension Validation Rule"::"Loan & Exclude Imported Dimensions":
                                AssignNotImportedLoanDimensions(GenJnlImportBuffer);
                        end;
                end;
                //Dimensions
                AssignDimensions(GenJnlImportBuffer);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 1 Mandatory", 1, GenJnlImportBuffer."Global Dimension 1 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 2 Mandatory", 2, GenJnlImportBuffer."Global Dimension 2 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 3 Mandatory", 3, GenJnlImportBuffer."Shortcut Dimension 3 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 4 Mandatory", 4, GenJnlImportBuffer."Shortcut Dimension 4 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 5 Mandatory", 5, GenJnlImportBuffer."Shortcut Dimension 5 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 6 Mandatory", 6, GenJnlImportBuffer."Shortcut Dimension 6 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 7 Mandatory", 7, GenJnlImportBuffer."Shortcut Dimension 7 Code", ImportBufferError);
                ValidateDimension(GenJnlImportBuffer."Line No.", FileImportSchema."Dimension 8 Mandatory", 8, GenJnlImportBuffer."Shortcut Dimension 8 Code", ImportBufferError);
                //External Document No.
                if (GenJnlImportBuffer."Document Type" in [GenJnlImportBuffer."Document Type"::"Credit Memo", GenJnlImportBuffer."Document Type"::Invoice]) and (GenJnlImportBuffer."Account Type" = GenJnlImportBuffer."Account Type"::Vendor) then
                    if GenJnlImportBuffer."External Document No." = '' then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, ExternalDocNoIsBlankErr)
                    else
                        if not CheckVendorExternalDocumentNo(GenJnlImportBuffer) then
                            AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(ExternalDocNoAlreadyPostedErr, GenJnlImportBuffer."External Document No.", GenJnlImportBuffer."Account No."));
                //Posting Group
                if GenJnlImportBuffer."Posting Group" = '' then begin
                    GenJnlImportBuffer."Posting Group" := FileImportSchema."Posting Group";
                end;
                if GenJnlImportBuffer."Posting Group" <> '' then
                    if not CheckPostingGroup(GenJnlImportBuffer) then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(PostingGroupMissingErr, GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Posting Group"));
                //Reason Code
                if GenJnlImportBuffer."Reason Code" = '' then
                    GenJnlImportBuffer."Reason Code" := FileImportSchema."Reason Code";
                if GenJnlImportBuffer."Reason Code" <> '' then
                    if not CheckReasonCode(GenJnlImportBuffer) then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(ReasonCodeMissingErr, GenJnlImportBuffer."Reason Code"));
                //Payment Method Code
                if GenJnlImportBuffer."Payment Method Code" <> '' then
                    if not CheckPaymentMethodCode(GenJnlImportBuffer) then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(PaymentMethodCodeMissingErr, GenJnlImportBuffer."Payment Method Code"));
                //Bank Payment Type
                if GenJnlImportBuffer."Bank Payment Type" = GenJnlImportBuffer."Bank Payment Type"::" " then
                    GenJnlImportBuffer."Bank Payment Type" := FileImportSchema."Bank Payment Type";
                //Recurring Frequence
                if Format(GenJnlImportBuffer."Recurring Frequency") = '' then
                    GenJnlImportBuffer."Recurring Frequency" := FileImportSchema."Recurring Frequency";
                //Recurring Method
                if GenJnlImportBuffer."Recurring Method" = GenJnlImportBuffer."Recurring Method"::" " then
                    GenJnlImportBuffer."Recurring Method" := FileImportSchema."Recurring Method";
                //Document No.
                case FileImportSchema."Document No. Filling" of
                    FileImportSchema."Document No. Filling"::"Sames As Loan No.":
                        GenJnlImportBuffer."Document No." := GenJnlImportBuffer."Loan No.";
                    FileImportSchema."Document No. Filling"::"Defined In File":
                        if GenJnlImportBuffer."Document No." <> '' then
                            if FileImportSchema."Document No. Prefix" <> '' then
                                GenJnlImportBuffer."Document No." := FileImportSchema."Document No. Prefix" + GenJnlImportBuffer."Document No.";
                    FileImportSchema."Document No. Filling"::"From Schema No. Series":
                        begin
                            if not FileImportSchema."Use Single Document No." then
                                DocumentNo := NoSeriesMgmt.GetNextNo(FileImportSchema."Document No. Series", Today(), true)
                            else
                                if DocumentNo = '' then
                                    DocumentNo := NoSeriesMgmt.GetNextNo(FileImportSchema."Document No. Series", Today(), true);
                            GenJnlImportBuffer."Document No." := DocumentNo;
                        end;
                end;
                //----
                GenJnlImportBuffer.Modify();
            until GenJnlImportBuffer.Next() = 0;
    end;

    local procedure ValidateDimension(LineNo: Integer; Mandatory: Boolean; DimensionNo: Integer; DimensionValueCode: Code[20]; var ImportBufferError: Record lvngImportBufferError)
    var
        DimensionValue: Record "Dimension Value";
        MandatoryDimensionBlankErr: Label 'Mandatory Dimension %1 is blank';
        DimensionValueCodeMissingErr: Label 'Dimension Value Code %1 is missing';
        DimensionValueCodeBlockedErr: Label 'Dimension Value Code %1 is blocked';
    begin
        if Mandatory then
            if DimensionValueCode = '' then
                AddErrorLine(LineNo, ImportBufferError, StrSubstNo(MandatoryDimensionBlankErr, DimensionNo));
        if DimensionValueCode <> '' then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Global Dimension No.", DimensionNo);
            DimensionValue.SetRange(Code, DimensionValueCode);
            if not DimensionValue.FindFirst() then
                AddErrorLine(LineNo, ImportBufferError, StrSubstNo(DimensionValueCodeMissingErr, DimensionValueCode))
            else
                if DimensionValue.Blocked then
                    AddErrorLine(LineNo, ImportBufferError, StrSubstNo(DimensionValueCodeBlockedErr, DimensionValueCode));
        end;
    end;

    local procedure AssignDimensions(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        DimensionHierarchy: Record lvngDimensionHierarchy;
        DimensionCode: Code[20];
    begin
        SearchDimension(1, FileImportSchema."Dimension 1 Mapping Type", GenJnlImportBuffer."Global Dimension 1 Value", GenJnlImportBuffer."Global Dimension 1 Code");
        SearchDimension(2, FileImportSchema."Dimension 2 Mapping Type", GenJnlImportBuffer."Global Dimension 2 Value", GenJnlImportBuffer."Global Dimension 2 Code");
        SearchDimension(3, FileImportSchema."Dimension 3 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 3 Value", GenJnlImportBuffer."Shortcut Dimension 3 Code");
        SearchDimension(4, FileImportSchema."Dimension 4 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 4 Value", GenJnlImportBuffer."Shortcut Dimension 4 Code");
        SearchDimension(5, FileImportSchema."Dimension 5 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 5 Value", GenJnlImportBuffer."Shortcut Dimension 5 Code");
        SearchDimension(6, FileImportSchema."Dimension 6 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 6 Value", GenJnlImportBuffer."Shortcut Dimension 6 Code");
        SearchDimension(7, FileImportSchema."Dimension 7 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 7 Value", GenJnlImportBuffer."Shortcut Dimension 7 Code");
        SearchDimension(8, FileImportSchema."Dimension 8 Mapping Type", GenJnlImportBuffer."Shortcut Dimension 8 Value", GenJnlImportBuffer."Shortcut Dimension 8 Code");
        case MainDimensionNo of
            1:
                DimensionCode := GenJnlImportBuffer."Global Dimension 1 Code";
            2:
                DimensionCode := GenJnlImportBuffer."Global Dimension 2 Code";
            3:
                DimensionCode := GenJnlImportBuffer."Shortcut Dimension 3 Code";
            4:
                DimensionCode := GenJnlImportBuffer."Shortcut Dimension 4 Code";
        end;
        DimensionHierarchy.Reset();
        DimensionHierarchy.Ascending(false);
        DimensionHierarchy.SetFilter(Date, '..%1', GenJnlImportBuffer."Posting Date");
        DimensionHierarchy.SetRange(Code, DimensionCode);
        if DimensionHierarchy.FindFirst() then begin
            if HierarchyDimensionsUsage[1] then
                GenJnlImportBuffer."Global Dimension 1 Code" := DimensionHierarchy."Global Dimension 1 Code";
            if HierarchyDimensionsUsage[2] then
                GenJnlImportBuffer."Global Dimension 2 Code" := DimensionHierarchy."Global Dimension 2 Code";
            if HierarchyDimensionsUsage[3] then
                GenJnlImportBuffer."Shortcut Dimension 3 Code" := DimensionHierarchy."Shortcut Dimension 3 Code";
            if HierarchyDimensionsUsage[4] then
                GenJnlImportBuffer."Shortcut Dimension 4 Code" := DimensionHierarchy."Shortcut Dimension 4 Code";
            if HierarchyDimensionsUsage[5] then
                GenJnlImportBuffer."Business Unit Code" := DimensionHierarchy."Business Unit Code";
        end;
    end;

    local procedure SearchDimension(DimensionNo: Integer; DimensionMappingType: Enum lvngDimensionMappingType; DimensionValueText: Text; var DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        if (DimensionValueCode = '') and (DimensionValueText <> '') then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Global Dimension No.", DimensionNo);
            case DimensionMappingType of
                DimensionMappingType::Code:
                    DimensionValue.SetRange(Code, DimensionValueText);
                DimensionMappingType::Name:
                    DimensionValue.SetRange(Name, DimensionValueText);
                DimensionMappingType::"Search Name":
                    DimensionValue.SetFilter(Name, '@%1', DimensionValueText);
                DimensionMappingType::"Additional Code":
                    DimensionValue.SetRange("Additional Code", DimensionValueText);
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckVendorExternalDocumentNo(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        VendorMgt: codeunit "Vendor Mgt.";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        Clear(VendorMgt);
        VendorMgt.SetFilterForExternalDocNo(VendorLedgerEntry, GenJnlImportBuffer."Document Type", GenJnlImportBuffer."External Document No.", GenJnlImportBuffer."Account No.", GenJnlImportBuffer."Posting Date");
        exit(VendorLedgerEntry.IsEmpty());
    end;

    local procedure CheckPaymentMethodCode(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        PaymentMethod: record "Payment Method";
    begin
        exit(PaymentMethod.Get(GenJnlImportBuffer."Payment Method Code"));
    end;

    local procedure CheckReasonCode(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        ReasonCode: record "Reason Code";
    begin
        exit(ReasonCode.Get(GenJnlImportBuffer."Reason Code"));
    end;

    local procedure CheckPostingGroup(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        CustomerPostingGroup: Record "Customer Posting Group";
        FAPostingGroup: Record "FA Posting Group";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        case GenJnlImportBuffer."Account Type" of
            GenJnlImportBuffer."Account Type"::"Bank Account":
                if not BankAccountPostingGroup.Get(GenJnlImportBuffer."Posting Group") then
                    exit(false);
            GenJnlImportBuffer."Account Type"::"Fixed Asset":
                if not FAPostingGroup.Get(GenJnlImportBuffer."Posting Group") then
                    exit(false);
            GenJnlImportBuffer."Account Type"::"Vendor":
                if not VendorPostingGroup.Get(GenJnlImportBuffer."Posting Group") then
                    exit(false);
            GenJnlImportBuffer."Account Type"::"Customer":
                if not CustomerPostingGroup.Get(GenJnlImportBuffer."Posting Group") then
                    exit(false);
        end;
        exit(true);
    end;

    local procedure AssignLoanDimensions(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        Loan: Record lvngLoan;
    begin
        if Loan.Get(GenJnlImportBuffer."Loan No.") then begin
            GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
            GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
            GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
            GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
            GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
            GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
            GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
            GenJnlImportBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
            GenJnlImportBuffer."Business Unit Code" := Loan."Business Unit Code";
        end;
    end;

    local procedure AssignEmptyLoanDimensions(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        Loan: Record lvngLoan;
    begin
        if Loan.Get(GenJnlImportBuffer."Loan No.") then begin
            if GenJnlImportBuffer."Global Dimension 1 Value" = '' then
                GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
            if GenJnlImportBuffer."Global Dimension 2 Value" = '' then
                GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
            if GenJnlImportBuffer."Shortcut Dimension 3 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
            if GenJnlImportBuffer."Shortcut Dimension 4 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
            if GenJnlImportBuffer."Shortcut Dimension 5 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
            if GenJnlImportBuffer."Shortcut Dimension 6 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
            if GenJnlImportBuffer."Shortcut Dimension 7 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
            if GenJnlImportBuffer."Shortcut Dimension 8 Value" = '' then
                GenJnlImportBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
            if GenJnlImportBuffer."Business Unit Code" = '' then
                GenJnlImportBuffer."Business Unit Code" := Loan."Business Unit Code";
        end;
    end;

    local procedure AssignNotImportedLoanDimensions(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        Loan: Record lvngLoan;
    begin
        if Loan.Get(GenJnlImportBuffer."Loan No.") then begin
            TempFileImportJnlLine.Reset();
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 1 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 2 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 3 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 4 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 5 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 6 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 7 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
            TempFileImportJnlLine.SetRange("Import Field Type", TempFileImportJnlLine."Import Field Type"::"Dimension 8 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
        end;
    end;

    local procedure CheckLoanNo(var LoanNo: Code[20]): Boolean
    var
        Loan: Record lvngLoan;
    begin
        case FileImportSchema."Loan No. Validation Rule" of
            FileImportSchema."Loan No. Validation Rule"::"Blank If Not Found":
                if not Loan.Get(LoanNo) then begin
                    Clear(LoanNo);
                    exit(true);
                end;
            FileImportSchema."Loan No. Validation Rule"::Validate:
                if not Loan.Get(LoanNo) then
                    exit(false);
        end;
        exit(true);
    end;

    local procedure FindAccountNo(GenJnlAccountType: Enum lvngGenJnlAccountType; Value: Text; var AccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        ICPartner: Record "IC Partner";
    begin
        //Account Type and Account No.
        case FileImportSchema."Account Mapping Type" of
            FileImportSchema."Account Mapping Type"::Name:
                case GenJnlAccountType of
                    GenJnlAccountType::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetFilter(Name, '@%1', Value);
                            if GLAccount.FindFirst() then
                                AccountNo := GLAccount."No.";
                        end;
                    GenJnlAccountType::"Bank Account":
                        begin
                            BankAccount.Reset();
                            BankAccount.SetFilter(Name, '@%1', Value);
                            if BankAccount.FindFirst() then
                                AccountNo := BankAccount."No.";
                        end;
                    GenJnlAccountType::Customer:
                        begin
                            Customer.Reset();
                            Customer.SetFilter(Name, '@%1', Value);
                            if Customer.FindFirst() then
                                AccountNo := Customer."No.";
                        end;
                    GenJnlAccountType::Vendor:
                        begin
                            Vendor.Reset();
                            Vendor.SetFilter(Name, '@%1', Value);
                            if Vendor.FindFirst() then
                                AccountNo := Vendor."No.";
                        end;
                    GenJnlAccountType::"Fixed Asset":
                        begin
                            FixedAsset.Reset();
                            FixedAsset.SetFilter(Description, '@%1', Value);
                            if FixedAsset.FindFirst() then
                                AccountNo := FixedAsset."No.";
                        end;
                    GenJnlAccountType::"IC Partner":
                        begin
                            ICPartner.Reset();
                            ICPartner.SetFilter(Name, '@%1', Value);
                            if ICPartner.FindFirst() then
                                AccountNo := ICPartner.Code;
                        end;
                end;
            FileImportSchema."Account Mapping Type"::"No.":
                case GenJnlAccountType of
                    GenJnlAccountType::"G/L Account":
                        if GLAccount.Get(Value) and (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                            AccountNo := GLAccount."No.";
                    GenJnlAccountType::"Bank Account":
                        if BankAccount.Get(Value) then
                            AccountNo := BankAccount."No.";
                    GenJnlAccountType::Customer:
                        if Customer.Get(Value) then
                            AccountNo := Customer."No.";
                    GenJnlAccountType::Vendor:
                        if Vendor.Get(Value) then
                            AccountNo := Vendor."No.";
                    GenJnlAccountType::"Fixed Asset":
                        if FixedAsset.Get(Value) then
                            AccountNo := FixedAsset."No.";
                    GenJnlAccountType::"IC Partner":
                        if ICPartner.Get(Value) then
                            AccountNo := ICPartner.Code;
                end;
            FileImportSchema."Account Mapping Type"::"No. 2":
                case GenJnlAccountType of
                    GenJnlAccountType::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetRange("No. 2", Value);
                            if GLAccount.FindFirst() then
                                AccountNo := GLAccount."No.";
                        end;
                end;
            FileImportSchema."Account Mapping Type"::"Search Name":
                case GenJnlAccountType of
                    GenJnlAccountType::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            GLAccount.SetRange("Search Name", Value);
                            if GLAccount.FindFirst() then
                                AccountNo := GLAccount."No.";
                        end;
                    GenJnlAccountType::"Bank Account":
                        begin
                            BankAccount.Reset();
                            BankAccount.SetRange("Search Name", Value);
                            if BankAccount.FindFirst() then
                                AccountNo := BankAccount."No.";
                        end;
                    GenJnlAccountType::Customer:
                        begin
                            Customer.Reset();
                            Customer.SetRange("Search Name", Value);
                            if Customer.FindFirst() then
                                AccountNo := Customer."No.";
                        end;
                    GenJnlAccountType::Vendor:
                        begin
                            Vendor.Reset();
                            Vendor.SetRange("Search Name", Value);
                            if Vendor.FindFirst() then
                                AccountNo := Vendor."No.";
                        end;
                    GenJnlAccountType::"Fixed Asset":
                        begin
                            FixedAsset.Reset();
                            FixedAsset.SetFilter(Description, '@%1', Value);
                            if FixedAsset.FindFirst() then
                                AccountNo := FixedAsset."No.";
                        end;
                    GenJnlAccountType::"IC Partner":
                        begin
                            ICPartner.Reset();
                            ICPartner.SetFilter(Name, '@%1', Value);
                            if ICPartner.FindFirst() then
                                AccountNo := ICPartner.Code;
                        end;
                end;
        end;
    end;

    local procedure AddErrorLine(GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError; ErrorText: Text)
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

    local procedure AddErrorLine(LineNo: Integer; var ImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        ErrorLineNo: Integer;
    begin
        ImportBufferError.Reset();
        ImportBufferError.SetRange("Line No.", LineNo);
        if ImportBufferError.FindLast() then
            ErrorLineNo := ImportBufferError."Error No." + 100
        else
            ErrorLineNo := 100;
        Clear(ImportBufferError);
        ImportBufferError."Line No." := LineNo;
        ImportBufferError."Error No." := ErrorLineNo;
        ImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(ImportBufferError.Description));
        ImportBufferError.Insert();
    end;
}