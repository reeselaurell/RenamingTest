page 14135118 "lvngDimensionsHierarchy"
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
            repeater(lvngRepeater)
            {
                field(lvngCode; Code)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                        BusinessUnit: Record "Business Unit";
                        DimensionCode: Code[20];
                    begin
                        DimensionCode := lvngDimensionsManagement.GetMainHierarchyDimensionCode();
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
                field(lvngDate; Date)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                {
                    Visible = Dimension4Visible;
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                {
                    Visible = Dimension3Visible;
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                {
                    Visible = Dimension2Visible;
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                {
                    Visible = Dimension1Visible;
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; "Business Unit Code")
                {
                    Visible = BusinessUnitVisible;
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        lvngLoanVisionSetup.Get();
        if lvngLoanVisionSetup."Hierarchy Levels" = 1 then
            exit;
        if lvngLoanVisionSetup."Hierarchy Levels" = 2 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 1");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 3 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 2");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 1");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 4 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 3");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 2");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 1");
        end;
        if lvngLoanVisionSetup."Hierarchy Levels" = 5 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 4");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 3");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 2");
            CheckDimensionsVisibility(lvngLoanVisionSetup."Level 1");
        end;
    end;

    local procedure CheckDimensionsVisibility(lvngHierarchyLevels: Enum lvngHierarchyLevels)
    begin
        case lvngHierarchyLevels of
            lvngHierarchyLevels::lvngDimension1:
                Dimension1Visible := true;
            lvngHierarchyLevels::lvngDimension2:
                Dimension2Visible := true;
            lvngHierarchyLevels::lvngDimension3:
                Dimension3Visible := true;
            lvngHierarchyLevels::lvngDimension4:
                Dimension4Visible := true;
            lvngHierarchyLevels::lvngBusinessUnit:
                BusinessUnitVisible := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        Dimension1Visible: Boolean;
        Dimension2Visible: Boolean;
        Dimension3Visible: Boolean;
        Dimension4Visible: Boolean;
        BusinessUnitVisible: Boolean;
}