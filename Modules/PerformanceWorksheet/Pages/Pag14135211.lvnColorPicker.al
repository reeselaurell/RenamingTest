page 14135211 "lvnColorPicker"
{
    PageType = Worksheet;

    layout
    {
        area(Content)
        {
            usercontrol(ColorPicker; ColorPickerControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    CurrPage.ColorPicker.SetValue(ControlValue);
                end;

                trigger ValueChanged(Value: Text)
                begin
                    ControlValue := Value;
                end;
            }
        }
    }

    var
        ControlValue: Text;

    procedure SetValue(Value: Text)
    begin
        ControlValue := Value;
    end;

    procedure GetValue(): Text
    begin
        exit(ControlValue);
    end;
}