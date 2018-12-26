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
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanJournalBatchType; lvngLoanJournalBatchType)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSeparatorCharacter; lvngFieldSeparatorCharacter)
                {
                    ApplicationArea = All;
                }
                field(lvngSkipLines; lvngSkipLines)
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
                RunPageLink = lvngCode = field (lvngCode);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = EditJournal;
            }
        }
    }
}