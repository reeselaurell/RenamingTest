codeunit 14135106 "lvngLoanCardManagement"
{
    procedure UpdateLoanCards(lvngJournalBatchCode: Code[20])
    var
        lvngLoanJournalBatch: Record lvngLoanJournalBatch;
        lvngLoanJournalLine: Record lvngLoanJournalLine;
        lvngLoanUpdateSchema: Record lvngLoanUpdateSchema;
        lvngLoanUpdateSchemaTemp: Record lvngLoanUpdateSchema temporary;
        lvngLoanJournalErrorMgmt: Codeunit lvngLoanJournalErrorMgmt;

    begin
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
        if lvngLoanJournalLine.FindSet() then begin
            repeat
                if not lvngLoanJournalErrorMgmt.HasError(lvngLoanJournalLine) then begin
                    case lvngLoanJournalBatch.lvngLoanCardUpdateOption of
                        lvngloanjournalbatch.lvngLoanCardUpdateOption::lvngAlways:
                            UpdateLoanCard(lvngLoanJournalLine);
                        lvngloanjournalbatch.lvngLoanCardUpdateOption::lvngSchema:
                            UpdateLoanCard(lvngLoanJournalLine, lvngLoanUpdateSchemaTemp);
                    end;
                end;
            until lvngLoanJournalLine.Next() = 0;
        end;
    end;

    procedure UpdateLoanCard(lvngLoanJournalLine: Record lvngLoanJournalLine; var lvngLoanUpdateSchema: record lvngLoanUpdateSchema)
    begin

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

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngLoanFieldsConfigurationRetrieved: Boolean;
        lvngCompletedLbl: Label 'Completed';
}