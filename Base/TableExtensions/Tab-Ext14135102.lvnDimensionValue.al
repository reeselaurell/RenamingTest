tableextension 14135102 "lvnDimensionValue" extends "Dimension Value"
{
    fields
    {
        field(14135100; lvnAdditionalCode; Code[50])
        {
            Caption = 'Additional Code';
            DataClassification = CustomerContent;
        }
        field(14135101; lvnFirstName; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(14135102; lvnMiddleName; Text[30])
        {
            Caption = 'Middle Name';
            DataClassification = CustomerContent;
        }
        field(14135103; lvnLastName; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        }
    }

    trigger OnInsert()
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Loan Officer Dimension Code" = "Dimension Code" then
            if LoanVisionSetup."Loan Officer Name Template" <> '' then
                Name := CopyStr(StrSubstNo(LoanVisionSetup."Loan Officer Name Template", lvnFirstName, lvnLastName, lvnMiddleName), 1, MaxStrLen(Name));
    end;

    trigger OnModify()
    begin
        GetLoanVisionSetup();
        if LoanVisionSetup."Loan Officer Dimension Code" = "Dimension Code" then
            if LoanVisionSetup."Loan Officer Name Template" <> '' then
                Name := CopyStr(StrSubstNo(LoanVisionSetup."Loan Officer Name Template", lvnFirstName, lvnLastName, lvnMiddleName), 1, MaxStrLen(Name));
    end;

    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        LoanVisionSetupRetrieved: Boolean;

    local procedure GetLoanVisionSetup()
    begin
        if not LoanVisionSetupRetrieved then begin
            LoanVisionSetup.Get();
            LoanVisionSetupRetrieved := true;
        end;
    end;
}