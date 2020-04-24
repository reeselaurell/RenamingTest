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
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field(lvngFieldName; FieldDescription) { ApplicationArea = All; Editable = false; Caption = 'Field Name'; }
                field("Field Value"; "Field Value") { ApplicationArea = All; }
                field("Boolean Value"; "Boolean Value") { ApplicationArea = All; Editable = false; }
                field("Date Value"; "Date Value") { ApplicationArea = All; Editable = false; }
                field("Decimal Value"; "Decimal Value") { ApplicationArea = All; Editable = false; }
                field("Integer Value"; "Integer Value") { ApplicationArea = All; Editable = false; }
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
        if TempLoanFieldsConfiguration.Get("Field No.") then begin
            FieldDescription := TempLoanFieldsConfiguration."Field Name";
        end;
    end;
}