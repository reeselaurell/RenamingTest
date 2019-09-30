page 14135231 lvngStyleList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngStyle;
    Caption = 'Display Style List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Bold; Bold) { ApplicationArea = All; }
                field(Italic; Italic) { ApplicationArea = All; }
                field(Underline; Underline) { ApplicationArea = All; }
                field("Background Color"; "Background Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Font Color"; "Font Color")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(ColorPicker);
                        ColorPicker.SetValue(Text);
                        ColorPicker.LookupMode(true);
                        if ColorPicker.RunModal() = Action::LookupOK then begin
                            Text := ColorPicker.GetValue();
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Font Size"; "Font Size") { ApplicationArea = All; }
            }
        }
    }

    var
        ColorPicker: Page lvngColorPicker;
}