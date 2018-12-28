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
                field(lvngCode; lvngCode)
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
                                lvngCode := BusinessUnit.Code;
                            end;
                        end else begin
                            DimensionValue.reset;
                            DimensionValue.SetRange("Dimension Code", DimensionCode);
                            if page.RunModal(0, DimensionValue) = Action::LookupOK then begin
                                lvngCode := DimensionValue.Code;
                            end;
                        end;
                    end;
                }
                field(lvngDate; lvngDate)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                {
                    Visible = Dimension4Visible;
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                {
                    Visible = Dimension3Visible;
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                {
                    Visible = Dimension2Visible;
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                {
                    Visible = Dimension1Visible;
                    ApplicationArea = All;
                }

                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
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
        if lvngLoanVisionSetup.lvngHierarchyLevels = 1 then
            if lvngLoanVisionSetup.lvngHierarchyLevels = 2 then begin
                CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel1);
            end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 3 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel2);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel1);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 4 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel3);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel2);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel1);
        end;
        if lvngLoanVisionSetup.lvngHierarchyLevels = 5 then begin
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel4);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel3);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel2);
            CheckDimensionsVisibility(lvngLoanVisionSetup.lvngLevel1);
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