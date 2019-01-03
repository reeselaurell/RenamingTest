page 14135123 "lvngLoanCardValuesPart"
{
    Caption = 'Loan Values';
    PageType = ListPart;
    SourceTable = lvngLoanValue;

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
                    Caption = 'Field Name';
                }
                field(lvngFieldValue; lvngFieldValue)
                {
                    ApplicationArea = All;
                }
                field(lvngBooleanValue; lvngBooleanValue)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDateValue; lvngDateValue)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngDecimalValue; lvngDecimalValue)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngIntegerValue; lvngIntegerValue)
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
        if lvngLoanFieldsConfigurationTemp.Get(lvngFieldNo) then begin
            lvngFieldName := lvngLoanFieldsConfigurationTemp.lvngFieldName;
        end;
    end;

    var
        lvngLoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
        lvngLoanFieldsConfigurationTemp: Record lvngLoanFieldsConfiguration temporary;
        lvngFieldName: Text;



}