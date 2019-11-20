page 14135118 lvngDimensionsHierarchy
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngDimensionHierarchy;
    Caption = 'Dimensions Hierarchy';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        BusinessUnit: Record "Business Unit";
                        DimensionsManagement: Codeunit lvngDimensionsManagement;
                        DimensionCode: Code[20];
                    begin
                        DimensionCode := DimensionsManagement.GetMainHierarchyDimensionCode();
                        if DimensionCode = '' then begin
                            BusinessUnit.reset;
                            if page.RunModal(0, BusinessUnit) = Action::LookupOK then begin
                                Code := BusinessUnit.Code;
                            end;
                        end else begin
                            DimensionValue.reset;
                            DimensionValue.SetRange("Dimension Code", DimensionCode);
                            if page.RunModal(0, DimensionValue) = Action::LookupOK then begin
                                Code := DimensionValue.Code;
                            end;
                        end;
                    end;
                }
                field(Date; Date) { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { Visible = Dimension4Visible; ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { Visible = Dimension3Visible; ApplicationArea = All; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { Visible = Dimension2Visible; ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { Visible = Dimension1Visible; ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { Visible = BusinessUnitVisible; ApplicationArea = All; }
            }
        }
    }

    var
        Dimension1Visible: Boolean;
        Dimension2Visible: Boolean;
        Dimension3Visible: Boolean;
        Dimension4Visible: Boolean;
        BusinessUnitVisible: Boolean;

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        DimensionsManagement: Codeunit lvngDimensionsManagement;
    begin
        LoanVisionSetup.Get();
        if LoanVisionSetup."Hierarchy Levels" = 1 then
            exit;
        if LoanVisionSetup."Hierarchy Levels" = 2 then
            CheckDimensionsVisibility(LoanVisionSetup."Level 1");
        if LoanVisionSetup."Hierarchy Levels" = 3 then begin
            CheckDimensionsVisibility(LoanVisionSetup."Level 2");
            CheckDimensionsVisibility(LoanVisionSetup."Level 1");
        end;
        if LoanVisionSetup."Hierarchy Levels" = 4 then begin
            CheckDimensionsVisibility(LoanVisionSetup."Level 3");
            CheckDimensionsVisibility(LoanVisionSetup."Level 2");
            CheckDimensionsVisibility(LoanVisionSetup."Level 1");
        end;
        if LoanVisionSetup."Hierarchy Levels" = 5 then begin
            CheckDimensionsVisibility(LoanVisionSetup."Level 4");
            CheckDimensionsVisibility(LoanVisionSetup."Level 3");
            CheckDimensionsVisibility(LoanVisionSetup."Level 2");
            CheckDimensionsVisibility(LoanVisionSetup."Level 1");
        end;
    end;

    local procedure CheckDimensionsVisibility(HierarchyLevels: Enum lvngHierarchyLevels)
    begin
        case HierarchyLevels of
            HierarchyLevels::"Dimension 1":
                Dimension1Visible := true;
            HierarchyLevels::"Dimension 2":
                Dimension2Visible := true;
            HierarchyLevels::"Dimension 3":
                Dimension3Visible := true;
            HierarchyLevels::"Dimension 4":
                Dimension4Visible := true;
            HierarchyLevels::"Business Unit":
                BusinessUnitVisible := true;
        end;
    end;
}