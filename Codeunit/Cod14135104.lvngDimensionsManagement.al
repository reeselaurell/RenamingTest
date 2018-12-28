codeunit 14135104 lvngDimensionsManagement
{
    procedure GetMainHierarchyDimensionCode(): Code[20]
    var
        DimensionNo: Integer;
    begin
        GetGLSetup();
        GetLoanVisionSetup();
        if lvngLoanVisionSetup.lvngHierarchyLevels = 1 then
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1);
        if lvngLoanVisionSetup.lvngHierarchyLevels = 2 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 3 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel3);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 4 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel4);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 5 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel5);
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
        if lvngLoanVisionSetup.lvngHierarchyLevels = 1 then
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1);
        if lvngLoanVisionSetup.lvngHierarchyLevels = 2 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 3 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel3);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 4 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel4);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 5 then begin
            DimensionNo := GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel5);
        end;
        exit(DimensionNo);
    end;

    procedure GetHierarchyDimensionsUsage(var DimensionUsed: array[5] of boolean)
    begin
        GetLoanVisionSetup();
        if lvngLoanVisionSetup.lvngHierarchyLevels = 1 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1)] := true;
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 2 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2)] := true;
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 3 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel3)] := true;
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 4 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel3)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel4)] := true;
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 5 then begin
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel1)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel2)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel3)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel4)] := true;
            DimensionUsed[GetHierarchyDimensionNo(lvngLoanVisionSetup.lvngLevel5)] := true;
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

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        lvngLoanVisionSetupRetrieved: Boolean;
        lvngGLSetupRetrieved: Boolean;
}