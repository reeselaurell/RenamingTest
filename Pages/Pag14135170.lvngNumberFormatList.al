page 14135170 lvngNumberFormatList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngNumberFormat;
    Caption = 'Number Format List';

    layout
    {
        area(Content)
        {
            field(Code; Code) { ApplicationArea = All; }
            field(Description; Description) { ApplicationArea = All; }
            field("Value Type"; "Value Type") { ApplicationArea = All; }
            field(Rounding; Rounding) { ApplicationArea = All; }
            field("Blank Zero"; "Blank Zero") { ApplicationArea = All; }
            field("Negative Formatting"; "Negative Formatting") { ApplicationArea = All; }
            field("Suppress Thousand Separator"; "Suppress Thousand Separator") { ApplicationArea = All; }
            field("Invert Sign"; "Invert Sign") { ApplicationArea = All; }
        }
    }
}