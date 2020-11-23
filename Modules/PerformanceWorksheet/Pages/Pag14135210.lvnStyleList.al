page 14135210 "lvnStyleList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnStyle;
    Caption = 'Display Style List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Bold; Rec.Bold)
                {
                    ApplicationArea = All;
                }
                field(Italic; Rec.Italic)
                {
                    ApplicationArea = All;
                }
                field(Underline; Rec.Underline)
                {
                    ApplicationArea = All;
                }
                field("Background Color"; Rec."Background Color")
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
                field("Font Color"; Rec."Font Color")
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
                field("Font Size"; Rec."Font Size")
                {
                    ApplicationArea = All;
                }
                field("Font Name"; Rec."Font Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ColorPicker: Page lvnColorPicker;
}