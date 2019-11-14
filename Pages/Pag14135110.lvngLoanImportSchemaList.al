page 14135110 "lvngLoanImportSchemaList"
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
                field(lvngCode; Code)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanJournalBatchType; "Loan Journal Batch Type")
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSeparatorCharacter; "Field Separator Character")
                {
                    ApplicationArea = All;
                }
                field(lvngSkipLines; "Skip Lines")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(lvngOpenSchemaLines)
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