page 14135123 "lvngLoanCardValuesPart"
{
    Caption = 'Loan Values';
    PageType = ListPart;
    SourceTable = lvngLoanValue;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngFieldNo; "Field No.")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldName; lvngFieldName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Field Name';
                }
                field(lvngFieldValue; "Field Value")
                {
                    ApplicationArea = All;
                }
                field(lvngBooleanValue; "Boolean Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDateValue; "Date Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDecimalValue; "Decimal Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngIntegerValue; "Integer Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        lvngLoanFieldsConfiguration.reset;
        if lvngLoanFieldsConfiguration.FindSet() then begin
            repeat
                Clear(lvngLoanFieldsConfigurationTemp);
                lvngLoanFieldsConfigurationTemp := lvngLoanFieldsConfiguration;
                lvngLoanFieldsConfigurationTemp.Insert();
            until lvngLoanFieldsConfiguration.Next() = 0;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(lvngFieldName);
        if lvngLoanFieldsConfigurationTemp.Get("Field No.") then begin
            lvngFieldName := lvngLoanFieldsConfigurationTemp."Field Name";
        end;
    end;

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngFieldName: Text;



}