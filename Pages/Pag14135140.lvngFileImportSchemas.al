page 14135140 "lvngFileImportSchemas"
{
    Caption = 'File Import Schemas';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngFileImportSchema;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngFileImportType; lvngFileImportType)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSeparator; lvngFieldSeparator)
                {
                    ApplicationArea = All;
                    ToolTip = 'Use <TAB> for Tab or any other symbol';
                }
                field(lvngSkipRows; lvngSkipRows)
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
            action(lvngEdit)
            {
                Caption = 'Edit Schema';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var
                    lvngGenJnlImportSchema: page lvngGenJnlImportSchema;
                    lvngPurchaseLinesImportSchema: Page lvngPurchaseLinesImportSchema;
                begin
                    case lvngFileImportType of
                        lvngfileimportType::lvngGeneralJournal:
                            begin
                                lvngGenJnlImportSchema.SetRecord(Rec);
                                lvngGenJnlImportSchema.Run();
                            end;
                        lvngFileImportType::lvngPurchaseLine:
                            begin
                                lvngPurchaseLinesImportSchema.SetRecord(Rec);
                                lvngPurchaseLinesImportSchema.Run();
                            end;
                    end;
                end;
            }
        }
    }
}