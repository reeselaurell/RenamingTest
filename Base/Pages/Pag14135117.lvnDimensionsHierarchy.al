page 14135117 "lvnDimensionsHierarchy"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnDimensionHierarchy;
    Caption = 'Dimensions Hierarchy';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        BusinessUnit: Record "Business Unit";
                        DimensionsManagement: Codeunit lvnDimensionsManagement;
                        DimensionCode: Code[20];
                    begin
                        DimensionCode := DimensionsManagement.GetMainHierarchyDimensionCode();
                        if DimensionCode = '' then begin
                            BusinessUnit.reset;
                            if page.RunModal(0, BusinessUnit) = Action::LookupOK then begin
                                Rec.Code := BusinessUnit.Code;
                            end;
                        end else begin
                            DimensionValue.reset;
                            DimensionValue.SetRange("Dimension Code", DimensionCode);
                            if page.RunModal(0, DimensionValue) = Action::LookupOK then begin
                                Rec.Code := DimensionValue.Code;
                            end;
                        end;
                    end;
                }
                field(Date; Rec.Date) { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { Visible = Dimension4Visible; ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { Visible = Dimension3Visible; ApplicationArea = All; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { Visible = Dimension2Visible; ApplicationArea = All; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { Visible = Dimension1Visible; ApplicationArea = All; }
                field("Business Unit Code"; Rec."Business Unit Code") { Visible = BusinessUnitVisible; ApplicationArea = All; }
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
        LoanVisionSetup: Record lvnLoanVisionSetup;
        DimensionsManagement: Codeunit lvnDimensionsManagement;
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

    local procedure CheckDimensionsVisibility(HierarchyLevels: Enum lvnHierarchyLevels)
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