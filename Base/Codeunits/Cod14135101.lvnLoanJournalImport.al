codeunit 14135101 "lvnLoanJournalImport"
{
    var
        BooleanStringWrongFormatErr: Label 'Boolean Value %1 has wrong format. Line No. %2, Field %3. Possible Values %4 %5';
        BooleanStringNoFormatDefinedErr: Label 'Boolean format is not defined for field %1';
        DateStringWrongFormatErr: Label 'Date Value %1 has wrong format. Line No. %2, Field %3';
        DecimalStringWrongFormatErr: Label 'Decimal Value %1 has wrong format. Line No. %2, Field %3';
        IntegerStringWrongFormatErr: Label 'Integer Value %1 has wrong format. Line No. %2, Field %3';

        TempCSVBuffer: Record "CSV Buffer" temporary;
        TempLoanImportSchema: Record lvnLoanImportSchema temporary;
        LoanJournalBatch: Record lvnLoanJournalBatch;
        OpenFileLbl: Label 'Open File for Import';
        ReadingToStreamErr: Label 'Error reading file to stream';
        PostProcessingMgmt: Codeunit lvnPostProcessingMgmt;
        ImportStream: InStream;
        FileName: Text;

    procedure ReadCSVStream(lvnLoanJournalBatchCode: Code[20]; lvnImportSchema: Record lvnLoanImportSchema)
    var
        TabChar: Char;
    begin
        TabChar := 9;
        TempLoanImportSchema := lvnImportSchema;
        if TempLoanImportSchema."Field Separator Character" = '<TAB>' then
            TempLoanImportSchema."Field Separator Character" := Format(TabChar);
        LoanJournalBatch.Get(lvnLoanJournalBatchCode);
        if UploadIntoStream(OpenFileLbl, '', '', FileName, ImportStream) then begin
            TempCSVBuffer.LoadDataFromStream(ImportStream, TempLoanImportSchema."Field Separator Character");
            TempCSVBuffer.ResetFilters();
            TempCSVBuffer.SetRange("Line No.", 0, TempLoanImportSchema."Skip Lines");
            TempCSVBuffer.DeleteAll();
            ProcessImportCSVBuffer();
            Clear(PostProcessingMgmt);
            PostProcessingMgmt.PostProcessBatch(lvnLoanJournalBatchCode);
        end else
            Error(ReadingToStreamErr);
    end;

    procedure ReadCSVStream(lvnLoanJournalBatchCode: Code[20]; lvnImportSchema: Record lvnLoanImportSchema; ContainerName: Text; FileName: Text)
    var
        StorageMgmt: Codeunit lvnAzureBlobManagement;
        TabChar: Char;
    begin
        TabChar := 9;
        TempLoanImportSchema := lvnImportSchema;
        if TempLoanImportSchema."Field Separator Character" = '<TAB>' then
            TempLoanImportSchema."Field Separator Character" := Format(TabChar);
        LoanJournalBatch.Get(lvnLoanJournalBatchCode);
        StorageMgmt.DownloadFile(ContainerName, FileName, ImportStream);
        TempCSVBuffer.LoadDataFromStream(ImportStream, TempLoanImportSchema."Field Separator Character");
        TempCSVBuffer.ResetFilters();
        TempCSVBuffer.SetRange("Line No.", 0, TempLoanImportSchema."Skip Lines");
        TempCSVBuffer.DeleteAll();
        ProcessImportCSVBuffer();
        Clear(PostProcessingMgmt);
        PostProcessingMgmt.PostProcessBatch(lvnLoanJournalBatchCode);
    end;

    procedure ProcessImportCSVBuffer()
    var
        LoanImportSchemaLine: Record lvnLoanImportSchemaLine;
        TempLoanImportSchemaLine: Record lvnLoanImportSchemaLine temporary;
        LoanJournalLine: Record lvnLoanJournalLine;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        StartLine: Integer;
        EndLine: Integer;
        ColumnNo: Integer;
    begin
        TempCSVBuffer.ResetFilters();
        TempCSVBuffer.FindFirst();
        StartLine := TempCSVBuffer."Line No.";
        EndLine := TempCSVBuffer.GetNumberOfLines();
        LoanImportSchemaLine.Reset();
        LoanImportSchemaLine.SetRange(Code, TempLoanImportSchema.Code);
        LoanImportSchemaLine.FindSet();
        repeat
            TempLoanImportSchemaLine := LoanImportSchemaLine;
            TempLoanImportSchemaLine.Insert();
        until LoanImportSchemaLine.next = 0;
        TempCSVBuffer.ResetFilters();
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code", LoanJournalBatch.Code);
        LoanJournalLine.DeleteAll(true);
        repeat
            Clear(LoanJournalLine);
            LoanJournalLine."Loan Journal Batch Code" := LoanJournalBatch.Code;
            LoanJournalLine."Line No." := StartLine;
            LoanJournalLine.Insert(true);
            RecordReference.GetTable(LoanJournalLine);
            TempLoanImportSchemaLine.Reset();
            TempLoanImportSchemaLine.FindSet();
            ColumnNo := 0;
            repeat
                ColumnNo := ColumnNo + 1;
                case TempLoanImportSchemaLine."Field Type" of
                    TempLoanImportSchemaLine."Field Type"::Table:
                        begin
                            FieldReference := RecordReference.Field(TempLoanImportSchemaLine."Field No.");
                            AssignValueToJournalField(StartLine, TempCSVBuffer.GetValue(StartLine, ColumnNo), TempLoanImportSchemaLine, FieldReference);
                        end;
                    TempLoanImportSchemaLine."Field Type"::Variable:
                        AssignValueToVariableField(TempCSVBuffer.GetValue(StartLine, ColumnNo), LoanJournalLine, TempLoanImportSchemaLine);
                end;
            until TempLoanImportSchemaLine.Next() = 0;
            RecordReference.Modify(true);
            RecordReference.SetTable(LoanJournalLine);
            RecordReference.Close();
            if LoanJournalLine."Processing Schema Code" = '' then
                LoanJournalLine."Processing Schema Code" := LoanJournalBatch."Def. Processing Schema Code";
            if LoanJournalLine."Reason Code" = '' then
                LoanJournalLine."Reason Code" := LoanJournalBatch."Default Reason Code";
            if LoanJournalLine."Title Customer No." = '' then
                LoanJournalLine."Title Customer No." := LoanJournalBatch."Default Title Customer No.";
            LoanJournalLine.Modify();
            StartLine := StartLine + 1;
        until (StartLine > EndLine);
    end;

    procedure AssignValueToVariableField(Value: Text; LoanJournalLine: Record lvnLoanJournalLine; LoanImportSchemaLine: Record lvnLoanImportSchemaLine)
    var
        LoanJournalValue: Record lvnLoanJournalValue;
        StringConversionManagement: Codeunit StringConversionManagement;
        BooleanField: Boolean;
        DateField: Date;
        IntegerField: Integer;
        DecimalField: Decimal;
        LineNo: Integer;
        UpperValue: Text;
    begin
        LineNo := LoanJournalLine."Line No.";
        if LoanImportSchemaLine."Field Size" > 0 then begin
            if LoanImportSchemaLine.Trimming = LoanImportSchemaLine.Trimming::Spaces then
                Value := DelChr(Value, '<>', ' ');
            if LoanImportSchemaLine.Trimming = LoanImportSchemaLine.Trimming::"To Size" then begin
                Value := DelChr(Value, '<>', ' ');
                Value := CopyStr(Value, 1, LoanImportSchemaLine."Field Size");
            end;
        end;
        if (LoanImportSchemaLine."Padding Character" <> '') and (LoanImportSchemaLine."Field Size" > 0) then begin
            if LoanImportSchemaLine."Padding Side" = LoanImportSchemaLine."Padding Side"::Left then
                Value := StringConversionManagement.GetPaddedString(Value, LoanImportSchemaLine."Field Size", LoanImportSchemaLine."Padding Character", 0);
            if LoanImportSchemaLine."Padding Side" = LoanImportSchemaLine."Padding Side"::Right then
                Value := StringConversionManagement.GetPaddedString(Value, LoanImportSchemaLine."Field Size", LoanImportSchemaLine."Padding Character", 1);
        end;
        case LoanImportSchemaLine."Value Type" of
            LoanImportSchemaLine."Value Type"::Boolean:
                begin
                    Clear(BooleanField);
                    case LoanImportSchemaLine."Boolean Format" of
                        LoanImportSchemaLine."Boolean Format"::"1/0":
                            begin
                                if (Value <> '1') and (Value <> '0') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 1, 0);
                                BooleanField := Value = '1';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"False If Blank":
                            BooleanField := Value <> '';
                        LoanImportSchemaLine."Boolean Format"::Undefined:
                            Error(BooleanStringNoFormatDefinedErr, LoanImportSchemaLine."Field Name");
                        LoanImportSchemaLine."Boolean Format"::"True/False":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'FALSE') and (UpperValue <> 'TRUE') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'True', 'False');
                                BooleanField := UpperValue = 'TRUE';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"Yes/No":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'NO') and (UpperValue <> 'YES') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'Yes', 'No');
                                BooleanField := UpperValue = 'YES';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"Y/N":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'N') and (UpperValue <> 'Y') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'Y', 'N');
                                BooleanField := UpperValue = 'Y';
                            end;
                    end;
                    Clear(LoanJournalValue);
                    LoanJournalValue.Init();
                    LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                    LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                    LoanJournalValue."Field No." := LoanImportSchemaLine."Field No.";
                    if BooleanField then
                        LoanJournalValue."Field Value" := 'True'
                    else
                        LoanJournalValue."Field Value" := 'False';
                    LoanJournalValue.Insert(true);
                end;
            LoanImportSchemaLine."Value Type"::Date:
                begin
                    Clear(DateField);
                    if not Evaluate(DateField, Value) then
                        Error(DateStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    Clear(LoanJournalValue);
                    LoanJournalValue.Init();
                    LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                    LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                    LoanJournalValue."Field No." := LoanImportSchemaLine."Field No.";
                    LoanJournalValue."Field Value" := Format(DateField);
                    LoanJournalValue.Insert(true);
                end;
            LoanImportSchemaLine."Value Type"::Decimal:
                begin
                    Clear(DecimalField);
                    if not Evaluate(DecimalField, Value) then
                        Error(DecimalStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    case LoanImportSchemaLine."Numeric Format" of
                        LoanImportSchemaLine."Numeric Format"::Negative:
                            DecimalField := -Abs(DecimalField);
                        LoanImportSchemaLine."Numeric Format"::Positive:
                            DecimalField := Abs(DecimalField);
                        LoanImportSchemaLine."Numeric Format"::"Reverse Sign":
                            DecimalField := -DecimalField;
                    end;
                    Clear(LoanJournalValue);
                    LoanJournalValue.Init();
                    LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                    LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                    LoanJournalValue."Field No." := LoanImportSchemaLine."Field No.";
                    LoanJournalValue."Field Value" := Format(DecimalField);
                    LoanJournalValue.Insert(true);
                end;
            LoanImportSchemaLine."Value Type"::Integer:
                begin
                    Clear(IntegerField);
                    if not Evaluate(IntegerField, Value) then
                        Error(IntegerStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    case LoanImportSchemaLine."Numeric Format" of
                        LoanImportSchemaLine."Numeric Format"::Negative:
                            IntegerField := -Abs(IntegerField);
                        LoanImportSchemaLine."Numeric Format"::Positive:
                            IntegerField := Abs(IntegerField);
                        LoanImportSchemaLine."Numeric Format"::"Reverse Sign":
                            IntegerField := -IntegerField;
                    end;
                    Clear(LoanJournalValue);
                    LoanJournalValue.Init();
                    LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                    LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                    LoanJournalValue."Field No." := LoanImportSchemaLine."Field No.";
                    LoanJournalValue."Field Value" := Format(IntegerField);
                    LoanJournalValue.Insert(true);
                end;
            LoanImportSchemaLine."Value Type"::Text:
                begin
                    Clear(LoanJournalValue);
                    LoanJournalValue.Init();
                    LoanJournalValue."Loan Journal Batch Code" := LoanJournalLine."Loan Journal Batch Code";
                    LoanJournalValue."Line No." := LoanJournalLine."Line No.";
                    LoanJournalValue."Field No." := LoanImportSchemaLine."Field No.";
                    LoanJournalValue."Field Value" := CopyStr(Value, 1, 250);
                    LoanJournalValue.Insert(true);
                end;
        end;
    end;

    procedure AssignValueToJournalField(LineNo: Integer; Value: Text; LoanImportSchemaLine: Record lvnLoanImportSchemaLine; var FieldReference: FieldRef)
    var
        StringConversionManagement: Codeunit StringConversionManagement;
        BooleanField: Boolean;
        DateField: Date;
        IntegerField: Integer;
        DecimalField: Decimal;
        UpperValue: Text;
    begin
        if LoanImportSchemaLine."Field Size" > 0 then begin
            if LoanImportSchemaLine.Trimming = LoanImportSchemaLine.Trimming::Spaces then begin
                Value := DelChr(Value, '<>', ' ');
            end;
            if LoanImportSchemaLine.Trimming = LoanImportSchemaLine.Trimming::"To Size" then begin
                Value := DelChr(Value, '<>', ' ');
                Value := CopyStr(Value, 1, LoanImportSchemaLine."Field Size");
            end;
        end;
        if (LoanImportSchemaLine."Padding Character" <> '') and (LoanImportSchemaLine."Field Size" > 0) then begin
            if LoanImportSchemaLine."Padding Side" = LoanImportSchemaLine."Padding Side"::Left then
                Value := StringConversionManagement.GetPaddedString(Value, LoanImportSchemaLine."Field Size", LoanImportSchemaLine."Padding Character", 0);
            if LoanImportSchemaLine."Padding Side" = LoanImportSchemaLine."Padding Side"::Right then
                Value := StringConversionManagement.GetPaddedString(Value, LoanImportSchemaLine."Field Size", LoanImportSchemaLine."Padding Character", 1);
        end;

        case LoanImportSchemaLine."Value Type" of
            LoanImportSchemaLine."Value Type"::Boolean:
                begin
                    Clear(BooleanField);
                    case LoanImportSchemaLine."Boolean Format" of
                        LoanImportSchemaLine."Boolean Format"::"1/0":
                            begin
                                if (Value <> '1') and (Value <> '0') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 1, 0);
                                BooleanField := Value = '1';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"False If Blank":
                            BooleanField := Value <> '';
                        LoanImportSchemaLine."Boolean Format"::Undefined:
                            Error(BooleanStringNoFormatDefinedErr, LoanImportSchemaLine."Field Name");
                        LoanImportSchemaLine."Boolean Format"::"True/False":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'FALSE') and (UpperValue <> 'TRUE') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'True', 'False');
                                BooleanField := UpperValue = 'TRUE';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"Yes/No":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'NO') and (UpperValue <> 'YES') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'Yes', 'No');
                                BooleanField := UpperValue = 'YES';
                            end;
                        LoanImportSchemaLine."Boolean Format"::"Y/N":
                            begin
                                UpperValue := UpperCase(Value);
                                if (UpperValue <> 'N') and (UpperValue <> 'Y') then
                                    Error(BooleanStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name", 'Y', 'N');
                                BooleanField := UpperValue = 'Y';
                            end;
                    end;
                    FieldReference.Validate(BooleanField);
                end;
            LoanImportSchemaLine."Value Type"::Date:
                begin
                    Clear(DateField);
                    if not Evaluate(DateField, Value) then
                        Error(DateStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    FieldReference.Validate(DateField);
                end;
            LoanImportSchemaLine."Value Type"::Decimal:
                begin
                    Clear(DecimalField);
                    if not Evaluate(DecimalField, Value) then
                        Error(DecimalStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    case LoanImportSchemaLine."Numeric Format" of
                        LoanImportSchemaLine."Numeric Format"::Negative:
                            DecimalField := -Abs(DecimalField);
                        LoanImportSchemaLine."Numeric Format"::Positive:
                            DecimalField := Abs(DecimalField);
                        LoanImportSchemaLine."Numeric Format"::"Reverse Sign":
                            DecimalField := -DecimalField;
                    end;
                    FieldReference.Validate(DecimalField);
                end;
            LoanImportSchemaLine."Value Type"::Integer:
                begin
                    Clear(IntegerField);
                    if not Evaluate(IntegerField, Value) then
                        Error(IntegerStringWrongFormatErr, Value, LineNo, LoanImportSchemaLine."Field Name");
                    case LoanImportSchemaLine."Numeric Format" of
                        LoanImportSchemaLine."Numeric Format"::Negative:
                            IntegerField := -Abs(IntegerField);
                        LoanImportSchemaLine."Numeric Format"::Positive:
                            IntegerField := Abs(IntegerField);
                        LoanImportSchemaLine."Numeric Format"::"Reverse Sign":
                            IntegerField := -IntegerField;
                    end;
                    FieldReference.Validate(IntegerField);
                end;
            LoanImportSchemaLine."Value Type"::Text:
                begin
                    FieldReference.Validate(CopyStr(Value, 1, FieldReference.Length()));
                end;
        end;
    end;
}