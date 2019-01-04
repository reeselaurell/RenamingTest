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
                field(lvngFieldNo; lvngFieldNo)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldName; lvngFieldName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Field Name';
                }
                field(lvngFieldValue; lvngFieldValue)
                {
                    ApplicationArea = All;
                }
                field(lvngBooleanValue; lvngBooleanValue)
                {
                    ApplicationArea = All;
                }
                field(lvngDateValue; lvngDateValue)
                {
                    ApplicationArea = All;
                }
                field(lvngDecimalValue; lvngDecimalValue)
                {
                    ApplicationArea = All;
                }
                field(lvngIntegerValue; lvngIntegerValue)
                {
                    ApplicationArea = All;
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
        if lvngLoanFieldsConfigurationTemp.Get(lvngFieldNo) then begin
            lvngFieldName := lvngLoanFieldsConfigurationTemp.lvngFieldName;
        end;
    end;

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngFieldName: Text;



}