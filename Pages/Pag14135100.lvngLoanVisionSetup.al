page 14135100 "lvngLoanVisionSetup"
{

    PageType = Card;
    SourceTable = lvngLoanVisionSetup;
    Caption = 'Loan Vision Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(lvngReasonCodes)
                {
                    Caption = 'Reason Codes';
                    field(lvngFundedReasonCode; lvngFundedReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngFundedVoidReasonCode; lvngFundedVoidReasonCode)
                    {
                        ApplicationArea = All;
                    }

                    field(lvngSoldReasonCode; lvngSoldReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngSoldVoidReasonCode; lvngSoldVoidReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngServicedReasonCode; lvngServicedReasonCode)
                    {
                        ApplicationArea = All;
                    }
                    field(lvngServicedVoidReasonCode; lvngServicedVoidReasonCode)
                    {
                        ApplicationArea = All;
                    }
                }
                group(lvngSourceCodes)
                {
                    Caption = 'Source Codes';
                    field(lvngFundedSourceCode; lvngFundedSourceCode)
                    {
                        ApplicationArea = All;
                    }
                }
                group(lvngMisc)
                {
                    Caption = 'Misc.';
                    field(lvngSearchNameTemplate; lvngSearchNameTemplate)
                    {
                        ApplicationArea = All;
                        ToolTip = '%1 - First Name, %2 - Last Name, %3 - Middle Name';
                    }

                    field(MaintenanceMode; lvngMaintenanceMode)
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Dimensions)
            {
                group(GeneralDimensions)
                {
                    Caption = 'General';
                    field(CostCenter; lvngCostCenterDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(PropertyStateCode; lvngPropertyStateDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanTypeCode; lvngLoanTypeDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanOfficerCode; lvngLoanOfficerDimensionCode)
                    {
                        ApplicationArea = All;
                    }

                    field(LoanPurposeCode; lvngLoanPurposeDimensionCode)
                    {
                        ApplicationArea = All;
                    }
                }
                group(HierarchyLevelsGroup)
                {
                    Caption = 'Hierarchy Levels';

                    field(HierarchyLevels; lvngHierarchyLevels)
                    {
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel1; lvngLevel1)
                    {
                        Editable = lvngHierarchyLevels > 0;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel2; lvngLevel2)
                    {
                        Editable = lvngHierarchyLevels > 1;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel3; lvngLevel3)
                    {
                        Editable = lvngHierarchyLevels > 2;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel4; lvngLevel4)
                    {
                        Editable = lvngHierarchyLevels > 3;
                        ApplicationArea = All;
                    }
                    field(HierarchyLevel5; lvngLevel5)
                    {
                        Editable = lvngHierarchyLevels > 4;
                        ApplicationArea = All;
                    }
                }
            }
        }
        //You might want to add fields here

    }
    actions
    {
        area(Processing)
        {
            action(lvngTempUpgrade)
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    UPG17: Record UPG17;
                    UPG15: Record UPG15;
                    UPG18: Record UPG18;
                    UPG21: Record UPG21;
                    UPG23: Record UPG23;
                    UPG25: Record UPG25;
                    UPG110: Record UPG110;
                    UPG111: Record UPG111;
                    UPG113: Record UPG113;
                    UPG115: Record UPG115;
                    UPG120: Record UPG120;
                    UPG121: Record UPG121;
                    UPG123: Record UPG123;
                    UPG125: Record UPG125;
                    UPG270: Record UPG270;
                    UPG271: Record UPG271;
                    UPG349: Record UPG349;
                    GLEntry: Record "G/L Entry";
                    GLAccount: Record "G/L Account";
                    DimensionValue: Record "Dimension Value";
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    CustomerLedgerEntry: Record "Cust. Ledger Entry";
                    SalesInvLine: Record "Sales Invoice Line";
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesCrMemoLine: Record "Sales Cr.Memo Line";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    CheckLedgerEntry: Record "Check Ledger Entry";
                    UPGLoanValue: Record UPGLoanValue;
                    UPGLoan: Record UPGLoan;
                    UPGLoanAddress: Record UPGLoanAddress;
                    UPGLoanFieldsConfiguration: Record UPGLoanFieldsConfiguration;
                    UPGDimensionCodeLink: Record UPGDimensionCodeLink;
                    lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                    lvngLoanAddress: Record lvngLoanAddress;
                    lvngLoanValue: Record lvngLoanValue;
                    lvngLoan: Record lvngLoan;
                    lvngLastNamePosition: Integer;
                    lvngWarehouseLineTemp: Record lvngWarehouseLine temporary;
                    lvngWarehouseLine: Record lvngWarehouseLine;
                begin
                    UPG349.reset;
                    UPG349.FindSet();
                    repeat
                        if DimensionValue.Get(UPG349."Dimension Code", UPG349.Code) then begin
                            DimensionValue.lvngAdditionalCode := UPG349."Payroll ID";
                            DimensionValue.Modify();
                        end;
                    until UPG349.Next() = 0;
                    UPG15.Reset();
                    UPG15.FindSet();
                    repeat
                        if GLAccount.Get(UPG15."No.") then begin
                            glaccount.lvngReportingAccountName := UPG15."Reporting Account Name";
                            case UPG15."Reporting Account Type" of
                                UPG15."Reporting Account Type"::Expense:
                                    GLAccount.lvngReportingAccountType := GLAccount.lvngReportingAccountType::lvngExpense;
                                UPG15."Reporting Account Type"::Income:
                                    GLAccount.lvngReportingAccountType := GLAccount.lvngReportingAccountType::lvngIncome;
                            end;
                            glaccount.lvngLoanNoMandatory := UPG15."Loan No. Mandatory";
                            GLAccount.Modify();
                        end;
                    until UPG15.Next() = 0;
                    UPG17.reset;
                    UPG17.FindSet();
                    repeat
                        GLEntry.Get(upg17."Entry No.");
                        GLEntry.lvngEntryDate := upg17."Entry Date";
                        GLEntry.lvngImportID := upg17."Import ID";
                        GLEntry.lvngLoanNo := UPG17."Loan No.";
                        GLEntry.lvngShortcutDimension3Code := upg17."Shortcut Dimension 3 Code";
                        GLEntry.lvngShortcutDimension4Code := upg17."Shortcut Dimension 4 Code";
                        GLEntry.lvngShortcutDimension5Code := upg17."Shortcut Dimension 5 Code";
                        GLEntry.lvngShortcutDimension6Code := upg17."Shortcut Dimension 6 Code";
                        GLEntry.lvngShortcutDimension7Code := upg17."Shortcut Dimension 7 Code";
                        GLEntry.lvngShortcutDimension8Code := upg17."Shortcut Dimension 8 Code";
                        GLEntry.Modify();
                    until upg17.Next() = 0;
                    UPGLoanFieldsConfiguration.reset;
                    UPGLoanFieldsConfiguration.FindSet();
                    repeat
                        clear(lvngLoanFieldsConfiguration);
                        lvngLoanFieldsConfiguration.lvngFieldNo := UPGLoanFieldsConfiguration."Field No.";
                        lvngLoanFieldsConfiguration.lvngFieldName := UPGLoanFieldsConfiguration."Field Name";
                        case UPGLoanFieldsConfiguration."Value Type" of
                            UPGLoanFieldsconfiguration."Value Type"::Boolean:
                                begin
                                    lvngLoanFieldsConfiguration.lvngValueType := lvngLoanFieldsConfiguration.lvngValueType::lvngBoolean;
                                end;
                            UPGLoanFieldsconfiguration."Value Type"::Date:
                                begin
                                    lvngLoanFieldsConfiguration.lvngValueType := lvngLoanFieldsConfiguration.lvngValueType::lvngDate;
                                end;
                            UPGLoanFieldsconfiguration."Value Type"::Decimal:
                                begin
                                    lvngLoanFieldsConfiguration.lvngValueType := lvngLoanFieldsConfiguration.lvngValueType::lvngDecimal;
                                end;
                            UPGLoanFieldsconfiguration."Value Type"::Integer:
                                begin
                                    lvngLoanFieldsConfiguration.lvngValueType := lvngLoanFieldsConfiguration.lvngValueType::lvngInteger;
                                end;
                            UPGLoanFieldsconfiguration."Value Type"::Text:
                                begin
                                    lvngLoanFieldsConfiguration.lvngValueType := lvngLoanFieldsConfiguration.lvngValueType::lvngText;
                                end;
                        end;
                        lvngLoanFieldsConfiguration.Insert();
                    until UPGLoanFieldsConfiguration.Next() = 0;
                    UPGLoanAddress.reset;
                    UPGLoanAddress.FindSet();
                    repeat
                        Clear(lvngLoanAddress);
                        lvngLoanAddress.lvngAddress := UPGLoanAddress.Address;
                        lvngLoanAddress.lvngAddress2 := UPGLoanAddress."Address 2";
                        lvngLoanAddress.lvngLoanNo := UPGLoanAddress."Loan No.";
                        lvngLoanAddress.lvngCity := UPGLoanAddress.City;
                        lvngLoanAddress.lvngZIPCode := UPGLoanAddress."ZIP Code";
                        lvngLoanAddress.lvngState := UPGLoanAddress.State;
                        case UPGLoanAddress."Address Type" of
                            upgloanaddress."Address Type"::Borrower:
                                begin
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngBorrower;
                                end;
                            upgloanaddress."Address Type"::"Co-Borrower":
                                begin
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngCoBorrower;
                                end;
                            upgloanaddress."Address Type"::Mailing:
                                begin
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngMailing;
                                end;
                            upgloanaddress."Address Type"::Property:
                                begin
                                    lvngLoanAddress.lvngAddressType := lvngLoanAddress.lvngAddressType::lvngProperty;
                                end;
                        end;
                        lvngLoanAddress.Insert();
                    until UPGLoanAddress.Next() = 0;
                    UPGLoanValue.reset;
                    UPGLoanValue.FindSet();
                    repeat
                        lvngLoanValue.lvngBooleanValue := UPGLoanValue."Boolean Value";
                        lvngLoanValue.lvngDateValue := UPGLoanValue."Date Value";
                        lvngLoanValue.lvngDecimalValue := UPGLoanValue."Decimal Value";
                        lvngLoanValue.lvngIntegerValue := UPGLoanValue."Integer Value";
                        lvngLoanValue.lvngLoanNo := UPGLoanValue."Loan No.";
                        lvngLoanValue.lvngFieldNo := UPGLoanValue."Field No.";
                        lvngLoanValue.lvngFieldValue := UPGLoanValue."Field Value";
                        lvngLoanValue.Insert();
                    until UPGLoanValue.Next() = 0;
                    UPGLoan.reset;
                    UPGLoan.FindSet();
                    repeat
                        Clear(lvngLoan);
                        lvngLoan.lvng203KContractorName := UPGLoan.Contractor;
                        lvngLoan.lvng203KInspectorName := UPGLoan.Inspector;
                        lvngLoan.lvngApplicationDate := UPGLoan."Application Date";
                        lvngLoan.lvngBlocked := UPGLoan.Blocked;
                        lvngLoan.lvngBorrowerCustomerNo := UPGLoan."Borrower Customer No.";
                        lvngLastNamePosition := StrPos(UPGLoan."Borrower Name", ' ');
                        if lvngLastNamePosition <> 0 then begin
                            lvngLoan.lvngBorrowerFirstName := CopyStr(UPGLoan."Borrower Name", 1, lvngLastNamePosition);
                            lvngLoan.lvngBorrowerLastName := CopyStr(UPGLoan."Borrower Name", lvngLastNamePosition + 1);
                        end else
                            lvngloan.lvngBorrowerFirstName := copystr(UPGLoan."Borrower Name", 1, MaxStrLen(lvngLoan.lvngBorrowerFirstName));
                        lvngLastNamePosition := StrPos(UPGLoan."Co-Borrower Name", ' ');
                        if lvngLastNamePosition <> 0 then begin
                            lvngLoan.lvngCoBorrowerFirstName := CopyStr(UPGLoan."Co-Borrower Name", 1, lvngLastNamePosition);
                            lvngLoan.lvngCoBorrowerLastName := CopyStr(UPGLoan."Co-Borrower Name", lvngLastNamePosition + 1);
                        end else
                            lvngloan.lvngCoBorrowerFirstName := copystr(UPGLoan."Co-Borrower Name", 1, MaxStrLen(lvngLoan.lvngBorrowerFirstName));
                        lvngLoan.lvngBusinessUnitCode := UPGLoan."Business Unit Code";
                        lvngLoan.lvngGlobalDimension1Code := UPGLoan."Global Dimension 1 Code";
                        lvngLoan.lvngGlobalDimension2Code := UPGLoan."Global Dimension 2 Code";
                        lvngLoan.lvngShortcutDimension3Code := UPGLoan."Shortcut Dimension 3 Code";
                        lvngLoan.lvngShortcutDimension4Code := UPGLoan."Shortcut Dimension 4 Code";
                        lvngLoan.lvngShortcutDimension5Code := UPGLoan."Shortcut Dimension 5 Code";
                        lvngLoan.lvngShortcutDimension6Code := UPGLoan."Shortcut Dimension 6 Code";
                        lvngLoan.lvngShortcutDimension7Code := UPGLoan."Shortcut Dimension 7 Code";
                        lvngLoan.lvngShortcutDimension8Code := UPGLoan."Shortcut Dimension 8 Code";
                        lvngLoan.lvngCommissionBaseAmount := UPGLoan."Loan Amount";
                        lvngLoan.lvngLoanAmount := UPGLoan."Loan Amount";
                        lvngLoan.lvngLoanNo := UPGLoan."Loan No.";
                        lvngLoan.lvngConstrInterestRate := UPGLoan."Construction Interest Rate";
                        lvngLoan.lvngInterestRate := UPGLoan."Interest Rate";
                        lvngLoan.lvngDateClosed := UPGLoan."Date Closed";
                        lvngloan.lvngDateLocked := UPGLoan."Date Locked";
                        lvngLoan.lvngDateFunded := UPGLoan."Date Funded";
                        lvngLoan.lvngDateSold := UPGLoan."Date Sold";
                        lvngLoan.lvngFirstPaymentDue := UPGLoan."First Payment Due";
                        lvngLoan.lvngFirstPaymentDueToInvestor := UPGLoan."First Payment Due to Investor";
                        lvngLoan.lvngInvestorCustomerNo := UPGLoan."Investor Customer No.";
                        lvngLoan.lvngSearchName := UPGLoan."Search Name";
                        lvngLoan.lvngLoanTermMonths := UPGLoan."Loan Term (Months)";
                        lvngLoan.lvngMonthlyEscrowAmount := UPGLoan."Monthly Escrow Amount";
                        lvngLoan.lvngTitleCustomerNo := UPGLoan."Title Customer No.";
                        lvngLoan.lvngWarehouseLineCode := UPGLoan."Warehouse Line Code";
                        lvngLoan.Insert();
                        lvngWarehouseLineTemp.lvngCode := UPGLoan."Warehouse Line Code";
                        if lvngWarehouseLineTemp.Insert() then;
                    until UPGLoan.next() = 0;
                    lvngWarehouseLineTemp.reset;
                    if lvngWarehouseLineTemp.FindSet() then begin
                        Clear(lvngWarehouseLine);
                        lvngWarehouseLine.lvngCode := lvngWarehouseLineTemp.lvngCode;
                        lvngWarehouseLine.lvngDescription := lvngWarehouseLine.lvngCode;
                        if lvngWarehouseLine.Insert() then;
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

    local procedure InsertIfNotExists()
    begin
        reset;
        if not get then begin
            Init();
            Insert();
        end;
    end;

}
