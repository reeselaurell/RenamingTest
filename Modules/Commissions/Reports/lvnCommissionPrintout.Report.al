report 14135316 "lvnCommissionPrintout"
{
    Caption = 'Commission Printout';
    ProcessingOnly = true;

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                field(ScheduleNo; CommissionSchedule."No.") { ApplicationArea = All; Caption = 'Commission Schedule'; TableRelation = lvnCommissionSchedule."No."; }
                field(ProfileCode; CommissionProfile.Code) { ApplicationArea = All; Caption = 'Profile Code'; TableRelation = lvnCommissionProfile.Code; }
            }
        }
    }

    trigger OnPreReport()
    var
        CommissionPrintoutView: Page lvnCommissionPrintoutView;
    begin
        CommissionSchedule.Get(CommissionSchedule."No.");
        CommissionProfile.Get(CommissionProfile.Code);
        Clear(CommissionPrintoutView);
        CommissionPrintoutView.SetParams(CommissionSchedule."No.", CommissionProfile.Code);
        CommissionPrintoutView.RunModal();
    end;

    var
        CommissionSchedule: Record lvnCommissionSchedule;
        CommissionProfile: Record lvnCommissionProfile;

    procedure SetParams(EntryNo: Integer)
    begin
        CommissionSchedule."No." := EntryNo;
    end;
}