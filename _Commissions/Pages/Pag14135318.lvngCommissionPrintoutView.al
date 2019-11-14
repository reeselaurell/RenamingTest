page 14135318 lvngCommissionPrintoutView
{
    Caption = 'Commission Printout';
    PageType = Card;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                field(LOName; CommissionProfile.lvngName) { ApplicationArea = All; Caption = 'Loan Officer Name'; }
                field(Period; DateFilter) { ApplicationArea = All; Caption = 'For Date Period'; }
            }
            usercontrol(CommissionGrid; DataGridControl)
            {
            }
        }
    }
    var
        CommissionSchedule: Record lvngCommissionSchedule;
        CommissionProfile: Record lvngCommissionProfile;
        InitScheduleNo: Integer;
        InitProfileCode: Code[20];
        DateFilter: Text;

    trigger OnOpenPage()
    begin
        CommissionSchedule.Get(InitScheduleNo);
        CommissionProfile.Get(InitProfileCode);
        DateFilter := StrSubstNo('%1..%2', CommissionSchedule.lvngPeriodStartDate, CommissionSchedule.lvngPeriodEndDate);
    end;

    procedure SetParams(ScheduleNo: Integer; ProfileCode: Code[20])
    begin
        InitScheduleNo := ScheduleNo;
        InitProfileCode := ProfileCode;
    end;
}