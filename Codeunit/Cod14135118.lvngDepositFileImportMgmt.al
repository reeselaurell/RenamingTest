codeunit 14135118 "lvngDepositFileImportMgmt"
{

    procedure CreateJournalLines(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; DepositNo: Code[20])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        DepositHeader: Record "Deposit Header";
        DimensionManagement: Codeunit DimensionManagement;
        LineNo: Integer;
    begin
        DepositHeader.Get(DepositNo);
        GenJnlTemplate.get(DepositHeader."Journal Template Name");
        GenJnlLine.reset;
        GenJnlLine.SetRange("Journal Template Name", DepositHeader."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", DepositHeader."Journal Batch Name");
        if GenJnlLine.FindLast() then begin
            LineNo := GenJnlLine."Line No." + 100;
        end else begin
            LineNo := 100;
        end;
        lvngGenJnlImportBuffer.reset;
        lvngGenJnlImportBuffer.FindSet();
        repeat
            Clear(GenJnlLine);
            GenJnlLine.init;
            GenJnlLine.validate("Journal Template Name", DepositHeader."Journal Template Name");
            GenJnlLine.validate("Journal Batch Name", DepositHeader."Journal Batch Name");
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine.Insert();
            GenJnlLine."Account Type" := lvngGenJnlImportBuffer."Account Type";
            GenJnlLine.validate("Account No.", lvngGenJnlImportBuffer."Account No.");
            if lvngGenJnlImportBuffer.Description <> '' then begin
                GenJnlLine.Description := lvngGenJnlImportBuffer.Description;
            end;
            GenJnlLine.validate("Document Type", lvngGenJnlImportBuffer."Document Type");
            GenJnlLine.validate("Document No.", lvngGenJnlImportBuffer."Document No.");
            if lvngGenJnlImportBuffer."Posting Date" <> 0D then
                GenJnlLine.validate("Posting Date", lvngGenJnlImportBuffer."Posting Date") else
                GenJnlLine.Validate("Posting Date", DepositHeader."Posting Date");
            if lvngGenJnlImportBuffer."Document Date" <> 0D then
                GenJnlLine.validate("Document Date", lvngGenJnlImportBuffer."Document Date") else
                GenJnlLine.Validate("Posting Date", DepositHeader."Posting Date");

            GenJnlLine.validate(Amount, lvngGenJnlImportBuffer.Amount);
            GenJnlLine."Applies-to Doc. Type" := lvngGenJnlImportBuffer."Applies-To Doc. Type";
            GenJnlLine."Applies-to Doc. No." := lvngGenJnlImportBuffer."Applies-To Doc. No.";
            GenJnlLine."Loan No." := lvngGenJnlImportBuffer."Loan No.";
            GenJnlLine.validate("Reason Code", lvngGenJnlImportBuffer."Reason Code");
            GenJnlLine."Shortcut Dimension 1 Code" := lvngGenJnlImportBuffer."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := lvngGenJnlImportBuffer."Global Dimension 2 Code";
            GenJnlLine."Business Unit Code" := lvngGenJnlImportBuffer."Business Unit Code";
            if lvngGenJnlImportBuffer."Global Dimension 1 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(1, lvngGenJnlImportBuffer."Global Dimension 1 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Global Dimension 2 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(2, lvngGenJnlImportBuffer."Global Dimension 2 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(3, lvngGenJnlImportBuffer."Shortcut Dimension 3 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(4, lvngGenJnlImportBuffer."Shortcut Dimension 4 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(5, lvngGenJnlImportBuffer."Shortcut Dimension 5 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(6, lvngGenJnlImportBuffer."Shortcut Dimension 6 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(7, lvngGenJnlImportBuffer."Shortcut Dimension 7 Code", GenJnlLine."Dimension Set ID");
            if lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" <> '' then
                DimensionManagement.ValidateShortcutDimValues(8, lvngGenJnlImportBuffer."Shortcut Dimension 8 Code", GenJnlLine."Dimension Set ID");
            GenJnlLine.Modify();
            LineNo := LineNo + 100;
        until lvngGenJnlImportBuffer.Next() = 0;
    end;

    procedure ManualFileImport(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError): Boolean
    begin
        lvngFileImportSchema.reset;
        lvngFileImportSchema.SetRange("File Import Type", lvngFileImportSchema."File Import Type"::"Deposit Lines");
        if page.RunModal(0, lvngFileImportSchema) = Action::LookupOK then begin
            lvngGenJnlImportBuffer.reset;
            lvngGenJnlImportBuffer.DeleteAll();
            lvngFileImportSchema.Get(lvngFileImportSchema.Code);
            lvngFileImportJnlLine.Reset();
            lvngFileImportJnlLine.SetRange(Code, lvngFileImportSchema.Code);
            lvngFileImportJnlLine.FindSet();
            repeat
                Clear(lvngFileImportJnlLineTemp);
                lvngFileImportJnlLineTemp := lvngFileImportJnlLine;
                lvngFileImportJnlLineTemp.Insert();
            until lvngFileImportJnlLine.Next() = 0;
            ReadCSVStream();
            ProcessImportCSVBuffer(lvngGenJnlImportBuffer);
            ValidateEntries(lvngGenJnlImportBuffer, lvngImportBufferError);
            exit(True);
        end;
        exit(false);
    end;

    local procedure ReadCSVStream()
    var
        TabChar: Char;
    begin
        TabChar := 9;
        if lvngFileImportSchema."Field Separator" = '<TAB>' then
            lvngFileImportSchema."Field Separator" := Format(TabChar);
        lvngImportToStream := UploadIntoStream(lvngOpenFileLabel, '', '', lvngFileName, lvngImportStream);
        if lvngImportToStream then begin
            CSVBufferTemp.LoadDataFromStream(lvngImportStream, lvngFileImportSchema."Field Separator");
            CSVBufferTemp.ResetFilters();
            CSVBufferTemp.SetRange("Line No.", 0, lvngFileImportSchema."Skip Rows");
            CSVBufferTemp.DeleteAll();
        end else begin
            Error(lvngErrorReadingToStreamLabel);
        end;
    end;

    local procedure ProcessImportCSVBuffer(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngStartLine: Integer;
        lvngEndLine: Integer;
        lvngValue: Text;
        lvngValue2: Text;
        Pos: Integer;
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
            lvngGenJnlImportBuffer."Line No." := lvngStartLine;
            lvngGenJnlImportBuffer.Insert(true);
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange(Code, lvngFileImportSchema.Code);
            lvngFileImportJnlLineTemp.SetFilter("Deposit Import Field Type", '<>%1', lvngFileImportJnlLine."Deposit Import Field Type"::Dummy);
            lvngFileImportJnlLineTemp.FindSet();
            repeat
                lvngValue := CSVBufferTemp.GetValue(lvngStartLine, lvngFileImportJnlLineTemp."Column No.");
                if lvngValue <> '' then begin
                    case lvngFileImportJnlLineTemp."Deposit Import Field Type" of
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Account No.":
                            begin
                                lvngGenJnlImportBuffer."Account Value" := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer."Account Value"));
                                if lvngFileImportJnlLineTemp."Dimension Split" then begin
                                    IF lvngFileImportJnlLineTemp."Dimension Split Character" <> '' THEN BEGIN
                                        Pos := STRPOS(lvngValue, lvngFileImportJnlLineTemp."Dimension Split Character");
                                        IF Pos <> 0 THEN BEGIN
                                            lvngValue2 := COPYSTR(lvngValue, Pos + 1);
                                            lvngValue := COPYSTR(lvngValue, 1, Pos - 1);
                                            lvngGenJnlImportBuffer."Account Value" := copystr(lvngValue, 1, maxstrlen(lvngGenJnlImportBuffer."Account Value"));
                                            case lvngFileImportJnlLineTemp."Split Dimension No." of
                                                1:
                                                    lvngGenJnlImportBuffer."Global Dimension 1 Value" := lvngValue2;
                                                2:
                                                    lvngGenJnlImportBuffer."Global Dimension 2 Value" := lvngValue2;
                                                3:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" := lvngValue2;
                                                4:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" := lvngValue2;
                                                5:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" := lvngValue2;
                                                6:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" := lvngValue2;
                                                7:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" := lvngValue2;
                                                8:
                                                    lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" := lvngValue2;
                                            end;
                                        END;
                                    END;
                                end;
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Account Type":
                            begin
                                evaluate(lvngGenJnlImportBuffer."Account Type", lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::Amount:
                            begin
                                Evaluate(lvngGenJnlImportBuffer.Amount, lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Applies-To Doc. No":
                            begin
                                lvngGenJnlImportBuffer."Applies-To Doc. No." := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Applies-To Doc. No."));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Applies-To Doc. Type":
                            begin
                                Evaluate(lvngGenJnlImportBuffer."Applies-To Doc. Type", lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Business Unit Code":
                            begin
                                lvngGenJnlImportBuffer."Business Unit Code" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Business Unit Code"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::Description:
                            begin
                                lvngGenJnlImportBuffer.Description := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer.Description));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 1 Code":
                            begin
                                lvngGenJnlImportBuffer."Global Dimension 1 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Global Dimension 1 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 2 Code":
                            begin
                                lvngGenJnlImportBuffer."Global Dimension 2 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Global Dimension 2 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 3 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 3 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 4 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 4 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 5 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 5 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 6 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 6 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 7 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 7 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 8 Code":
                            begin
                                lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Shortcut Dimension 8 Value"));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Document Date":
                            begin
                                evaluate(lvngGenJnlImportBuffer."Document Date", lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Document No.":
                            begin
                                lvngGenJnlImportBuffer."Document No." := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Document No."));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Document Type":
                            begin
                                evaluate(lvngGenJnlImportBuffer."Document Type", lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Loan No.":
                            begin
                                lvngGenJnlImportBuffer."Loan No." := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Loan No."));
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Posting Date":
                            begin
                                evaluate(lvngGenJnlImportBuffer."Posting Date", lvngValue);
                            end;
                        lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Reason Code":
                            begin
                                lvngGenJnlImportBuffer."Reason Code" := CopyStr(lvngValue, 1, MaxStrLen(lvngGenJnlImportBuffer."Reason Code"));
                            end;
                    end;
                end;
            until lvngFileImportJnlLineTemp.Next() = 0;
            lvngGenJnlImportBuffer.Modify();
            lvngStartLine := lvngStartLine + 1;
        until (lvngStartLine > lvngEndLine);
    end;

    local procedure ValidateEntries(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError)
    var
        lvngPostingDateIsNotValidLbl: Label '%1 Posting Date is not within allowed date ranges';
        lvngAccountNoBlankOrMissingLbl: Label 'Account %1 %2 is missing or blank';
        lvngLoanNoNotFoundLbl: Label 'Loan No. %1 not found';
        lvngReasonCodeMissingLbl: Label '%1 Reason Code is not available';
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        UserSetupMgmt: Codeunit "User Setup Management";
        GLAccount: Record "G/L Account";
        DocumentNo: Code[20];
    begin
        MainDimensionCode := lvngDimensionsManagement.GetMainHierarchyDimensionCode();
        MainDimensionNo := lvngDimensionsManagement.GetMainHierarchyDimensionNo();
        lvngDimensionsManagement.GetHierarchyDimensionsUsage(HierarchyDimensionsUsage);
        if MainDimensionNo <> 0 then
            HierarchyDimensionsUsage[MainDimensionNo] := false;

        lvngImportBufferError.reset;
        lvngImportBufferError.DeleteAll();
        lvngGenJnlImportBuffer.reset;
        if lvngGenJnlImportBuffer.FindSet() then begin
            repeat
                //Amount
                if lvngFileImportSchema."Reverse Amount Sign" then begin
                    lvngGenJnlImportBuffer.Amount := -lvngGenJnlImportBuffer.Amount;
                end;
                //Document Type
                if lvngFileImportSchema."Document Type Option" = lvngFileImportSchema."Document Type Option"::Predefined then begin
                    if lvngFileImportSchema."Deposit Document Type" = lvngFileImportSchema."Deposit Document Type"::Payment then
                        lvngGenJnlImportBuffer."Document Type" := lvngFileImportSchema."Document Type"::Payment;
                    if lvngFileImportSchema."Deposit Document Type" = lvngFileImportSchema."Deposit Document Type"::Refund then
                        lvngGenJnlImportBuffer."Document Type" := lvngFileImportSchema."Document Type"::Refund;
                end;

                //Posting Date
                if lvngGenJnlImportBuffer."Posting Date" <> 0D then begin
                    if not UserSetupMgmt.IsPostingDateValid(lvngGenJnlImportBuffer."Posting Date") then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngPostingDateIsNotValidLbl, lvngGenJnlImportBuffer."Posting Date"));
                    end;
                end;

                //Account Type and Account No.
                FindAccountNo(lvngGenJnlImportBuffer."Account Type", lvngGenJnlImportBuffer."Account Value", lvngGenJnlImportBuffer."Account No.");
                if lvngFileImportSchema."Default Account No." <> '' then begin
                    lvngGenJnlImportBuffer."Account Type" := lvngFileImportSchema."Gen. Jnl. Account Type";
                    lvngGenJnlImportBuffer."Account No." := lvngFileImportSchema."Default Account No.";
                end;
                if lvngGenJnlImportBuffer."Account No." = '' then begin
                    AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngAccountNoBlankOrMissingLbl, lvngGenJnlImportBuffer."Account Type", lvngGenJnlImportBuffer."Account Value"));
                end else begin
                    if lvngFileImportSchema."Subs. G/L With Bank Acc." then begin
                        if GLAccount.Get(lvngGenJnlImportBuffer."Account No.") then begin
                            lvngGenJnlImportBuffer."Account Type" := lvngGenJnlImportBuffer."Account Type"::"Bank Account";
                            lvngGenJnlImportBuffer."Account No." := GLAccount."Linked Bank Account No.";
                        end;
                    end;
                end;


                //Loan No.
                if lvngGenJnlImportBuffer."Loan No." <> '' then begin
                    if not CheckLoanNo(lvngGenJnlImportBuffer."Loan No.") then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, StrSubstNo(lvngLoanNoNotFoundLbl, lvngGenJnlImportBuffer."Loan No."));
                    end;
                    if lvngGenJnlImportBuffer."Loan No." <> '' then begin
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"All Loan Dimensions" then begin
                            AssignLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"Empty Dimensions" then begin
                            AssignEmptyLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                        if lvngFileImportSchema."Dimension Validation Rule" = lvngFileImportSchema."Dimension Validation Rule"::"Loan & Exclude Imported Dimensions" then begin
                            AssignNotImportedLoanDimensions(lvngGenJnlImportBuffer);
                        end;
                    end;
                end;

                //Dimensions
                AssignDimensions(lvngGenJnlImportBuffer);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 1 Mandatory", 1, lvngGenJnlImportBuffer."Global Dimension 1 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 2 Mandatory", 2, lvngGenJnlImportBuffer."Global Dimension 2 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 3 Mandatory", 3, lvngGenJnlImportBuffer."Shortcut Dimension 3 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 4 Mandatory", 4, lvngGenJnlImportBuffer."Shortcut Dimension 4 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 5 Mandatory", 5, lvngGenJnlImportBuffer."Shortcut Dimension 5 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 6 Mandatory", 6, lvngGenJnlImportBuffer."Shortcut Dimension 6 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 7 Mandatory", 7, lvngGenJnlImportBuffer."Shortcut Dimension 7 Code", lvngImportBufferError);
                ValidateDimension(lvngGenJnlImportBuffer."Line No.", lvngFileImportSchema."Dimension 8 Mandatory", 8, lvngGenJnlImportBuffer."Shortcut Dimension 8 Code", lvngImportBufferError);


                //Reason Code
                if lvngGenJnlImportBuffer."Reason Code" = '' then begin
                    lvngGenJnlImportBuffer."Reason Code" := lvngFileImportSchema."Reason Code";
                end;
                if lvngGenJnlImportBuffer."Reason Code" <> '' then begin
                    if not CheckReasonCode(lvngGenJnlImportBuffer) then begin
                        AddErrorLine(lvngGenJnlImportBuffer, lvngImportBufferError, strsubstno(lvngReasonCodeMissingLbl, lvngGenJnlImportBuffer."Reason Code"));
                    end;
                end;

                //Document No.
                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"Sames As Loan No." then begin
                    lvngGenJnlImportBuffer."Document No." := lvngGenJnlImportBuffer."Loan No.";
                end;

                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"Defined In File" then begin
                    if lvngGenJnlImportBuffer."Document No." <> '' then begin
                        if lvngFileImportSchema."Document No. Prefix" <> '' then begin
                            lvngGenJnlImportBuffer."Document No." := lvngFileImportSchema."Document No. Prefix" + lvngGenJnlImportBuffer."Document No.";
                        end;
                    end;
                end;

                if lvngFileImportSchema."Document No. Filling" = lvngFileImportSchema."Document No. Filling"::"From Schema No. Series" then begin
                    if lvngFileImportSchema."Use Single Document No." then begin
                        if DocumentNo = '' then
                            DocumentNo := NoSeriesMgmt.GetNextNo(lvngFileImportSchema."Document No. Series", today, true);
                    end else begin
                        DocumentNo := NoSeriesMgmt.GetNextNo(lvngFileImportSchema."Document No. Series", today, true);
                    end;
                    lvngGenJnlImportBuffer."Document No." := DocumentNo;
                end;

                //----
                lvngGenJnlImportBuffer.Modify();
            until lvngGenJnlImportBuffer.Next() = 0
        end;
    end;

    local procedure ValidateDimension(lvngLineNo: integer; Mandatory: boolean; DimensionNo: Integer; DimensionValueCode: Code[20]; var lvngImportBufferError: Record lvngImportBufferError)
    var
        DimensionValue: Record "Dimension Value";
        lvngMandatoryDimensionBlankLbl: Label 'Mandatory Dimension %1 is blank';
        lvngDimensionValueCodeMissingLbl: Label 'Dimension Value Code %1 is missing';
        lvngDimensionValueCodeBlockedLbl: Label 'Dimension Value Code %1 is blocked';
    begin
        if Mandatory then begin
            if DimensionValueCode = '' then begin
                AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngMandatoryDimensionBlankLbl, DimensionNo));
            end;
        end;
        if DimensionValueCode <> '' then begin
            DimensionValue.reset;
            DimensionValue.SetRange("Global Dimension No.", DimensionNo);
            DimensionValue.SetRange(Code, DimensionValueCode);
            if not DimensionValue.FindFirst() then begin
                AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngDimensionValueCodeMissingLbl, DimensionValueCode));
            end else begin
                if DimensionValue.Blocked then begin
                    AddErrorLine(lvngLineNo, lvngImportBufferError, StrSubstNo(lvngDimensionValueCodeBlockedLbl, DimensionValueCode));
                end;
            end;
        end;
    end;

    local procedure AssignDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngDimensionHierarchy: Record lvngDimensionHierarchy;
        DimensionCode: Code[20];
    begin
        SearchDimension(1, lvngFileImportSchema."Dimension 1 Mapping Type", lvngGenJnlImportBuffer."Global Dimension 1 Value", lvngGenJnlImportBuffer."Global Dimension 1 Code");
        SearchDimension(2, lvngFileImportSchema."Dimension 2 Mapping Type", lvngGenJnlImportBuffer."Global Dimension 2 Value", lvngGenJnlImportBuffer."Global Dimension 2 Code");
        SearchDimension(3, lvngFileImportSchema."Dimension 3 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 3 Value", lvngGenJnlImportBuffer."Shortcut Dimension 3 Code");
        SearchDimension(4, lvngFileImportSchema."Dimension 4 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 4 Value", lvngGenJnlImportBuffer."Shortcut Dimension 4 Code");
        SearchDimension(5, lvngFileImportSchema."Dimension 5 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 5 Value", lvngGenJnlImportBuffer."Shortcut Dimension 5 Code");
        SearchDimension(6, lvngFileImportSchema."Dimension 6 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 6 Value", lvngGenJnlImportBuffer."Shortcut Dimension 6 Code");
        SearchDimension(7, lvngFileImportSchema."Dimension 7 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 7 Value", lvngGenJnlImportBuffer."Shortcut Dimension 7 Code");
        SearchDimension(8, lvngFileImportSchema."Dimension 8 Mapping Type", lvngGenJnlImportBuffer."Shortcut Dimension 8 Value", lvngGenJnlImportBuffer."Shortcut Dimension 8 Code");
        case MainDimensionNo of
            1:
                DimensionCode := lvngGenJnlImportBuffer."Global Dimension 1 Code";
            2:
                DimensionCode := lvngGenJnlImportBuffer."Global Dimension 2 Code";
            3:
                DimensionCode := lvngGenJnlImportBuffer."Shortcut Dimension 3 Code";
            4:
                DimensionCode := lvngGenJnlImportBuffer."Shortcut Dimension 4 Code";
        end;
        lvngDimensionHierarchy.reset;
        lvngDimensionHierarchy.Ascending(false);
        lvngDimensionHierarchy.SetFilter(Date, '..%1', lvngGenJnlImportBuffer."Posting Date");
        lvngDimensionHierarchy.SetRange(Code, DimensionCode);
        if lvngDimensionHierarchy.FindFirst() then begin
            if HierarchyDimensionsUsage[1] then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngDimensionHierarchy."Global Dimension 1 Code";
            if HierarchyDimensionsUsage[2] then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngDimensionHierarchy."Global Dimension 2 Code";
            if HierarchyDimensionsUsage[3] then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngDimensionHierarchy."Shortcut Dimension 3 Code";
            if HierarchyDimensionsUsage[4] then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngDimensionHierarchy."Shortcut Dimension 4 Code";
            if HierarchyDimensionsUsage[5] then
                lvngGenJnlImportBuffer."Business Unit Code" := lvngDimensionHierarchy."Business Unit Code";
        end;
    end;

    local procedure SearchDimension(lvngDimensionNo: Integer; lvngDimensionMappingType: enum lvngDimensionMappingType; lvngDimensionValue: Text; var DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        if (DimensionValueCode = '') and (lvngDimensionValue <> '') then begin
            DimensionValue.reset;
            DimensionValue.SetRange("Global Dimension No.", lvngDimensionNo);
            case lvngDimensionMappingType of
                lvngDimensionMappingType::Code:
                    begin
                        DimensionValue.SetRange(Code, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Code)));
                    end;
                lvngDimensionMappingType::Name:
                    begin
                        DimensionValue.SetFilter(Name, copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::"Search Name":
                    begin
                        DimensionValue.Setrange(Name, '@' + copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue.Name)));
                    end;
                lvngDimensionMappingType::"Additional Code":
                    begin
                        DimensionValue.SetRange("Additional Code", copystr(lvngDimensionValue, 1, MaxStrLen(DimensionValue."Additional Code")));
                    end;
            end;
            if DimensionValue.FindFirst() then
                DimensionValueCode := DimensionValue.Code;
        end;
    end;

    local procedure CheckReasonCode(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer): Boolean
    var
        ReasonCode: record "Reason Code";
    begin
        if not ReasonCode.Get(lvngGenJnlImportBuffer."Reason Code") then
            exit(false);
        exit(True);
    end;

    local procedure AssignLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";
            lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";
            lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
            lvngGenJnlImportBuffer."Business Unit Code" := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignEmptyLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            if lvngGenJnlImportBuffer."Global Dimension 1 Value" = '' then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";
            if lvngGenJnlImportBuffer."Global Dimension 2 Value" = '' then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 3 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 4 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 5 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 6 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 7 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";
            if lvngGenJnlImportBuffer."Shortcut Dimension 8 Value" = '' then
                lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
            if lvngGenJnlImportBuffer."Business Unit Code" = '' then
                lvngGenJnlImportBuffer."Business Unit Code" := lvngLoan."Business Unit Code";
        end;
    end;

    local procedure AssignNotImportedLoanDimensions(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer)
    var
        lvngLoan: Record lvngLoan;
    begin
        if lvngLoan.Get(lvngGenJnlImportBuffer."Loan No.") then begin
            lvngFileImportJnlLineTemp.reset;
            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 1 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Global Dimension 1 Code" := lvngLoan."Global Dimension 1 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 2 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Global Dimension 2 Code" := lvngLoan."Global Dimension 2 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 3 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 3 Code" := lvngLoan."Shortcut Dimension 3 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 4 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 4 Code" := lvngLoan."Shortcut Dimension 4 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 5 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 5 Code" := lvngLoan."Shortcut Dimension 5 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 6 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 6 Code" := lvngLoan."Shortcut Dimension 6 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 7 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 7 Code" := lvngLoan."Shortcut Dimension 7 Code";

            lvngFileImportJnlLineTemp.SetRange("Deposit Import Field Type", lvngFileImportJnlLineTemp."Deposit Import Field Type"::"Dimension 8 Code");
            if lvngFileImportJnlLineTemp.IsEmpty() then
                lvngGenJnlImportBuffer."Shortcut Dimension 8 Code" := lvngLoan."Shortcut Dimension 8 Code";
        end;
    end;

    local procedure CheckLoanNo(var lvngLoanNo: Code[20]): Boolean
    var
        lvngLoan: Record lvngLoan;
    begin
        case lvngFileImportSchema."Loan No. Validation Rule" of
            lvngFileImportSchema."Loan No. Validation Rule"::"Blank If Not Found":
                begin
                    if not lvngLoan.Get(lvngLoanNo) then begin
                        Clear(lvngLoanNo);
                        exit(true);
                    end;
                end;
            lvngFileImportSchema."Loan No. Validation Rule"::Validate:
                begin
                    if not lvngloan.Get(lvngLoanNo) then
                        exit(false);
                end;
        end;
        exit(true);
    end;

    local procedure FindAccountNo(lvngGenJnlAccountType: enum lvngGenJnlAccountType; lvngValue: Text; var lvngAccountNo: Code[20])
    var
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        ICPartner: Record "IC Partner";
    begin
        //Account Type and Account No.
        case lvngFileImportSchema."Account Mapping Type" of
            lvngFileImportSchema."Account Mapping Type"::Name:
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetFilter(Name, '@' + lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetFilter(Name, '@' + lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetFilter(Name, '@' + lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetFilter(Name, '@' + lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetFilter(Description, '@' + lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetFilter(Name, '@' + lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No.":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("No.", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetRange("No.", lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetRange("No.", lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetRange("No.", lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetRange("No.", lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetRange(Code, lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"No. 2":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("No. 2", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                    end;
                end;
            lvngFileImportSchema."Account Mapping Type"::"Search Name":
                begin
                    case lvngGenJnlAccountType of
                        lvngGenJnlAccountType::"G/L Account":
                            begin
                                GLAccount.reset;
                                GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                                GLAccount.SetRange("Search Name", lvngValue);
                                if GLAccount.FindFirst() then begin
                                    lvngAccountNo := GLAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Bank Account":
                            begin
                                BankAccount.reset;
                                BankAccount.SetRange("Search Name", lvngValue);
                                if BankAccount.FindFirst() then begin
                                    lvngAccountNo := BankAccount."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Customer:
                            begin
                                Customer.reset;
                                Customer.SetRange("Search Name", lvngValue);
                                if Customer.FindFirst() then begin
                                    lvngAccountNo := Customer."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::Vendor:
                            begin
                                Vendor.reset;
                                Vendor.SetRange("Search Name", lvngValue);
                                if Vendor.FindFirst() then begin
                                    lvngAccountNo := Vendor."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"Fixed Asset":
                            begin
                                FixedAsset.reset;
                                FixedAsset.SetFilter(Description, '@' + lvngValue);
                                if FixedAsset.FindFirst() then begin
                                    lvngAccountNo := FixedAsset."No.";
                                end;
                            end;
                        lvngGenJnlAccountType::"IC Partner":
                            begin
                                ICPartner.reset;
                                ICPartner.SetFilter(Name, '@' + lvngValue);
                                if ICPartner.FindFirst() then begin
                                    lvngAccountNo := ICPartner.Code;
                                end;
                            end;
                    end;
                end;
        end;
    end;

    local procedure AddErrorLine(lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.SetRange("Line No.", lvngGenJnlImportBuffer."Line No.");
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError."Error No." + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError."Line No." := lvngGenJnlImportBuffer."Line No.";
        lvngImportBufferError."Error No." := lvngErrorLineNo;
        lvngImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.Description));
        lvngImportBufferError.Insert();
    end;

    local procedure AddErrorLine(lvngLineNo: Integer; var lvngImportBufferError: Record lvngImportBufferError; ErrorText: Text)
    var
        lvngErrorLineNo: Integer;
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.SetRange("Line No.", lvngLineNo);
        if lvngImportBufferError.FindLast() then begin
            lvngErrorLineNo := lvngImportBufferError."Error No." + 100;
        end else begin
            lvngErrorLineNo := 100;
        end;
        Clear(lvngImportBufferError);
        lvngImportBufferError."Line No." := lvngLineNo;
        lvngImportBufferError."Error No." := lvngErrorLineNo;
        lvngImportBufferError.Description := CopyStr(ErrorText, 1, MaxStrLen(lvngImportBufferError.Description));
        lvngImportBufferError.Insert();
    end;

    var
        lvngFileImportSchema: Record lvngFileImportSchema;
        lvngFileImportJnlLine: Record lvngFileImportJnlLine;
        lvngFileImportJnlLineTemp: Record lvngFileImportJnlLine temporary;
        CSVBufferTemp: Record "CSV Buffer" temporary;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        lvngOpenFileLabel: Label 'Open File for Import';
        lvngErrorReadingToStreamLabel: Label 'Error reading file to stream';
        MainDimensionCode: Code[20];
        HierarchyDimensionsUsage: array[5] of boolean;
        MainDimensionNo: Integer;
        lvngImportStream: InStream;
        lvngFileName: Text;
        lvngImportToStream: Boolean;
}