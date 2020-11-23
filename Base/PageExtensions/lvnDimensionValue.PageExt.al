pageextension 14135103 "lvnDimensionValue" extends "Dimension Values"
{
    layout
    {
        addbefore(Name)
        {
            field(lvnFirstName; Rec.lvnFirstName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvnLastName; Rec.lvnLastName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
            field(lvnMiddleName; Rec.lvnMiddleName)
            {
                ApplicationArea = All;
                Visible = LoanOfficerFieldsVisible;
            }
        }
        addafter(Code)
        {
            field(lvnAdditionalCode; Rec.lvnAdditionalCode)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
    begin
        LoanVisionSetup.Get();
        if LoanVisionSetup."Loan Officer Dimension Code" = Rec."Dimension Code" then
            LoanOfficerFieldsVisible := true;
    end;

    var
        LoanOfficerFieldsVisible: Boolean;
}