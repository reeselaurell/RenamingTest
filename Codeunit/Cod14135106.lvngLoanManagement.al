codeunit 14135106 "lvngLoanManagement"
{
    procedure LoanNumberBatch(lvngLoanNo: Code[20]; lvngLoanNoMatchPattern: Record lvngLoanNoMatchPattern): Boolean
    begin
        if lvngLoanNoMatchPattern.lvngMaxFieldLength > 0 then
            if strlen(lvngLoanNo) > lvngLoanNoMatchPattern.lvngMaxFieldLength then
                exit(false);
        if lvngLoanNoMatchPattern.lvngMinFieldLength <> 0 then
            if lvngLoanNoMatchPattern.lvngMinFieldLength > strlen(lvngLoanNo) then
                exit(false);
        //TODO: Issues with Regex not available in Codeunit 10. Requires implementation
        exit(true);
    end;

    procedure UpdateLoans(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanUpdateSchema: Record lvngLoanUpdateSchema;
        lvngLoanUpdateSchemaTemp: Record lvngLoanUpdateSchema temporary;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        Window: Dialog;
        lvngProgressLbl: Label 'Processing #1########### of #2###########';
        lvngProcessedLbl: Label '%1 of %2 Loans Processed';
        lvngCounter: Integer;
        lvngProcessedCount: Integer;

    begin
        GetLoanVisionSetup();
        lvngLoanJournalBatch.Get(lvngJournalBatchCode);
        if lvngLoanJournalBatch."Loan Card Update Option" = lvngLoanJournalBatch."Loan Card Update Option"::lvngSchema then begin
            lvngLoanUpdateSchema.reset;
            lvngLoanUpdateSchema.SetRange("Journal Batch Code", lvngJournalBatchCode);
            lvngLoanUpdateSchema.FindSet();
            repeat
                Clear(lvngLoanUpdateSchemaTemp);
                lvngLoanUpdateSchemaTemp := lvngLoanUpdateSchema;
                lvngLoanUpdateSchemaTemp.Insert();
            until lvngLoanUpdateSchema.Next() = 0;
        end;
        lvngLoanJournalLine.reset;
        lvngLoanJournalLine.SetRange("Loan Journal Batch Code", lvngJournalBatchCode);
        if lvngLoanJournalBatch."Loan Journal Type" = lvngLoanJournalBatch."Loan Journal Type"::lvngFunded then begin
            if lvngLoanVisionSetup."Funded Void Reason Code" <> '' then begin
                lvngLoanJournalLine.SetFilter("Reason Code", '<>%1', lvngLoanVisionSetup."Funded Void Reason Code");
            end;
        end;
        if lvngLoanJournalBatch."Loan Journal Type" = lvngLoanJournalBatch."Loan Journal Type"::lvngSold then begin
            if lvngLoanVisionSetup."Sold Void Reason Code" <> '' then begin
                lvngLoanJournalLine.SetFilter("Reason Code", '<>%1', lvngLoanVisionSetup."Sold Void Reason Code");
            end;
        end;
        if lvngLoanJournalLine.FindSet() then begin
            if GuiAllowed() then begin
                Window.Open(lvngProgressLbl);
                Window.Update(2, lvngLoanJournalLine.Count());
            end;
            repeat
                lvngCounter := lvngCounter + 1;
                if GuiAllowed() then
                    Window.Update(1, lvngCounter);
                if not lvngLoanJournalErrorMgmt.HasError(lvngLoanJournalLine) then begin
                    case lvngLoanJournalBatch."Loan Card Update Option" of
                        lvngloanjournalbatch."Loan Card Update Option"::lvngAlways:
                            UpdateLoanCard(lvngLoanJournalLine);
                        lvngloanjournalbatch."Loan Card Update Option"::lvngSchema:
                            UpdateLoan(lvngLoanJournalLine, lvngLoanUpdateSchemaTemp);
                    end;
                    lvngProcessedCount := lvngProcessedCount + 1;
                    lvngLoanJournalLine.Mark(true);
                end;
            until lvngLoanJournalLine.Next() = 0;

            lvngLoanJournalLine.MarkedOnly(true);
            lvngLoanJournalLine.DeleteAll(true);
            if GuiAllowed() then begin
                Window.Close();
                Message(lvngProcessedLbl, lvngProcessedCount, lvngCounter);
            end;

        end;
    end;

    procedure UpdateLoan(lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLoanUpdateSchema: record lvngLoanUpdateSchema)
    var
        lvngLoanJournalValue: record lvngLoanJournalValue;
        lvngLoanValue: Record lvngLoanValue;
        lvngLoan: Record lvngLoan;
        lvngLoanAddress: Record lvngLoanAddress;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if lvngLoanJournalLine."Loan No." = '' then
            exit;

        if not lvngLoan.Get(lvngLoanJournalLine."Loan No.") then begin
            Clear(lvngLoan);
            lvngloan."No." := lvngLoanJournalLine."Loan No.";
            lvngLoan.Insert(true);
        end;
        lvngLoanUpdateSchema.reset;
        if lvngLoanUpdateSchema.FindSet() then begin
            repeat
                case lvngLoanUpdateSchema."Import Field Type" of
                    lvngloanupdateschema."Import Field Type"::lvngVariable:
                        begin
                            if lvngLoanJournalValue.Get(lvngLoanJournalLine."Loan Journal Batch Code", lvngLoanJournalLine."Line No.", lvngLoanUpdateSchema."Field No.") then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine."Loan No.", lvngLoanUpdateSchema."Field No.") then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue."Loan No." := lvngLoanJournalLine."Loan No.";
                                                lvngLoanValue."Field No." := lvngLoanUpdateSchema."Field No.";
                                                lvngLoanValue.Insert();
                                            end;
                                            lvngLoanValue.Validate("Field Value", lvngLoanJournalValue."Field Value");
                                            lvngLoanValue.Modify();
                                        end;
                                    lvngloanupdateschema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine."Loan No.", lvngLoanUpdateSchema."Field No.") then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue."Loan No." := lvngLoanJournalLine."Loan No.";
                                                lvngLoanValue."Field No." := lvngLoanUpdateSchema."Field No.";
                                                lvngLoanValue.Insert();
                                            end;
                                            if lvngLoanValue."Field Value" = '' then begin
                                                lvngLoanValue.Validate("Field Value", lvngLoanJournalValue."Field Value");
                                                lvngLoanValue.Modify();
                                            end;
                                        end;
                                    lvngloanupdateschema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine."Loan No.", lvngLoanUpdateSchema."Field No.") then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue."Loan No." := lvngLoanJournalLine."Loan No.";
                                                lvngLoanValue."Field No." := lvngLoanUpdateSchema."Field No.";
                                                lvngLoanValue.Insert();
                                            end;
                                            if lvngLoanJournalValue."Field Value" = '' then begin
                                                lvngLoanValue.Validate("Field Value", lvngLoanJournalValue."Field Value");
                                                lvngLoanValue.Modify();
                                            end;
                                        end;
                                end;
                            end;
                        end;
                    lvngloanupdateschema."Import Field Type"::lvngTable:
                        begin
                            //Search Name
                            if lvngLoanUpdateSchema."Field No." = 10 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Search Name" := lvngLoanJournalLine."Search Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Search Name" = '' then
                                                lvngloan."Search Name" := lvngLoanJournalLine."Search Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Search Name" <> '' then begin
                                                lvngLoan."Search Name" := lvngLoanJournalLine."Search Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower First Name
                            if lvngLoanUpdateSchema."Field No." = 11 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Borrower First Name" := lvngLoanJournalLine."Borrower First Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Borrower First Name" = '' then
                                                lvngloan."Borrower First Name" := lvngLoanJournalLine."Borrower First Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower First Name" <> '' then begin
                                                lvngLoan."Borrower First Name" := lvngLoanJournalLine."Borrower First Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Last Name
                            if lvngLoanUpdateSchema."Field No." = 12 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Borrower Last Name" := lvngLoanJournalLine."Borrower Last Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Borrower Last Name" = '' then
                                                lvngloan."Borrower Last Name" := lvngLoanJournalLine."Borrower Last Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Last Name" <> '' then begin
                                                lvngLoan."Borrower Last Name" := lvngLoanJournalLine."Borrower Last Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Middle Name
                            if lvngLoanUpdateSchema."Field No." = 13 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Borrower Middle Name" := lvngLoanJournalLine."Borrower Middle Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Borrower Middle Name" = '' then
                                                lvngloan."Borrower Middle Name" := lvngLoanJournalLine."Borrower Middle Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Middle Name" <> '' then begin
                                                lvngLoan."Borrower Middle Name" := lvngLoanJournalLine."Borrower Middle Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Title Customer No.
                            if lvngLoanUpdateSchema."Field No." = 14 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Title Customer No." := lvngLoanJournalLine."Title Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Title Customer No." = '' then
                                                lvngloan."Title Customer No." := lvngLoanJournalLine."Title Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Title Customer No." <> '' then begin
                                                lvngLoan."Title Customer No." := lvngLoanJournalLine."Title Customer No.";
                                            end;
                                        end;
                                end;
                            end;
                            //Investor Customer No.
                            if lvngLoanUpdateSchema."Field No." = 15 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Investor Customer No." := lvngLoanJournalLine."Investor Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Investor Customer No." = '' then
                                                lvngloan."Investor Customer No." := lvngLoanJournalLine."Investor Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Investor Customer No." <> '' then begin
                                                lvngLoan."Investor Customer No." := lvngLoanJournalLine."Investor Customer No.";
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Customer No.
                            if lvngLoanUpdateSchema."Field No." = 16 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Borrower Customer No" := lvngLoanJournalLine."Borrower Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Borrower Customer No" = '' then
                                                lvngloan."Borrower Customer No" := lvngLoanJournalLine."Borrower Customer No.";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Customer No." <> '' then begin
                                                lvngLoan."Borrower Customer No" := lvngLoanJournalLine."Borrower Customer No.";
                                            end;
                                        end;
                                end;
                            end;
                            //Application Date
                            if lvngLoanUpdateSchema."Field No." = 20 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Application Date" := lvngLoanJournalLine."Application Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Application Date" = 0D then
                                                lvngloan."Application Date" := lvngLoanJournalLine."Application Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Application Date" <> 0D then begin
                                                lvngLoan."Application Date" := lvngLoanJournalLine."Application Date";
                                            end;
                                        end;
                                end;
                            end;
                            //Date Closed
                            if lvngLoanUpdateSchema."Field No." = 21 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Date Closed" := lvngLoanJournalLine."Date Closed";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Date Closed" = 0D then
                                                lvngloan."Date Closed" := lvngLoanJournalLine."Date Closed";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Date Closed" <> 0D then begin
                                                lvngLoan."Date Closed" := lvngLoanJournalLine."Date Closed";
                                            end;
                                        end;
                                end;
                            end;
                            //Date Funded
                            if lvngLoanUpdateSchema."Field No." = 22 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Date Funded" := lvngLoanJournalLine."Date Funded";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Date Funded" = 0D then
                                                lvngloan."Date Funded" := lvngLoanJournalLine."Date Funded";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Date Funded" <> 0D then begin
                                                lvngLoan."Date Funded" := lvngLoanJournalLine."Date Funded";
                                            end;
                                        end;
                                end;
                            end;
                            //Date Sold
                            if lvngLoanUpdateSchema."Field No." = 23 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Date Sold" := lvngLoanJournalLine."Date Sold";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Date Sold" = 0D then
                                                lvngloan."Date Sold" := lvngLoanJournalLine."Date Sold";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Date Sold" <> 0D then begin
                                                lvngLoan."Date Sold" := lvngLoanJournalLine."Date Sold";
                                            end;
                                        end;
                                end;
                            end;
                            //Date Locked
                            if lvngLoanUpdateSchema."Field No." = 24 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Date Locked" := lvngLoanJournalLine."Date Locked";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Date Locked" = 0D then
                                                lvngloan."Date Locked" := lvngLoanJournalLine."Date Locked";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Date Locked" <> 0D then begin
                                                lvngLoan."Date Locked" := lvngLoanJournalLine."Date Locked";
                                            end;
                                        end;
                                end;
                            end;
                            //Loan Amount
                            if lvngLoanUpdateSchema."Field No." = 25 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Loan Amount" := lvngLoanJournalLine."Loan Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Loan Amount" = 0 then
                                                lvngloan."Loan Amount" := lvngLoanJournalLine."Loan Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Loan Amount" <> 0 then begin
                                                lvngLoan."Loan Amount" := lvngLoanJournalLine."Loan Amount";
                                            end;
                                        end;
                                end;
                            end;
                            //Blocked
                            if lvngLoanUpdateSchema."Field No." = 26 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.Blocked := lvngLoanJournalLine.Blocked;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.Blocked = false then
                                                lvngloan.Blocked := lvngLoanJournalLine.Blocked;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.Blocked <> false then begin
                                                lvngLoan.Blocked := lvngLoanJournalLine.Blocked;
                                            end;
                                        end;
                                end;
                            end;
                            //Warehouse Line Code
                            if lvngLoanUpdateSchema."Field No." = 27 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Warehouse Line Code" := lvngLoanJournalLine."Warehouse Line Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Warehouse Line Code" = '' then
                                                lvngloan."Warehouse Line Code" := lvngLoanJournalLine."Warehouse Line Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Warehouse Line Code" <> '' then begin
                                                lvngLoan."Warehouse Line Code" := lvngLoanJournalLine."Warehouse Line Code";
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower First Name
                            if lvngLoanUpdateSchema."Field No." = 28 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Co-Borrower First Name" := lvngLoanJournalLine."Co-Borrower First Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Co-Borrower First Name" = '' then
                                                lvngloan."Co-Borrower First Name" := lvngLoanJournalLine."Co-Borrower First Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower First Name" <> '' then begin
                                                lvngLoan."Co-Borrower First Name" := lvngLoanJournalLine."Co-Borrower First Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower Last Name
                            if lvngLoanUpdateSchema."Field No." = 29 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Co-Borrower Last Name" := lvngLoanJournalLine."Co-Borrower Last Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Co-Borrower Last Name" = '' then
                                                lvngloan."Co-Borrower Last Name" := lvngLoanJournalLine."Co-Borrower Last Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Last Name" <> '' then begin
                                                lvngLoan."Co-Borrower Last Name" := lvngLoanJournalLine."Co-Borrower Last Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower Middle Name
                            if lvngLoanUpdateSchema."Field No." = 30 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Co-Borrower Middle Name" := lvngLoanJournalLine."Co-Borrower Middle Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Co-Borrower Middle Name" = '' then
                                                lvngloan."Co-Borrower Middle Name" := lvngLoanJournalLine."Co-Borrower Middle Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Middle Name" <> '' then begin
                                                lvngLoan."Co-Borrower Middle Name" := lvngLoanJournalLine."Co-Borrower Middle Name";
                                            end;
                                        end;
                                end;
                            end;
                            //203K Contractor Name
                            if lvngLoanUpdateSchema."Field No." = 31 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."203K Contractor Name" := lvngLoanJournalLine."203K Contractor Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."203K Contractor Name" = '' then
                                                lvngloan."203K Contractor Name" := lvngLoanJournalLine."203K Contractor Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."203K Contractor Name" <> '' then begin
                                                lvngLoan."203K Contractor Name" := lvngLoanJournalLine."203K Contractor Name";
                                            end;
                                        end;
                                end;
                            end;
                            //203K Inspector Name
                            if lvngLoanUpdateSchema."Field No." = 32 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."203K Inspector Name" := lvngLoanJournalLine."203K Inspector Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."203K Inspector Name" = '' then
                                                lvngloan."203K Inspector Name" := lvngLoanJournalLine."203K Inspector Name";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."203K Inspector Name" <> '' then begin
                                                lvngLoan."203K Inspector Name" := lvngLoanJournalLine."203K Inspector Name";
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 1 Code
                            if lvngLoanUpdateSchema."Field No." = 80 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Global Dimension 1 Code" = '' then
                                                lvngLoan.validate("Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Global Dimension 1 Code" <> '' then begin
                                                lvngLoan.validate("Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 2 Code
                            if lvngLoanUpdateSchema."Field No." = 81 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Global Dimension 2 Code" = '' then
                                                lvngLoan.validate("Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Global Dimension 2 Code" <> '' then begin
                                                lvngLoan.validate("Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 3 Code
                            if lvngLoanUpdateSchema."Field No." = 82 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 3 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 3 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 4 Code
                            if lvngLoanUpdateSchema."Field No." = 83 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 4 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 4 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 5 Code
                            if lvngLoanUpdateSchema."Field No." = 84 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 5 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 5 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 6 Code
                            if lvngLoanUpdateSchema."Field No." = 85 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 6 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 6 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 7 Code
                            if lvngLoanUpdateSchema."Field No." = 86 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 7 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 7 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 8 Code
                            if lvngLoanUpdateSchema."Field No." = 87 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Shortcut Dimension 8 Code" = '' then
                                                lvngLoan.validate("Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Shortcut Dimension 8 Code" <> '' then begin
                                                lvngLoan.validate("Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Business Unit Code
                            if lvngLoanUpdateSchema."Field No." = 88 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan.validate("Business Unit Code", lvngLoanJournalLine."Business Unit Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Business Unit Code" = '' then
                                                lvngLoan.validate("Business Unit Code", lvngLoanJournalLine."Business Unit Code");
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Business Unit Code" <> '' then begin
                                                lvngLoan.validate("Business Unit Code", lvngLoanJournalLine."Business Unit Code");
                                            end;
                                        end;
                                end;
                            end;
                            //Loan Term Months
                            if lvngLoanUpdateSchema."Field No." = 100 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Loan Term (Months)" := lvngLoanJournalLine."Loan Term (Months)";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Loan Term (Months)" = 0 then
                                                lvngLoan."Loan Term (Months)" := lvngLoanJournalLine."Loan Term (Months)";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Loan Term (Months)" <> 0 then begin
                                                lvngLoan."Loan Term (Months)" := lvngLoanJournalLine."Loan Term (Months)";
                                            end;
                                        end;
                                end;
                            end;
                            //Interest Rate
                            if lvngLoanUpdateSchema."Field No." = 101 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Interest Rate" := lvngLoanJournalLine."Interest Rate";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Interest Rate" = 0 then
                                                lvngLoan."Interest Rate" := lvngLoanJournalLine."Interest Rate";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Interest Rate" <> 0 then begin
                                                lvngLoan."Interest Rate" := lvngLoanJournalLine."Interest Rate";
                                            end;
                                        end;
                                end;
                            end;
                            //First Payment Due
                            if lvngLoanUpdateSchema."Field No." = 102 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."First Payment Due" := lvngLoanJournalLine."First Payment Due";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."First Payment Due" = 0D then
                                                lvngLoan."First Payment Due" := lvngLoanJournalLine."First Payment Due";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."First Payment Due" <> 0D then begin
                                                lvngLoan."First Payment Due" := lvngLoanJournalLine."First Payment Due";
                                            end;
                                        end;
                                end;
                            end;
                            //First Payment Due to Investor
                            if lvngLoanUpdateSchema."Field No." = 103 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."First Payment Due To Investor" := lvngLoanJournalLine."First Payment Due To Investor";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."First Payment Due To Investor" = 0D then
                                                lvngLoan."First Payment Due To Investor" := lvngLoanJournalLine."First Payment Due To Investor";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."First Payment Due To Investor" <> 0D then begin
                                                lvngLoan."First Payment Due To Investor" := lvngLoanJournalLine."First Payment Due To Investor";
                                            end;
                                        end;
                                end;
                            end;
                            //Next Payment Date
                            if lvngLoanUpdateSchema."Field No." = 104 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Next Payment Date" := lvngLoanJournalLine."Next Payment Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Next Payment Date" = 0D then
                                                lvngLoan."Next Payment Date" := lvngLoanJournalLine."Next Payment Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Next Payment Date" <> 0D then begin
                                                lvngLoan."Next Payment Date" := lvngLoanJournalLine."Next Payment Date";
                                            end;
                                        end;
                                end;
                            end;
                            //Monthly Escrow Amount
                            if lvngLoanUpdateSchema."Field No." = 105 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Monthly Escrow Amount" := lvngLoanJournalLine."Monthly Escrow Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Monthly Escrow Amount" = 0 then
                                                lvngLoan."Monthly Escrow Amount" := lvngLoanJournalLine."Monthly Escrow Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Monthly Escrow Amount" <> 0 then begin
                                                lvngLoan."Monthly Escrow Amount" := lvngLoanJournalLine."Monthly Escrow Amount";
                                            end;
                                        end;
                                end;
                            end;
                            //Monthly Payment Amount
                            if lvngLoanUpdateSchema."Field No." = 106 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Monthly Payment Amount" := lvngLoanJournalLine."Monthly Payment Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Monthly Payment Amount" = 0 then
                                                lvngLoan."Monthly Payment Amount" := lvngLoanJournalLine."Monthly Payment Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Monthly Payment Amount" <> 0 then begin
                                                lvngLoan."Monthly Payment Amount" := lvngLoanJournalLine."Monthly Payment Amount";
                                            end;
                                        end;
                                end;
                            end;
                            //Servicing Late Fee
                            if lvngLoanUpdateSchema."Field No." = 107 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Late Fee" := lvngLoanJournalLine."Late Fee";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Late Fee" = 0 then
                                                lvngLoan."Late Fee" := lvngLoanJournalLine."Late Fee";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Late Fee" <> 0 then begin
                                                lvngLoan."Late Fee" := lvngLoanJournalLine."Late Fee";
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Base Amount
                            if lvngLoanUpdateSchema."Field No." = 500 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Commission Base Amount" := lvngLoanJournalLine."Commission Base Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Commission Base Amount" = 0 then
                                                lvngLoan."Commission Base Amount" := lvngLoanJournalLine."Commission Base Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Commission Base Amount" <> 0 then begin
                                                lvngLoan."Commission Base Amount" := lvngLoanJournalLine."Commission Base Amount";
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Date
                            if lvngLoanUpdateSchema."Field No." = 501 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Commission Date" := lvngLoanJournalLine."Commission Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Commission Date" = 0D then
                                                lvngLoan."Commission Date" := lvngLoanJournalLine."Commission Date";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Commission Date" <> 0D then begin
                                                lvngLoan."Commission Date" := lvngLoanJournalLine."Commission Date";
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Bps
                            if lvngLoanUpdateSchema."Field No." = 502 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Commission Bps" := lvngLoanJournalLine."Commission Bps";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Commission Bps" = 0 then
                                                lvngLoan."Commission Bps" := lvngLoanJournalLine."Commission Bps";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Commission Bps" <> 0 then begin
                                                lvngLoan."Commission Bps" := lvngLoanJournalLine."Commission Bps";
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Value
                            if lvngLoanUpdateSchema."Field No." = 503 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Commission Amount" := lvngLoanJournalLine."Commission Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Commission Amount" = 0 then
                                                lvngLoan."Commission Amount" := lvngLoanJournalLine."Commission Amount";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Commission Amount" <> 0 then begin
                                                lvngLoan."Commission Amount" := lvngLoanJournalLine."Commission Amount";
                                            end;
                                        end;
                                end;
                            end;
                            //Construction Interest Rate
                            if lvngLoanUpdateSchema."Field No." = 600 then begin
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoan."Constr. Interest Rate" := lvngLoanJournalLine."Constr. Interest Rate";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan."Constr. Interest Rate" = 0 then
                                                lvngLoan."Constr. Interest Rate" := lvngLoanJournalLine."Constr. Interest Rate";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Constr. Interest Rate" <> 0 then begin
                                                lvngLoan."Constr. Interest Rate" := lvngLoanJournalLine."Constr. Interest Rate";
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower
                            if lvngLoanUpdateSchema."Field No." = 200 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.Address := lvngLoanJournalLine."Borrower Address";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.Address = '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Borrower Address";
                                            end;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Address" <> '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Borrower Address";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 201 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."Address 2" := lvngLoanJournalLine."Borrower Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."Address 2" = '' then
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Borrower Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Address" <> '' then begin
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Borrower Address 2";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 202 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.City := lvngLoanJournalLine."Borrower City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.City = '' then
                                                lvngLoanAddress.City := lvngLoanJournalLine."Borrower City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Address" <> '' then begin
                                                lvngLoanAddress.City := lvngLoanJournalLine."Borrower City";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 203 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.State := lvngLoanJournalLine."Borrower State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.State = '' then
                                                lvngLoanAddress.State := lvngLoanJournalLine."Borrower State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Address" <> '' then begin
                                                lvngLoanAddress.State := lvngLoanJournalLine."Borrower State";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 204 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Borrower ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."ZIP Code" = '' then
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Borrower ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Borrower Address" <> '' then begin
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Borrower ZIP Code";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //CoBorrower
                            if lvngLoanUpdateSchema."Field No." = 210 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.Address := lvngLoanJournalLine."Co-Borrower Address";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.Address = '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Co-Borrower Address";
                                            end;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Address" <> '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Co-Borrower Address";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 211 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."Address 2" := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."Address 2" = '' then
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Address" <> '' then begin
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 212 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.City := lvngLoanJournalLine."Co-Borrower City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.City = '' then
                                                lvngLoanAddress.City := lvngLoanJournalLine."Co-Borrower City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Address" <> '' then begin
                                                lvngLoanAddress.City := lvngLoanJournalLine."Co-Borrower City";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 213 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.State := lvngLoanJournalLine."Co-Borrower State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.State = '' then
                                                lvngLoanAddress.State := lvngLoanJournalLine."Co-Borrower State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Address" <> '' then begin
                                                lvngLoanAddress.State := lvngLoanJournalLine."Co-Borrower State";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 214 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Co-Borrower ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."ZIP Code" = '' then
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Co-Borrower ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Co-Borrower Address" <> '' then begin
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Co-Borrower ZIP Code";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //Property
                            if lvngLoanUpdateSchema."Field No." = 220 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.Address := lvngLoanJournalLine."Property Address";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.Address = '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Property Address";
                                            end;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Property Address" <> '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Property Address";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 221 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."Address 2" := lvngLoanJournalLine."Property Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."Address 2" = '' then
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Property Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Property Address" <> '' then begin
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Property Address 2";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 222 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.City := lvngLoanJournalLine."Property City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.City = '' then
                                                lvngLoanAddress.City := lvngLoanJournalLine."Property City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Property Address" <> '' then begin
                                                lvngLoanAddress.City := lvngLoanJournalLine."Property City";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 223 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.State := lvngLoanJournalLine."Property State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.State = '' then
                                                lvngLoanAddress.State := lvngLoanJournalLine."Property State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Property Address" <> '' then begin
                                                lvngLoanAddress.State := lvngLoanJournalLine."Property State";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 224 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Property ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."ZIP Code" = '' then
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Property ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Property Address" <> '' then begin
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Property ZIP Code";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //Mailing
                            if lvngLoanUpdateSchema."Field No." = 230 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.Address := lvngLoanJournalLine."Mailing Address";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.Address = '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Mailing Address";
                                            end;
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Mailing Address" <> '' then begin
                                                lvngLoanAddress.Address := lvngLoanJournalLine."Mailing Address";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 231 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."Address 2" := lvngLoanJournalLine."Mailing Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."Address 2" = '' then
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Mailing Address 2";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Mailing Address" <> '' then begin
                                                lvngLoanAddress."Address 2" := lvngLoanJournalLine."Mailing Address 2";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 232 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.City := lvngLoanJournalLine."Mailing City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.City = '' then
                                                lvngLoanAddress.City := lvngLoanJournalLine."Mailing City";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Mailing Address" <> '' then begin
                                                lvngLoanAddress.City := lvngLoanJournalLine."Mailing City";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 233 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress.State := lvngLoanJournalLine."Mailing State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.State = '' then
                                                lvngLoanAddress.State := lvngLoanJournalLine."Mailing State";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Mailing Address" <> '' then begin
                                                lvngLoanAddress.State := lvngLoanJournalLine."Mailing State";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema."Field No." = 234 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
                                    lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema."Field Update Option" of
                                    lvngloanupdateschema."Field Update Option"::lvngAlways:
                                        begin
                                            lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Mailing ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress."ZIP Code" = '' then
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Mailing ZIP Code";
                                        end;
                                    lvngLoanUpdateSchema."Field Update Option"::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine."Mailing Address" <> '' then begin
                                                lvngLoanAddress."ZIP Code" := lvngLoanJournalLine."Mailing ZIP Code";
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            lvngLoan.modify(true);
                        end;
                end;
            until lvngLoanUpdateSchema.Next() = 0;
        end;
        lvngLoan.modify(true);
    end;

    procedure UpdateLoanCard(lvngLoanJournalLine: Record lvngLoanJournalLine)
    var
        lvngLoanJournalValue: record lvngLoanJournalValue;
        lvngLoanValue: Record lvngLoanValue;
        lvngLoan: Record lvngLoan;
        lvngLoanAddress: Record lvngLoanAddress;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if lvngLoanJournalLine."Loan No." = '' then
            exit;
        if not lvngLoan.Get(lvngLoanJournalLine."Loan No.") then begin
            Clear(lvngLoan);
            lvngloan."No." := lvngLoanJournalLine."Loan No.";
            lvngLoan.Insert(true);
        end;
        lvngLoan."Search Name" := lvngLoanJournalLine."Search Name";
        lvngloan."Borrower First Name" := lvngLoanJournalLine."Borrower First Name";
        lvngloan."Borrower Last Name" := lvngLoanJournalLine."Borrower Last Name";
        lvngLoan."Borrower Middle Name" := lvngLoanJournalLine."Borrower Middle Name";
        lvngLoan."Application Date" := lvngLoanJournalLine."Application Date";
        lvngLoan.Blocked := lvngLoanJournalLine.Blocked;
        lvngLoan."Borrower Customer No" := lvngLoanJournalLine."Borrower Customer No.";
        lvngloan."Business Unit Code" := lvngLoanJournalLine."Business Unit Code";
        lvngloan."Commission Base Amount" := lvngLoanJournalLine."Commission Base Amount";
        lvngLoan."Commission Date" := lvngLoanJournalLine."Commission Date";
        lvngloan."Constr. Interest Rate" := lvngLoanJournalLine."Constr. Interest Rate";
        lvngloan."Date Closed" := lvngLoanJournalLine."Date Closed";
        lvngloan."Date Funded" := lvngLoanJournalLine."Date Funded";
        lvngloan."Date Locked" := lvngLoanJournalLine."Date Locked";
        lvngloan."Date Sold" := lvngLoanJournalLine."Date Sold";
        lvngloan."First Payment Due" := lvngLoanJournalLine."First Payment Due";
        lvngloan."First Payment Due To Investor" := lvngLoanJournalLine."First Payment Due To Investor";
        lvngloan.validate("Global Dimension 1 Code", lvngLoanJournalLine."Global Dimension 1 Code");
        lvngloan.validate("Global Dimension 2 Code", lvngLoanJournalLine."Global Dimension 2 Code");
        lvngloan."Interest Rate" := lvngLoanJournalLine."Interest Rate";
        lvngloan."Investor Customer No." := lvngLoanJournalLine."Investor Customer No.";
        lvngloan."Loan Amount" := lvngLoanJournalLine."Loan Amount";
        lvngloan."Loan Term (Months)" := lvngLoanJournalLine."Loan Term (Months)";
        lvngloan."Monthly Escrow Amount" := lvngLoanJournalLine."Monthly Escrow Amount";
        lvngloan."Monthly Payment Amount" := lvngLoanJournalLine."Monthly Payment Amount";
        lvngloan.validate("Shortcut Dimension 3 Code", lvngLoanJournalLine."Shortcut Dimension 3 Code");
        lvngloan.validate("Shortcut Dimension 4 Code", lvngLoanJournalLine."Shortcut Dimension 4 Code");
        lvngloan.validate("Shortcut Dimension 5 Code", lvngLoanJournalLine."Shortcut Dimension 5 Code");
        lvngloan.validate("Shortcut Dimension 6 Code", lvngLoanJournalLine."Shortcut Dimension 6 Code");
        lvngloan.validate("Shortcut Dimension 7 Code", lvngLoanJournalLine."Shortcut Dimension 7 Code");
        lvngloan.validate("Shortcut Dimension 8 Code", lvngLoanJournalLine."Shortcut Dimension 8 Code");
        lvngloan."Title Customer No." := lvngLoanJournalLine."Title Customer No.";
        lvngloan."Warehouse Line Code" := lvngLoanJournalLine."Warehouse Line Code";
        lvngLoan."Co-Borrower First Name" := lvngLoanJournalLine."Co-Borrower First Name";
        lvngloan."Co-Borrower Last Name" := lvngLoanJournalLine."Co-Borrower Last Name";
        lvngloan."Co-Borrower Middle Name" := lvngLoanJournalLine."Co-Borrower Middle Name";
        lvngloan."203K Contractor Name" := lvngLoanJournalLine."203K Contractor Name";
        lvngloan."203K Inspector Name" := lvngLoanJournalLine."203K Inspector Name";
        if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngBorrower) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
            lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngBorrower;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.Address := lvngLoanJournalLine."Borrower Address";
        lvngLoanAddress."Address 2" := lvngLoanJournalLine."Borrower Address 2";
        lvngloanAddress.City := lvngLoanJournalLine."Borrower City";
        lvngLoanAddress.State := lvngLoanJournalLine."Borrower State";
        lvngloanaddress."ZIP Code" := lvngLoanJournalLine."Borrower ZIP Code";
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngCoBorrower) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
            lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngCoBorrower;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.Address := lvngLoanJournalLine."Co-Borrower Address";
        lvngLoanAddress."Address 2" := lvngLoanJournalLine.lvngCoBorrowerAddress2;
        lvngloanAddress.City := lvngLoanJournalLine."Co-Borrower City";
        lvngLoanAddress.State := lvngLoanJournalLine."Co-Borrower State";
        lvngloanaddress."ZIP Code" := lvngLoanJournalLine."Co-Borrower ZIP Code";
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngMailing) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
            lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngMailing;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.Address := lvngLoanJournalLine."Mailing Address";
        lvngLoanAddress."Address 2" := lvngLoanJournalLine."Mailing Address 2";
        lvngloanAddress.City := lvngLoanJournalLine."Mailing City";
        lvngLoanAddress.State := lvngLoanJournalLine."Mailing State";
        lvngloanaddress."ZIP Code" := lvngLoanJournalLine."Mailing ZIP Code";
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine."Loan No.", lvngLoanAddress."Address Type"::lvngProperty) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress."Loan No." := lvngLoanJournalLine."Loan No.";
            lvngLoanAddress."Address Type" := lvngLoanAddress."Address Type"::lvngProperty;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.Address := lvngLoanJournalLine."Property Address";
        lvngLoanAddress."Address 2" := lvngLoanJournalLine."Property Address 2";
        lvngloanAddress.City := lvngLoanJournalLine."Property City";
        lvngLoanAddress.State := lvngLoanJournalLine."Property State";
        lvngloanaddress."ZIP Code" := lvngLoanJournalLine."Property ZIP Code";
        lvngLoanAddress.Modify();
        lvngLoanJournalValue.reset;
        lvngLoanJournalValue.SetRange("Loan Journal Batch Code", lvngLoanJournalLine."Loan Journal Batch Code");
        lvngLoanJournalValue.SetRange("Line No.", lvngLoanJournalLine."Line No.");
        if lvngLoanJournalValue.FindSet() then begin
            repeat
                if lvngLoanValue.Get(lvngLoanJournalLine."Loan No.", lvngLoanJournalValue."Field No.") then begin
                    lvngLoanValue."Field Value" := lvngLoanJournalValue."Field Value";
                    EvaluateLoanFieldsValue(lvngLoanValue, true);
                    lvngLoanValue.Modify()
                end else begin
                    Clear(lvngLoanValue);
                    lvngLoanValue."Loan No." := lvngLoanJournalLine."Loan No.";
                    lvngLoanValue."Field No." := lvngLoanJournalValue."Field No.";
                    lvngLoanValue."Field Value" := lvngLoanJournalValue."Field Value";
                    EvaluateLoanFieldsValue(lvngLoanValue, true);
                    lvngLoanValue.Insert();
                end;

            until lvngLoanJournalValue.Next() = 0;
        end;
        lvngloan.Modify(true);
    end;

    procedure EvaluateLoanFieldsValue(var lvngLoanValue: Record lvngLoanValue; lvngFillBuffer: boolean)
    begin
        if lvngFillBuffer then begin
            FillLoanFieldsConfigurationBuffer();
            if not lvngLoanFieldsConfigurationTemp.Get(lvngLoanValue."Field No.") then
                exit;
        end else begin
            lvngLoanFieldsConfiguration.Get(lvngLoanValue."Field No.");
            lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
        end;

        case lvngLoanFieldsConfigurationTemp."Value Type" of
            lvngloanfieldsconfigurationtemp."Value Type"::Boolean:
                begin
                    if evaluate(lvngLoanValue."Boolean Value", lvngLoanValue."Field Value") then;
                end;
            lvngloanfieldsconfigurationtemp."Value Type"::Date:
                begin
                    if evaluate(lvngLoanValue."Date Value", lvngLoanValue."Field Value") then;
                end;
            lvngloanfieldsconfigurationtemp."Value Type"::Decimal:
                begin
                    if evaluate(lvngLoanValue."Decimal Value", lvngLoanValue."Field Value") then;
                end;
            lvngloanfieldsconfigurationtemp."Value Type"::Integer:
                begin
                    if evaluate(lvngLoanValue."Integer Value", lvngLoanValue."Field Value") then;
                end;

        end;
    end;

    procedure CopyImportSchemaToUpdateSchema(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanImportSchema: Record lvngLoanImportSchema;
        lvngLoanImportSchemaLine: Record lvngLoanImportSchemaLine;
        lvngLoanUpdateSchema: Record lvngLoanUpdateSchema;
        lvngClearTableLbl: Label 'Please remove existing schema lines prior to copying';
    begin
        lvngLoanJournalBatch.Get(lvngJournalBatchCode);
        lvngLoanUpdateSchema.reset;
        lvngLoanUpdateSchema.SetRange("Journal Batch Code", lvngJournalBatchCode);
        if not lvngLoanUpdateSchema.IsEmpty() then begin
            Error(lvngClearTableLbl);
        end;
        if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOK then begin
            lvngLoanImportSchemaLine.reset;
            lvngLoanImportSchemaLine.SetRange(Code, lvngLoanImportSchema.Code);
            lvngLoanImportSchemaLine.SetFilter("Field Type", '<>%1', lvngLoanImportSchemaLine."Field Type"::lvngDummy);
            if lvngLoanImportSchemaLine.FindSet() then begin
                repeat
                    Clear(lvngLoanUpdateSchema);
                    lvngLoanUpdateSchema."Journal Batch Code" := lvngJournalBatchCode;
                    lvngLoanUpdateSchema."Import Field Type" := lvngLoanImportSchemaLine."Field Type";
                    lvngLoanUpdateSchema."Field No." := lvngLoanImportSchemaLine."Field No.";
                    lvngLoanUpdateSchema."Field Update Option" := lvngLoanUpdateSchema."Field Update Option"::lvngAlways;
                    lvngLoanUpdateSchema.Insert();
                until lvngLoanImportSchemaLine.Next() = 0;
            end;
            lvngLoanUpdateSchema.reset;
            lvngLoanUpdateSchema.SetRange("Journal Batch Code", lvngJournalBatchCode);
            lvngLoanUpdateSchema.SetRange("Field No.", 1, 4);
            lvngLoanUpdateSchema.DeleteAll();
            lvngLoanUpdateSchema.SetRange("Field No.", 5000, 999999999);
            lvngLoanUpdateSchema.DeleteAll();
            Message(lvngCompletedLbl);
        end;
    end;

    procedure ModifyFieldUpdateOption(lvngJournalBatchCode: code[20]; lvngFieldUpdateOption: Enum lvngFieldUpdateOption)
    var
        lvngLoanUpdateSchema: Record lvngLoanUpdateSchema;
        lvngConfirmModificationLbl: Label 'Do You want to update all entries to %1 update option?';
    begin
        if Confirm(lvngConfirmModificationLbl, false, lvngFieldUpdateOption) then begin
            lvngLoanUpdateSchema.reset;
            lvngLoanUpdateSchema.SetRange("Journal Batch Code", lvngJournalBatchCode);
            lvngLoanUpdateSchema.ModifyAll("Field Update Option", lvngFieldUpdateOption);
            Message(lvngCompletedLbl);
        end;
    end;

    procedure GetFieldName(lvngFieldNo: Integer): Text
    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if not lvngLoanFieldsConfiguration.Get(lvngFieldNo) then
            exit('ERROR');
        exit(lvngLoanFieldsConfiguration."Field Name");
    end;

    local procedure FillLoanFieldsConfigurationBuffer()
    begin
        if not lvngLoanFieldsConfigurationRetrieved then begin
            lvngLoanFieldsConfigurationRetrieved := true;
            lvngLoanFieldsConfiguration.reset;
            if lvngLoanFieldsConfiguration.FindSet() then begin
                repeat
                    Clear(lvngLoanFieldsConfigurationTemp);
                    lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
                    lvngLoanFieldsConfigurationTemp.Insert();
                until lvngLoanFieldsConfiguration.Next() = 0;
            end;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetupRetrieved := true;
            lvngLoanVisionSetup.Get();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', true, true)]
    local procedure OnDimensionAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption)
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::lvngLoan);
    end;

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanVisionSetupRetrieved: Boolean;
        lvngLoanFieldsConfigurationRetrieved: Boolean;
        lvngCompletedLbl: Label 'Completed';
}