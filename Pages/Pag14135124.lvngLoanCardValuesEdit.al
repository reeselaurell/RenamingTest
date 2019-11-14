page 14135124 "lvngLoanCardValuesEdit"
{
    Caption = 'Loan Values';
    PageType = List;
    SourceTable = lvngLoanValue;
    DeleteAllowed = false;

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
                    Editable = false;
                }
                field(lvngDateValue; "Date Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngDecimalValue; "Decimal Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngIntegerValue; "Integer Value")
                {
                    ApplicationArea = All;
                    Editable = false;
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