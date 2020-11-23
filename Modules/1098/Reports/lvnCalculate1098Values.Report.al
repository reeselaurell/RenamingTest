report 14135105 "lvnCalculate1098Values"
{
    Caption = 'Calculate 1098 Values';
    ProcessingOnly = true;

    dataset
    {
        dataitem(FormEntry; lvnForm1098Entry)
        {
            trigger OnPreDataItem()
            begin
                Progress.Open(ProcessingLoanMsg);
            end;

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                TempGLEntry: Record "G/L Entry" temporary;
                TempExpressionValueBuffer: Record lvnExpressionValueBuffer temporary;
                Loan: Record lvnLoan;
            begin
                Progress.Update(1, "Loan No.");
                Validate("Loan No.");
                Loan.Get("Loan No.");
                TempGLEntry.Reset();
                TempGLEntry.DeleteAll();
                GLEntry.Reset();
                GLEntry.SetCurrentKey(lvnLoanNo);
                GLEntry.SetRange(lvnLoanNo, "Loan No.");
                if GLEntry.FindSet() then
                    repeat
                        TempGLEntry := GLEntry;
                        TempGLEntry.Insert();
                    until GLEntry.Next() = 0;
                TempExpressionValueBuffer.Reset();
                TempExpressionValueBuffer.DeleteAll();
                ConditionsMgmt.FillLoanFieldValues(TempExpressionValueBuffer, Loan);
                "Box 1" := CalculateValue(1, TempGLEntry, TempExpressionValueBuffer);
                "Box 2" := CalculateValue(2, TempGLEntry, TempExpressionValueBuffer);
                "Box 4" := CalculateValue(4, TempGLEntry, TempExpressionValueBuffer);
                "Box 5" := CalculateValue(5, TempGLEntry, TempExpressionValueBuffer);
                "Box 6" := CalculateValue(6, TempGLEntry, TempExpressionValueBuffer);
                "Box 10" := CalculateValue(10, TempGLEntry, TempExpressionValueBuffer);
                "Not Eligible" := not ("Box 1" >= Box1Limit) or ("Box 5" >= Box5Limit) or ("Box 1" + "Box 6" >= Box1Plus6Limit);
                Modify();
            end;

            trigger OnPostDataItem()
            begin
                Progress.Close();
                Reset();
                SetRange("Not Eligible", true);
                DeleteAll(true);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(YearField; Year) { Caption = 'As of Year'; ApplicationArea = All; }
                    field(Box1LimitField; Box1Limit) { Caption = 'Box 1 Limit'; ApplicationArea = All; }
                    field(Box5LimitField; Box5Limit) { Caption = 'Box 5 Limit'; ApplicationArea = All; }
                    field(Box1Plus6LimitField; Box1Plus6Limit) { Caption = 'Box 1 + Box 6 Limit'; ApplicationArea = All; }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if Box1Limit = 0 then
                Box1Limit := 600;
            if Box1Plus6Limit = 0 then
                Box1Plus6Limit := 600;
            if Box5Limit = 0 then
                Box5Limit := 600;
        end;
    }

    trigger OnPreReport()
    begin
        Form1098Details.Reset();
        Form1098Details.DeleteAll();
    end;

    var
        Form1098Details: Record lvnForm1098Details;
        ConditionsMgmt: Codeunit lvnConditionsMgmt;
        Progress: Dialog;
        Year: Integer;
        Box1Limit: Decimal;
        Box5Limit: Decimal;
        Box1Plus6Limit: Decimal;
        ProcessingLoanMsg: Label 'Processing Loan #1#########', Comment = '#1 = Loan No.';

    local procedure ApplyGLEntryFilters(
        var GLEntry: Record "G/L Entry";
        var Form1098ColRuleDetails: Record lvnForm1098ColRuleDetails): Boolean
    var
        IStream: InStream;
        ViewText: Text;
    begin
        Form1098ColRuleDetails.CalcFields("G/L Filter");
        if Form1098ColRuleDetails."G/L Filter".HasValue then begin
            Form1098ColRuleDetails."G/L Filter".CreateInStream(IStream);
            IStream.ReadText(ViewText);
            GLEntry.SetView(ViewText);
            exit(true);
        end else
            exit(false);
    end;

    local procedure CalculateValue(
        BoxNo: Integer;
        var TempGLEntry: Record "G/L Entry";
        var TempExpressionValueBuffer: Record lvnExpressionValueBuffer) Value: Decimal
    var
        Form1098CollectionRule: Record lvnForm1098CollectionRule;
        Form1098ColRuleDetails: Record lvnForm1098ColRuleDetails;
        Form1098Details: Record lvnForm1098Details;
        ExpressionHeader: Record lvnExpressionHeader;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ClosingVendorLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ClosingCustLedgerEntry: Record "Cust. Ledger Entry";
        ExpressionEngine: Codeunit lvnExpressionEngine;
        LineNo: Integer;
        ProcessLoan: Boolean;
        YearCompare: Integer;
        CalculatedValue: Decimal;
    begin
        LineNo := 1;
        if Form1098CollectionRule.Get(BoxNo) then begin
            Form1098ColRuleDetails.Reset();
            Form1098ColRuleDetails.SetRange("Box No.", Form1098CollectionRule."Box No.");
            if Form1098ColRuleDetails.FindSet() then
                repeat
                    ProcessLoan := true;
                    if Form1098ColRuleDetails."Condition Code" <> '' then
                        if ExpressionHeader.Get(Form1098ColRuleDetails."Condition Code", ConditionsMgmt.GetConditionsMgmtConsumerId()) then
                            ProcessLoan := ExpressionEngine.CheckCondition(ExpressionHeader, TempExpressionValueBuffer)
                        else
                            ProcessLoan := false;
                    if ProcessLoan then
                        if Form1098ColRuleDetails.Type = Form1098ColRuleDetails.Type::"G/L Entry" then begin
                            TempGLEntry.Reset();
                            if ApplyGLEntryFilters(TempGLEntry, Form1098ColRuleDetails) then
                                if TempGLEntry.FindSet() then
                                    repeat
                                        if Form1098ColRuleDetails."Reverse Amount" then
                                            TempGLEntry.Amount := -TempGLEntry.Amount;
                                        if not Form1098ColRuleDetails."Document Paid" then begin
                                            Value += TempGLEntry.Amount;
                                            Clear(Form1098Details);
                                            Form1098Details."Loan No." := FormEntry."Loan No.";
                                            Form1098Details."Box No." := BoxNo;
                                            Form1098Details."Line No." := LineNo;
                                            LineNo += 1;
                                            Form1098Details.Type := Form1098Details.Type::"G/L Entry";
                                            Form1098Details."G/L Entry No." := TempGLEntry."Entry No.";
                                            Form1098Details.Description := TempGLEntry.Description;
                                            Form1098Details.Amount := TempGLEntry.Amount;
                                            Form1098Details."Rule Line No." := Form1098ColRuleDetails."Line No.";
                                            Form1098Details.Insert();
                                        end else
                                            case TempGLEntry."Source Type" of
                                                TempGLEntry."Source Type"::Vendor:
                                                    begin
                                                        VendorLedgerEntry.Reset();
                                                        VendorLedgerEntry.SetCurrentKey("Transaction No.");
                                                        VendorLedgerEntry.SetRange("Transaction No.", TempGLEntry."Transaction No.");
                                                        VendorLedgerEntry.SetRange("Document No.", TempGLEntry."Document No.");
                                                        if VendorLedgerEntry.FindFirst() then
                                                            if not VendorLedgerEntry.Open then begin
                                                                if VendorLedgerEntry."Closed at Date" = 0D then begin
                                                                    ClosingVendorLedgerEntry.Reset();
                                                                    ClosingVendorLedgerEntry.SetRange("Closed by Entry No.", VendorLedgerEntry."Entry No.");
                                                                    if ClosingVendorLedgerEntry.FindFirst() then
                                                                        VendorLedgerEntry."Closed at Date" := ClosingVendorLedgerEntry."Posting Date"
                                                                    else
                                                                        VendorLedgerEntry."Closed at Date" := DMY2Date(1, 1, Year);
                                                                end;
                                                                if Form1098ColRuleDetails."Paid Before Current Year" then
                                                                    YearCompare := Year - 1
                                                                else
                                                                    YearCompare := Year;
                                                                if Date2DMY(VendorLedgerEntry."Closed at Date", 3) = YearCompare then begin
                                                                    Value += TempGLEntry.Amount;
                                                                    Clear(Form1098Details);
                                                                    Form1098Details."Loan No." := FormEntry."Loan No.";
                                                                    Form1098Details."Box No." := BoxNo;
                                                                    Form1098Details."Line No." := LineNo;
                                                                    LineNo += 1;
                                                                    Form1098Details.Type := Form1098Details.Type::"G/L Entry";
                                                                    Form1098Details."G/L Entry No." := TempGLEntry."Entry No.";
                                                                    Form1098Details.Description := TempGLEntry.Description;
                                                                    Form1098Details.Amount := TempGLEntry.Amount;
                                                                    Form1098Details."Rule Line No." := Form1098Details."Line No.";
                                                                    Form1098Details."Closed at Date" := VendorLedgerEntry."Closed at Date";
                                                                    Form1098Details.Insert();
                                                                end;
                                                            end;
                                                    end;
                                                TempGLEntry."Source Type"::Customer:
                                                    begin
                                                        CustLedgerEntry.Reset();
                                                        CustLedgerEntry.SetCurrentKey("Transaction No.");
                                                        CustLedgerEntry.SetRange("Transaction No.", TempGLEntry."Transaction No.");
                                                        CustLedgerEntry.SetRange("Document No.", TempGLEntry."Document No.");
                                                        if CustLedgerEntry.FindFirst() then
                                                            if not CustLedgerEntry.Open then begin
                                                                if CustLedgerEntry."Closed at Date" = 0D then begin
                                                                    ClosingCustLedgerEntry.Reset();
                                                                    ClosingCustLedgerEntry.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
                                                                    if ClosingCustLedgerEntry.FindFirst() then
                                                                        CustLedgerEntry."Closed at Date" := ClosingCustLedgerEntry."Posting Date"
                                                                    else
                                                                        CustLedgerEntry."Closed at Date" := DMY2Date(1, 1, Year);
                                                                end;
                                                                if Form1098ColRuleDetails."Paid Before Current Year" then
                                                                    YearCompare := Year - 1
                                                                else
                                                                    YearCompare := Year;
                                                                if Date2DMY(CustLedgerEntry."Closed at Date", 3) = YearCompare then begin
                                                                    Value += TempGLEntry.Amount;
                                                                    Clear(Form1098Details);
                                                                    Form1098Details."Loan No." := FormEntry."Loan No.";
                                                                    Form1098Details."Box No." := BoxNo;
                                                                    Form1098Details."Line No." := LineNo;
                                                                    LineNo += 1;
                                                                    Form1098Details.Type := Form1098Details.Type::"G/L Entry";
                                                                    Form1098Details."G/L Entry No." := TempGLEntry."Entry No.";
                                                                    Form1098Details.Description := TempGLEntry.Description;
                                                                    Form1098Details.Amount := TempGLEntry.Amount;
                                                                    Form1098Details."Rule Line No." := Form1098Details."Line No.";
                                                                    Form1098Details."Closed at Date" := CustLedgerEntry."Closed at Date";
                                                                    Form1098Details.Insert();
                                                                end;
                                                            end;
                                                    end;
                                            end;
                                    until TempGLEntry.Next() = 0;
                        end else
                            if ExpressionHeader.Get(Form1098ColRuleDetails."Formula Code", ConditionsMgmt.GetConditionsMgmtConsumerId()) then
                                if Evaluate(CalculatedValue, ExpressionEngine.CalculateFormula(ExpressionHeader, TempExpressionValueBuffer)) then begin
                                    Value += CalculatedValue;
                                    Clear(Form1098Details);
                                    Form1098Details."Loan No." := FormEntry."Loan No.";
                                    Form1098Details."Box No." := BoxNo;
                                    Form1098Details."Line No." := LineNo;
                                    LineNo += 1;
                                    Form1098Details.Type := Form1098Details.Type::Formula;
                                    Form1098Details.Description := Form1098ColRuleDetails."Formula Code";
                                    Form1098Details.Amount := CalculatedValue;
                                    Form1098Details."Rule Line No." := Form1098ColRuleDetails."Line No.";
                                    Form1098Details.Insert();
                                end;
                until Form1098ColRuleDetails.Next() = 0;
        end;
    end;
}