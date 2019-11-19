pageextension 14135103 "lvngDimensionValue" extends "Dimension Values" //MyTargetPageId
{
    layout
    {
        addbefore(Name)
        {
            field(lvngFirstName; "First Name")
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvngLastName; "Last Name")
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvngMiddleName; "Middle Name")
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
        }
        addafter(Code)
        {
            field(lvngAdditionalCode; "Additional Code")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        LoanOfficerFieldsVisible: Boolean;

    trigger OnOpenPage()
    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
    begin
        lvngLoanVisionSetup.Get();
        if lvngLoanVisionSetup."Loan Officer Dimension Code" = Rec."Dimension Code" then begin
            LoanOfficerFieldsVisible := true;
        end;
    end;

}