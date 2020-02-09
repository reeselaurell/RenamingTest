codeunit 14135106 lvngLoanManagement
{
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        TempLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration temporary;
        LoanFieldsConfigurationRetrieved: Boolean;
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanVisionSetupRetrieved: Boolean;
        CompletedMsg: Label 'Completed';

    procedure LoanNumberMatch(LoanNo: Code[20]; LoanNoMatchPattern: Record lvngLoanNoMatchPattern): Boolean
    begin
        if LoanNoMatchPattern."Max. Field Length" > 0 then
            if StrLen(LoanNo) > LoanNoMatchPattern."Max. Field Length" then
                exit(false);
        if LoanNoMatchPattern."Min. Field Length" <> 0 then
            if LoanNoMatchPattern."Min. Field Length" > StrLen(LoanNo) then
                exit(false);
        //TODO: Issues with Regex not available in Codeunit 10. Requires implementation
        exit(true);
    end;

    procedure UpdateLoans(JournalBatchCode: Code[20])
    var
        LoanJournalBatch: Record lvngLoanJournalBatch;
        LoanJournalLine: Record lvngLoanJournalLine;
        LoanUpdateSchema: Record lvngLoanUpdateSchema;
        TempLoanUpdateSchema: Record lvngLoanUpdateSchema temporary;
        LoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        Window: Dialog;
        Counter: Integer;
        ProcessedCount: Integer;
        ProgressMsg: Label 'Processing #1########### of #2###########';
        ProcessedMsg: Label '%1 of %2 Loans Processed';
    begin
        GetLoanVisionSetup();
        LoanJournalBatch.Get(JournalBatchCode);
        if LoanJournalBatch."Loan Card Update Option" = LoanJournalBatch."Loan Card Update Option"::Schema then begin
            LoanUpdateSchema.Reset();
            LoanUpdateSchema.SetRange("Journal Batch Code", JournalBatchCode);
            LoanUpdateSchema.FindSet();
            repeat
                Clear(TempLoanUpdateSchema);
                TempLoanUpdateSchema := LoanUpdateSchema;
                TempLoanUpdateSchema.Insert();
            until LoanUpdateSchema.Next() = 0;
        end;
        LoanJournalLine.Reset();
        LoanJournalLine.SetRange("Loan Journal Batch Code", JournalBatchCode);
        if LoanJournalBatch."Loan Journal Type" = LoanJournalBatch."Loan Journal Type"::Funded then
            if LoanVisionSetup."Funded Void Reason Code" <> '' then
                LoanJournalLine.SetFilter("Reason Code", '<>%1', LoanVisionSetup."Funded Void Reason Code");
        if LoanJournalBatch."Loan Journal Type" = LoanJournalBatch."Loan Journal Type"::Sold then
            if LoanVisionSetup."Sold Void Reason Code" <> '' then
                LoanJournalLine.SetFilter("Reason Code", '<>%1', LoanVisionSetup."Sold Void Reason Code");
        if LoanJournalLine.FindSet() then begin
            if GuiAllowed() then begin
                Window.Open(ProgressMsg);
                Window.Update(2, LoanJournalLine.Count());
            end;
            repeat
                Counter := Counter + 1;
                if GuiAllowed() then
                    Window.Update(1, Counter);
                if not LoanJournalErrorMgmt.HasError(LoanJournalLine) then begin
                    case LoanJournalBatch."Loan Card Update Option" of
                        LoanJournalBatch."Loan Card Update Option"::Always:
                            UpdateLoanCard(LoanJournalLine);
                        LoanJournalBatch."Loan Card Update Option"::Schema:
                            UpdateLoan(LoanJournalLine, TempLoanUpdateSchema);
                    end;
                    ProcessedCount := ProcessedCount + 1;
                    LoanJournalLine.Mark(true);
                end;
            until LoanJournalLine.Next() = 0;
            LoanJournalLine.MarkedOnly(true);
            LoanJournalLine.DeleteAll(true);
            if GuiAllowed() then begin
                Window.Close();
                Message(ProcessedMsg, ProcessedCount, Counter);
            end;
        end;
    end;

    procedure UpdateLoan(LoanJournalLine: Record lvngLoanJournalLine; var LoanUpdateSchema: Record lvngLoanUpdateSchema)
    var
        LoanJournalValue: Record lvngLoanJournalValue;
        LoanValue: Record lvngLoanValue;
        Loan: Record lvngLoan;
        LoanAddress: Record lvngLoanAddress;
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if LoanJournalLine."Loan No." = '' then
            exit;
        if not Loan.Get(LoanJournalLine."Loan No.") then begin
            Clear(Loan);
            Loan."No." := LoanJournalLine."Loan No.";
            Loan.Insert(true);
        end;
        LoanUpdateSchema.Reset();
        if LoanUpdateSchema.FindSet() then
            repeat
                case LoanUpdateSchema."Import Field Type" of
                    LoanUpdateSchema."Import Field Type"::Variable:
                        if LoanJournalValue.Get(LoanJournalLine."Loan Journal Batch Code", LoanJournalLine."Line No.", LoanUpdateSchema."Field No.") then
                            case LoanUpdateSchema."Field Update Option" of
                                LoanUpdateSchema."Field Update Option"::lvngAlways:
                                    begin
                                        if not LoanValue.Get(LoanJournalLine."Loan No.", LoanUpdateSchema."Field No.") then begin
                                            Clear(LoanValue);
                                            LoanValue."Loan No." := LoanJournalLine."Loan No.";
                                            LoanValue."Field No." := LoanUpdateSchema."Field No.";
                                            LoanValue.Insert();
                                        end;
                                        LoanValue.Validate("Field Value", LoanJournalValue."Field Value");
                                        LoanValue.Modify();
                                    end;
                                LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                    begin
                                        if not LoanValue.Get(LoanJournalLine."Loan No.", LoanUpdateSchema."Field No.") then begin
                                            Clear(LoanValue);
                                            LoanValue."Loan No." := LoanJournalLine."Loan No.";
                                            LoanValue."Field No." := LoanUpdateSchema."Field No.";
                                            LoanValue.Insert();
                                        end;
                                        if LoanValue."Field Value" = '' then begin
                                            LoanValue.Validate("Field Value", LoanJournalValue."Field Value");
                                            LoanValue.Modify();
                                        end;
                                    end;
                                LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                    begin
                                        if not LoanValue.Get(LoanJournalLine."Loan No.", LoanUpdateSchema."Field No.") then begin
                                            Clear(LoanValue);
                                            LoanValue."Loan No." := LoanJournalLine."Loan No.";
                                            LoanValue."Field No." := LoanUpdateSchema."Field No.";
                                            LoanValue.Insert();
                                        end;
                                        if LoanJournalValue."Field Value" = '' then begin
                                            LoanValue.Validate("Field Value", LoanJournalValue."Field Value");
                                            LoanValue.Modify();
                                        end;
                                    end;
                            end;
                    LoanUpdateSchema."Import Field Type"::Table:
                        begin
                            //Search Name
                            if LoanUpdateSchema."Field No." = 10 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Search Name" := LoanJournalLine."Search Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Search Name" = '' then
                                            Loan."Search Name" := LoanJournalLine."Search Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Search Name" <> '' then
                                            Loan."Search Name" := LoanJournalLine."Search Name";
                                end;
                            //Borrower First Name
                            if LoanUpdateSchema."Field No." = 11 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Borrower First Name" := LoanJournalLine."Borrower First Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Borrower First Name" = '' then
                                            Loan."Borrower First Name" := LoanJournalLine."Borrower First Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower First Name" <> '' then
                                            Loan."Borrower First Name" := LoanJournalLine."Borrower First Name";
                                end;
                            //Borrower Last Name
                            if LoanUpdateSchema."Field No." = 12 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Borrower Last Name" := LoanJournalLine."Borrower Last Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Borrower Last Name" = '' then
                                            Loan."Borrower Last Name" := LoanJournalLine."Borrower Last Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Last Name" <> '' then
                                            Loan."Borrower Last Name" := LoanJournalLine."Borrower Last Name";
                                end;
                            //Borrower Middle Name
                            if LoanUpdateSchema."Field No." = 13 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Borrower Middle Name" := LoanJournalLine."Borrower Middle Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Borrower Middle Name" = '' then
                                            Loan."Borrower Middle Name" := LoanJournalLine."Borrower Middle Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Middle Name" <> '' then
                                            Loan."Borrower Middle Name" := LoanJournalLine."Borrower Middle Name";
                                end;
                            //Title Customer No.
                            if LoanUpdateSchema."Field No." = 14 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Title Customer No." := LoanJournalLine."Title Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Title Customer No." = '' then
                                            Loan."Title Customer No." := LoanJournalLine."Title Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Title Customer No." <> '' then
                                            Loan."Title Customer No." := LoanJournalLine."Title Customer No.";
                                end;
                            //Investor Customer No.
                            if LoanUpdateSchema."Field No." = 15 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Investor Customer No." := LoanJournalLine."Investor Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Investor Customer No." = '' then
                                            Loan."Investor Customer No." := LoanJournalLine."Investor Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Investor Customer No." <> '' then
                                            Loan."Investor Customer No." := LoanJournalLine."Investor Customer No.";
                                end;
                            //Borrower Customer No.
                            if LoanUpdateSchema."Field No." = 16 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Borrower Customer No" := LoanJournalLine."Borrower Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Borrower Customer No" = '' then
                                            Loan."Borrower Customer No" := LoanJournalLine."Borrower Customer No.";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Customer No." <> '' then
                                            Loan."Borrower Customer No" := LoanJournalLine."Borrower Customer No.";
                                end;
                            //Alternative Loan No.
                            if LoanUpdateSchema."Field No." = 17 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Alternative Loan No." := LoanJournalLine."Alternative Loan No.";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Alternative Loan No." = '' then
                                            Loan."Alternative Loan No." := LoanJournalLine."Alternative Loan No.";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Alternative Loan No." <> '' then
                                            Loan."Alternative Loan No." := LoanJournalLine."Alternative Loan No.";
                                end;
                            //Application Date
                            if LoanUpdateSchema."Field No." = 20 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Application Date" := LoanJournalLine."Application Date";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Application Date" = 0D then
                                            Loan."Application Date" := LoanJournalLine."Application Date";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Application Date" <> 0D then
                                            Loan."Application Date" := LoanJournalLine."Application Date";
                                end;
                            //Date Closed
                            if LoanUpdateSchema."Field No." = 21 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Date Closed" := LoanJournalLine."Date Closed";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Date Closed" = 0D then
                                            Loan."Date Closed" := LoanJournalLine."Date Closed";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Date Closed" <> 0D then
                                            Loan."Date Closed" := LoanJournalLine."Date Closed";
                                end;
                            //Date Funded
                            if LoanUpdateSchema."Field No." = 22 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Date Funded" := LoanJournalLine."Date Funded";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Date Funded" = 0D then
                                            Loan."Date Funded" := LoanJournalLine."Date Funded";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Date Funded" <> 0D then
                                            Loan."Date Funded" := LoanJournalLine."Date Funded";
                                end;
                            //Date Sold
                            if LoanUpdateSchema."Field No." = 23 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Date Sold" := LoanJournalLine."Date Sold";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Date Sold" = 0D then
                                            Loan."Date Sold" := LoanJournalLine."Date Sold";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Date Sold" <> 0D then
                                            Loan."Date Sold" := LoanJournalLine."Date Sold";
                                end;
                            //Date Locked
                            if LoanUpdateSchema."Field No." = 24 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Date Locked" := LoanJournalLine."Date Locked";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Date Locked" = 0D then
                                            Loan."Date Locked" := LoanJournalLine."Date Locked";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Date Locked" <> 0D then
                                            Loan."Date Locked" := LoanJournalLine."Date Locked";
                                end;
                            //Loan Amount
                            if LoanUpdateSchema."Field No." = 25 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Loan Amount" := LoanJournalLine."Loan Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Loan Amount" = 0 then
                                            Loan."Loan Amount" := LoanJournalLine."Loan Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Loan Amount" <> 0 then
                                            Loan."Loan Amount" := LoanJournalLine."Loan Amount";
                                end;
                            //Blocked
                            if LoanUpdateSchema."Field No." = 26 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.Blocked := LoanJournalLine.Blocked;
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan.Blocked = false then
                                            Loan.Blocked := LoanJournalLine.Blocked;
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine.Blocked <> false then
                                            Loan.Blocked := LoanJournalLine.Blocked;
                                end;
                            //Warehouse Line Code
                            if LoanUpdateSchema."Field No." = 27 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Warehouse Line Code" := LoanJournalLine."Warehouse Line Code";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Warehouse Line Code" = '' then
                                            Loan."Warehouse Line Code" := LoanJournalLine."Warehouse Line Code";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Warehouse Line Code" <> '' then
                                            Loan."Warehouse Line Code" := LoanJournalLine."Warehouse Line Code";
                                end;
                            //Co-Borrower First Name
                            if LoanUpdateSchema."Field No." = 28 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Co-Borrower First Name" := LoanJournalLine."Co-Borrower First Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Co-Borrower First Name" = '' then
                                            Loan."Co-Borrower First Name" := LoanJournalLine."Co-Borrower First Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower First Name" <> '' then
                                            Loan."Co-Borrower First Name" := LoanJournalLine."Co-Borrower First Name";
                                end;
                            //Co-Borrower Last Name
                            if LoanUpdateSchema."Field No." = 29 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Co-Borrower Last Name" := LoanJournalLine."Co-Borrower Last Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Co-Borrower Last Name" = '' then
                                            Loan."Co-Borrower Last Name" := LoanJournalLine."Co-Borrower Last Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Last Name" <> '' then
                                            Loan."Co-Borrower Last Name" := LoanJournalLine."Co-Borrower Last Name";
                                end;
                            //Co-Borrower Middle Name
                            if LoanUpdateSchema."Field No." = 30 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Co-Borrower Middle Name" := LoanJournalLine."Co-Borrower Middle Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Co-Borrower Middle Name" = '' then
                                            Loan."Co-Borrower Middle Name" := LoanJournalLine."Co-Borrower Middle Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Middle Name" <> '' then
                                            Loan."Co-Borrower Middle Name" := LoanJournalLine."Co-Borrower Middle Name";
                                end;
                            //203K Contractor Name
                            if LoanUpdateSchema."Field No." = 31 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."203K Contractor Name" := LoanJournalLine."203K Contractor Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."203K Contractor Name" = '' then
                                            Loan."203K Contractor Name" := LoanJournalLine."203K Contractor Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."203K Contractor Name" <> '' then
                                            Loan."203K Contractor Name" := LoanJournalLine."203K Contractor Name";
                                end;
                            //203K Inspector Name
                            if LoanUpdateSchema."Field No." = 32 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."203K Inspector Name" := LoanJournalLine."203K Inspector Name";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."203K Inspector Name" = '' then
                                            Loan."203K Inspector Name" := LoanJournalLine."203K Inspector Name";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."203K Inspector Name" <> '' then
                                            Loan."203K Inspector Name" := LoanJournalLine."203K Inspector Name";
                                end;
                            //Dimension 1 Code
                            if LoanUpdateSchema."Field No." = 80 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Global Dimension 1 Code" = '' then
                                            Loan.validate("Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Global Dimension 1 Code" <> '' then
                                            Loan.validate("Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code");
                                end;
                            //Dimension 2 Code
                            if LoanUpdateSchema."Field No." = 81 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Global Dimension 2 Code" = '' then
                                            Loan.validate("Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Global Dimension 2 Code" <> '' then
                                            Loan.validate("Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code");
                                end;
                            //Dimension 3 Code
                            if LoanUpdateSchema."Field No." = 82 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 3 Code" = '' then
                                            Loan.validate("Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 3 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code");
                                end;
                            //Dimension 4 Code
                            if LoanUpdateSchema."Field No." = 83 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 4 Code" = '' then
                                            Loan.validate("Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 4 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code");
                                end;
                            //Dimension 5 Code
                            if LoanUpdateSchema."Field No." = 84 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 5 Code" = '' then
                                            Loan.validate("Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 5 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code");
                                end;
                            //Dimension 6 Code
                            if LoanUpdateSchema."Field No." = 85 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 6 Code" = '' then
                                            Loan.validate("Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 6 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code");
                                end;
                            //Dimension 7 Code
                            if LoanUpdateSchema."Field No." = 86 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 7 Code" = '' then
                                            Loan.validate("Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 7 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code");
                                end;
                            //Dimension 8 Code
                            if LoanUpdateSchema."Field No." = 87 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Shortcut Dimension 8 Code" = '' then
                                            Loan.validate("Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Shortcut Dimension 8 Code" <> '' then
                                            Loan.validate("Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code");
                                end;
                            //Business Unit Code
                            if LoanUpdateSchema."Field No." = 88 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan.validate("Business Unit Code", LoanJournalLine."Business Unit Code");
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Business Unit Code" = '' then
                                            Loan.validate("Business Unit Code", LoanJournalLine."Business Unit Code");
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Business Unit Code" <> '' then
                                            Loan.validate("Business Unit Code", LoanJournalLine."Business Unit Code");
                                end;
                            //Loan Term Months
                            if LoanUpdateSchema."Field No." = 100 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Loan Term (Months)" := LoanJournalLine."Loan Term (Months)";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Loan Term (Months)" = 0 then
                                            Loan."Loan Term (Months)" := LoanJournalLine."Loan Term (Months)";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Loan Term (Months)" <> 0 then
                                            Loan."Loan Term (Months)" := LoanJournalLine."Loan Term (Months)";
                                end;
                            //Interest Rate
                            if LoanUpdateSchema."Field No." = 101 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Interest Rate" := LoanJournalLine."Interest Rate";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Interest Rate" = 0 then
                                            Loan."Interest Rate" := LoanJournalLine."Interest Rate";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Interest Rate" <> 0 then
                                            Loan."Interest Rate" := LoanJournalLine."Interest Rate";
                                end;
                            //First Payment Due
                            if LoanUpdateSchema."Field No." = 102 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."First Payment Due" := LoanJournalLine."First Payment Due";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."First Payment Due" = 0D then
                                            Loan."First Payment Due" := LoanJournalLine."First Payment Due";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."First Payment Due" <> 0D then
                                            Loan."First Payment Due" := LoanJournalLine."First Payment Due";
                                end;
                            //First Payment Due to Investor
                            if LoanUpdateSchema."Field No." = 103 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."First Payment Due To Investor" := LoanJournalLine."First Payment Due To Investor";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."First Payment Due To Investor" = 0D then
                                            Loan."First Payment Due To Investor" := LoanJournalLine."First Payment Due To Investor";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."First Payment Due To Investor" <> 0D then
                                            Loan."First Payment Due To Investor" := LoanJournalLine."First Payment Due To Investor";
                                end;
                            //Next Payment Date
                            if LoanUpdateSchema."Field No." = 104 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Next Payment Date" := LoanJournalLine."Next Payment Date";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Next Payment Date" = 0D then
                                            Loan."Next Payment Date" := LoanJournalLine."Next Payment Date";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Next Payment Date" <> 0D then
                                            Loan."Next Payment Date" := LoanJournalLine."Next Payment Date";
                                end;
                            //Monthly Escrow Amount
                            if LoanUpdateSchema."Field No." = 105 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Monthly Escrow Amount" := LoanJournalLine."Monthly Escrow Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Monthly Escrow Amount" = 0 then
                                            Loan."Monthly Escrow Amount" := LoanJournalLine."Monthly Escrow Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Monthly Escrow Amount" <> 0 then
                                            Loan."Monthly Escrow Amount" := LoanJournalLine."Monthly Escrow Amount";
                                end;
                            //Monthly Payment Amount
                            if LoanUpdateSchema."Field No." = 106 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Monthly Payment Amount" := LoanJournalLine."Monthly Payment Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Monthly Payment Amount" = 0 then
                                            Loan."Monthly Payment Amount" := LoanJournalLine."Monthly Payment Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Monthly Payment Amount" <> 0 then
                                            Loan."Monthly Payment Amount" := LoanJournalLine."Monthly Payment Amount";
                                end;
                            //Servicing Late Fee
                            if LoanUpdateSchema."Field No." = 107 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Late Fee" := LoanJournalLine."Late Fee";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Late Fee" = 0 then
                                            Loan."Late Fee" := LoanJournalLine."Late Fee";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Late Fee" <> 0 then
                                            Loan."Late Fee" := LoanJournalLine."Late Fee";
                                end;
                            //Commission Base Amount
                            if LoanUpdateSchema."Field No." = 500 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Commission Base Amount" := LoanJournalLine."Commission Base Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Commission Base Amount" = 0 then
                                            Loan."Commission Base Amount" := LoanJournalLine."Commission Base Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Commission Base Amount" <> 0 then
                                            Loan."Commission Base Amount" := LoanJournalLine."Commission Base Amount";
                                end;
                            //Commission Date
                            if LoanUpdateSchema."Field No." = 501 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Commission Date" := LoanJournalLine."Commission Date";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Commission Date" = 0D then
                                            Loan."Commission Date" := LoanJournalLine."Commission Date";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Commission Date" <> 0D then
                                            Loan."Commission Date" := LoanJournalLine."Commission Date";
                                end;
                            //Commission Bps
                            if LoanUpdateSchema."Field No." = 502 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Commission Bps" := LoanJournalLine."Commission Bps";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Commission Bps" = 0 then
                                            Loan."Commission Bps" := LoanJournalLine."Commission Bps";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Commission Bps" <> 0 then
                                            Loan."Commission Bps" := LoanJournalLine."Commission Bps";
                                end;
                            //Commission Value
                            if LoanUpdateSchema."Field No." = 503 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Commission Amount" := LoanJournalLine."Commission Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Commission Amount" = 0 then
                                            Loan."Commission Amount" := LoanJournalLine."Commission Amount";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Commission Amount" <> 0 then
                                            Loan."Commission Amount" := LoanJournalLine."Commission Amount";
                                end;
                            //Construction Interest Rate
                            if LoanUpdateSchema."Field No." = 600 then
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        Loan."Constr. Interest Rate" := LoanJournalLine."Constr. Interest Rate";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if Loan."Constr. Interest Rate" = 0 then
                                            Loan."Constr. Interest Rate" := LoanJournalLine."Constr. Interest Rate";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Constr. Interest Rate" <> 0 then
                                            Loan."Constr. Interest Rate" := LoanJournalLine."Constr. Interest Rate";
                                end;
                            //Borrower
                            if LoanUpdateSchema."Field No." = 200 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.Address := LoanJournalLine."Borrower Address";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.Address = '' then
                                            LoanAddress.Address := LoanJournalLine."Borrower Address";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Address" <> '' then
                                            LoanAddress.Address := LoanJournalLine."Borrower Address";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 201 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."Address 2" := LoanJournalLine."Borrower Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."Address 2" = '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Borrower Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Address" <> '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Borrower Address 2";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 202 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.City := LoanJournalLine."Borrower City";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.City = '' then
                                            LoanAddress.City := LoanJournalLine."Borrower City";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Address" <> '' then
                                            LoanAddress.City := LoanJournalLine."Borrower City";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 203 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.State := LoanJournalLine."Borrower State";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.State = '' then
                                            LoanAddress.State := LoanJournalLine."Borrower State";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Address" <> '' then
                                            LoanAddress.State := LoanJournalLine."Borrower State";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 204 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."ZIP Code" := LoanJournalLine."Borrower ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."ZIP Code" = '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Borrower ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Borrower Address" <> '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Borrower ZIP Code";
                                end;
                                LoanAddress.Modify();
                            end;
                            //CoBorrower
                            if LoanUpdateSchema."Field No." = 210 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.Address := LoanJournalLine."Co-Borrower Address";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.Address = '' then
                                            LoanAddress.Address := LoanJournalLine."Co-Borrower Address";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Address" <> '' then
                                            LoanAddress.Address := LoanJournalLine."Co-Borrower Address";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 211 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."Address 2" := LoanJournalLine."Co-Borrower Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."Address 2" = '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Co-Borrower Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Address" <> '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Co-Borrower Address 2";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 212 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.City := LoanJournalLine."Co-Borrower City";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.City = '' then
                                            LoanAddress.City := LoanJournalLine."Co-Borrower City";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Address" <> '' then
                                            LoanAddress.City := LoanJournalLine."Co-Borrower City";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 213 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.State := LoanJournalLine."Co-Borrower State";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.State = '' then
                                            LoanAddress.State := LoanJournalLine."Co-Borrower State";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Address" <> '' then
                                            LoanAddress.State := LoanJournalLine."Co-Borrower State";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 214 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."ZIP Code" := LoanJournalLine."Co-Borrower ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."ZIP Code" = '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Co-Borrower ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Co-Borrower Address" <> '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Co-Borrower ZIP Code";
                                end;
                                LoanAddress.Modify();
                            end;
                            //Property
                            if LoanUpdateSchema."Field No." = 220 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
                                    LoanAddress.Insert();

                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.Address := LoanJournalLine."Property Address";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.Address = '' then
                                            LoanAddress.Address := LoanJournalLine."Property Address";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Property Address" <> '' then
                                            LoanAddress.Address := LoanJournalLine."Property Address";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 221 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."Address 2" := LoanJournalLine."Property Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."Address 2" = '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Property Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Property Address" <> '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Property Address 2";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 222 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.City := LoanJournalLine."Property City";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.City = '' then
                                            LoanAddress.City := LoanJournalLine."Property City";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Property Address" <> '' then
                                            LoanAddress.City := LoanJournalLine."Property City";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 223 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.State := LoanJournalLine."Property State";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.State = '' then
                                            LoanAddress.State := LoanJournalLine."Property State";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Property Address" <> '' then
                                            LoanAddress.State := LoanJournalLine."Property State";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 224 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."ZIP Code" := LoanJournalLine."Property ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."ZIP Code" = '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Property ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Property Address" <> '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Property ZIP Code";
                                end;
                                LoanAddress.Modify();
                            end;
                            //Mailing
                            if LoanUpdateSchema."Field No." = 230 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.Address := LoanJournalLine."Mailing Address";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.Address = '' then
                                            LoanAddress.Address := LoanJournalLine."Mailing Address";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Mailing Address" <> '' then
                                            LoanAddress.Address := LoanJournalLine."Mailing Address";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 231 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."Address 2" := LoanJournalLine."Mailing Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."Address 2" = '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Mailing Address 2";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Mailing Address" <> '' then
                                            LoanAddress."Address 2" := LoanJournalLine."Mailing Address 2";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 232 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.City := LoanJournalLine."Mailing City";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.City = '' then
                                            LoanAddress.City := LoanJournalLine."Mailing City";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Mailing Address" <> '' then
                                            LoanAddress.City := LoanJournalLine."Mailing City";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 233 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress.State := LoanJournalLine."Mailing State";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress.State = '' then
                                            LoanAddress.State := LoanJournalLine."Mailing State";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Mailing Address" <> '' then
                                            LoanAddress.State := LoanJournalLine."Mailing State";
                                end;
                                LoanAddress.Modify();
                            end;
                            if LoanUpdateSchema."Field No." = 234 then begin
                                if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
                                    Clear(LoanAddress);
                                    LoanAddress."Loan No." := LoanJournalLine."Loan No.";
                                    LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
                                    LoanAddress.Insert();
                                end;
                                case LoanUpdateSchema."Field Update Option" of
                                    LoanUpdateSchema."Field Update Option"::lvngAlways:
                                        LoanAddress."ZIP Code" := LoanJournalLine."Mailing ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Destination Blank":
                                        if LoanAddress."ZIP Code" = '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Mailing ZIP Code";
                                    LoanUpdateSchema."Field Update Option"::"If Source Not Blank":
                                        if LoanJournalLine."Mailing Address" <> '' then
                                            LoanAddress."ZIP Code" := LoanJournalLine."Mailing ZIP Code";
                                end;
                                LoanAddress.Modify();
                            end;
                            Loan.modify(true);
                        end;
                end;
            until LoanUpdateSchema.Next() = 0;
        Loan.Modify(true);
    end;

    procedure UpdateLoanCard(LoanJournalLine: Record lvngLoanJournalLine)
    var
        LoanJournalValue: record lvngLoanJournalValue;
        LoanValue: Record lvngLoanValue;
        Loan: Record lvngLoan;
        LoanAddress: Record lvngLoanAddress;
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if LoanJournalLine."Loan No." = '' then
            exit;
        if not Loan.Get(LoanJournalLine."Loan No.") then begin
            Clear(Loan);
            Loan."No." := LoanJournalLine."Loan No.";
            Loan.Insert(true);
        end;
        Loan."Search Name" := LoanJournalLine."Search Name";
        Loan."Borrower First Name" := LoanJournalLine."Borrower First Name";
        Loan."Borrower Last Name" := LoanJournalLine."Borrower Last Name";
        Loan."Borrower Middle Name" := LoanJournalLine."Borrower Middle Name";
        Loan."Alternative Loan No." := LoanJournalLine."Alternative Loan No.";
        Loan."Application Date" := LoanJournalLine."Application Date";
        Loan.Blocked := LoanJournalLine.Blocked;
        Loan."Borrower Customer No" := LoanJournalLine."Borrower Customer No.";
        Loan."Business Unit Code" := LoanJournalLine."Business Unit Code";
        Loan."Commission Base Amount" := LoanJournalLine."Commission Base Amount";
        Loan."Commission Date" := LoanJournalLine."Commission Date";
        Loan."Constr. Interest Rate" := LoanJournalLine."Constr. Interest Rate";
        Loan."Date Closed" := LoanJournalLine."Date Closed";
        Loan."Date Funded" := LoanJournalLine."Date Funded";
        Loan."Date Locked" := LoanJournalLine."Date Locked";
        Loan."Date Sold" := LoanJournalLine."Date Sold";
        Loan."First Payment Due" := LoanJournalLine."First Payment Due";
        Loan."First Payment Due To Investor" := LoanJournalLine."First Payment Due To Investor";
        Loan.Validate("Global Dimension 1 Code", LoanJournalLine."Global Dimension 1 Code");
        Loan.Validate("Global Dimension 2 Code", LoanJournalLine."Global Dimension 2 Code");
        Loan."Interest Rate" := LoanJournalLine."Interest Rate";
        Loan."Investor Customer No." := LoanJournalLine."Investor Customer No.";
        Loan."Loan Amount" := LoanJournalLine."Loan Amount";
        Loan."Loan Term (Months)" := LoanJournalLine."Loan Term (Months)";
        Loan."Monthly Escrow Amount" := LoanJournalLine."Monthly Escrow Amount";
        Loan."Monthly Payment Amount" := LoanJournalLine."Monthly Payment Amount";
        Loan.Validate("Shortcut Dimension 3 Code", LoanJournalLine."Shortcut Dimension 3 Code");
        Loan.Validate("Shortcut Dimension 4 Code", LoanJournalLine."Shortcut Dimension 4 Code");
        Loan.Validate("Shortcut Dimension 5 Code", LoanJournalLine."Shortcut Dimension 5 Code");
        Loan.Validate("Shortcut Dimension 6 Code", LoanJournalLine."Shortcut Dimension 6 Code");
        Loan.Validate("Shortcut Dimension 7 Code", LoanJournalLine."Shortcut Dimension 7 Code");
        Loan.Validate("Shortcut Dimension 8 Code", LoanJournalLine."Shortcut Dimension 8 Code");
        Loan."Title Customer No." := LoanJournalLine."Title Customer No.";
        Loan."Warehouse Line Code" := LoanJournalLine."Warehouse Line Code";
        Loan."Co-Borrower First Name" := LoanJournalLine."Co-Borrower First Name";
        Loan."Co-Borrower Last Name" := LoanJournalLine."Co-Borrower Last Name";
        Loan."Co-Borrower Middle Name" := LoanJournalLine."Co-Borrower Middle Name";
        Loan."203K Contractor Name" := LoanJournalLine."203K Contractor Name";
        Loan."203K Inspector Name" := LoanJournalLine."203K Inspector Name";
        if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Borrower) then begin
            Clear(LoanAddress);
            LoanAddress."Loan No." := LoanJournalLine."Loan No.";
            LoanAddress."Address Type" := LoanAddress."Address Type"::Borrower;
            LoanAddress.Insert();
        end;
        LoanAddress.Address := LoanJournalLine."Borrower Address";
        LoanAddress."Address 2" := LoanJournalLine."Borrower Address 2";
        LoanAddress.City := LoanJournalLine."Borrower City";
        LoanAddress.State := LoanJournalLine."Borrower State";
        LoanAddress."ZIP Code" := LoanJournalLine."Borrower ZIP Code";
        LoanAddress.Modify();
        if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::CoBorrower) then begin
            Clear(LoanAddress);
            LoanAddress."Loan No." := LoanJournalLine."Loan No.";
            LoanAddress."Address Type" := LoanAddress."Address Type"::CoBorrower;
            LoanAddress.Insert();
        end;
        LoanAddress.Address := LoanJournalLine."Co-Borrower Address";
        LoanAddress."Address 2" := LoanJournalLine."Co-Borrower Address 2";
        LoanAddress.City := LoanJournalLine."Co-Borrower City";
        LoanAddress.State := LoanJournalLine."Co-Borrower State";
        LoanAddress."ZIP Code" := LoanJournalLine."Co-Borrower ZIP Code";
        LoanAddress.Modify();
        if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Mailing) then begin
            Clear(LoanAddress);
            LoanAddress."Loan No." := LoanJournalLine."Loan No.";
            LoanAddress."Address Type" := LoanAddress."Address Type"::Mailing;
            LoanAddress.Insert();
        end;
        LoanAddress.Address := LoanJournalLine."Mailing Address";
        LoanAddress."Address 2" := LoanJournalLine."Mailing Address 2";
        LoanAddress.City := LoanJournalLine."Mailing City";
        LoanAddress.State := LoanJournalLine."Mailing State";
        LoanAddress."ZIP Code" := LoanJournalLine."Mailing ZIP Code";
        LoanAddress.Modify();
        if not LoanAddress.Get(LoanJournalLine."Loan No.", LoanAddress."Address Type"::Property) then begin
            Clear(LoanAddress);
            LoanAddress."Loan No." := LoanJournalLine."Loan No.";
            LoanAddress."Address Type" := LoanAddress."Address Type"::Property;
            LoanAddress.Insert();
        end;
        LoanAddress.Address := LoanJournalLine."Property Address";
        LoanAddress."Address 2" := LoanJournalLine."Property Address 2";
        LoanAddress.City := LoanJournalLine."Property City";
        LoanAddress.State := LoanJournalLine."Property State";
        LoanAddress."ZIP Code" := LoanJournalLine."Property ZIP Code";
        LoanAddress.Modify();
        LoanJournalValue.Reset();
        LoanJournalValue.SetRange("Loan Journal Batch Code", LoanJournalLine."Loan Journal Batch Code");
        LoanJournalValue.SetRange("Line No.", LoanJournalLine."Line No.");
        if LoanJournalValue.FindSet() then
            repeat
                if LoanValue.Get(LoanJournalLine."Loan No.", LoanJournalValue."Field No.") then begin
                    LoanValue."Field Value" := LoanJournalValue."Field Value";
                    EvaluateLoanFieldsValue(LoanValue, true);
                    LoanValue.Modify();
                end else begin
                    Clear(LoanValue);
                    LoanValue."Loan No." := LoanJournalLine."Loan No.";
                    LoanValue."Field No." := LoanJournalValue."Field No.";
                    LoanValue."Field Value" := LoanJournalValue."Field Value";
                    EvaluateLoanFieldsValue(LoanValue, true);
                    LoanValue.Insert();
                end;
            until LoanJournalValue.Next() = 0;
        Loan.Modify(true);
    end;

    procedure EvaluateLoanFieldsValue(var LoanValue: Record lvngLoanValue; FillBuffer: Boolean)
    begin
        if FillBuffer then begin
            FillLoanFieldsConfigurationBuffer();
            if not TempLoanFieldsConfiguration.Get(LoanValue."Field No.") then
                exit;
        end else begin
            LoanFieldsConfiguration.Get(LoanValue."Field No.");
            TempLoanFieldsConfiguration := LoanFieldsConfiguration;
        end;
        case TempLoanFieldsConfiguration."Value Type" of
            TempLoanFieldsConfiguration."Value Type"::Boolean:
                if Evaluate(LoanValue."Boolean Value", LoanValue."Field Value") then
                    ;
            TempLoanFieldsConfiguration."Value Type"::Date:
                if Evaluate(LoanValue."Date Value", LoanValue."Field Value") then
                    ;
            TempLoanFieldsConfiguration."Value Type"::Decimal:
                if Evaluate(LoanValue."Decimal Value", LoanValue."Field Value") then
                    ;
            TempLoanFieldsConfiguration."Value Type"::Integer:
                if Evaluate(LoanValue."Integer Value", LoanValue."Field Value") then
                    ;
        end;
    end;

    procedure CopyImportSchemaToUpdateSchema(JournalBatchCode: Code[20])
    var
        LoanJournalBatch: Record lvngLoanJournalBatch;
        LoanImportSchema: Record lvngLoanImportSchema;
        LoanImportSchemaLine: Record lvngLoanImportSchemaLine;
        LoanUpdateSchema: Record lvngLoanUpdateSchema;
        ClearTableErr: Label 'Please remove existing schema lines prior to copying';
    begin
        LoanJournalBatch.Get(JournalBatchCode);
        LoanUpdateSchema.Reset();
        LoanUpdateSchema.SetRange("Journal Batch Code", JournalBatchCode);
        if not LoanUpdateSchema.IsEmpty() then
            Error(ClearTableErr);
        if Page.RunModal(0, LoanImportSchema) = Action::LookupOK then begin
            LoanImportSchemaLine.Reset();
            LoanImportSchemaLine.SetRange(Code, LoanImportSchema.Code);
            LoanImportSchemaLine.SetFilter("Field Type", '<>%1', LoanImportSchemaLine."Field Type"::Dummy);
            if LoanImportSchemaLine.FindSet() then
                repeat
                    Clear(LoanUpdateSchema);
                    LoanUpdateSchema."Journal Batch Code" := JournalBatchCode;
                    LoanUpdateSchema."Import Field Type" := LoanImportSchemaLine."Field Type";
                    LoanUpdateSchema."Field No." := LoanImportSchemaLine."Field No.";
                    LoanUpdateSchema."Field Update Option" := LoanUpdateSchema."Field Update Option"::lvngAlways;
                    LoanUpdateSchema.Insert();
                until LoanImportSchemaLine.Next() = 0;
            LoanUpdateSchema.Reset();
            LoanUpdateSchema.SetRange("Journal Batch Code", JournalBatchCode);
            LoanUpdateSchema.SetRange("Field No.", 1, 4);
            LoanUpdateSchema.DeleteAll();
            LoanUpdateSchema.SetRange("Field No.", 5000, 999999999);
            LoanUpdateSchema.DeleteAll();
            Message(CompletedMsg);
        end;
    end;

    procedure ModifyFieldUpdateOption(JournalBatchCode: code[20]; FieldUpdateOption: Enum lvngFieldUpdateCondition)
    var
        LoanUpdateSchema: Record lvngLoanUpdateSchema;
        ConfirmModificationQst: Label 'Do You want to update all entries to %1 update option?';
    begin
        if Confirm(ConfirmModificationQst, false, FieldUpdateOption) then begin
            LoanUpdateSchema.Reset();
            LoanUpdateSchema.SetRange("Journal Batch Code", JournalBatchCode);
            LoanUpdateSchema.ModifyAll("Field Update Option", FieldUpdateOption);
            Message(CompletedMsg);
        end;
    end;

    procedure GetFieldName(FieldNo: Integer): Text
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if not LoanFieldsConfiguration.Get(FieldNo) then
            exit('ERROR');
        exit(LoanFieldsConfiguration."Field Name");
    end;

    local procedure FillLoanFieldsConfigurationBuffer()
    begin
        if not LoanFieldsConfigurationRetrieved then begin
            LoanFieldsConfigurationRetrieved := true;
            LoanFieldsConfiguration.reset;
            if LoanFieldsConfiguration.FindSet() then begin
                repeat
                    Clear(TempLoanFieldsConfiguration);
                    TempLoanFieldsConfiguration := LoanFieldsConfiguration;
                    TempLoanFieldsConfiguration.Insert();
                until LoanFieldsConfiguration.Next() = 0;
            end;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetupRetrieved := true;
            LoanVisionSetup.Get();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', true, true)]
    local procedure OnDimensionAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption)
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::lvngLoan);
    end;
}