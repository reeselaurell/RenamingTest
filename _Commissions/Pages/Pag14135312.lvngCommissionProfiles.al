page 14135312 "lvngCommissionProfiles"
{
    Caption = 'Commission Profiles';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngCommissionProfile;
    CardPageId = lvngCommissionProfileCard;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngCostCenterCode; lvngCostCenterCode)
                {
                    ApplicationArea = All;
                }
                field(lvngName; lvngName)
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }
                field(lvngCreationTimestamp; lvngCreationTimestamp)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngModificationTimestamp; lvngModificationTimestamp)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngUpdatedBy; lvngUpdatedBy)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngShowAllProfiles)
            {
                Caption = 'Show All Profiles';
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SetRange(lvngBlocked);
                    CurrPage.Update(false);
                end;
            }
            action(lvngShowActiveProfiles)
            {
                Caption = 'Show Active Profiles';
                ApplicationArea = All;
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SetRange(lvngBlocked, false);
                    CurrPage.Update(false);
                end;
            }
            action(lvngExportProfilesData)
            {
                Caption = 'Export Profiles Data';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = Report lvngCommissionProfiles;
            }

        }
    }

    trigger OnOpenPage()
    begin
        SetRange(lvngBlocked, false);
    end;
}