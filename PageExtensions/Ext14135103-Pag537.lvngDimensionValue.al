pageextension 14135103 lvngDimensionValue extends "Dimension Values"
{
    layout
    {
        addbefore(Name)
        {
            field(lvngFirstName; "First Name") { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
            field(lvngLastName; "Last Name") { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
            field(lvngMiddleName; "Middle Name") { ApplicationArea = All; Visible = LoanOfficerFieldsVisible; }
        }
        addafter(Code)
        {
            field(lvngAdditionalCode; "Additional Code") { ApplicationArea = All; }
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