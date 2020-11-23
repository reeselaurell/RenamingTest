page 14135320 "lvnCommissionJournalView"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnCommissionProfile;
    Caption = 'Journal View';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                Editable = false;

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(LoanLevelAmount; LoanLevelAmount)
                {
                    Caption = 'Loan Level Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PeriodLevelAmount; PeriodLevelAmount)
                {
                    Caption = 'Period Level Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(TotalAmount; LoanLevelAmount + PeriodLevelAmount)
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(LoanLevelJournalSubform; lvnLoanLevelJournalSubform)
            {
                Caption = 'Loan Level';
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Profile Code" = field(Code), "Profile Line Type" = const("Loan Level");
            }
            part(PeriodLevelJournalSubform; lvnPeriodLevelJournalSubform)
            {
                Caption = 'Period Level';
                ApplicationArea = All;
                SubPageLink = "Profile Code" = field(Code), "Profile Line Type" = const("Period Level");
                UpdatePropagation = Both;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.LoanLevelJournalSubform.Page.SetParams(ScheduleNo, Rec.Code);
        CurrPage.LoanLevelJournalSubform.Page.Update(false);
        CurrPage.PeriodLevelJournalSubform.Page.SetParams(ScheduleNo, Rec.Code);
        CurrPage.PeriodLevelJournalSubform.Page.Update(false);
    end;

    trigger OnAfterGetRecord()
    var
        CommissionJournalLine: Record lvnCommissionJournalLine;
    begin
        CommissionJournalLine.Reset();
        CommissionJournalLine.SetCurrentKey("Schedule No.", "Profile Code", "Profile Line Type");
        CommissionJournalLine.SetRange("Schedule No.", ScheduleNo);
        CommissionJournalLine.SetRange("Profile Code", Rec.Code);
        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Loan Level");
        CommissionJournalLine.CalcSums("Commission Amount");
        LoanLevelAmount := CommissionJournalLine."Commission Amount";
        CommissionJournalLine.SetRange("Profile Line Type", CommissionJournalLine."Profile Line Type"::"Period Level");
        CommissionJournalLine.CalcSums("Commission Amount");
        PeriodLevelAmount := CommissionJournalLine."Commission Amount";
    end;

    var
        ScheduleNo: Integer;
        LoanLevelAmount: Decimal;
        PeriodLevelAmount: Decimal;

    procedure SetParams(_ScheduleNo: Integer)
    begin
        ScheduleNo := _ScheduleNo;
    end;
}