report 14135103 "lvngImportGenJnlFile"
{

    Caption = 'Import Journal File';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(lvngSettings)
                {
                    Caption = 'Settings';

                    field(lvngSchemaCode; lvngSchemaCode)
                    {
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            lvngFileImportSchema.reset;
                            lvngFileImportSchema.SetRange(lvngFileImportType, lvngFileImportSchema.lvngFileImportType::lvngGeneralJournal);
                            if page.RunModal(0, lvngFileImportSchema) = Action::LookupOK then begin
                                lvngSchemaCode := lvngFileImportSchema.lvngCode;
                            end;
                        end;

                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin

        lvngFileImportSchema.Get(lvngSchemaCode);
        lvngFileImportJnlLine.Reset();
        lvngFileImportJnlLine.SetRange(lvngCode, lvngSchemaCode);
        lvngFileImportJnlLine.FindSet();
        repeat
            Clear(lvngFileImportJnlLineTemp);
            lvngFileImportJnlLineTemp := lvngFileImportJnlLine;
            lvngFileImportJnlLineTemp.Insert();
        until lvngFileImportJnlLine.Next() = 0;
        ReadCSVStream();
        ProcessImportCSVBuffer();

    end;

    procedure ReadCSVStream()
    var
        TabChar: Char;
    begin
        TabChar := 9;
        if lvngFileImportSchema.lvngFieldSeparator = '<TAB>' then
            lvngFileImportSchema.lvngFieldSeparator := Format(TabChar);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngFileImportSchema.lvngFieldSeparator);
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngFileImportSchema.lvngSkipRows);
            CSVBufferTemp.DeleteAll();
        end else begin
            Error(lvngErrorReadingToStreamLabel);
        end;
    end;

    procedure ProcessImportCSVBuffer()
    var
        lvngStartLine: Integer;
        lvngEndLine: Integer;
        lvngValue: Text;
    begin
        lvngGenJnlImportBuffer.Reset();
        lvngGenJnlImportBuffer.DeleteAll();
        CSVBufferTemp.ResetFilters();
        CSVBufferTemp.FindFirst();
        lvngStartLine := CSVBufferTemp."Line No.";
        lvngEndLine := CSVBufferTemp.GetNumberOfLines();
        CSVBufferTemp.ResetFilters();
        repeat
            Clear(lvngGenJnlImportBuffer);
            lvngGenJnlImportBuffer.lvngLineNo := lvngStartLine;
            lvngGenJnlImportBuffer.Insert(true);
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange(lvngCode, lvngFileImportSchema.lvngCode);
            lvngFileImportJnlLineTemp.SetFilter(lvngImportFieldType, '<>%1', lvngFileImportJnlLine.lvngImportFieldType::lvngDummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp.lvngColumnNo);
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp.lvngImportFieldType of
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAccountNo:
                            begin
                                lvngGenJnlImportBuffer.lvngAccountNo := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer.lvngAccountNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAccountType:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAmount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAmount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAppliesToDocNo:
                            begin
                                lvngGenJnlImportBuffer.lvngAppliesToDocNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngAppliesToDocNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngAppliesToDocType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngAppliesToDocType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBalAccountNo:
                            begin
                                lvngGenJnlImportBuffer.lvngBalAccountNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBalAccountNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBalAccountType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBalAccountType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBankPaymentType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngBankPaymentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngBusinessUnitCode:
                            begin
                                lvngGenJnlImportBuffer.lvngBusinessUnitCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngBusinessUnitCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngComment:
                            begin
                                lvngGenJnlImportBuffer.lvngComment := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngComment));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDepreciationBookCode:
                            begin
                                lvngGenJnlImportBuffer.lvngDepreciationBookCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDepreciationBookCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDescription:
                            begin
                                lvngGenJnlImportBuffer.lvngDescription := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDescription));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension1Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension1Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension1Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension2Code:
                            begin
                                lvngGenJnlImportBuffer.lvngGlobalDimension2Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngGlobalDimension2Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension3Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension3Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension3Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension4Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension4Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension4Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension5Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension5Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension5Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension6Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension6Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension6Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension7Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension7Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension7Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDimension8Code:
                            begin
                                lvngGenJnlImportBuffer.lvngShortcutDimension8Code := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngShortcutDimension8Code));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentNo:
                            begin
                                lvngGenJnlImportBuffer.lvngDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDocumentType:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDocumentType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngDueDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngDueDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngExternalDocumentNo:
                            begin
                                lvngGenJnlImportBuffer.lvngExternalDocumentNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngExternalDocumentNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngFAPostingType:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.lvngFAPostingType, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngLoanNo:
                            begin
                                lvngGenJnlImportBuffer.lvngLoanNo := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngLoanNo));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPaymentMethodCode:
                            begin
                                lvngGenJnlImportBuffer.lvngPaymentMethodCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPaymentMethodCode));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPostingDate:
                            begin
                                evaluate(lvngGenJnlImportBuffer.lvngPostingDate, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngPostingGroupCode:
                            begin
                                lvngGenJnlImportBuffer.lvngPostingGroup := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngPostingGroup));
                            end;
                        lvngFileImportJnlLineTemp.lvngImportFieldType::lvngReasonCode:
                            begin
                                lvngGenJnlImportBuffer.lvngReasonCode := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.lvngReasonCode));
                            end;
                    end;
                end;
            until lvngFileImportJnlLineTemp.Next() = 0;
            lvngGenJnlImportBuffer.Modify();
            lvngStartLine := lvngStartLine + 1;
        until (lvngStartLine > lvngEndLine);
    end;

    var
        lvngSchemaCode: Code[20];
        lvngFileImportSchema: Record lvngFileImportSchema;
        lvngFileImportJnlLine: Record lvngFileImportJnlLine;
        lvngFileImportJnlLineTemp: Record lvngFileImportJnlLine temporary;
        CSVBufferTemp: Record "CSV Buffer" temporary;
        lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer;
        lvngOpenFileLabel: Label 'Open File for Import';
        lvngErrorReadingToStreamLabel: Label 'Error reading file to stream';
        lvngImportStream: InStream;
        lvngFileName: Text;
        lvngImportToStream: Boolean;
}