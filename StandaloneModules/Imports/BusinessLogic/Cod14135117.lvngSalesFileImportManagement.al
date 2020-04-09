codeunit 14135117 lvngSalesFileImportManagement
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

    procedure CreateSalesLines(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; DocumentType: enum lvngLoanDocumentType; DocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        if DocumentType = DocumentType::"Credit Memo" then
            SalesHeader.Get(SalesHeader."Document Type"::"Credit Memo", DocumentNo)
        else
            SalesHeader.Get(SalesHeader."Document Type"::Invoice, DocumentNo);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            LineNo := SalesLine."Line No." + 100
        else
            LineNo := 100;
        GenJnlImportBuffer.Reset();
        GenJnlImportBuffer.FindSet();
        repeat
            Clear(SalesLine);
            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := LineNo;
            SalesLine.Insert(true);
            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", GenJnlImportBuffer."Account No.");
            if GenJnlImportBuffer.Description <> '' then
                SalesLine.Description := GenJnlImportBuffer.Description;
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", GenJnlImportBuffer.Amount);
            if GenJnlImportBuffer."Reason Code" <> '' then
                SalesLine.Validate(lvngReasonCode, GenJnlImportBuffer."Reason Code");
            SalesLine.lvngLoanNo := GenJnlImportBuffer."Loan No.";
            if GenJnlImportBuffer."Shortcut Dimension 4 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, GenJnlImportBuffer."Shortcut Dimension 4 Code", SalesLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 3 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, GenJnlImportBuffer."Shortcut Dimension 3 Code", SalesLine."Dimension Set ID");
            if GenJnlImportBuffer."Global Dimension 2 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, GenJnlImportBuffer."Global Dimension 2 Code", SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 2 Code" := GenJnlImportBuffer."Global Dimension 2 Code";
            if GenJnlImportBuffer."Global Dimension 1 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, GenJnlImportBuffer."Global Dimension 1 Code", SalesLine."Dimension Set ID");
            SalesLine."Shortcut Dimension 1 Code" := GenJnlImportBuffer."Global Dimension 1 Code";
            if GenJnlImportBuffer."Shortcut Dimension 5 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, GenJnlImportBuffer."Shortcut Dimension 5 Code", SalesLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 6 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, GenJnlImportBuffer."Shortcut Dimension 6 Code", SalesLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 7 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, GenJnlImportBuffer."Shortcut Dimension 7 Code", SalesLine."Dimension Set ID");
            if GenJnlImportBuffer."Shortcut Dimension 8 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, GenJnlImportBuffer."Shortcut Dimension 8 Code", SalesLine."Dimension Set ID");
            SalesLine.Modify();
            LineNo := LineNo + 100;
        until GenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError): Boolean
    begin
        FileImportSchema.Reset();
        FileImportSchema.SetRange("File Import Type", FileImportSchema."File Import Type"::"Sales Line");
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
            TempFileImportJnlLine.SetFilter("Sales Import Field Type", '<>%1', FileImportJnlLine."Sales Import Field Type"::Dummy);
            TempFileImportJnlLine.FindSet();
            repeat
                Value := TempCSVBuffer.GetValue(StartLine, TempFileImportJnlLine."Column No.");
                if Value <> '' then
                    case TempFileImportJnlLine."Sales Import Field Type" of
                        TempFileImportJnlLine."Sales Import Field Type"::"Account No.":
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
                        TempFileImportJnlLine."Sales Import Field Type"::Amount:
                            Evaluate(GenJnlImportBuffer.Amount, Value);
                        TempFileImportJnlLine."Sales Import Field Type"::Description:
                            GenJnlImportBuffer.Description := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer.Description));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 1 Code":
                            GenJnlImportBuffer."Global Dimension 1 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 1 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 2 Code":
                            GenJnlImportBuffer."Global Dimension 2 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Global Dimension 2 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 3 Code":
                            GenJnlImportBuffer."Shortcut Dimension 3 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 3 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 4 Code":
                            GenJnlImportBuffer."Shortcut Dimension 4 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 4 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 5 Code":
                            GenJnlImportBuffer."Shortcut Dimension 5 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 5 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 6 Code":
                            GenJnlImportBuffer."Shortcut Dimension 6 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 6 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 7 Code":
                            GenJnlImportBuffer."Shortcut Dimension 7 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 7 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Dimension 8 Code":
                            GenJnlImportBuffer."Shortcut Dimension 8 Value" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Shortcut Dimension 8 Value"));
                        TempFileImportJnlLine."Sales Import Field Type"::"Loan No.":
                            GenJnlImportBuffer."Loan No." := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Loan No."));
                        TempFileImportJnlLine."Sales Import Field Type"::"Reason Code":
                            GenJnlImportBuffer."Reason Code" := CopyStr(Value, 1, MaxStrLen(GenJnlImportBuffer."Reason Code"));
                    end;
            until TempFileImportJnlLine.Next() = 0;
            GenJnlImportBuffer.Modify();
            StartLine := StartLine + 1;
        until (StartLine > EndLine);
    end;

    local procedure ValidateEntries(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError)
    var
        AccountNoBlankOrMissingErr: Label 'Account %1 %2 is missing or blank';
        LoanNoNotFoundErr: Label 'Loan No. %1 not found';
        ReasonCodeMissingErr: Label '%1 Reason Code is not available';
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
                //Account Type and Account No.
                FindAccountNo(GenJnlImportBuffer."Account Value", GenJnlImportBuffer."Account No.");
                if FileImportSchema."Default Account No." <> '' then begin
                    GenJnlImportBuffer."Account Type" := FileImportSchema."Gen. Jnl. Account Type"::"G/L Account";
                    GenJnlImportBuffer."Account No." := FileImportSchema."Default Account No.";
                end;
                if GenJnlImportBuffer."Account No." = '' then
                    AddErrorLine(GenJnlImportBuffer, ImportBufferError, StrSubstNo(AccountNoBlankOrMissingErr, GenJnlImportBuffer."Account Type", GenJnlImportBuffer."Account Value"));
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
                        AddErrorLine(GenJnlImportBuffer, ImportBufferError, strsubstno(ReasonCodeMissingErr, GenJnlImportBuffer."Reason Code"));
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
                    DimensionValue.SetRange(lvngAdditionalCode, DimensionValueText);
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckReasonCode(GenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        ReasonCode: Record "Reason Code";
    begin
        exit(ReasonCode.Get(GenJnlImportBuffer."Reason Code"));
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
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 1 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 2 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 3 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 4 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 5 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 6 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 7 Code");
            if TempFileImportJnlLine.IsEmpty() then
                GenJnlImportBuffer."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
            TempFileImportJnlLine.SetRange("Sales Import Field Type", TempFileImportJnlLine."Sales Import Field Type"::"Dimension 8 Code");
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

    local procedure FindAccountNo(Value: Text; var AccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
    begin
        //Account Type and Account No.
        case FileImportSchema."Account Mapping Type" of
            FileImportSchema."Account Mapping Type"::Name:
                begin
                    GLAccount.Reset();
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetFilter(Name, '@%1', Value);
                    if GLAccount.FindFirst() then
                        AccountNo := GLAccount."No.";
                end;
            FileImportSchema."Account Mapping Type"::"No.":
                if GLAccount.Get(Value) and (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                    AccountNo := GLAccount."No.";
            FileImportSchema."Account Mapping Type"::"No. 2":
                begin
                    GLAccount.Reset();
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("No. 2", Value);
                    if GLAccount.FindFirst() then
                        AccountNo := GLAccount."No.";
                end;
            FileImportSchema."Account Mapping Type"::"Search Name":
                begin
                    GLAccount.Reset();
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.SetRange("Search Name", Value);
                    if GLAccount.FindFirst() then
                        AccountNo := GLAccount."No.";
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