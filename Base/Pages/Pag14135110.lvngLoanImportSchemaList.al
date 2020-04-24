page 14135110 lvngLoanImportSchemaList
{
    PageType = List;
    SourceTable = lvngLoanImportSchema;
    Caption = 'Loan Import Schema';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Loan Journal Batch Type"; "Loan Journal Batch Type") { ApplicationArea = All; }
                field("Field Separator Character"; "Field Separator Character") { ApplicationArea = All; }
                field("Skip Lines"; "Skip Lines") { ApplicationArea = All; }
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
                RunObject = page lvngLoanImportSchemaLines;
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