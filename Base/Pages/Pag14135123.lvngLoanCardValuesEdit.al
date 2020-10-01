page 14135123 lvngLoanCardValuesEdit
{
    Caption = 'Loan Values';
    PageType = List;
    SourceTable = lvngLoanValue;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; Rec."Field No.") { ApplicationArea = All; }
                field(lvngFieldName; FieldDescription) { ApplicationArea = All; Editable = false; Caption = 'Field Name'; }
                field("Field Value"; Rec."Field Value") { ApplicationArea = All; }
                field("Boolean Value"; Rec."Boolean Value") { ApplicationArea = All; Editable = false; }
                field("Date Value"; Rec."Date Value") { ApplicationArea = All; Editable = false; }
                field("Decimal Value"; Rec."Decimal Value") { ApplicationArea = All; Editable = false; }
                field("Integer Value"; Rec."Integer Value") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    var
        TempLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration temporary;
        FieldDescription: Text;

    trigger OnOpenPage()
    var
        LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
    begin
        LoanFieldsConfiguration.Reset();
        if LoanFieldsConfiguration.FindSet() then begin
            repeat
                TempLoanFieldsConfiguration := LoanFieldsConfiguration;
                TempLoanFieldsConfiguration.Insert();
            until LoanFieldsConfiguration.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        FieldDescription := '';
        if TempLoanFieldsConfiguration.Get(Rec."Field No.") then begin
            FieldDescription := TempLoanFieldsConfiguration."Field Name";
        end;
    end;
}