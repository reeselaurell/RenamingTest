page 14135312 lvnCommissionProfiles
{
    Caption = 'Commission Profiles';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionProfile;
    CardPageId = lvnCommissionProfileCard;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Additional Code"; Rec."Additional Code")
                {
                    ApplicationArea = All;
                }
                field(CostCenterCode; Rec."Cost Center Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(CreationDateTime; Rec."Creation DateTime")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ModificationDateTime; Rec."Modification DateTime")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(UpdatedBy; Rec."Updated By")
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
            action(ShowAllProfiles)
            {
                Caption = 'Show All Profiles';
                ApplicationArea = All;
                Image = ShowList;

                trigger OnAction()
                begin
                    Rec.SetRange(Blocked);
                    CurrPage.Update(false);
                end;
            }
            action(ShowActiveProfiles)
            {
                Caption = 'Show Active Profiles';
                ApplicationArea = All;
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.SetRange(Blocked, false);
                    CurrPage.Update(false);
                end;
            }
            action(ExportProfilesData)
            {
                Caption = 'Export Profiles Data';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = Report lvnCommissionProfiles;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}