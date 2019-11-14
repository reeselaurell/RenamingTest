page 14135146 "lvngPurchaseImportSchemaLines"
{
    Caption = 'Import Lines';
    PageType = ListPart;
    SourceTable = lvngFileImportJnlLine;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngColumnNo; "Column No.")
                {
                    ApplicationArea = All;
                }
                field(lvngPurchaseImportFieldType; "Purchase Import Field Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDescriptionSequence; "Description Sequence")
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionSplit; "Dimension Split")
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionSplitCharacter; "Dimension Split Character")
                {
                    ApplicationArea = All;
                }
                field(lvngSplitDimensionNo; "Split Dimension No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}