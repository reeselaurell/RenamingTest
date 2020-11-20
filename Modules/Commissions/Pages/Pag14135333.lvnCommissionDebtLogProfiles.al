page 14135333 lvnCommissionDebtLogProfiles
{
    Caption = 'Commission Debt Log Profiles';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionProfile;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
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
                field(DebtLogCalculation; Rec."Debt Log Calculation")
                {
                    ApplicationArea = All;
                }
                field(DebtLogLOType; Rec."Debt Log LO Type")
                {
                    ApplicationArea = All;
                }
                field(MinimumAdvance; Rec."Minimum Advance")
                {
                    ApplicationArea = All;
                }
                field(MaxAdvanceBalance; Rec."Max. Advance Balance")
                {
                    ApplicationArea = All;
                }
                field(MaxReductionCap; Rec."Max. Reduction Cap")
                {
                    ApplicationArea = All;
                }
                field(CommissionIdentifierFilter; Rec."Commission Identifier Filter")
                {
                    ApplicationArea = All;
                }
                field(CurrentBalance; Rec."Current Balance")
                {
                    ApplicationArea = All;
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
                RunObject = Report lvnCommissionProfiles;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}