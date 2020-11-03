page 14135183 "lvnFlexibleImportSchemaList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnFlexibleImportSchema;
    Caption = 'Flexible Import Schema List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
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
                    FlexibleImportSchema: Record lvnFlexibleImportSchema;
                begin
                    FlexibleImportSchema.Reset();
                    FlexibleImportSchema.SetRange(Code, Rec.Code);
                    Page.RunModal(Page::lvnFlexibleImportSchemaCard, FlexibleImportSchema)
                end;
            }
        }
    }
}