page 14135311 "lvngCommissionTiersBreakdown"
{
    Caption = 'Commission Tiers Breakdown';
    PageType = Worksheet;
    SourceTable = lvngCommissionTierLine;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngFromVolume; lvngFromVolume)
                {
                    ApplicationArea = All;
                    Visible = volumeVisible;
                }
                field(lvngToVolume; lvngToVolume)
                {
                    ApplicationArea = All;
                    Visible = volumeVisible;
                }
                field(lvngFromUnits; lvngFromUnits)
                {
                    ApplicationArea = All;
                    Visible = unitsVisible;
                }
                field(lvngToUnits; lvngToUnits)
                {
                    ApplicationArea = All;
                    Visible = unitsVisible;
                }
                field(lvngRetroactive; lvngRetroactive)
                {
                    ApplicationArea = All;
                }
                field(lvngRate; lvngRate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        unitsVisible := true;
        volumeVisible := true;
        lvngCommissionTierHeader.Get(lvngCode);
        if lvngCommissionTierHeader.lvngTierType = lvngCommissionTierHeader.lvngTierType::lvngUnits then begin
            unitsVisible := true;
            volumeVisible := false;
        end;
        if lvngCommissionTierHeader.lvngTierType = lvngCommissionTierHeader.lvngTierType::lvngVolume then begin
            volumeVisible := true;
            unitsVisible := false;
        end;
    end;

    var
        lvngCommissionTierHeader: Record lvngCommissionTierHeader;
        unitsVisible: Boolean;
        volumeVisible: Boolean;
}