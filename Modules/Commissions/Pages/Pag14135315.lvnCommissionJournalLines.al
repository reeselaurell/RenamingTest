page 14135315 lvnCommissionJournalLines
{
    Caption = 'Commission Journal Lines';
    PageType = List;
    SourceTable = lvnCommissionJournalLine;
    Editable = false;

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
                field(ProfileCode; Rec."Profile Code")
                {
                    ApplicationArea = All;
                }
                field(CalculationLineNo; Rec."Calculation Line No.")
                {
                    ApplicationArea = All;
                }
                field(LoanNo; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(CommissionDate; Rec."Commission Date")
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
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = All;
                }
                field(CommissionAmount; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                }
                field(PeriodIdentifierCode; Rec."Period Identifier Code")
                {
                    ApplicationArea = All;
                    Visible = PeriodIdentifierVisible;
                }
                field(ManualAdjustment; Rec."Manual Adjustment")
                {
                    ApplicationArea = All;
                }
                field(ProfileLineType; Rec."Profile Line Type")
                {
                    ApplicationArea = All;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CommissionSetup.Get();
        PeriodIdentifierVisible := CommissionSetup."Use Period Identifiers";
    end;

    var
        CommissionSetup: Record lvnCommissionSetup;
        PeriodIdentifierVisible: Boolean;
}