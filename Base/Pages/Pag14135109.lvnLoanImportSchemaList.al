page 14135109 "lvnLoanImportSchemaList"
{
    PageType = List;
    SourceTable = lvnLoanImportSchema;
    Caption = 'Loan Import Schema';
    ApplicationArea = All;
    UsageCategory = Lists;

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
                field("Loan Journal Batch Type"; Rec."Loan Journal Batch Type")
                {
                    ApplicationArea = All;
                }
                field("Field Separator Character"; Rec."Field Separator Character")
                {
                    ApplicationArea = All;
                }
                field("Skip Lines"; Rec."Skip Lines")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenSchemaLines)
            {
                Caption = 'Schema Lines';
                ApplicationArea = All;
                RunObject = page lvnLoanImportSchemaLines;
                RunPageMode = Edit;
                RunPageLink = Code = field(Code);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = EditJournal;
            }
        }
    }
}