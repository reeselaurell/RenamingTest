page 14135147 "lvnSalesImportSchemaLines"
{
    Caption = 'Import Lines';
    PageType = ListPart;
    SourceTable = lvnFileImportJnlLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Column No."; Rec."Column No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Import Field Type"; Rec."Sales Import Field Type")
                {
                    ApplicationArea = All;
                }
                field("Description Sequence"; Rec."Description Sequence")
                {
                    ApplicationArea = All;
                }
                field("Dimension Split"; Rec."Dimension Split")
                {
                    ApplicationArea = All;
                }
                field("Dimension Split Character"; Rec."Dimension Split Character")
                {
                    ApplicationArea = All;
                }
                field("Split Dimension No."; Rec."Split Dimension No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}