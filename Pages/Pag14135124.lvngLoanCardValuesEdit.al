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
                    Editable = false;
                }
                field(lvngDateValue; lvngDateValue)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngDecimalValue; lvngDecimalValue)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngIntegerValue; lvngIntegerValue)
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
        if lvngLoanFieldsConfigurationTemp.Get(lvngFieldNo) then begin
            lvngFieldName := lvngLoanFieldsConfigurationTemp.lvngFieldName;
        end;
    end;

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngFieldName: Text;



}