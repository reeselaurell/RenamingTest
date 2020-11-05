page 14135209 "lvnNumberFormatList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvnNumberFormat;
    Caption = 'Number Format List';

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
                field("Value Type"; Rec."Value Type")
                {
                    ApplicationArea = All;
                }
                field(Rounding; Rec.Rounding)
                {
                    ApplicationArea = All;
                }
                field("Blank Zero"; Rec."Blank Zero")
                {
                    ApplicationArea = All;
                }
                field("Negative Formatting"; Rec."Negative Formatting")
                {
                    ApplicationArea = All;
                }
                field("Suppress Thousand Separator"; Rec."Suppress Thousand Separator")
                {
                    ApplicationArea = All;
                }
                field("Invert Sign"; Rec."Invert Sign")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}