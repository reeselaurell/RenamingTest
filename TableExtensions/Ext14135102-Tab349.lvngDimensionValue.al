tableextension 14135102 lvngDimensionValue extends "Dimension Value"
{
    fields
    {
        field(14135100; "Additional Code"; Code[50]) { Caption = 'Additional Code'; DataClassification = CustomerContent; }
        field(14135101; "First Name"; Text[50]) { Caption = 'First Name'; DataClassification = CustomerContent; }
        field(14135102; "Middle Name"; Text[30]) { Caption = 'Middle Name'; DataClassification = CustomerContent; }
        field(14135103; "Last Name"; Text[50]) { Caption = 'Last Name'; DataClassification = CustomerContent; }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        LoanVisionSetupRetrieved: Boolean;

    trigger OnInsert()
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Loan Officer Dimension Code" = "Dimension Code" then
            if LoanVisionSetup."Loan Officer Name Template" <> '' then
                Name := CopyStr(StrSubstNo(LoanVisionSetup."Loan Officer Name Template", "First Name", "Last Name", "Middle Name"), 1, MaxStrLen(Name));
    end;

    trigger OnModify()
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Loan Officer Dimension Code" = "Dimension Code" then
            if LoanVisionSetup."Loan Officer Name Template" <> '' then
                Name := CopyStr(StrSubstNo(LoanVisionSetup."Loan Officer Name Template", "First Name", "Last Name", "Middle Name"), 1, MaxStrLen(Name));
    end;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;
}