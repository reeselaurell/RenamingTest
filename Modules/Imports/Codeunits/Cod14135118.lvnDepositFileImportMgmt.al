codeunit 14135118 "lvnDepositFileImportMgmt"
{
    var
        FileImportSchema: Record lvnFileImportSchema;
        FileImportJnlLine: Record lvnFileImportJnlLine;
        TempFileImportJnlLine: Record lvnFileImportJnlLine temporary;
        TempCSVBuffer: Record "CSV Buffer" temporary;
        DimensionsManagement: Codeunit lvnDimensionsManagement;
        MainDimensionCode: Code[20];
        HierarchyDimensionsUsage: array[5] of Boolean;
        MainDimensionNo: Integer;
        ImportStream: InStream;
        FileName: Text;
        ImportToStream: Boolean;
        OpenFileLbl: Label 'Open File for Import';
        ReadingToStreamErr: Label 'Error reading file to stream';

    procedure CreateJournalLines(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer; DepositNo: Code[20])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        DepositHeader: Record "Deposit Header";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        DepositHeader.Get(DepositNo);
        GenJnlTemplate.Get(DepositHeader."Journal Template Name");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", DepositHeader."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", DepositHeader."Journal Batch Name");
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 100
        else
            LineNo := 100;
        GenJnlImportBuffer.Reset();
        GenJnlImportBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", DepositHeader."Journal Template Name");
            GenJnlLine.Validate("Journal Batch Name", DepositHeader."Journal Batch Name");
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.Insert();
            GenJnlLine."Account Type" := GenJnlImportBuffer."Account Type";
            GenJnlLine.Validate("Account No.", GenJnlImportBuffer."Account No.");
            if GenJnlImportBuffer.Description <> '' then
                GenJnlLine.Description := GenJnlImportBuffer.Description;
            GenJnlLine.Validate("Document Type", GenJnlImportBuffer."Document Type");
            GenJnlLine.Validate("Document No.", GenJnlImportBuffer."Document No.");
            if GenJnlImportBuffer."Posting Date" <> 0D then
                GenJnlLine.Validate("Posting Date", GenJnlImportBuffer."Posting Date")
            else
                GenJnlLine.Validate("Posting Date", DepositHeader."Posting Date");
            if GenJnlImportBuffer."Document Date" <> 0D then
                GenJnlLine.Validate("Document Date", GenJnlImportBuffer."Document Date")
            else
                GenJnlLine.Validate("Posting Date", DepositHeader."Posting Date");
            GenJnlLine.Validate(Amount, GenJnlImportBuffer.Amount);
            GenJnlLine."Applies-to Doc. Type" := GenJnlImportBuffer."Applies-To Doc. Type";
            GenJnlLine."Applies-to Doc. No." := GenJnlImportBuffer."Applies-To Doc. No.";
            GenJnlLine.lvnLoanNo := GenJnlImportBuffer."Loan No.";
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

    procedure ManualFileImport(
        var GenJnlImportBuffer: Record lvnGenJnlImportBuffer;
        var ImportBufferError: Record lvnImportBufferError): Boolean
    begin
        FileImportSchema.Reset();
        FileImportSchema.SetRange("File Import Type", FileImportSchema."File Import Type"::"Deposit Lines");
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
        FieldSeparatorLbl: Label '<TAB>';
    begin
        TabChar := 9;
        if FileImportSchema."Field Separator" = FieldSeparatorLbl then
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

    local procedure ProcessImportCSVBuffer(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer)
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
            TempFileImportJnlLine.SetFilter("Deposit Import Field Type", '<>%1', FileImportJnlLine."Deposit Import Field Type"::Dummy);
            TempFileImportJnlLine.FindSet();
            repeat
                Value := TempCSVBuffer.GetValue(StartLine, TempFileImportJnlLine."Column No.");
                if Value <> '' then
                    case TempFileImportJnlLine."Deposit Import Field Type" of
                        TempFileImportJnlLine."Deposit Import Field Type"::"Account No.":
                            begin
                                GenJnlImportBuffer."Account Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Account Value"));
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
                        TempFileImportJnlLine."Deposit Import Field Type"::"Account Type":
                            Evaluate(GenJnlImportBuffer."Account Type", Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::Amount:
                            Evaluate(GenJnlImportBuffer.Amount, Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::"Applies-To Doc. No":
                            GenJnlImportBuffer."Applies-To Doc. No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Applies-To Doc. No."));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Applies-To Doc. Type":
                            Evaluate(GenJnlImportBuffer."Applies-To Doc. Type", Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::"Business Unit Code":
                            GenJnlImportBuffer."Business Unit Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Business Unit Code"));
                        TempFileImportJnlLine."Deposit Import Field Type"::Description:
                            GenJnlImportBuffer.Description := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer.Description));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 1 Code":
                            GenJnlImportBuffer."Global Dimension 1 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 1 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 2 Code":
                            GenJnlImportBuffer."Global Dimension 2 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 2 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 3 Code":
                            GenJnlImportBuffer."Shortcut Dimension 3 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 3 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 4 Code":
                            GenJnlImportBuffer."Shortcut Dimension 4 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 4 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 5 Code":
                            GenJnlImportBuffer."Shortcut Dimension 5 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 5 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 6 Code":
                            GenJnlImportBuffer."Shortcut Dimension 6 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 6 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 7 Code":
                            GenJnlImportBuffer."Shortcut Dimension 7 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 7 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 8 Code":
                            GenJnlImportBuffer."Shortcut Dimension 8 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 8 Value"));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Document Date":
                            Evaluate(GenJnlImportBuffer."Document Date", Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::"Document No.":
                            GenJnlImportBuffer."Document No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Document No."));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Document Type":
                            Evaluate(GenJnlImportBuffer."Document Type", Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::"Loan No.":
                            GenJnlImportBuffer."Loan No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Loan No."));
                        TempFileImportJnlLine."Deposit Import Field Type"::"Posting Date":
                            Evaluate(GenJnlImportBuffer."Posting Date", Value);
                        TempFileImportJnlLine."Deposit Import Field Type"::"Reason Code":
                            GenJnlImportBuffer."Reason Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Reason Code"));
                    end;
            until TempFileImportJnlLine.Next() = 0;
            GenJnlImportBuffer.Modify();
            StartLine := StartLine + 1;
        until (StartLine > EndLine);
    end;

    local procedure ValidateEntries(
        var GenJnlImportBuffer: Record lvnGenJnlImportBuffer;
        var ImportBufferError: Record lvnImportBufferError)
    var
        GLAccount: Record "G/L Account";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        UserSetupMgmt: Codeunit "User Setup Management";
        DocumentNo: Code[20];
        PostingDateIsNotValidErr: Label '%1 Posting Date is not within allowed date ranges', Comment = '%1 = Posting Date';
        AccountNoBlankOrMissingErr: Label 'Account %1 %2 is missing or blank', Comment = '%1 = Account Type; %2 = Account Value';
        LoanNoNotFoundErr: Label 'Loan No. %1 not found', Comment = '%1 = Loan No.';
        ReasonCodeMissingErr: Label '%1 Reason Code is not available', Comment = '%1 = Reason Code';

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
                if GenJnlImportBuffer."Posting Date" <> 0D then
                    if not UserSetupMgmt.IsPostingDateValid(GenJnlImportBuffer."Posting Date") then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(PostingDateIsNotValidErr, GenJnlImportBuffer."Posting Date"));
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
                            GenJnlImportBuffer."Account No." := GLAccount.lvnLinkedBankAccountNo;
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
                //Reason Code
                if GenJnlImportBuffer."Reason Code" = '' then
                    GenJnlImportBuffer."Reason Code" := FileImportSchema."Reason Code";
                if GenJnlImportBuffer."Reason Code" <> '' then
                    if not CheckReasonCode(GenJnlImportBuffer) then
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(ReasonCodeMissingErr, GenJnlImportBuffer."Reason Code"));
                //Document No.
                if FileImportSchema."Document No. Filling" = FileImportSchema."Document No. Filling"::"Sames As Loan No." then
                    GenJnlImportBuffer."Document No." := GenJnlImportBuffer."Loan No.";
                if FileImportSchema."Document No. Filling" = FileImportSchema."Document No. Filling"::"Defined In File" then
                    if GenJnlImportBuffer."Document No." <> '' then
                        if FileImportSchema."Document No. Prefix" <> '' then
                            GenJnlImportBuffer."Document No." := FileImportSchema."Document No. Prefix" + GenJnlImportBuffer."Document No.";

                if FileImportSchema."Document No. Filling" = FileImportSchema."Document No. Filling"::"From Schema No. Series" then begin
                    if not FileImportSchema."Use Single Document No." then
                        DocumentNo := NoSeriesMgmt.GetNextNo(FileImportSchema."Document No. Series", Today, true)
                    else
                        if DocumentNo = '' then
                            DocumentNo := NoSeriesMgmt.GetNextNo(FileImportSchema."Document No. Series", Today, true);
                    GenJnlImportBuffer."Document No." := DocumentNo;
                end;
                //----
                GenJnlImportBuffer.Modify();
            until GenJnlImportBuffer.Next() = 0;
    end;

    local procedure ValidateDimension(
        LineNo: Integer;
        Mandatory: Boolean;
        DimensionNo: Integer;
        DimensionValueCode: Code[20];
        var ImportBufferError: Record lvnImportBufferError)
    var
        DimensionValue: Record "Dimension Value";
        MandatoryDimensionBlankErr: Label 'Mandatory Dimension %1 is blank', Comment = ' %1 = Dimension No.';
        DimensionValueCodeMissingErr: Label 'Dimension Value Code %1 is missing', Comment = '%1 = Dimension Value Code';
        DimensionValueCodeBlockedErr: Label 'Dimension Value Code %1 is blocked', Comment = '%1 = Dimension Value Code';
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

    local procedure AssignDimensions(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer)
    var
        DimensionHierarchy: Record lvnDimensionHierarchy;
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

    local procedure SearchDimension(
        DimensionNo: Integer;
        DimensionMappingType: Enum lvnDimensionMappingType;
        DimensionValueText: Text;
        var DimensionValueCode: Code[20])
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
                    DimensionValue.SetRange(lvnAdditionalCode, DimensionValueText);
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckReasonCode(GenJnlImportBuffer: Record lvnGenJnlImportBuffer): Boolean
    var
        ReasonCode: Record "Reason Code";
    begin
        exit(ReasonCode.Get(GenJnlImportBuffer."Reason Code"));
    end;

    local procedure AssignLoanDimensions(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer)
    var
        Loan: Record lvnLoan;
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

    local procedure AssignEmptyLoanDimensions(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer)
    var
        Loan: Record lvnLoan;
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

    local procedure AssignNotImportedLoanDimensions(var GenJnlImportBuffer: Record lvnGenJnlImportBuffer)
    var
        Loan: Record lvnLoan;
    begin
        if Loan.Get(GenJnlImportBuffer."Loan No.") then begin
            TempFileImportJnlLine.Reset();
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 1 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 2 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 3 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 4 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 5 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 6 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 7 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
            TempFileImportJnlLine.SetRange("Deposit Import Field Type", TempFileImportJnlLine."Deposit Import Field Type"::"Dimension 8 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
        end;
    end;

    local procedure CheckLoanNo(var LoanNo: Code[20]): Boolean
    var
        Loan: Record lvnLoan;
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

    local procedure FindAccountNo(
        GenJnlAccountType: Enum lvnGenJnlAccountType;
        Value: Text;
        var AccountNo: Code[20])
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
                            ICPartner.SetFilter(Name, '@' + Value);
                            if ICPartner.FindFirst() then
                                AccountNo := ICPartner.Code;
                        end;
                end;
        end;
    end;

    local procedure AddErrorLine(
        GenJnlImportBuffer: Record lvnGenJnlImportBuffer;
        var ImportBufferError: Record lvnImportBufferError;
        ErrorText: Text)
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

    local procedure AddErrorLine(
        LineNo: Integer;
        var ImportBufferError: Record lvnImportBufferError;
        ErrorText: Text)
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