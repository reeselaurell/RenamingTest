pageextension 14135103 lvngDimensionValue extends "Dimension Values"
{
    layout
    {
        addbefore(Name)
        {
            field(lvngFirstName; lvngFirstName) { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
            field(lvngLastName; lvngLastName) { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
            field(lvngMiddleName; lvngMiddleName) { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
        }
        addafter(Code)
        {
            field(lvngAdditionalCode; lvngAdditionalCode) { ApplicationArea = All; }
        }
    }

    var
        LoanOfficerFieldsVisible: Boolean;

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
    begin
        LoanVisionSetup.Get();
        if LoanVisionSetup."Loan Officer Dimension Code" = Rec."Dimension Code" then begin
            LoanOfficerFieldsVisible := true;
        end;
    end;

}