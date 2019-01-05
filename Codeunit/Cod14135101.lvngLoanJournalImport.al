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
        if lvngLoanImportSchemaTemp.lvngFieldSeparatorCharacter = '<TAB>' then
            lvngLoanImportSchemaTemp.lvngFieldSeparatorCharacter := Format(TabChar);
        lvngLoanJournalBatch.Get(lvngLoanJournalBatchCode);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngLoanImportSchemaTemp.lvngFieldSeparatorCharacter);
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngLoanImportSchemaTemp.lvngSkipLines);
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
        lvngLoanImportSchemaLine.SetRange(lvngCode, lvngLoanImportSchemaTemp.lvngCode);
        lvngLoanImportSchemaLine.FindSet();
        repeat
            Clear(lvngLoanImportSchemaLineTemp);
            lvngLoanImportSchemaLineTemp := lvngLoanImportSchemaLine;
            lvngLoanImportSchemaLineTemp.insert;
        until lvngLoanImportSchemaLine.next = 0;
        CSVBufferTemp.ResetFilters();
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalBatch.lvngCode);
        lvngLoanJournalLine.DeleteAll(true);
        repeat
            Clear(lvngLoanJournalLine);
            lvngLoanJournalLine.lvngLoanJournalBatchCode := lvngLoanJournalBatch.lvngCode;
            lvngLoanJournalLine.lvngLineNo := lvngStartLine;
            lvngLoanJournalLine.Insert(true);
            lvngRecRef.GetTable(lvngLoanJournalLine);
            lvngLoanImportSchemaLineTemp.reset;
            lvngLoanImportSchemaLineTemp.FindSet();
            lvngColumnNo := 0;
            repeat
                lvngColumnNo := lvngColumnNo + 1;
                case lvngLoanImportSchemaLineTemp.lvngFieldType of
                    lvngLoanImportSchemaLineTemp.lvngFieldType::lvngTable:
                        begin
                            lvngFieldRef := lvngRecRef.Field(lvngLoanImportSchemaLineTemp.lvngFieldNo);
                            AssignValueToJournalField(lvngStartLine, CSVBufferTemp.GetValue(lvngStartLine, lvngColumnNo), lvngLoanImportSchemaLineTemp, lvngFieldRef);
                        end;
                    lvngLoanImportSchemaLineTemp.lvngFieldType::lvngVariable:
                        begin
                            AssignValueToVariableField(CSVBufferTemp.GetValue(lvngStartLine, lvngColumnNo), lvngLoanJournalLine, lvngLoanImportSchemaLineTemp);
                        end;
                end;
            until lvngLoanImportSchemaLineTemp.Next() = 0;
            lvngRecRef.Modify(true);
            lvngRecRef.SetTable(lvngLoanJournalLine);
            lvngRecRef.Close();
            if lvngLoanJournalLine.lvngProcessingSchemaCode = '' then
                lvngLoanJournalLine.lvngProcessingSchemaCode := lvngLoanJournalBatch.lvngDefProcessingSchemaCode;
            if lvngLoanJournalLine.lvngReasonCode = '' then
                lvngLoanJournalLine.lvngReasonCode := lvngLoanJournalBatch.lvngDefaultReasonCode;
            if lvngLoanJournalLine.lvngTitleCustomerNo = '' then
                lvngLoanJournalLine.lvngTitleCustomerNo := lvngLoanJournalBatch.lvngDefaultTitleCustomerNo;
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
        lvngLineNo := lvngLoanJournalLine.lvngLineNo;
        if lvngLoanImportSchemaLine.lvngFieldSize > 0 then begin
            if lvngLoanImportSchemaLine.lvngTrimOption = lvngLoanImportSchemaLine.lvngTrimOption::lvngSpaces then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
            end;
            if lvngLoanImportSchemaLine.lvngTrimOption = lvngLoanImportSchemaLine.lvngTrimOption::lvngToSize then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
                lvngValue := CopyStr(lvngValue, 1, lvngLoanImportSchemaLine.lvngFieldSize);
            end;
        end;
        if (lvngLoanImportSchemaLine.lvngPaddingCharacter <> '') and (lvngLoanImportSchemaLine.lvngFieldSize > 0) then begin
            if lvngLoanImportSchemaLine.lvngPaddingSide = lvngLoanImportSchemaLine.lvngPaddingSide::lvngLeft then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine.lvngFieldSize, lvngLoanImportSchemaLine.lvngPaddingCharacter, 0);
            if lvngLoanImportSchemaLine.lvngPaddingSide = lvngLoanImportSchemaLine.lvngPaddingSide::lvngRight then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine.lvngFieldSize, lvngLoanImportSchemaLine.lvngPaddingCharacter, 1);
        end;

        case lvngLoanImportSchemaLine.lvngValueType of
            lvngLoanImportSchemaLine.lvngValueType::lvngBoolean:
                begin
                    Clear(lvngBooleanField);
                    case lvngLoanImportSchemaLine.lvngBooleanFormat of
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvng10:
                            begin
                                if (StrLen(lvngValue) <> 1) AND ((lvngValue <> '1') OR (lvngValue <> '0')) then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 1, 0);
                                end;
                                if lvngValue = '1' then
                                    lvngbooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngFalseIfBlank:
                            begin
                                if lvngValue <> '' then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngNone:
                            begin
                                Error(lvngBooleanStringNoFormatDefined, lvngLoanImportSchemaLine.lvngName);
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngTrueFalse:
                            begin
                                if (UpperCase(lvngValue) <> 'FALSE') AND (UpperCase(lvngValue) <> 'TRUE') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'True', 'False');
                                end;
                                if (UpperCase(lvngValue) = 'TRUE') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngYesNo:
                            begin
                                if (UpperCase(lvngValue) <> 'NO') AND (UpperCase(lvngValue) <> 'YES') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'Yes', 'No');
                                end;
                                if (UpperCase(lvngValue) = 'YES') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngYN:
                            begin
                                if (UpperCase(lvngValue) <> 'N') AND (UpperCase(lvngValue) <> 'Y') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'Y', 'N');
                                end;
                                if (UpperCase(lvngValue) = 'Y') then
                                    lvngBooleanField := true;
                            end;
                    end;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                    lvngLoanJournalValue.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
                    lvngLoanJournalValue.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    if lvngBooleanField then
                        lvngLoanJournalValue.lvngFieldValue := 'True' else
                        lvngLoanJournalValue.lvngFieldValue := 'False';
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngDate:
                begin
                    clear(lvngDateField);
                    if not Evaluate(lvngDateField, lvngValue) then
                        Error(lvngDateStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                    lvngLoanJournalValue.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
                    lvngLoanJournalValue.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    lvngLoanJournalValue.lvngFieldValue := Format(lvngDateField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngDecimal:
                begin
                    Clear(lvngDecimalField);
                    if not Evaluate(lvngDecimalField, lvngValue) then
                        Error(lvngDecimalStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngNegative then
                        lvngDecimalField := -ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngPositive then
                        lvngDecimalField := ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngReverseSign then
                        lvngDecimalField := -lvngDecimalField;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                    lvngLoanJournalValue.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
                    lvngLoanJournalValue.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    lvngLoanJournalValue.lvngFieldValue := Format(lvngDecimalField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngInteger:
                begin
                    Clear(lvngIntegerField);
                    if not Evaluate(lvngIntegerField, lvngValue) then
                        Error(lvngIntegerStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngNegative then
                        lvngIntegerField := -ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngPositive then
                        lvngIntegerField := ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngReverseSign then
                        lvngIntegerField := -lvngIntegerField;
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                    lvngLoanJournalValue.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
                    lvngLoanJournalValue.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    lvngLoanJournalValue.lvngFieldValue := Format(lvngIntegerField);
                    lvngLoanJournalValue.Insert(true)
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngText:
                begin
                    Clear(lvngLoanJournalValue);
                    lvngLoanJournalValue.Init();
                    lvngLoanJournalValue.lvngLoanJournalBatchCode := lvngLoanJournalLine.lvngLoanJournalBatchCode;
                    lvngLoanJournalValue.lvngLineNo := lvngLoanJournalLine.lvngLineNo;
                    lvngLoanJournalValue.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    lvngLoanJournalValue.lvngFieldValue := CopyStr(lvngValue, 1, 250);
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
        if lvngLoanImportSchemaLine.lvngFieldSize > 0 then begin
            if lvngLoanImportSchemaLine.lvngTrimOption = lvngLoanImportSchemaLine.lvngTrimOption::lvngSpaces then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
            end;
            if lvngLoanImportSchemaLine.lvngTrimOption = lvngLoanImportSchemaLine.lvngTrimOption::lvngToSize then begin
                lvngValue := DelChr(lvngValue, '<>', ' ');
                lvngValue := CopyStr(lvngValue, 1, lvngLoanImportSchemaLine.lvngFieldSize);
            end;
        end;
        if (lvngLoanImportSchemaLine.lvngPaddingCharacter <> '') and (lvngLoanImportSchemaLine.lvngFieldSize > 0) then begin
            if lvngLoanImportSchemaLine.lvngPaddingSide = lvngLoanImportSchemaLine.lvngPaddingSide::lvngLeft then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine.lvngFieldSize, lvngLoanImportSchemaLine.lvngPaddingCharacter, 0);
            if lvngLoanImportSchemaLine.lvngPaddingSide = lvngLoanImportSchemaLine.lvngPaddingSide::lvngRight then
                lvngValue := StringConversionManagement.GetPaddedString(lvngValue, lvngLoanImportSchemaLine.lvngFieldSize, lvngLoanImportSchemaLine.lvngPaddingCharacter, 1);
        end;

        case lvngLoanImportSchemaLine.lvngValueType of
            lvngLoanImportSchemaLine.lvngValueType::lvngBoolean:
                begin
                    Clear(lvngBooleanField);
                    case lvngLoanImportSchemaLine.lvngBooleanFormat of
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvng10:
                            begin
                                if StrLen(lvngValue) <> 1 then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 1, 0);
                                end;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngFalseIfBlank:
                            begin
                                if lvngValue <> '' then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngNone:
                            begin
                                Error(lvngBooleanStringNoFormatDefined, lvngLoanImportSchemaLine.lvngName);
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngTrueFalse:
                            begin
                                if (UpperCase(lvngValue) <> 'FALSE') AND (UpperCase(lvngValue) <> 'TRUE') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'True', 'False');
                                end;
                                if (UpperCase(lvngValue) = 'TRUE') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngYesNo:
                            begin
                                if (UpperCase(lvngValue) <> 'NO') AND (UpperCase(lvngValue) <> 'YES') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'Yes', 'No');
                                end;
                                if (UpperCase(lvngValue) = 'YES') then
                                    lvngBooleanField := true;
                            end;
                        lvngLoanImportSchemaLine.lvngBooleanFormat::lvngYN:
                            begin
                                if (UpperCase(lvngValue) <> 'N') AND (UpperCase(lvngValue) <> 'Y') then begin
                                    Error(lvngBooleanStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName, 'Y', 'N');
                                end;
                                if (UpperCase(lvngValue) = 'Y') then
                                    lvngBooleanField := true;
                            end;
                    end;
                    lvngFieldRef.Validate(lvngBooleanField);
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngDate:
                begin
                    Clear(lvngDateField);
                    if not Evaluate(lvngDateField, lvngValue) then
                        Error(lvngDateStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    lvngFieldRef.Validate(lvngDateField);
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngDecimal:
                begin
                    Clear(lvngDecimalField);
                    if not Evaluate(lvngDecimalField, lvngValue) then
                        Error(lvngDecimalStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngNegative then
                        lvngDecimalField := -ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngPositive then
                        lvngDecimalField := ABS(lvngDecimalField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngReverseSign then
                        lvngDecimalField := -lvngDecimalField;
                    lvngFieldRef.Validate(lvngDecimalField);
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngInteger:
                begin
                    Clear(lvngIntegerField);
                    if not Evaluate(lvngIntegerField, lvngValue) then
                        Error(lvngIntegerStringWrongFormat, lvngValue, lvngLineNo, lvngLoanImportSchemaLine.lvngName);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngNegative then
                        lvngIntegerField := -ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngPositive then
                        lvngIntegerField := ABS(lvngIntegerField);
                    if lvngLoanImportSchemaLine.lvngNumbericalFormatting = lvngLoanImportSchemaLine.lvngNumbericalFormatting::lvngReverseSign then
                        lvngIntegerField := -lvngIntegerField;
                    lvngFieldRef.Validate(lvngIntegerField);
                end;
            lvngLoanImportSchemaLine.lvngValueType::lvngText:
                begin
                    lvngFieldRef.Validate(CopyStr(lvngValue, 1, lvngFieldRef.Length()));
                end;
        end;
    end;

}