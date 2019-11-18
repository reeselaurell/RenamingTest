codeunit 14135101 "lvngLoanJournalImport"
{
    var
        CSVBufferTemp: Record "CSV Buffer" temporary;
        lvngLoanImportSchemaTemp: Record lvngLoanImportSchema temporary;
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngOpenFileLabel: Label 'Open File for Import';
        lvngErrorReadingToStreamLabel: Label 'Error reading file to stream';
        lvngPostProcessingMgmt: Codeunit lvngPostProcessingMgmt;
        lvngImportStream: InStream;
        lvngFileName: Text;
        lvngImportToStream: Boolean;

    procedure ReadCSVStream(lvngLoanJournalBatchCode: Code[20]; lvngImportSchema: Record lvngLoanImportSchema)
    var
        TabChar: Char;
    begin
        TabChar := 9;
        lvngLoanImportSchemaTemp := lvngImportSchema;
        if lvngLoanImportSchemaTemp."Field Separator Character" = '<TAB>' then
            lvngLoanImportSchemaTemp."Field Separator Character" := Format(TabChar);
        lvngLoanJournalBatch.Get(lvngLoanJournalBatchCode);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngLoanImportSchemaTemp."Field Separator Character");
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngLoanImportSchemaTemp."Skip Lines");
            CSVBufferTemp.DeleteAll();
            ProcessImportCSVBuffer();
            Clear(lvngPostProcessingMgmt);
            lvngPostProcessingMgmt.PostProcessBatch(lvngLoanJournalBatchCode);
        end else begin
            Error(lvngErrorReadingToStreamLabel);
        end;
    end;

    procedure ProcessImportCSVBuffer()
    var
        lvngLoanImportSchemaLine: Record lvngLoanImportSchemaLine;
        lvngLoanImportSchemaLineTemp: Record lvngLoanImportSchemaLine temporary;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngRecRef: RecordRef;
        lvngFieldRef: FieldRef;
        lvngStartLine: Integer;
        lvngEndLine: Integer;
        lvngColumnNo: Integer;
    begin
        CSVBufferTemp.ResetFilters();
        CSVBufferTemp.FindFirst();
        lvngStartLine := CSVBufferTemp."Line No.";
        lvngEndLine := CSVBufferTemp.GetNumberOfLines();
        lvngLoanImportSchemaLine.reset;
        lvngLoanImportSchemaLine.SetRange(Code, lvngLoanImportSchemaTemp.Code);
        lvngLoanImportSchemaLine.FindSet();
        repeat
            Clear(lvngLoanImportSchemaLineTemp);
            lvngLoanImportSchemaLineTemp := lvngLoanImportSchemaLine;
            lvngLoanImportSchemaLineTemp.insert;
        until lvngLoanImportSchemaLine.next = 0;
        CSVBufferTemp.ResetFilters();
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngLoanJournalBatch.Code);
        lvngLoanJournalLine.DeleteAll(true);
        repeat
            Clear(lvngLoanJournalLine);
            lvngLoanJournalLine."Loan Journal Batch Code" := lvngLoanJournalBatch.Code;
            lvngLoanJournalLine."Line No." := lvngStartLine;
            lvngLoanJournalLine.Insert(true);
            lvngRecRef.GetTable(lvngLoanJournalLine);
            lvngLoanImportSchemaLineTemp.reset;
            lvngLoanImportSchemaLineTemp.FindSet();
            lvngColumnNo := 0;
            repeat
                lvngColumnNo := lvngColumnNo + 1;
                case lvngLoanImportSchemaLineTemp."Field Type" of
                    lvngLoanImportSchemaLineTemp."Field Type"::Table:
                        begin
                            lvngFieldRef := lvngRecRef.Field(lvngLoanImportSchemaLineTemp."Field No.");
                            AssignValueToJournalField(lvngStartLine, CSVBufferTemp.GetValue(lvngStartLine, lvngColumnNo), lvngLoanImportSchemaLineTemp, lvngFieldRef);
                        end;
                    lvngLoanImportSchemaLineTemp."Field Type"::Variable:
                        begin
                            AssignValueToVariableField(CSVBufferTemp.GetValue(lvngStartLine, lvngColumnNo), lvngLoanJournalLine, lvngLoanImportSchemaLineTemp);
                        end;
                end;
            until lvngLoanImportSchemaLineTemp.Next() = 0;
            lvngRecRef.Modify(true);
            lvngRecRef.SetTable(lvngLoanJournalLine);
            lvngRecRef.Close();
            if lvngLoanJournalLine."Processing Schema Code" = '' then
                lvngLoanJournalLine."Processing Schema Code" := lvngLoanJournalBatch."Def. Processing Schema Code";
            if lvngLoanJournalLine."Reason Code" = '' then
                lvngLoanJournalLine."Reason Code" := lvngLoanJournalBatch."Default Reason Code";
            if lvngLoanJournalLine."Title Customer No." = '' then
                lvngLoanJournalLine."Title Customer No." := lvngLoanJournalBatch."Default Title Customer No.";
            lvngLoanJournalLine.Modify();
            lvngStartLine := lvngStartLine + 1;
        until (lvngStartLine > lvngEndLine);
    end;

    procedure AssignValueToVariableField(lvngValue: Text; lvngLoanJournalLine: Record lvngLoanJournalLine; lvngLoanImportSchemaLine: record lvngLoanImportSchemaLine)
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        StringConversionManagement: Codeunit StringConversionManagement;
        lvngBooleanStringWrongFormat: Label 'Boolean Value %1 has wrong format. Line No. %2, Field %3. Possible Values %4 %5';
        lvngBooleanStringNoFormatDefined: Label 'Boolean format is not defined for field %1';
        lvngDateStringWrongFormat: Label 'Date Value %1 has wrong format. Line No. %2, Field %3';
        lvngDecimalStringWrongFormat: Label 'Decimal Value %1 has wrong format. Line No. %2, Field %3';
        lvngIntegerStringWrongFormat: Label 'Integer Value %1 has wrong format. Line No. %2, Field %3';
        lvngBooleanField: Boolean;
        lvngDateField: Date;
        lvngIntegerField: Integer;
        lvngDecimalField: Decimal;
        lvngLineNo: Integer;
    begin
        lvngLineNo := lvngLoanJournalLine."Line No.";
        if lvngLoanImportSchemaLine."Field Size" > 0 then begin
            if lvngLoanImportSchemaLine.Trimming = lvngLoanImportSchemaLine.Trimming::Spaces then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
            end;
            if lvngLoanImportSchemaLine.Trimming = lvngLoanImportSchemaLine.Trimming::"To Size" then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
                lvngValue := CopyStr(lvngValue, 1, lvngLoanImportSchemaLine."Field Size");
            end;
        end;
        if (lvngLoanImportSchemaLine."Padding Character" <> '') and (lvngLoanImportSchemaLine."Field Size" > 0) then begin
            if lvngLoanImportSchemaLine."Padding Side" = lvngLoanImportSchemaLine."Padding Side"::Left then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine."Field Size", lvngLoanImportSchemaLine."Padding Character", 0);
            if lvngLoanImportSchemaLine."Padding Side" = lvngLoanImportSchemaLine."Padding Side"::Right then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine."Field Size", lvngLoanImportSchemaLine."Padding Character", 1);
        end;

        case lvngLoanImportSchemaLine."Value Type" of
            lvngLoanImportSchemaLine."Value Type"::Boolean:
                begin
                    Clear(lvngBooleanField);
                    case lvngLoanImportSchemaLine."Boolean Format" of
                        lvngLoanImportSchemaLine."Boolean Format"::"1/0":
                            begin
                                if (StrLen(lvngValue) <> 1) AND ((lvngValue <> '1') OR (lvngValue <> '0')) then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 1, 0);
                                end;
                                if lvngValue = '1' then
                                    lvngbooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"False If Blank":
                            begin
                                if lvngValue <> '' then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::Undefined:
                            begin
                                Error(lvngBooleanStringNoFormatDefined, lvngLoanImportSchemaLine."Field Name");
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"True/False":
                            begin
                                if (UpperCase(lvngValue) <> 'FALSE') AND (UpperCase(lvngValue) <> 'TRUE') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'True', 'False');
                                end;
                                if (UpperCase(lvngValue) = 'TRUE') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"Yes/No":
                            begin
                                if (UpperCase(lvngValue) <> 'NO') AND (UpperCase(lvngValue) <> 'YES') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'Yes', 'No');
                                end;
                                if (UpperCase(lvngValue) = 'YES') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"Y/N":
                            begin
                                if (UpperCase(lvngValue) <> 'N') AND (UpperCase(lvngValue) <> 'Y') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'Y', 'N');
                                end;
                                if (UpperCase(lvngValue) = 'Y') then
                                    lvngBooleanField := true;
                            end;
                    end;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                    lvngLoanJournalValue."Line No." := lvngLoanJournalLine."Line No.";
                    lvngLoanJournalValue."Field No." := lvngLoanImportSchemaLine."Field No.";
                    if lvngBooleanField then
                        lvngLoanJournalValue."Field Value" := 'True' else
                        lvngLoanJournalValue."Field Value" := 'False';
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine."Value Type"::Date:
                begin
                    clear(lvngDateField);
                    if not Evaluate(lvngDateField, lvngValue) then
                        Error(lvngDateStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                    lvngLoanJournalValue."Line No." := lvngLoanJournalLine."Line No.";
                    lvngLoanJournalValue."Field No." := lvngLoanImportSchemaLine."Field No.";
                    lvngLoanJournalValue."Field Value" := Format(lvngDateField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine."Value Type"::Decimal:
                begin
                    Clear(lvngDecimalField);
                    if not Evaluate(lvngDecimalField, lvngValue) then
                        Error(lvngDecimalStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Negative then
                        lvngDecimalField := -ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Positive then
                        lvngDecimalField := ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::"Reverse Sign" then
                        lvngDecimalField := -lvngDecimalField;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                    lvngLoanJournalValue."Line No." := lvngLoanJournalLine."Line No.";
                    lvngLoanJournalValue."Field No." := lvngLoanImportSchemaLine."Field No.";
                    lvngLoanJournalValue."Field Value" := Format(lvngDecimalField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine."Value Type"::Integer:
                begin
                    Clear(lvngIntegerField);
                    if not Evaluate(lvngIntegerField, lvngValue) then
                        Error(lvngIntegerStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Negative then
                        lvngIntegerField := -ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Positive then
                        lvngIntegerField := ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::"Reverse Sign" then
                        lvngIntegerField := -lvngIntegerField;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                    lvngLoanJournalValue."Line No." := lvngLoanJournalLine."Line No.";
                    lvngLoanJournalValue."Field No." := lvngLoanImportSchemaLine."Field No.";
                    lvngLoanJournalValue."Field Value" := Format(lvngIntegerField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine."Value Type"::Text:
                begin
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue."Loan Journal Batch Code" := lvngLoanJournalLine."Loan Journal Batch Code";
                    lvngLoanJournalValue."Line No." := lvngLoanJournalLine."Line No.";
                    lvngLoanJournalValue."Field No." := lvngLoanImportSchemaLine."Field No.";
                    lvngLoanJournalValue."Field Value" := CopyStr(lvngValue, 1, 250);
                    lvngLoanJournalValue.Insert(true)
                end;
        end;
    end;

    procedure AssignValueToJournalField(lvngLineNo: integer; lvngValue: Text; lvngLoanImportSchemaLine: record lvngLoanImportSchemaLine; var lvngFieldRef: FieldRef)
    var
        StringConversionManagement: Codeunit StringConversionManagement;
        lvngBooleanStringWrongFormat: Label 'Boolean Value %1 has wrong format. Line No. %2, Field %3. Possible Values %4 %5';
        lvngBooleanStringNoFormatDefined: Label 'Boolean format is not defined for field %1';
        lvngDateStringWrongFormat: Label 'Date Value %1 has wrong format. Line No. %2, Field %3';
        lvngDecimalStringWrongFormat: Label 'Decimal Value %1 has wrong format. Line No. %2, Field %3';
        lvngIntegerStringWrongFormat: Label 'Integer Value %1 has wrong format. Line No. %2, Field %3';
        lvngBooleanField: Boolean;
        lvngDateField: Date;
        lvngIntegerField: Integer;
        lvngDecimalField: Decimal;
    begin
        if lvngLoanImportSchemaLine."Field Size" > 0 then begin
            if lvngLoanImportSchemaLine.Trimming = lvngLoanImportSchemaLine.Trimming::Spaces then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
            end;
            if lvngLoanImportSchemaLine.Trimming = lvngLoanImportSchemaLine.Trimming::"To Size" then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
                lvngValue := CopyStr(lvngValue, 1, lvngLoanImportSchemaLine."Field Size");
            end;
        end;
        if (lvngLoanImportSchemaLine."Padding Character" <> '') and (lvngLoanImportSchemaLine."Field Size" > 0) then begin
            if lvngLoanImportSchemaLine."Padding Side" = lvngLoanImportSchemaLine."Padding Side"::Left then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine."Field Size", lvngLoanImportSchemaLine."Padding Character", 0);
            if lvngLoanImportSchemaLine."Padding Side" = lvngLoanImportSchemaLine."Padding Side"::Right then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine."Field Size", lvngLoanImportSchemaLine."Padding Character", 1);
        end;

        case lvngLoanImportSchemaLine."Value Type" of
            lvngLoanImportSchemaLine."Value Type"::Boolean:
                begin
                    Clear(lvngBooleanField);
                    case lvngLoanImportSchemaLine."Boolean Format" of
                        lvngLoanImportSchemaLine."Boolean Format"::"1/0":
                            begin
                                if StrLen(lvngValue) <> 1 then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 1, 0);
                                end;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"False If Blank":
                            begin
                                if lvngValue <> '' then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::Undefined:
                            begin
                                Error(lvngBooleanStringNoFormatDefined, lvngLoanImportSchemaLine."Field Name");
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"True/False":
                            begin
                                if (UpperCase(lvngValue) <> 'FALSE') AND (UpperCase(lvngValue) <> 'TRUE') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'True', 'False');
                                end;
                                if (UpperCase(lvngValue) = 'TRUE') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"Yes/No":
                            begin
                                if (UpperCase(lvngValue) <> 'NO') AND (UpperCase(lvngValue) <> 'YES') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'Yes', 'No');
                                end;
                                if (UpperCase(lvngValue) = 'YES') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine."Boolean Format"::"Y/N":
                            begin
                                if (UpperCase(lvngValue) <> 'N') AND (UpperCase(lvngValue) <> 'Y') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name", 'Y', 'N');
                                end;
                                if (UpperCase(lvngValue) = 'Y') then
                                    lvngBooleanField := true;
                            end;
                    end;
                    lvngFieldRef.Validate(lvngBooleanField);
                end;
            lvngLoanImportSchemaLine."Value Type"::Date:
                begin
                    Clear(lvngDateField);
                    if not Evaluate(lvngDateField, lvngValue) then
                        Error(lvngDateStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    lvngFieldRef.Validate(lvngDateField);
                end;
            lvngLoanImportSchemaLine."Value Type"::Decimal:
                begin
                    Clear(lvngDecimalField);
                    if not Evaluate(lvngDecimalField, lvngValue) then
                        Error(lvngDecimalStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Negative then
                        lvngDecimalField := -ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Positive then
                        lvngDecimalField := ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::"Reverse Sign" then
                        lvngDecimalField := -lvngDecimalField;
                    lvngFieldRef.Validate(lvngDecimalField);
                end;
            lvngLoanImportSchemaLine."Value Type"::Integer:
                begin
                    Clear(lvngIntegerField);
                    if not Evaluate(lvngIntegerField, lvngValue) then
                        Error(lvngIntegerStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine."Field Name");
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Negative then
                        lvngIntegerField := -ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::Positive then
                        lvngIntegerField := ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine."Numeric Format" = lvngLoanImportSchemaLine."Numeric Format"::"Reverse Sign" then
                        lvngIntegerField := -lvngIntegerField;
                    lvngFieldRef.Validate(lvngIntegerField);
                end;
            lvngLoanImportSchemaLine."Value Type"::Text:
                begin
                    lvngFieldRef.Validate(CopyStr(lvngValue, 1, lvngFieldRef.Length()));
                end;
        end;
    end;

}