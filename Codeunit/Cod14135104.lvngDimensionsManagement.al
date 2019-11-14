codeunit 14135104 lvngDimensionsManagement
{
    procedure GetMainHierarchyDimensionCode(): Code[20]
    var
        DimensionNo: Integer;
    begin
        GetGLSetup();
        GetLoanVisionSetup();
        if lvngLoanVisionSetup."Hierarchy Levels" = 1 then
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1");
        if lvngLoanVisionSetup."Hierarchy Levels" = 2 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 3 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 3");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 4 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 4");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 5 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 5");
        end;
        case DimensionNo of
            1:
                exit(GLSetup."Shortcut Dimension 1 Code");
            2:
                exit(GLSetup."Shortcut Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            else
                exit('')
        end;
    end;

    procedure GetMainHierarchyDimensionNo(): Integer
    var
        DimensionNo: Integer;
    begin
        GetGLSetup();
        GetLoanVisionSetup();
        if lvngLoanVisionSetup."Hierarchy Levels" = 1 then
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1");
        if lvngLoanVisionSetup."Hierarchy Levels" = 2 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 3 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 3");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 4 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 4");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 5 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 5");
        end;
        exit(DimensionNo);
    end;

    procedure GetHierarchyDimensionsUsage(var DimensionUsed: array[5] of boolean)
    begin
        GetLoanVisionSetup();
        if lvngLoanVisionSetup."Hierarchy Levels" = 1 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1")] := true;
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 2 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2")] := true;
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 3 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 3")] := true;
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 4 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 3")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 4")] := true;
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 5 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 1")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 2")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 3")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 4")] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup."Level 5")] := true;
        end;
    end;

    procedure GetHierarchyDimensionNo(lvngHierarchyLevels: Enum lvngHierarchyLevels): Integer;
    begin
        case lvngHierarchyLevels of
            lvngHierarchyLevels::lvngDimension1:
                exit(1);
            lvngHierarchyLevels::lvngDimension2:
                exit(2);
            lvngHierarchyLevels::lvngDimension3:
                exit(3);
            lvngHierarchyLevels::lvngDimension4:
                exit(4);
        end;
        exit(5);
    end;

    procedure LookupCostCenter(var lvngDimensionValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        GetLoanVisionSetup();
        lvngLoanVisionSetup.TestField("Cost Center Dimension Code");
        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", lvngLoanVisionSetup."Cost Center Dimension Code");
        if page.RunModal(0, DimensionValue) = Action::LookupOK then
            lvngDimensionValueCode := DimensionValue.Code;
    end;

    local procedure GetGLSetup()
    begin
        if not lvngGLSetupRetrieved then begin
            GLSetup.get();
            lvngGLSetupRetrieved := true;
        end;
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    procedure FillDimensionsFromTable(lvngLoanDocument: Record lvngLoanDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanDocument.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanDocument.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanDocument.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanDocument.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanDocument.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanDocument.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanDocument.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanDocument.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoanDocumentLine: Record lvngLoanDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanDocumentLine.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanDocumentLine.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanDocumentLine.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanDocumentLine.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanDocumentLine.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanDocumentLine.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanDocumentLine.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanDocumentLine.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoanFundedDocument: Record lvngLoanFundedDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanFundedDocument.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanFundedDocument.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanFundedDocument.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanFundedDocument.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanFundedDocument.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanFundedDocument.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanFundedDocument.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanFundedDocument.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoanFundedDocumentLine: Record lvngLoanFundedDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanFundedDocumentLine.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanFundedDocumentLine.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanFundedDocumentLine.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanFundedDocumentLine.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanFundedDocumentLine.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanFundedDocumentLine.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanFundedDocumentLine.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanFundedDocumentLine.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoanSoldDocument: Record lvngLoanSoldDocument; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanSoldDocument.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanSoldDocument.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanSoldDocument.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanSoldDocument.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanSoldDocument.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanSoldDocument.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanSoldDocument.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanSoldDocument.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoanSoldDocumentLine: Record lvngLoanSoldDocumentLine; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoanSoldDocumentLine.lvngGlobalDimension1Code;
        DimensionCodes[2] := lvngLoanSoldDocumentLine.lvngGlobalDimension2Code;
        DimensionCodes[3] := lvngLoanSoldDocumentLine.lvngShortcutDimension3Code;
        DimensionCodes[4] := lvngLoanSoldDocumentLine.lvngShortcutDimension4Code;
        DimensionCodes[5] := lvngLoanSoldDocumentLine.lvngShortcutDimension5Code;
        DimensionCodes[6] := lvngLoanSoldDocumentLine.lvngShortcutDimension6Code;
        DimensionCodes[7] := lvngLoanSoldDocumentLine.lvngShortcutDimension7Code;
        DimensionCodes[8] := lvngLoanSoldDocumentLine.lvngShortcutDimension8Code;
    end;

    procedure FillDimensionsFromTable(lvngLoan: Record lvngLoan; var DimensionCodes: array[8] of Code[20])
    begin
        DimensionCodes[1] := lvngLoan."Global Dimension 1 Code";
        DimensionCodes[2] := lvngLoan."Global Dimension 2 Code";
        DimensionCodes[3] := lvngLoan."Shortcut Dimension 3 Code";
        DimensionCodes[4] := lvngLoan."Shortcut Dimension 4 Code";
        DimensionCodes[5] := lvngLoan."Shortcut Dimension 5 Code";
        DimensionCodes[6] := lvngLoan."Shortcut Dimension 6 Code";
        DimensionCodes[7] := lvngLoan."Shortcut Dimension 7 Code";
        DimensionCodes[8] := lvngLoan."Shortcut Dimension 8 Code";
    end;

    procedure GetDimensionNames(var DimensionNames: array[8] of Text)
    var
        Dimension: Record Dimension;
    begin
        GetGLSetup();
        Clear(DimensionNames);
        if Dimension.Get(GLSetup."Global Dimension 1 Code") then begin
            DimensionNames[1] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Global Dimension 2 Code") then begin
            DimensionNames[2] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 3 Code") then begin
            DimensionNames[3] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 4 Code") then begin
            DimensionNames[4] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 5 Code") then begin
            DimensionNames[5] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 6 Code") then begin
            DimensionNames[6] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 7 Code") then begin
            DimensionNames[7] := Dimension."Code Caption";
        end;
        if Dimension.Get(GLSetup."Shortcut Dimension 8 Code") then begin
            DimensionNames[8] := Dimension."Code Caption";
        end;
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

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        lvngLoanVisionSetupRetrieved: Boolean;
        lvngGLSetupRetrieved: Boolean;
}