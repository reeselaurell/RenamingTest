page 14135193 lvngFlexibleImportSchemaList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngFlexibleImportSchema;
    Caption = 'Flexible Import Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditSchema)
            {
                ApplicationArea = All;
                Caption = 'Edit Schema';
                Image = OpenJournal;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    FlexibleImportSchema: Record lvngFlexibleImportSchema;
                begin
                    FlexibleImportSchema.Reset();
                    FlexibleImportSchema.SetRange(Code, Code);
                    Page.RunModal(Page::lvngFlexibleImportSchemaCard, FlexibleImportSchema)
                end;
            }
        }
    }
}