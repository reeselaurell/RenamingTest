codeunit 14135119 "lvnServicingManagement"
{
    var
        LoanServicingSetup: Record lvnLoanServicingSetup;
        Loan: Record lvnLoan;
        lvnDimensionManagement: Codeunit lvnDimensionsManagement;
        LoanServicingSetupRetrieved: Boolean;
        MainDimensionNo: Integer;
        DimensionsUsed: array[5] of Boolean;

    procedure GetPrincipalAndInterest(
        Loan: Record lvnLoan;
        NextPaymentDate: Date;
        var PrincipalAmount: Decimal;
        var InterestAmount: Decimal)
    var
        GLEntry: Record "G/L Entry";
        TempGLEntryBuffer: Record lvnGLEntryBuffer temporary;
        LineNo: Integer;
        PreviousBalance: Decimal;
        InterestPerMonth: Decimal;
        MonthlyPayment: Decimal;
        StartDate: Date;
        CalculationDate: Date;
        CalcDateFormatLbl: Label '<+%1M>', Comment = '%1 = Loan Term (Months) + 1';
        CalcDateLineNoFormatLbl: Label '<+%1M>', Comment = '%1 = Line No.';
    begin
        if Loan."Date Funded" = 0D then
            exit;
        if Loan."Loan Term (Months)" = 0 then
            exit;
        if Loan."First Payment Due" = 0D then
            Loan."First Payment Due" := CalcDate('<CM + 1D - 1M>', Loan."Date Funded");
        if CalcDate(StrSubstNo(CalcDateFormatLbl, Loan."Loan Term (Months)" + 1), Loan."First Payment Due") < NextPaymentDate then
            exit;
        GetSetupData();
        LoanServicingSetup.TestField("Principal Red. Reason Code");
        LoanServicingSetup.TestField("Principal Red. G/L Account No.");
        GLEntry.Reset();
        GLEntry.SetRange(lvnLoanNo, Loan."No.");
        GLEntry.SetRange("Reason Code", LoanServicingSetup."Principal Red. Reason Code");
        GLEntry.SetRange("G/L Account No.", LoanServicingSetup."Principal Red. G/L Account No.");
        if GLEntry.FindSet() then
            repeat
                Clear(TempGLEntryBuffer);
                TempGLEntryBuffer."Entry No." := GLEntry."Entry No.";
                TempGLEntryBuffer.Amount := GLEntry.Amount;
                TempGLEntryBuffer."Posting Date" := GLEntry."Posting Date";
                TempGLEntryBuffer.Insert();
            until GLEntry.Next() = 0;
        InterestPerMonth := Loan."Interest Rate" / 12 / 100;
        MonthlyPayment := InterestPerMonth * Loan."Loan Amount" * Power(1 + InterestPerMonth, Loan."Loan Term (Months)") / (Power(1 + InterestPerMonth, Loan."Loan Term (Months)") - 1);
        StartDate := Loan."First Payment Due";
        PreviousBalance := Loan."Loan Amount";
        CalculationDate := StartDate;
        for LineNo := 1 to Loan."Loan Term (Months)" do begin
            TempGLEntryBuffer.Reset();
            TempGLEntryBuffer.SetRange("Posting Date", CalcDate('<-1M + 1D>', CalculationDate), CalculationDate);
            if TempGLEntryBuffer.FindSet() then begin
                repeat
                    PreviousBalance := PreviousBalance + TempGLEntryBuffer.Amount;
                until TempGLEntryBuffer.Next() = 0;
                if PreviousBalance < 0 then
                    PreviousBalance := 0;
            end;
            InterestAmount := PreviousBalance * InterestPerMonth;
            PrincipalAmount := MonthlyPayment - InterestAmount;
            if PrincipalAmount > PreviousBalance then
                PrincipalAmount := PreviousBalance;
            if (InterestAmount = 0) and (PrincipalAmount = 0) then
                exit;
            InterestAmount := Round(InterestAmount, 0.01);
            PrincipalAmount := Round(PrincipalAmount, 0.01);
            if (InterestAmount + PrincipalAmount) <> Loan."Monthly Payment Amount" then
                PrincipalAmount := Loan."Monthly Payment Amount" - InterestAmount;
            CalculationDate := CalcDate(StrSubstNo(CalcDateLineNoFormatLbl, LineNo), StartDate);
        end;
    end;

    procedure GetTotalEscrowAmounts(Loan: Record lvnLoan): Decimal
    var
        EscrowFieldsMapping: Record lvnEscrowFieldsMapping;
        LoanValue: Record lvnLoanValue;
        EscrowAmount: Decimal;
    begin
        EscrowFieldsMapping.Reset();
        if EscrowFieldsMapping.FindSet() then
            repeat
                if LoanValue.Get(Loan."No.", EscrowFieldsMapping."Field No.") then
                    EscrowAmount := EscrowAmount + LoanValue."Decimal Value";
            until EscrowFieldsMapping.Next() = 0;
        exit(EscrowAmount);
    end;

    procedure ValidateServicingWorksheet()
    var
        ServicingWorksheet: Record lvnServicingWorksheet;
    begin
        ServicingWorksheet.Reset();
        if ServicingWorksheet.FindSet() then
            repeat
                ServicingWorksheet.CalculateAmounts();
                ValidateServicingLine(ServicingWorksheet);
                ServicingWorksheet.Modify();
            until ServicingWorksheet.Next() = 0;
    end;

    procedure ValidateServicingLine(var ServicingWorksheet: Record lvnServicingWorksheet)
    var
        Customer: Record Customer;
        EscrowsDoesntMatchErr: Label 'Total escrow amount doesn''t match';
        BorrowerCustomerMissingErr: Label 'Borrower Customer is empty or doesn''t exist';
    begin
        GetSetupData();
        GetLoan(ServicingWorksheet."Loan No.");
        if Loan."Date Sold" <> 0D then
            if Date2DMY(Loan."Date Sold", 1) > LoanServicingSetup."Last Servicing Month Day" then
                ServicingWorksheet."Payable to Investor" := true
            else
                ServicingWorksheet."Last Servicing Period" := true;
        Clear(ServicingWorksheet."Error Message");
        if LoanServicingSetup."Test Escrow Totals" then
            if Loan."Monthly Escrow Amount" <> ServicingWorksheet."Escrow Amount" then
                ServicingWorksheet."Error Message" := CopyStr(EscrowsDoesntMatchErr, 1, MaxStrLen(ServicingWorksheet."Error Message"));
        if ServicingWorksheet."Error Message" = '' then
            if not Customer.Get(Loan."Borrower Customer No.") then
                ServicingWorksheet."Error Message" := CopyStr(BorrowerCustomerMissingErr, 1, MaxStrLen(ServicingWorksheet."Error Message"));
    end;

    procedure CreateBorrowerCustomers()
    var
        ServicingWorksheet: Record lvnServicingWorksheet;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Template";
    begin
        GetSetupData();
        LoanServicingSetup.TestField("Borrower Customer Template");
        CustomerTemplate.Get(LoanServicingSetup."Borrower Customer Template");
        ServicingWorksheet.Reset();
        ServicingWorksheet.FindSet();
        repeat
            GetLoan(ServicingWorksheet."Loan No.");
            if Loan."Borrower Customer No." = '' then begin
                Customer."No." := Loan."No.";
                Customer.Name := CopyStr(Loan."Search Name", 1, MaxStrLen(Customer.Name));
                Customer.CopyFromCustomerTemplate(CustomerTemplate);
                Customer.Insert(true);
                Loan."Borrower Customer No." := Customer."No.";
                Loan.Modify(true);
            end;
        until ServicingWorksheet.Next() = 0;
    end;

    procedure CreateServicingDocuments()
    var
        ServicingWorksheet: Record lvnServicingWorksheet;
        LoanDocument: Record lvnLoanDocument;
        EscrowFieldsMapping: Record lvnEscrowFieldsMapping;
        LoanValue: Record lvnLoanValue;
        LoanDocumentLine: Record lvnLoanDocumentLine;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GLAccountCode: Code[20];
        LineNo: Integer;
        InterestLbl: Label 'Interest';
        PrincipalLbl: Label 'Principal';
    begin
        ValidateServicingWorksheet();
        GetSetupData();
        LoanServicingSetup.TestField("Serviced No. Series");
        LoanServicingSetup.TestField("Serviced Reason Code");
        ServicingWorksheet.Reset();
        ServicingWorksheet.FindSet();
        repeat
            if ServicingWorksheet."Error Message" = '' then begin
                LineNo := 1000;
                GetLoan(ServicingWorksheet."Loan No.");
                Clear(LoanDocument);
                LoanDocument.Init();
                LoanDocument.Validate("Transaction Type", LoanDocument."Transaction Type"::Serviced);
                LoanDocument.Validate("Document Type", LoanDocument."Document Type"::Invoice);
                LoanDocument.Validate("Document No.", NoSeriesManagement.DoGetNextNo(LoanServicingSetup."Serviced No. Series", Today, true, false));
                ServicingWorksheet.CalcFields("Next Payment Date", "First Payment Due", "Customer No.");
                LoanDocument.Validate("Customer No.", ServicingWorksheet."Customer No.");
                LoanDocument.Validate("Loan No.", ServicingWorksheet."Loan No.");
                if ServicingWorksheet."Next Payment Date" <> 0D then
                    LoanDocument.Validate("Posting Date", ServicingWorksheet."Next Payment Date") else
                    LoanDocument.Validate("Posting Date", ServicingWorksheet."First Payment Due");
                LoanDocument.Validate("Reason Code", LoanServicingSetup."Serviced Reason Code");
                LoanDocument.Validate("Global Dimension 1 Code", Loan."Global Dimension 1 Code");
                LoanDocument.Validate("Global Dimension 2 Code", Loan."Global Dimension 2 Code");
                LoanDocument.Validate("Shortcut Dimension 3 Code", Loan."Shortcut Dimension 3 Code");
                LoanDocument.Validate("Shortcut Dimension 4 Code", Loan."Shortcut Dimension 4 Code");
                LoanDocument.Validate("Shortcut Dimension 5 Code", Loan."Shortcut Dimension 5 Code");
                LoanDocument.Validate("Shortcut Dimension 6 Code", Loan."Shortcut Dimension 6 Code");
                LoanDocument.Validate("Shortcut Dimension 7 Code", Loan."Shortcut Dimension 7 Code");
                LoanDocument.Validate("Shortcut Dimension 8 Code", Loan."Shortcut Dimension 8 Code");
                LoanDocument.Validate("Business Unit Code", Loan."Business Unit Code");
                LoanDocument.Insert(true);
                Clear(LoanDocumentLine);
                LoanDocumentLine.Validate("Transaction Type", LoanDocument."Transaction Type");
                LoanDocumentLine.Validate("Document No.", LoanDocument."Document No.");
                LoanDocumentLine.Validate("Account Type", LoanDocumentLine."Account Type"::"G/L Account");
                if LoanServicingSetup."Interest G/L Acc. Switch Code" <> '' then begin
                    GLAccountCode := CalculateSwitch(LoanServicingSetup."Interest G/L Acc. Switch Code", ServicingWorksheet."Loan No.");
                    if GLAccountCode = '' then
                        GLAccountCode := LoanServicingSetup."Interest G/L Account No.";
                    LoanDocumentLine.Validate("Account No.", GLAccountCode);
                end else
                    LoanDocumentLine.Validate("Account No.", LoanServicingSetup."Interest G/L Account No."); //add switch
                LoanDocumentLine.Description := InterestLbl;
                LoanDocumentLine."Line No." := LineNo;
                LoanDocumentLine.Amount := ServicingWorksheet."Interest Amount";
                LoanDocumentLine."Servicing Type" := LoanDocumentLine."Servicing Type"::Interest;
                FillDimensions(ServicingWorksheet."Loan No.", LoanDocumentLine, LoanServicingSetup."Interest Cost Center Option", LoanServicingSetup."Interest Cost Center", LoanDocument."Posting Date");
                LoanDocumentLine.Insert(true);
                LineNo := LineNo + 1000;
                Clear(LoanDocumentLine);
                LoanDocumentLine.Validate("Transaction Type", LoanDocument."Transaction Type");
                LoanDocumentLine.Validate("Document No.", LoanDocument."Document No.");
                LoanDocumentLine.Validate("Account Type", LoanDocumentLine."Account Type"::"G/L Account");
                if LoanServicingSetup."Principal G/L Acc. Switch Code" <> '' then begin
                    GLAccountCode := CalculateSwitch(LoanServicingSetup."Principal G/L Acc. Switch Code", ServicingWorksheet."Loan No.");
                    if GLAccountCode = '' then
                        GLAccountCode := LoanServicingSetup."Principal G/L Account No.";
                    LoanDocumentLine.Validate("Account No.", GLAccountCode);
                end else
                    LoanDocumentLine.Validate("Account No.", LoanServicingSetup."Principal G/L Account No.");
                LoanDocumentLine.Description := PrincipalLbl;
                LoanDocumentLine."Line No." := LineNo;
                LoanDocumentLine.Amount := ServicingWorksheet."Principal Amount";
                LoanDocumentLine."Servicing Type" := LoanDocumentLine."Servicing Type"::Principal;
                FillDimensions(ServicingWorksheet."Loan No.", LoanDocumentLine, LoanServicingSetup."Principal Cost Center Option", LoanServicingSetup."Principal Cost Center", LoanDocument."Posting Date");
                LoanDocumentLine.Insert(true);
                LineNo := LineNo + 1000;
                EscrowFieldsMapping.Reset();
                EscrowFieldsMapping.SetFilter("Map-To G/L Account No.", '<>%1', '');
                if EscrowFieldsMapping.FindSet() then
                    repeat
                        if LoanValue.Get(ServicingWorksheet."Loan No.", EscrowFieldsMapping."Field No.") then begin
                            Clear(LoanDocumentLine);
                            LoanDocumentLine.Validate("Transaction Type", LoanDocument."Transaction Type");
                            LoanDocumentLine.Validate("Document No.", LoanDocument."Document No.");
                            LoanDocumentLine.Validate("Account Type", LoanDocumentLine."Account Type"::"G/L Account");
                            LoanDocumentLine.Validate("Account No.", EscrowFieldsMapping."Map-To G/L Account No."); //add switch
                            LoanDocumentLine."Line No." := LineNo;
                            LoanDocumentLine.Description := CopyStr(EscrowFieldsMapping.Description, 1, MaxStrLen(LoanDocumentLine.Description));
                            LoanDocumentLine.Amount := LoanValue."Decimal Value";
                            LoanDocumentLine."Servicing Type" := LoanDocumentLine."Servicing Type"::Escrow;
                            FillDimensions(ServicingWorksheet."Loan No.", LoanDocumentLine, EscrowFieldsMapping."Cost Center Option", EscrowFieldsMapping."Cost Center", LoanDocument."Posting Date");
                            LoanDocumentLine.Insert(true);
                            LineNo := LineNo + 1000;
                        end;
                    until EscrowFieldsMapping.Next() = 0;
            end;
        until ServicingWorksheet.Next() = 0;
    end;

    procedure ValidateDimensionFromHierarchy(
        var LoanDocumentLine: Record lvnLoanDocumentLine;
        ShortcutDimCode: Code[20];
        AsOfDate: Date)
    var
        DimensionHierarchy: Record lvnDimensionHierarchy;
    begin
        if (MainDimensionNo < 1) or (MainDimensionNo > 8) then
            exit;
        DimensionHierarchy.Reset();
        DimensionHierarchy.Ascending(false);
        if AsOfDate <> 0D then
            DimensionHierarchy.SetFilter(Date, '..%1', AsOfDate)
        else
            DimensionHierarchy.SetRange(Date, 0D);
        DimensionHierarchy.SetRange(Code, ShortcutDimCode);
        if DimensionHierarchy.FindFirst() then begin
            if DimensionsUsed[1] and (MainDimensionNo <> 1) then
                LoanDocumentLine."Global Dimension 1 Code" := DimensionHierarchy."Global Dimension 1 Code";
            if DimensionsUsed[2] and (MainDimensionNo <> 2) then
                LoanDocumentLine."Global Dimension 2 Code" := DimensionHierarchy."Global Dimension 2 Code";
            if DimensionsUsed[3] and (MainDimensionNo <> 3) then
                LoanDocumentLine."Shortcut Dimension 3 Code" := DimensionHierarchy."Shortcut Dimension 3 Code";
            if DimensionsUsed[4] and (MainDimensionNo <> 4) then
                LoanDocumentLine."Shortcut Dimension 4 Code" := DimensionHierarchy."Shortcut Dimension 4 Code";
            if DimensionsUsed[5] then
                LoanDocumentLine."Business Unit Code" := DimensionHierarchy."Business Unit Code";
            case MainDimensionNo of
                1:
                    LoanDocumentLine."Global Dimension 1 Code" := ShortcutDimCode;
                2:
                    LoanDocumentLine."Global Dimension 2 Code" := ShortcutDimCode;
                3:
                    LoanDocumentLine."Shortcut Dimension 3 Code" := ShortcutDimCode;
                4:
                    LoanDocumentLine."Shortcut Dimension 4 Code" := ShortcutDimCode;
                5:
                    LoanDocumentLine."Business Unit Code" := ShortcutDimCode;
            end;
        end;
    end;

    local procedure GetSetupData()
    begin
        if not LoanServicingSetupRetrieved then begin
            LoanServicingSetup.Get();
            lvnDimensionManagement.GetHierarchyDimensionsUsage(DimensionsUsed);
            MainDimensionNo := lvnDimensionManagement.GetMainHierarchyDimensionNo();
            LoanServicingSetupRetrieved := true;
        end;
    end;

    local procedure CalculateSwitch(SwitchCode: Code[20]; LoanNo: Code[20]): Text
    var
        TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
        ExpressionHeader: Record lvnExpressionHeader;
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        ExpressionEngine: Codeunit lvnExpressionEngine;
        Value: Text;
        SwitchCaseErr: Label 'Switch Case %1 can not be resolved', Comment = '%1 = Switch Code';
    begin
        GetLoan(LoanNo);
        ConditionsMgmt.FillLoanFieldValues(TempExpressionValueBuffer, Loan);
        ExpressionHeader.Get(SwitchCode, ConditionsMgmt.GetConditionsMgmtConsumerId());
        if not ExpressionEngine.SwitchCase(ExpressionHeader, Value, TempExpressionValueBuffer) then
            Error(SwitchCaseErr, SwitchCode);
        exit(Value);
    end;

    local procedure FillDimensions(
        LoanNo: Code[20];
        var LoanDocumentLine: Record lvnLoanDocumentLine;
        DimensionRule: Enum lvnServDimSelectionType;
        DefaultCostCenter: Code[20];
        AsOfDate: Date)
    begin
        GetLoan(LoanNo);
        case DimensionRule of
            DimensionRule::Blank:
                begin
                    LoanDocumentLine."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                    LoanDocumentLine."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                    LoanDocumentLine."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                    LoanDocumentLine."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                    LoanDocumentLine."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                    LoanDocumentLine."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                    LoanDocumentLine."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                    LoanDocumentLine."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                    LoanDocumentLine."Business Unit Code" := Loan."Business Unit Code";
                    ClearDimensionsUsage(LoanDocumentLine);
                end;
            DimensionRule::"Loan Card":
                begin
                    LoanDocumentLine."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                    LoanDocumentLine."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                    LoanDocumentLine."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                    LoanDocumentLine."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                    LoanDocumentLine."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                    LoanDocumentLine."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                    LoanDocumentLine."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                    LoanDocumentLine."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                    LoanDocumentLine."Business Unit Code" := Loan."Business Unit Code";
                    ClearDimensionsUsage(LoanDocumentLine);
                    case MainDimensionNo of
                        1:
                            DefaultCostCenter := Loan."Global Dimension 1 Code";
                        2:
                            DefaultCostCenter := Loan."Global Dimension 2 Code";
                        3:
                            DefaultCostCenter := Loan."Shortcut Dimension 3 Code";
                        4:
                            DefaultCostCenter := Loan."Shortcut Dimension 4 Code";
                        5:
                            DefaultCostCenter := Loan."Business Unit Code";
                    end;
                    ValidateDimensionFromHierarchy(LoanDocumentLine, DefaultCostCenter, AsOfDate);
                end;
            DimensionRule::"Cost Center Predefined":
                begin
                    LoanDocumentLine."Global Dimension 1 Code" := Loan."Global Dimension 1 Code";
                    LoanDocumentLine."Global Dimension 2 Code" := Loan."Global Dimension 2 Code";
                    LoanDocumentLine."Shortcut Dimension 3 Code" := Loan."Shortcut Dimension 3 Code";
                    LoanDocumentLine."Shortcut Dimension 4 Code" := Loan."Shortcut Dimension 4 Code";
                    LoanDocumentLine."Shortcut Dimension 5 Code" := Loan."Shortcut Dimension 5 Code";
                    LoanDocumentLine."Shortcut Dimension 6 Code" := Loan."Shortcut Dimension 6 Code";
                    LoanDocumentLine."Shortcut Dimension 7 Code" := Loan."Shortcut Dimension 7 Code";
                    LoanDocumentLine."Shortcut Dimension 8 Code" := Loan."Shortcut Dimension 8 Code";
                    LoanDocumentLine."Business Unit Code" := Loan."Business Unit Code";
                    ClearDimensionsUsage(LoanDocumentLine);
                    ValidateDimensionFromHierarchy(LoanDocumentLine, DefaultCostCenter, AsOfDate);
                end;
        end;
        LoanDocumentLine.GenerateDimensionSetId();
    end;

    local procedure ClearDimensionsUsage(var LoanDocumentLine: Record lvnLoanDocumentLine)
    begin
        if DimensionsUsed[1] then
            Clear(LoanDocumentLine."Global Dimension 1 Code");
        if DimensionsUsed[2] then
            Clear(LoanDocumentLine."Global Dimension 2 Code");
        if DimensionsUsed[3] then
            Clear(LoanDocumentLine."Shortcut Dimension 3 Code");
        if DimensionsUsed[4] then
            Clear(LoanDocumentLine."Shortcut Dimension 4 Code");
        if DimensionsUsed[5] then
            Clear(LoanDocumentLine."Business Unit Code");
    end;

    local procedure GetLoan(LoanNo: Code[20])
    begin
        if Loan."No." <> LoanNo then
            Loan.Get(LoanNo);
    end;
}