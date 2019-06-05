pageextension 14135103 "lvngDimensionValue" extends "Dimension Values" //MyTargetPageId
{
    layout
    {
        addbefore(Name)
        {
            field(lvngFirstName; lvngFirstName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvngLastName; lvngLastName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvngMiddleName; lvngMiddleName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
        }
        addafter(Code)
        {
            field(lvngAdditionalCode; lvngAdditionalCode)
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
        if lvngLoanVisionSetup.lvngLoanOfficerDimensionCode = Rec."Dimension Code" then begin
            LoanOfficerFieldsVisible := true;
        end;
    end;

}