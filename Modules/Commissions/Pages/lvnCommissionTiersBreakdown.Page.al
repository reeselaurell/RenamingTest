page 14135311 "lvnCommissionTiersBreakdown"
{
    Caption = 'Commission Tiers Breakdown';
    PageType = Worksheet;
    SourceTable = lvnCommissionTierLine;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(FromVolume; Rec."From Volume")
                {
                    ApplicationArea = All;
                    Visible = VolumeVisible;
                }
                field(ToVolume; Rec."To Volume")
                {
                    ApplicationArea = All;
                    Visible = VolumeVisible;
                }
                field(FromUnits; Rec."From Units")
                {
                    ApplicationArea = All;
                    Visible = UnitsVisible;
                }
                field(ToUnits; Rec."To Units")
                {
                    ApplicationArea = All;
                    Visible = UnitsVisible;
                }
                field(Retroactive; Rec.Retroactive)
                {
                    ApplicationArea = All;
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CommissionTierHeader.Get(Rec."Tier Code");
        UnitsVisible := true;
        VolumeVisible := true;
        if CommissionTierHeader."Tier Type" = CommissionTierHeader."Tier Type"::Units then
            VolumeVisible := false;
        if CommissionTierHeader."Tier Type" = CommissionTierHeader."Tier Type"::Volume then
            UnitsVisible := false;
    end;

    var
        CommissionTierHeader: Record lvnCommissionTierHeader;
        UnitsVisible: Boolean;
        VolumeVisible: Boolean;
}