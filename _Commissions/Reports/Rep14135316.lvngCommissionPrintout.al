report 14135316 lvngCommissionPrintout
{
    Caption = 'Commission Printout';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(ScheduleNo; CommissionSchedule.lvngNo) { ApplicationArea = All; Caption = 'Commission Schedule'; }
                field(ProfileCode; CommissionProfile.lvngCode) { ApplicationArea = All; Caption = 'Profile Code'; }
            }
        }
    }

    var
        CommissionSchedule: Record lvngCommissionSchedule;
        CommissionProfile: Record lvngCommissionProfile;

    procedure SetParams(EntryNo: Integer)
    begin
        CommissionSchedule.lvngNo := EntryNo;
    end;

    trigger OnPreReport()
    var
        CommissionPrintoutView: Page lvngCommissionPrintoutView;
    begin
        CommissionSchedule.Get(CommissionSchedule.lvngNo);
        CommissionProfile.Get(CommissionProfile.lvngCode);
        Clear(CommissionPrintoutView);
        CommissionPrintoutView.SetParams(CommissionSchedule.lvngNo, CommissionProfile.lvngCode);
        CommissionPrintoutView.RunModal();
    end;
}