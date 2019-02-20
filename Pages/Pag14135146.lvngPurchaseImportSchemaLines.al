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
                field(lvngColumnNo; lvngColumnNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPurchaseImportFieldType; lvngPurchaseImportFieldType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescriptionSequence; lvngDescriptionSequence)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionSplit; lvngDimensionSplit)
                {
                    ApplicationArea = All;
                }
                field(lvngDimensionSplitCharacter; lvngDimensionSplitCharacter)
                {
                    ApplicationArea = All;
                }
                field(lvngSplitDimensionNo; lvngSplitDimensionNo)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}