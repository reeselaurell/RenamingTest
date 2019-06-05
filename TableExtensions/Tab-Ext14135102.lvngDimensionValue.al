tableextension 14135102 "lvngDimensionValue" extends "Dimension Value" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngAdditionalCode; Code[50])
        {
            Caption = 'Additional Code';
            DataClassification = CustomerContent;
        }

        field(14135101; lvngFirstName; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }

        field(14135102; lvngMiddleName; Text[30])
        {
            Caption = 'Middle Name';
            DataClassification = CustomerContent;
        }
        field(14135103; lvngLastName; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        }

    }

    trigger OnInsert()
    begin
        lvngGetLoanVisionSetup();
        if lvngLoanVisionSetup.lvngLoanOfficerDimensionCode = "Dimension Code" then begin
            if lvngLoanVisionSetup.lvngLoanOfficerNameTemplate <> '' then begin
                Name := CopyStr(strsubstno(lvngloanvisionsetup.lvngLoanOfficerNameTemplate, lvngFirstName, lvngLastName, lvngMiddleName), 1, MaxStrLen(Name));
            end;
        end;
    end;

    trigger OnModify()
    begin
        lvngGetLoanVisionSetup();
        if lvngLoanVisionSetup.lvngLoanOfficerDimensionCode = "Dimension Code" then begin
            if lvngLoanVisionSetup.lvngLoanOfficerNameTemplate <> '' then begin
                Name := CopyStr(strsubstno(lvngloanvisionsetup.lvngLoanOfficerNameTemplate, lvngFirstName, lvngLastName, lvngMiddleName), 1, MaxStrLen(Name));
            end;
        end;

    end;

    local procedure lvngGetLoanVisionSetup()
    begin
        if not lvngLoanVisionSetupRetrieved then begin
            lvngLoanVisionSetup.Get();
            lvngLoanVisionSetupRetrieved := true;
        end;
    end;

    var
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        lvngLoanVisionSetupRetrieved: Boolean;


}