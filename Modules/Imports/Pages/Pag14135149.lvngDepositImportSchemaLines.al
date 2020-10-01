page 14135149 lvngDepositImportSchemaLines
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
                field("Column No."; Rec."Column No.") { ApplicationArea = All; }
                field("Deposit Import Field Type"; Rec."Deposit Import Field Type") { ApplicationArea = All; }
                field("Description Sequence"; Rec."Description Sequence") { ApplicationArea = All; }
                field("Dimension Split"; Rec."Dimension Split") { ApplicationArea = All; }
                field("Dimension Split Character"; Rec."Dimension Split Character") { ApplicationArea = All; }
                field("Split Dimension No."; Rec."Split Dimension No.") { ApplicationArea = All; }
            }
        }
    }
}