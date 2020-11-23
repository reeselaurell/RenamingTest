page 14135321 "lvnLoanLevelJournalSubform"
{
    Caption = 'Loan Level Journal';
    PageType = ListPart;
    SourceTable = lvnCommissionJournalLine;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(LoanNo; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(CommissionDate; Rec."Commission Date")
                {
                    ApplicationArea = All;
                }
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(CalculationLineNo; Rec."Calculation Line No.")
                {
                    ApplicationArea = All;
                }
                field(BaseAmount; Rec."Base Amount")
                {
                    ApplicationArea = All;
                }
                field(Bps; Rec.Bps)
                {
                    ApplicationArea = All;
                }
                field(CommissionAmount; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        CommissionSchedule: Record lvnCommissionSchedule;
        CommissionProfile: Record lvnCommissionProfile;

    procedure SetParams(ScheduleNo: Integer; ProfileCode: Code[20])
    begin
        CommissionSchedule.Get(ScheduleNo);
        CommissionProfile.Get(ProfileCode);
        Rec.SetRange("Schedule No.", ScheduleNo);
    end;
}