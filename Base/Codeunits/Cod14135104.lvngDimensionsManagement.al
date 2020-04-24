codeunit 14135104 lvngDimensionsManagement
{
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        LoanVisionSetupRetrieved: Boolean;
        GLSetupRetrieved: Boolean;

    procedure GetMainHierarchyDimensionCode(): Code[20]
    begin
        GetGLSetup();
        case GetMainHierarchyDimensionNo() of
            1:
                exit(GLSetup."Shortcut Dimension 1 Code");
            2:
                exit(GLSetup."Shortcut Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            else
                exit('');
        end;
    end;

    procedure GetMainHierarchyDimensionNo() DimensionNo: Integer
    begin
        GetLoanVisionSetup();
        case LoanVisionSetup."Hierarchy Levels" of
            1:
                DimensionNo := GetHierarchyDimensionNo(LoanVisionSetup."Level 1");
            2:
                DimensionNo := GetHierarchyDimensionNo(LoanVisionSetup."Level 2");
            3:
                DimensionNo := GetHierarchyDimensionNo(LoanVisionSetup."Level 3");
            4:
                DimensionNo := GetHierarchyDimensionNo(LoanVisionSetup."Level 4");
            5:
                DimensionNo := GetHierarchyDimensionNo(LoanVisionSetup."Level 5");
            else
                DimensionNo := 0;
        end;
    end;

    procedure GetHierarchyDimensionsUsage(var DimensionUsed: array[5] of Boolean)
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Hierarchy Levels" = 1 then
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 1")] := true;
        if LoanVisionSetup."Hierarchy Levels" = 2 then begin
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 2")] := true;
        end;
        if LoanVisionSetup."Hierarchy Levels" = 3 then begin
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 3")] := true;
        end;
        if LoanVisionSetup."Hierarchy Levels" = 4 then begin
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 3")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 4")] := true;
        end;
        if LoanVisionSetup."Hierarchy Levels" = 5 then begin
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 3")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 4")] := true;
            DimensionUsed[GetHierarchyDimensionNo(LoanVisionSetup."Level 5")] := true;
        end;
    end;

    procedure GetHierarchyDimensionNo(HierarchyLevels: Enum lvngHierarchyLevels): Integer;
    begin
        if HierarchyLevels = HierarchyLevels::"Business Unit" then
            exit(5)
        else
            exit(HierarchyLevels.AsInteger());
    end;

    procedure LookupCostCenter(var DimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        GetLoanVisionSetup();
        LoanVisionSetup.TestField("Cost Center Dimension Code");
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", LoanVisionSetup."Cost Center Dimension Code");
        if Page.RunModal(0, DimensionValue) = Action::LookupOK then
            DimensionValueCode := DimensionValue.Code;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRetrieved then begin
            GLSetup.Get();
            GLSetupRetrieved := true;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;

    procedure FillDimensionsFromTable(LoanDocument: Record lvngLoanDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanDocument."Global Dimension 1 Code";
        DimensionCodes[2] := LoanDocument."Global Dimension 2 Code";
        DimensionCodes[3] := LoanDocument."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanDocument."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanDocument."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanDocument."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanDocument."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanDocument."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(LoanDocumentLine: Record lvngLoanDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanDocumentLine."Global Dimension 1 Code";
        DimensionCodes[2] := LoanDocumentLine."Global Dimension 2 Code";
        DimensionCodes[3] := LoanDocumentLine."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanDocumentLine."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanDocumentLine."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanDocumentLine."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanDocumentLine."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanDocumentLine."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(LoanFundedDocument: Record lvngLoanFundedDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanFundedDocument."Global Dimension 1 Code";
        DimensionCodes[2] := LoanFundedDocument."Global Dimension 2 Code";
        DimensionCodes[3] := LoanFundedDocument."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanFundedDocument."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanFundedDocument."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanFundedDocument."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanFundedDocument."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanFundedDocument."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(LoanFundedDocumentLine: Record lvngLoanFundedDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanFundedDocumentLine."Global Dimension 1 Code";
        DimensionCodes[2] := LoanFundedDocumentLine."Global Dimension 2 Code";
        DimensionCodes[3] := LoanFundedDocumentLine."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanFundedDocumentLine."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanFundedDocumentLine."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanFundedDocumentLine."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanFundedDocumentLine."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanFundedDocumentLine."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(LoanSoldDocument: Record lvngLoanSoldDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanSoldDocument."Global Dimension 1 Code";
        DimensionCodes[2] := LoanSoldDocument."Global Dimension 2 Code";
        DimensionCodes[3] := LoanSoldDocument."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanSoldDocument."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanSoldDocument."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanSoldDocument."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanSoldDocument."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanSoldDocument."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(LoanSoldDocumentLine: Record lvngLoanSoldDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := LoanSoldDocumentLine."Global Dimension 1 Code";
        DimensionCodes[2] := LoanSoldDocumentLine."Global Dimension 2 Code";
        DimensionCodes[3] := LoanSoldDocumentLine."Shortcut Dimension 3 Code";
        DimensionCodes[4] := LoanSoldDocumentLine."Shortcut Dimension 4 Code";
        DimensionCodes[5] := LoanSoldDocumentLine."Shortcut Dimension 5 Code";
        DimensionCodes[6] := LoanSoldDocumentLine."Shortcut Dimension 6 Code";
        DimensionCodes[7] := LoanSoldDocumentLine."Shortcut Dimension 7 Code";
        DimensionCodes[8] := LoanSoldDocumentLine."Shortcut Dimension 8 Code";
    end;

    procedure FillDimensionsFromTable(Loan: Record lvngLoan; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := Loan."Global Dimension 1 Code";
        DimensionCodes[2] := Loan."Global Dimension 2 Code";
        DimensionCodes[3] := Loan."Shortcut Dimension 3 Code";
        DimensionCodes[4] := Loan."Shortcut Dimension 4 Code";
        DimensionCodes[5] := Loan."Shortcut Dimension 5 Code";
        DimensionCodes[6] := Loan."Shortcut Dimension 6 Code";
        DimensionCodes[7] := Loan."Shortcut Dimension 7 Code";
        DimensionCodes[8] := Loan."Shortcut Dimension 8 Code";
    end;

    procedure GetDimensionNames(var DimensionNames: array[8] of Text)
    var
        Dimension: Record Dimension;
    begin
        GetGLSetup();
        Clear(DimensionNames);
        if Dimension.Get(GLSetup."Global Dimension 1 Code") then
            DimensionNames[1] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Global Dimension 2 Code") then
            DimensionNames[2] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 3 Code") then
            DimensionNames[3] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 4 Code") then
            DimensionNames[4] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 5 Code") then
            DimensionNames[5] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 6 Code") then
            DimensionNames[6] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 7 Code") then
            DimensionNames[7] := Dimension."Code Caption";
        if Dimension.Get(GLSetup."Shortcut Dimension 8 Code") then
            DimensionNames[8] := Dimension."Code Caption";
    end;

    procedure GetDimensionNo(DimensionCode: Code[20]): Integer
    begin
        GetGLSetup();
        if DimensionCode = GLSetup."Shortcut Dimension 1 Code" then
            exit(1);
        if DimensionCode = GLSetup."Shortcut Dimension 2 Code" then
            exit(2);
        if DimensionCode = GLSetup."Shortcut Dimension 3 Code" then
            exit(3);
        if DimensionCode = GLSetup."Shortcut Dimension 4 Code" then
            exit(4);
        if DimensionCode = GLSetup."Shortcut Dimension 5 Code" then
            exit(5);
        if DimensionCode = GLSetup."Shortcut Dimension 6 Code" then
            exit(6);
        if DimensionCode = GLSetup."Shortcut Dimension 7 Code" then
            exit(7);
        if DimensionCode = GLSetup."Shortcut Dimension 8 Code" then
            exit(8);
        exit(-1);
    end;

    procedure ValidateDimensionHierarchyGenJnlLine(var Sender: Record "Gen. Journal Line")
    var
        DimensionHierarchy: Record lvngDimensionHierarchy;
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        ShortcutDimensions: array[8] of Code[20];
        MainDimensionNo: Integer;
        ShortcutDimCode: Code[20];
        DimensionUsage: array[5] of Boolean;
    begin
        MainDimensionNo := GetMainHierarchyDimensionNo();
        if (MainDimensionNo < 1) or (MainDimensionNo > 8) then
            exit;
        Clear(ShortcutDimensions);
        GetShortcutDimensionValues.GetShortcutDimensions(Sender."Dimension Set ID", ShortcutDimensions);
        ShortcutDimCode := ShortcutDimensions[MainDimensionNo];
        GetHierarchyDimensionsUsage(DimensionUsage);
        DimensionHierarchy.Reset();
        DimensionHierarchy.Ascending(false);
        if Sender."Posting Date" <> 0D then
            DimensionHierarchy.SetFilter(Date, '..%1', Sender."Posting Date")
        else
            DimensionHierarchy.SetRange(Date, 0D);
        DimensionHierarchy.SetRange(Code, ShortcutDimCode);
        if DimensionHierarchy.FindFirst() then begin
            if DimensionUsage[1] and (MainDimensionNo <> 1) then
                Sender.Validate("Shortcut Dimension 1 Code", DimensionHierarchy."Global Dimension 1 Code");
            if DimensionUsage[2] and (MainDimensionNo <> 2) then
                Sender.Validate("Shortcut Dimension 2 Code", DimensionHierarchy."Global Dimension 1 Code");
            if DimensionUsage[3] and (MainDimensionNo <> 3) then
                Sender.ValidateShortcutDimCode(3, DimensionHierarchy."Shortcut Dimension 3 Code");
            if DimensionUsage[4] and (MainDimensionNo <> 4) then
                Sender.ValidateShortcutDimCode(4, DimensionHierarchy."Shortcut Dimension 4 Code");
            if DimensionUsage[5] then
                Sender.Validate("Business Unit Code", DimensionHierarchy."Business Unit Code");
        end;
    end;
}