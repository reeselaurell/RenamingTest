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
                field(lvngCode; Code)
                {
                    ApplicationArea = All;
                }
                field(lvngFileImportType; "File Import Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }
                field(lvngFieldSeparator; "Field Separator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Use <TAB> for Tab or any other symbol';
                }
                field(lvngSkipRows; "Skip Rows")
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
                    lvngSalesLinesImportSchema: Page lvngSalesLinesImportSchema;
                    lvngDepositImportSchema: Page lvngDepositImportSchema;
                begin
                    case "File Import Type" of
                        "File Import Type"::lvngGeneralJournal:
                            begin
                                lvngGenJnlImportSchema.SetRecord(Rec);
                                lvngGenJnlImportSchema.Run();
                            end;
                        "File Import Type"::lvngPurchaseLine:
                            begin
                                lvngPurchaseLinesImportSchema.SetRecord(Rec);
                                lvngPurchaseLinesImportSchema.Run();
                            end;
                        "File Import Type"::lvngSalesLine:
                            begin
                                lvngSalesLinesImportSchema.SetRecord(Rec);
                                lvngSalesLinesImportSchema.Run();
                            end;
                        "File Import Type"::lvngDepositLines:
                            begin
                                lvngDepositImportSchema.SetRecord(Rec);
                                lvngDepositImportSchema.Run();
                            end;
                    end;
                end;
            }
        }
    }
}