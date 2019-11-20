page 14135123 lvngLoanCardValuesPart
{
    Caption = 'Loan Values';
    PageType = ListPart;
    SourceTable = lvngLoanValue;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field No."; "Field No.") { ApplicationArea = All; }
                field(FieldDescription; FieldDescription) { ApplicationArea = All; Editable = false; Caption = 'Field Name'; }
                field("Field Value"; "Field Value") { ApplicationArea = All; }
                field("Boolean Value"; "Boolean Value") { ApplicationArea = All; Visible = false; }
                field("Date Value"; "Date Value") { ApplicationArea = All; Visible = false; }
                field("Decimal Value"; "Decimal Value") { ApplicationArea = All; Visible = false; }
                field("Integer Value"; "Integer Value") { ApplicationArea = All; Visible = false; }
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