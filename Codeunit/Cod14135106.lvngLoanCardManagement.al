codeunit 14135106 "lvngLoanCardManagement"
{
    procedure UpdateLoanCards(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanUpdateSchema: Record lvngLoanUpdateSchema;
        lvngLoanUpdateSchemaTemp: Record lvngLoanUpdateSchema temporary;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;
        Window: Dialog;
        lvngProgressLbl: Label 'Processing #1########### of #2###########';
        lvngCounter: Integer;

    begin
        GetLoanVisionSetup();
        lvngLoanJournalBatch.Get(lvngJournalBatchCode);
        if lvngLoanJournalBatch.lvngLoanCardUpdateOption = lvngLoanJournalBatch.lvngLoanCardUpdateOption::lvngSchema then begin
            lvngLoanUpdateSchema.reset;
            lvngLoanUpdateSchema.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
            lvngLoanUpdateSchema.FindSet();
            repeat
                Clear(lvngLoanUpdateSchemaTemp);
                lvngLoanUpdateSchemaTemp := lvngLoanUpdateSchema;
                lvngLoanUpdateSchemaTemp.Insert();
            until lvngLoanUpdateSchema.Next() = 0;
        end;
        lvngLoanJournalLine.reset;
        if lvngLoanJournalBatch.lvngLoanJournalType = lvngLoanJournalBatch.lvngLoanJournalType::lvngFunded then begin
            if lvngLoanVisionSetup.lvngFundedVoidReasonCode <> '' then begin
                lvngLoanJournalLine.SetFilter(lvngReasonCode, '<>%1', lvngLoanVisionSetup.lvngFundedVoidReasonCode);
            end;
        end;
        if lvngLoanJournalBatch.lvngLoanJournalType = lvngLoanJournalBatch.lvngLoanJournalType::lvngSold then begin
            if lvngLoanVisionSetup.lvngSoldVoidReasonCode <> '' then begin
                lvngLoanJournalLine.SetFilter(lvngReasonCode, '<>%1', lvngLoanVisionSetup.lvngSoldVoidReasonCode);
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
                    case lvngLoanJournalBatch.lvngLoanCardUpdateOption of
                        lvngloanjournalbatch.lvngLoanCardUpdateOption::lvngAlways:
                            UpdateLoanCard(lvngLoanJournalLine);
                        lvngloanjournalbatch.lvngLoanCardUpdateOption::lvngSchema:
                            UpdateLoanCard(lvngLoanJournalLine, lvngLoanUpdateSchemaTemp);
                    end;
                end;
            until lvngLoanJournalLine.Next() = 0;
            if GuiAllowed() then
                Window.Close();
        end;
    end;

    procedure UpdateLoanCard(lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLoanUpdateSchema: record lvngLoanUpdateSchema)
    var
        lvngLoanJournalValue: record lvngLoanJournalValue;
        lvngLoanValue: Record lvngLoanValue;
        lvngLoan: Record lvngLoan;
        lvngLoanAddress: Record lvngLoanAddress;
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if lvngLoanJournalLine.lvngLoanNo = '' then
            exit;

        if not lvngLoan.Get(lvngLoanJournalLine.lvngLoanNo) then begin
            Clear(lvngLoan);
            lvngloan.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoan.Insert(true);
        end;
        lvngLoanUpdateSchema.reset;
        if lvngLoanUpdateSchema.FindSet() then begin
            repeat
                case lvngLoanUpdateSchema.lvngImportFieldType of
                    lvngloanupdateschema.lvngImportFieldType::lvngVariable:
                        begin
                            if lvngLoanJournalValue.Get(lvngLoanJournalLine.lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLineNo, lvngLoanUpdateSchema.lvngFieldNo) then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine.lvngLoanNo, lvngLoanUpdateSchema.lvngFieldNo) then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                                lvngLoanValue.lvngFieldNo := lvngLoanUpdateSchema.lvngFieldNo;
                                                lvngLoanValue.Insert();
                                            end;
                                            lvngLoanValue.Validate(lvngFieldValue, lvngLoanJournalValue.lvngFieldValue);
                                            lvngLoanValue.Modify();
                                        end;
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine.lvngLoanNo, lvngLoanUpdateSchema.lvngFieldNo) then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                                lvngLoanValue.lvngFieldNo := lvngLoanUpdateSchema.lvngFieldNo;
                                                lvngLoanValue.Insert();
                                            end;
                                            if lvngLoanValue.lvngFieldValue = '' then begin
                                                lvngLoanValue.Validate(lvngFieldValue, lvngLoanJournalValue.lvngFieldValue);
                                                lvngLoanValue.Modify();
                                            end;
                                        end;
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if not lvngLoanValue.get(lvngLoanJournalLine.lvngLoanNo, lvngLoanUpdateSchema.lvngFieldNo) then begin
                                                Clear(lvngLoanValue);
                                                lvngloanvalue.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                                lvngLoanValue.lvngFieldNo := lvngLoanUpdateSchema.lvngFieldNo;
                                                lvngLoanValue.Insert();
                                            end;
                                            if lvngLoanJournalValue.lvngFieldValue = '' then begin
                                                lvngLoanValue.Validate(lvngFieldValue, lvngLoanJournalValue.lvngFieldValue);
                                                lvngLoanValue.Modify();
                                            end;
                                        end;
                                end;
                            end;
                        end;
                    lvngloanupdateschema.lvngImportFieldType::lvngTable:
                        begin
                            //Search Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 10 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngSearchName := lvngLoanJournalLine.lvngSearchName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngSearchName = '' then
                                                lvngloan.lvngSearchName := lvngLoanJournalLine.lvngSearchName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngSearchName <> '' then begin
                                                lvngLoan.lvngSearchName := lvngLoanJournalLine.lvngSearchName;
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower First Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 11 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngBorrowerFirstName := lvngLoanJournalLine.lvngBorrowerFirstName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBorrowerFirstName = '' then
                                                lvngloan.lvngBorrowerFirstName := lvngLoanJournalLine.lvngBorrowerFirstName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerFirstName <> '' then begin
                                                lvngLoan.lvngBorrowerFirstName := lvngLoanJournalLine.lvngBorrowerFirstName;
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Last Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 12 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngBorrowerLastName := lvngLoanJournalLine.lvngBorrowerLastName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBorrowerLastName = '' then
                                                lvngloan.lvngBorrowerLastName := lvngLoanJournalLine.lvngBorrowerLastName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerLastName <> '' then begin
                                                lvngLoan.lvngBorrowerLastName := lvngLoanJournalLine.lvngBorrowerLastName;
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Middle Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 13 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngBorrowerMiddleName := lvngLoanJournalLine.lvngBorrowerMiddleName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBorrowerMiddleName = '' then
                                                lvngloan.lvngBorrowerMiddleName := lvngLoanJournalLine.lvngBorrowerMiddleName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerMiddleName <> '' then begin
                                                lvngLoan.lvngBorrowerMiddleName := lvngLoanJournalLine.lvngBorrowerMiddleName;
                                            end;
                                        end;
                                end;
                            end;
                            //Title Customer No.
                            if lvngLoanUpdateSchema.lvngFieldNo = 14 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngTitleCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngTitleCustomerNo = '' then
                                                lvngloan.lvngTitleCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngTitleCustomerNo <> '' then begin
                                                lvngLoan.lvngTitleCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
                                            end;
                                        end;
                                end;
                            end;
                            //Investor Customer No.
                            if lvngLoanUpdateSchema.lvngFieldNo = 15 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngInvestorCustomerNo := lvngLoanJournalLine.lvngInvestorCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngInvestorCustomerNo = '' then
                                                lvngloan.lvngInvestorCustomerNo := lvngLoanJournalLine.lvngInvestorCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngInvestorCustomerNo <> '' then begin
                                                lvngLoan.lvngInvestorCustomerNo := lvngLoanJournalLine.lvngInvestorCustomerNo;
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower Customer No.
                            if lvngLoanUpdateSchema.lvngFieldNo = 16 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngBorrowerCustomerNo := lvngLoanJournalLine.lvngBorrowerCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBorrowerCustomerNo = '' then
                                                lvngloan.lvngBorrowerCustomerNo := lvngLoanJournalLine.lvngBorrowerCustomerNo;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerCustomerNo <> '' then begin
                                                lvngLoan.lvngBorrowerCustomerNo := lvngLoanJournalLine.lvngBorrowerCustomerNo;
                                            end;
                                        end;
                                end;
                            end;
                            //Application Date
                            if lvngLoanUpdateSchema.lvngFieldNo = 20 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngApplicationDate := lvngLoanJournalLine.lvngApplicationDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngApplicationDate = 0D then
                                                lvngloan.lvngApplicationDate := lvngLoanJournalLine.lvngApplicationDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngApplicationDate <> 0D then begin
                                                lvngLoan.lvngApplicationDate := lvngLoanJournalLine.lvngApplicationDate;
                                            end;
                                        end;
                                end;
                            end;
                            //Date Closed
                            if lvngLoanUpdateSchema.lvngFieldNo = 21 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngDateClosed := lvngLoanJournalLine.lvngDateClosed;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngDateClosed = 0D then
                                                lvngloan.lvngDateClosed := lvngLoanJournalLine.lvngDateClosed;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngDateClosed <> 0D then begin
                                                lvngLoan.lvngDateClosed := lvngLoanJournalLine.lvngDateClosed;
                                            end;
                                        end;
                                end;
                            end;
                            //Date Funded
                            if lvngLoanUpdateSchema.lvngFieldNo = 22 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngDateFunded := lvngLoanJournalLine.lvngDateFunded;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngDateFunded = 0D then
                                                lvngloan.lvngDateFunded := lvngLoanJournalLine.lvngDateFunded;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngDateFunded <> 0D then begin
                                                lvngLoan.lvngDateFunded := lvngLoanJournalLine.lvngDateFunded;
                                            end;
                                        end;
                                end;
                            end;
                            //Date Sold
                            if lvngLoanUpdateSchema.lvngFieldNo = 23 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngDateSold := lvngLoanJournalLine.lvngDateSold;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngDateSold = 0D then
                                                lvngloan.lvngDateSold := lvngLoanJournalLine.lvngDateSold;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngDateSold <> 0D then begin
                                                lvngLoan.lvngDateSold := lvngLoanJournalLine.lvngDateSold;
                                            end;
                                        end;
                                end;
                            end;
                            //Date Locked
                            if lvngLoanUpdateSchema.lvngFieldNo = 24 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngDateLocked := lvngLoanJournalLine.lvngDateLocked;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngDateLocked = 0D then
                                                lvngloan.lvngDateLocked := lvngLoanJournalLine.lvngDateLocked;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngDateLocked <> 0D then begin
                                                lvngLoan.lvngDateLocked := lvngLoanJournalLine.lvngDateLocked;
                                            end;
                                        end;
                                end;
                            end;
                            //Loan Amount
                            if lvngLoanUpdateSchema.lvngFieldNo = 25 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngLoanAmount := lvngLoanJournalLine.lvngLoanAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngLoanAmount = 0 then
                                                lvngloan.lvngLoanAmount := lvngLoanJournalLine.lvngLoanAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngLoanAmount <> 0 then begin
                                                lvngLoan.lvngLoanAmount := lvngLoanJournalLine.lvngLoanAmount;
                                            end;
                                        end;
                                end;
                            end;
                            //Blocked
                            if lvngLoanUpdateSchema.lvngFieldNo = 26 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngBlocked := lvngLoanJournalLine.lvngBlocked;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBlocked = false then
                                                lvngloan.lvngBlocked := lvngLoanJournalLine.lvngBlocked;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBlocked <> false then begin
                                                lvngLoan.lvngBlocked := lvngLoanJournalLine.lvngBlocked;
                                            end;
                                        end;
                                end;
                            end;
                            //Warehouse Line Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 27 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngWarehouseLineCode := lvngLoanJournalLine.lvngWarehouseLineCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngWarehouseLineCode = '' then
                                                lvngloan.lvngWarehouseLineCode := lvngLoanJournalLine.lvngWarehouseLineCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngWarehouseLineCode <> '' then begin
                                                lvngLoan.lvngWarehouseLineCode := lvngLoanJournalLine.lvngWarehouseLineCode;
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower First Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 28 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngCoBorrowerFirstName := lvngLoanJournalLine.lvngCoBorrowerFirstName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngCoBorrowerFirstName = '' then
                                                lvngloan.lvngCoBorrowerFirstName := lvngLoanJournalLine.lvngCoBorrowerFirstName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerFirstName <> '' then begin
                                                lvngLoan.lvngCoBorrowerFirstName := lvngLoanJournalLine.lvngCoBorrowerFirstName;
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower Last Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 29 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngCoBorrowerLastName := lvngLoanJournalLine.lvngCoBorrowerLastName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngCoBorrowerLastName = '' then
                                                lvngloan.lvngCoBorrowerLastName := lvngLoanJournalLine.lvngCoBorrowerLastName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerLastName <> '' then begin
                                                lvngLoan.lvngCoBorrowerLastName := lvngLoanJournalLine.lvngCoBorrowerLastName;
                                            end;
                                        end;
                                end;
                            end;
                            //Co-Borrower Middle Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 30 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngCoBorrowerMiddleName := lvngLoanJournalLine.lvngCoBorrowerMiddleName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngCoBorrowerMiddleName = '' then
                                                lvngloan.lvngCoBorrowerMiddleName := lvngLoanJournalLine.lvngCoBorrowerMiddleName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerMiddleName <> '' then begin
                                                lvngLoan.lvngCoBorrowerMiddleName := lvngLoanJournalLine.lvngCoBorrowerMiddleName;
                                            end;
                                        end;
                                end;
                            end;
                            //203K Contractor Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 31 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvng203KContractorName := lvngLoanJournalLine.lvng203KContractorName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvng203KContractorName = '' then
                                                lvngloan.lvng203KContractorName := lvngLoanJournalLine.lvng203KContractorName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvng203KContractorName <> '' then begin
                                                lvngLoan.lvng203KContractorName := lvngLoanJournalLine.lvng203KContractorName;
                                            end;
                                        end;
                                end;
                            end;
                            //203K Inspector Name
                            if lvngLoanUpdateSchema.lvngFieldNo = 32 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvng203KInspectorName := lvngLoanJournalLine.lvng203KInspectorName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvng203KInspectorName = '' then
                                                lvngloan.lvng203KInspectorName := lvngLoanJournalLine.lvng203KInspectorName;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvng203KInspectorName <> '' then begin
                                                lvngLoan.lvng203KInspectorName := lvngLoanJournalLine.lvng203KInspectorName;
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 1 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 80 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngGlobalDimension1Code = '' then
                                                lvngLoan.validate(lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngGlobalDimension1Code <> '' then begin
                                                lvngLoan.validate(lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 2 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 81 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngGlobalDimension2Code = '' then
                                                lvngLoan.validate(lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngGlobalDimension2Code <> '' then begin
                                                lvngLoan.validate(lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 3 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 82 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension3Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension3Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 4 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 83 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension4Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension4Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 5 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 84 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension5Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension5Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 6 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 85 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension6Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension6Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 7 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 86 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension7Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension7Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Dimension 8 Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 87 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngShortcutDimension8Code = '' then
                                                lvngLoan.validate(lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngShortcutDimension8Code <> '' then begin
                                                lvngLoan.validate(lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code);
                                            end;
                                        end;
                                end;
                            end;
                            //Business Unit Code
                            if lvngLoanUpdateSchema.lvngFieldNo = 88 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.validate(lvngBusinessUnitCode, lvngLoanJournalLine.lvngBusinessUnitCode);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngBusinessUnitCode = '' then
                                                lvngLoan.validate(lvngBusinessUnitCode, lvngLoanJournalLine.lvngBusinessUnitCode);
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBusinessUnitCode <> '' then begin
                                                lvngLoan.validate(lvngBusinessUnitCode, lvngLoanJournalLine.lvngBusinessUnitCode);
                                            end;
                                        end;
                                end;
                            end;
                            //Loan Term Months
                            if lvngLoanUpdateSchema.lvngFieldNo = 100 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngLoanTermMonths := lvngLoanJournalLine.lvngLoanTermMonths;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngLoanTermMonths = 0 then
                                                lvngLoan.lvngLoanTermMonths := lvngLoanJournalLine.lvngLoanTermMonths;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngLoanTermMonths <> 0 then begin
                                                lvngLoan.lvngLoanTermMonths := lvngLoanJournalLine.lvngLoanTermMonths;
                                            end;
                                        end;
                                end;
                            end;
                            //Interest Rate
                            if lvngLoanUpdateSchema.lvngFieldNo = 101 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngInterestRate := lvngLoanJournalLine.lvngInterestRate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngInterestRate = 0 then
                                                lvngLoan.lvngInterestRate := lvngLoanJournalLine.lvngInterestRate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngInterestRate <> 0 then begin
                                                lvngLoan.lvngInterestRate := lvngLoanJournalLine.lvngInterestRate;
                                            end;
                                        end;
                                end;
                            end;
                            //First Payment Due
                            if lvngLoanUpdateSchema.lvngFieldNo = 102 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngFirstPaymentDue := lvngLoanJournalLine.lvngFirstPaymentDue;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngFirstPaymentDue = 0D then
                                                lvngLoan.lvngFirstPaymentDue := lvngLoanJournalLine.lvngFirstPaymentDue;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngFirstPaymentDue <> 0D then begin
                                                lvngLoan.lvngFirstPaymentDue := lvngLoanJournalLine.lvngFirstPaymentDue;
                                            end;
                                        end;
                                end;
                            end;
                            //First Payment Due to Investor
                            if lvngLoanUpdateSchema.lvngFieldNo = 103 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngFirstPaymentDueToInvestor := lvngLoanJournalLine.lvngFirstPaymentDueToInvestor;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngFirstPaymentDueToInvestor = 0D then
                                                lvngLoan.lvngFirstPaymentDueToInvestor := lvngLoanJournalLine.lvngFirstPaymentDueToInvestor;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngFirstPaymentDueToInvestor <> 0D then begin
                                                lvngLoan.lvngFirstPaymentDueToInvestor := lvngLoanJournalLine.lvngFirstPaymentDueToInvestor;
                                            end;
                                        end;
                                end;
                            end;
                            //Next Payment Date
                            if lvngLoanUpdateSchema.lvngFieldNo = 104 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngNextPaymentDate := lvngLoanJournalLine.lvngNextPaymentDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngNextPaymentDate = 0D then
                                                lvngLoan.lvngNextPaymentDate := lvngLoanJournalLine.lvngNextPaymentDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngNextPaymentDate <> 0D then begin
                                                lvngLoan.lvngNextPaymentDate := lvngLoanJournalLine.lvngNextPaymentDate;
                                            end;
                                        end;
                                end;
                            end;
                            //Monthly Escrow Amount
                            if lvngLoanUpdateSchema.lvngFieldNo = 105 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngMonthlyEscrowAmount := lvngLoanJournalLine.lvngMonthlyEscrowAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngMonthlyEscrowAmount = 0 then
                                                lvngLoan.lvngMonthlyEscrowAmount := lvngLoanJournalLine.lvngMonthlyEscrowAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMonthlyEscrowAmount <> 0 then begin
                                                lvngLoan.lvngMonthlyEscrowAmount := lvngLoanJournalLine.lvngMonthlyEscrowAmount;
                                            end;
                                        end;
                                end;
                            end;
                            //Monthly Payment Amount
                            if lvngLoanUpdateSchema.lvngFieldNo = 106 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngMonthlyPaymentAmount := lvngLoanJournalLine.lvngMonthlyPaymentAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngMonthlyPaymentAmount = 0 then
                                                lvngLoan.lvngMonthlyPaymentAmount := lvngLoanJournalLine.lvngMonthlyPaymentAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMonthlyPaymentAmount <> 0 then begin
                                                lvngLoan.lvngMonthlyPaymentAmount := lvngLoanJournalLine.lvngMonthlyPaymentAmount;
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Base Amount
                            if lvngLoanUpdateSchema.lvngFieldNo = 500 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngCommissionBaseAmount := lvngLoanJournalLine.lvngCommissionBaseAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngCommissionBaseAmount = 0 then
                                                lvngLoan.lvngCommissionBaseAmount := lvngLoanJournalLine.lvngCommissionBaseAmount;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCommissionBaseAmount <> 0 then begin
                                                lvngLoan.lvngCommissionBaseAmount := lvngLoanJournalLine.lvngCommissionBaseAmount;
                                            end;
                                        end;
                                end;
                            end;
                            //Commission Date
                            if lvngLoanUpdateSchema.lvngFieldNo = 501 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngCommissionDate := lvngLoanJournalLine.lvngCommissionDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngCommissionDate = 0D then
                                                lvngLoan.lvngCommissionDate := lvngLoanJournalLine.lvngCommissionDate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCommissionDate <> 0D then begin
                                                lvngLoan.lvngCommissionDate := lvngLoanJournalLine.lvngCommissionDate;
                                            end;
                                        end;
                                end;
                            end;
                            //Construction Interest Rate
                            if lvngLoanUpdateSchema.lvngFieldNo = 600 then begin
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoan.lvngConstrInterestRate := lvngLoanJournalLine.lvngConstrInterestRate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngloan.lvngConstrInterestRate = 0 then
                                                lvngLoan.lvngConstrInterestRate := lvngLoanJournalLine.lvngConstrInterestRate;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngConstrInterestRate <> 0 then begin
                                                lvngLoan.lvngConstrInterestRate := lvngLoanJournalLine.lvngConstrInterestRate;
                                            end;
                                        end;
                                end;
                            end;
                            //Borrower
                            if lvngLoanUpdateSchema.lvngFieldNo = 200 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngBorrowerAddress;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress = '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngBorrowerAddress;
                                            end;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngBorrowerAddress;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 201 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress2 = '' then
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngBorrowerAddress2;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 202 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngBorrowerCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngCity = '' then
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngBorrowerCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngBorrowerCity;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 203 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngBorrowerState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngState = '' then
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngBorrowerState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngBorrowerState;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 204 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngBorrowerZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngZIPCode = '' then
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngBorrowerZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngBorrowerZIPCode;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //CoBorrower
                            if lvngLoanUpdateSchema.lvngFieldNo = 210 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngCoBorrowerAddress;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress = '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngCoBorrowerAddress;
                                            end;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngCoBorrowerAddress;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 211 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress2 = '' then
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngCoBorrowerAddress2;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 212 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngCoBorrowerCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngCity = '' then
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngCoBorrowerCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngCoBorrowerCity;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 213 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngCoBorrowerState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngState = '' then
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngCoBorrowerState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngCoBorrowerState;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 214 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngCoBorrowerZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngZIPCode = '' then
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngCoBorrowerZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngCoBorrowerAddress <> '' then begin
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngCoBorrowerZIPCode;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //Property
                            if lvngLoanUpdateSchema.lvngFieldNo = 220 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngPropertyAddress;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress = '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngPropertyAddress;
                                            end;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngPropertyAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngPropertyAddress;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 221 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngPropertyAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress2 = '' then
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngPropertyAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngPropertyAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngPropertyAddress2;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 222 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngPropertyCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngCity = '' then
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngPropertyCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngPropertyAddress <> '' then begin
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngPropertyCity;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 223 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngPropertyState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngState = '' then
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngPropertyState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngPropertyAddress <> '' then begin
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngPropertyState;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 224 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngPropertyZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngZIPCode = '' then
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngPropertyZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngPropertyAddress <> '' then begin
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngPropertyZIPCode;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            //Mailing
                            if lvngLoanUpdateSchema.lvngFieldNo = 230 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                    lvngLoanAddress.Insert();

                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngMailingAddress;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress = '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngMailingAddress;
                                            end;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMailingAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngMailingAddress;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 231 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngMailingAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngAddress2 = '' then
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngMailingAddress2;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMailingAddress <> '' then begin
                                                lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngMailingAddress2;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 232 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngMailingCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngCity = '' then
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngMailingCity;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMailingAddress <> '' then begin
                                                lvngLoanAddress.lvngCity := lvngLoanJournalLine.lvngMailingCity;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 233 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngMailingState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngState = '' then
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngMailingState;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMailingAddress <> '' then begin
                                                lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngMailingState;
                                            end;
                                        end;
                                end;
                                lvngLoanAddress.Modify();
                            end;
                            if lvngLoanUpdateSchema.lvngFieldNo = 234 then begin
                                if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
                                    Clear(lvngLoanAddress);
                                    lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                    lvngLoanAddress.Insert();
                                end;
                                case lvngLoanUpdateSchema.lvngFieldUpdateOption of
                                    lvngloanupdateschema.lvngFieldUpdateOption::lvngAlways:
                                        begin
                                            lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngMailingZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfDestinationBlank:
                                        begin
                                            if lvngLoanAddress.lvngZIPCode = '' then
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngMailingZIPCode;
                                        end;
                                    lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngIfSourceNotBlank:
                                        begin
                                            if lvngLoanJournalLine.lvngMailingAddress <> '' then begin
                                                lvngLoanAddress.lvngZIPCode := lvngLoanJournalLine.lvngMailingZIPCode;
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
        if lvngLoanJournalLine.lvngLoanNo = '' then
            exit;
        if not lvngLoan.Get(lvngLoanJournalLine.lvngLoanNo) then begin
            Clear(lvngLoan);
            lvngloan.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoan.Insert(true);
        end;
        lvngLoan.lvngSearchName := lvngLoanJournalLine.lvngSearchName;
        lvngloan.lvngBorrowerFirstName := lvngLoanJournalLine.lvngBorrowerFirstName;
        lvngloan.lvngBorrowerLastName := lvngLoanJournalLine.lvngBorrowerLastName;
        lvngLoan.lvngBorrowerMiddleName := lvngLoanJournalLine.lvngBorrowerMiddleName;
        lvngLoan.lvngApplicationDate := lvngLoanJournalLine.lvngApplicationDate;
        lvngLoan.lvngBlocked := lvngLoanJournalLine.lvngBlocked;
        lvngLoan.lvngBorrowerCustomerNo := lvngLoanJournalLine.lvngBorrowerCustomerNo;
        lvngloan.lvngBusinessUnitCode := lvngLoanJournalLine.lvngBusinessUnitCode;
        lvngloan.lvngCommissionBaseAmount := lvngLoanJournalLine.lvngCommissionBaseAmount;
        lvngLoan.lvngCommissionDate := lvngLoanJournalLine.lvngCommissionDate;
        lvngloan.lvngConstrInterestRate := lvngLoanJournalLine.lvngConstrInterestRate;
        lvngloan.lvngDateClosed := lvngLoanJournalLine.lvngDateClosed;
        lvngloan.lvngDateFunded := lvngLoanJournalLine.lvngDateFunded;
        lvngloan.lvngDateLocked := lvngLoanJournalLine.lvngDateLocked;
        lvngloan.lvngDateSold := lvngLoanJournalLine.lvngDateSold;
        lvngloan.lvngFirstPaymentDue := lvngLoanJournalLine.lvngFirstPaymentDue;
        lvngloan.lvngFirstPaymentDueToInvestor := lvngLoanJournalLine.lvngFirstPaymentDueToInvestor;
        lvngloan.validate(lvngGlobalDimension1Code, lvngLoanJournalLine.lvngGlobalDimension1Code);
        lvngloan.validate(lvngGlobalDimension2Code, lvngLoanJournalLine.lvngGlobalDimension2Code);
        lvngloan.lvngInterestRate := lvngLoanJournalLine.lvngInterestRate;
        lvngloan.lvngInvestorCustomerNo := lvngLoanJournalLine.lvngInvestorCustomerNo;
        lvngloan.lvngLoanAmount := lvngLoanJournalLine.lvngLoanAmount;
        lvngloan.lvngLoanTermMonths := lvngLoanJournalLine.lvngLoanTermMonths;
        lvngloan.lvngMonthlyEscrowAmount := lvngLoanJournalLine.lvngMonthlyEscrowAmount;
        lvngloan.lvngMonthlyPaymentAmount := lvngLoanJournalLine.lvngMonthlyPaymentAmount;
        lvngloan.validate(lvngShortcutDimension3Code, lvngLoanJournalLine.lvngShortcutDimension3Code);
        lvngloan.validate(lvngShortcutDimension4Code, lvngLoanJournalLine.lvngShortcutDimension4Code);
        lvngloan.validate(lvngShortcutDimension5Code, lvngLoanJournalLine.lvngShortcutDimension5Code);
        lvngloan.validate(lvngShortcutDimension6Code, lvngLoanJournalLine.lvngShortcutDimension6Code);
        lvngloan.validate(lvngShortcutDimension7Code, lvngLoanJournalLine.lvngShortcutDimension7Code);
        lvngloan.validate(lvngShortcutDimension8Code, lvngLoanJournalLine.lvngShortcutDimension8Code);
        lvngloan.lvngTitleCustomerNo := lvngLoanJournalLine.lvngTitleCustomerNo;
        lvngloan.lvngWarehouseLineCode := lvngLoanJournalLine.lvngWarehouseLineCode;
        lvngLoan.lvngCoBorrowerFirstName := lvngLoanJournalLine.lvngCoBorrowerFirstName;
        lvngloan.lvngCoBorrowerLastName := lvngLoanJournalLine.lvngCoBorrowerLastName;
        lvngloan.lvngCoBorrowerMiddleName := lvngLoanJournalLine.lvngCoBorrowerMiddleName;
        lvngloan.lvng203KContractorName := lvngLoanJournalLine.lvng203KContractorName;
        lvngloan.lvng203KInspectorName := lvngLoanJournalLine.lvng203KInspectorName;
        if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngBorrower) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngBorrowerAddress;
        lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngBorrowerAddress2;
        lvngloanAddress.lvngCity := lvngLoanJournalLine.lvngBorrowerCity;
        lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngBorrowerState;
        lvngloanaddress.lvngZIPCode := lvngLoanJournalLine.lvngBorrowerZIPCode;
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngCoBorrower) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngCoBorrowerAddress;
        lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngCoBorrowerAddress2;
        lvngloanAddress.lvngCity := lvngLoanJournalLine.lvngCoBorrowerCity;
        lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngCoBorrowerState;
        lvngloanaddress.lvngZIPCode := lvngLoanJournalLine.lvngCoBorrowerZIPCode;
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngMailing) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngMailingAddress;
        lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngMailingAddress2;
        lvngloanAddress.lvngCity := lvngLoanJournalLine.lvngMailingCity;
        lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngMailingState;
        lvngloanaddress.lvngZIPCode := lvngLoanJournalLine.lvngMailingZIPCode;
        lvngLoanAddress.Modify();
        if not lvngLoanAddress.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanAddress.lvngAddressType::lvngProperty) then begin
            Clear(lvngLoanAddress);
            lvngLoanAddress.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
            lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
            lvngLoanAddress.Insert();
        end;
        lvngLoanAddress.lvngAddress := lvngLoanJournalLine.lvngPropertyAddress;
        lvngLoanAddress.lvngAddress2 := lvngLoanJournalLine.lvngPropertyAddress2;
        lvngloanAddress.lvngCity := lvngLoanJournalLine.lvngPropertyCity;
        lvngLoanAddress.lvngState := lvngLoanJournalLine.lvngPropertyState;
        lvngloanaddress.lvngZIPCode := lvngLoanJournalLine.lvngPropertyZIPCode;
        lvngLoanAddress.Modify();
        lvngLoanJournalValue.reset;
        lvngLoanJournalValue.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalLine.lvngLoanJournalBatchCode);
        lvngLoanJournalValue.SetRange(lvngLineNo, lvngLoanJournalLine.lvngLineNo);
        if lvngLoanJournalValue.FindSet() then begin
            repeat
                if lvngLoanValue.Get(lvngLoanJournalLine.lvngLoanNo, lvngLoanJournalValue.lvngFieldNo) then begin
                    lvngLoanValue.lvngFieldValue := lvngLoanJournalValue.lvngFieldValue;
                    EvaluateLoanFieldsValue(lvngLoanValue, true);
                    lvngLoanValue.Modify()
                end else begin
                    Clear(lvngLoanValue);
                    lvngLoanValue.lvngLoanNo := lvngLoanJournalLine.lvngLoanNo;
                    lvngLoanValue.lvngFieldNo := lvngLoanJournalValue.lvngFieldNo;
                    lvngLoanValue.lvngFieldValue := lvngLoanJournalValue.lvngFieldValue;
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
            if not lvngLoanFieldsConfigurationTemp.Get(lvngLoanValue.lvngFieldNo) then
                exit;
        end else begin
            lvngLoanFieldsConfiguration.Get(lvngLoanValue.lvngFieldNo);
            lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
        end;

        case lvngLoanFieldsConfigurationTemp.lvngValueType of
            lvngloanfieldsconfigurationtemp.lvngValueType::lvngBoolean:
                begin
                    if evaluate(lvngLoanValue.lvngBooleanValue, lvngLoanValue.lvngFieldValue) then;
                end;
            lvngloanfieldsconfigurationtemp.lvngValueType::lvngDate:
                begin
                    if evaluate(lvngLoanValue.lvngDateValue, lvngLoanValue.lvngFieldValue) then;
                end;
            lvngloanfieldsconfigurationtemp.lvngValueType::lvngDecimal:
                begin
                    if evaluate(lvngLoanValue.lvngDecimalValue, lvngLoanValue.lvngFieldValue) then;
                end;
            lvngloanfieldsconfigurationtemp.lvngValueType::lvngInteger:
                begin
                    if evaluate(lvngLoanValue.lvngIntegerValue, lvngLoanValue.lvngFieldValue) then;
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
        lvngLoanUpdateSchema.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
        if not lvngLoanUpdateSchema.IsEmpty() then begin
            Error(lvngClearTableLbl);
        end;
        if Page.RunModal(0, lvngLoanImportSchema) = Action::LookupOK then begin
            lvngLoanImportSchemaLine.reset;
            lvngLoanImportSchemaLine.SetRange(lvngCode, lvngLoanImportSchema.lvngCode);
            lvngLoanImportSchemaLine.SetFilter(lvngFieldType, '<>%1', lvngLoanImportSchemaLine.lvngFieldType::lvngDummy);
            if lvngLoanImportSchemaLine.FindSet() then begin
                repeat
                    Clear(lvngLoanUpdateSchema);
                    lvngLoanUpdateSchema.lvngJournalBatchCode := lvngJournalBatchCode;
                    lvngLoanUpdateSchema.lvngImportFieldType := lvngLoanImportSchemaLine.lvngFieldType;
                    lvngLoanUpdateSchema.lvngFieldNo := lvngLoanImportSchemaLine.lvngFieldNo;
                    lvngLoanUpdateSchema.lvngFieldUpdateOption := lvngLoanUpdateSchema.lvngFieldUpdateOption::lvngAlways;
                    lvngLoanUpdateSchema.Insert();
                until lvngLoanImportSchemaLine.Next() = 0;
            end;
            lvngLoanUpdateSchema.reset;
            lvngLoanUpdateSchema.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
            lvngLoanUpdateSchema.SetRange(lvngFieldNo, 1, 4);
            lvngLoanUpdateSchema.DeleteAll();
            lvngLoanUpdateSchema.SetRange(lvngFieldNo, 5000, 999999999);
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
            lvngLoanUpdateSchema.SetRange(lvngJournalBatchCode, lvngJournalBatchCode);
            lvngLoanUpdateSchema.ModifyAll(lvngFieldUpdateOption, lvngFieldUpdateOption);
            Message(lvngCompletedLbl);
        end;
    end;

    procedure GetFieldName(lvngFieldNo: Integer): Text
    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        if not lvngLoanFieldsConfiguration.Get(lvngFieldNo) then
            exit('ERROR');
        exit(lvngLoanFieldsConfiguration.lvngFieldName);
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