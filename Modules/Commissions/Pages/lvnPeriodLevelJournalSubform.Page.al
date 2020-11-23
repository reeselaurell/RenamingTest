page 14135322 "lvnPeriodLevelJournalSubform"
{
    Caption = 'Period Level Journal';
    PageType = ListPart;
    SourceTable = lvnCommissionJournalLine;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(CommissionDate; Rec."Commission Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec."Commission Date" > CommissionSchedule."Period End Date" then
                            Error(WrongCommissionDateErr);
                        if Rec."Commission Date" < CommissionSchedule."Period Start Date" then
                            Error(WrongCommissionDateErr);
                    end;
                }
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(LoanNo; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(CommissionAmount; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                }
                field(CalculationLineNo; Rec."Calculation Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
        LineNo: Integer;
    begin
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetRange("Schedule No.", CommissionSchedule."No.");
        CommissionJournalLine.SetRange("Profile Code", CommissionProfile.Code);
        if CommissionJournalLine.FindLast() then
            LineNo := CommissionJournalLine."Line No." + 100
        else
            LineNo := 100;
        Rec."Line No." := LineNo;
        Rec."Profile Code" := CommissionProfile.Code;
        Rec."Profile Line Type" := Rec."Profile Line Type"::"Period Level";
        Rec."Schedule No." := CommissionSchedule."No.";
        Rec."Manual Adjustment" := true;
    end;

    var
        CommissionSchedule: Record lvnCommissionSchedule;
        CommissionProfile: Record lvnCommissionProfile;
        WrongCommissionDateErr: Label 'Commission Date can''t be smaller than Period Start Date and bigger than Period End Date';

    procedure SetParams(ScheduleNo: Integer; ProfileCode: Code[20])
    begin
        CommissionSchedule.Get(ScheduleNo);
        CommissionProfile.Get(ProfileCode);
        Rec.SetRange("Schedule No.", ScheduleNo);
    end;
}