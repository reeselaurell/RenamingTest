page 14135146 lvngPurchaseImportSchemaLines
{
    Caption = 'Import Lines';
    PageType = ListPart;
    SourceTable = lvngFileImportJnlLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Column No."; "Column No.") { ApplicationArea = All; }
                field("Purchase Import Field Type"; "Purchase Import Field Type") { ApplicationArea = All; }
                field("Description Sequence"; "Description Sequence") { ApplicationArea = All; }
                field("Dimension Split"; "Dimension Split") { ApplicationArea = All; }
                field("Dimension Split Character"; "Dimension Split Character") { ApplicationArea = All; }
                field("Split Dimension No."; "Split Dimension No.") { ApplicationArea = All; }
            }
        }
    }
}