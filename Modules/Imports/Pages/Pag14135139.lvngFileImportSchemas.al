page 14135139 lvngFileImportSchemas
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
            repeater(Group)
            {
                field(Code; Code) { ApplicationArea = All; }
                field("File Import Type"; "File Import Type") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Field Separator"; "Field Separator") { ApplicationArea = All; ToolTip = 'Use <TAB> for Tab or any other symbol'; }
                field("Skip Rows"; "Skip Rows") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                Caption = 'Edit Schema';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var
                    GenJnlImportSchema: page lvngGenJnlImportSchema;
                    PurchaseLinesImportSchema: Page lvngPurchaseLinesImportSchema;
                    SalesLinesImportSchema: Page lvngSalesLinesImportSchema;
                    DepositImportSchema: Page lvngDepositImportSchema;
                begin
                    case "File Import Type" of
                        "File Import Type"::"General Journal":
                            begin
                                GenJnlImportSchema.SetRecord(Rec);
                                GenJnlImportSchema.Run();
                            end;
                        "File Import Type"::"Purchase Line":
                            begin
                                PurchaseLinesImportSchema.SetRecord(Rec);
                                PurchaseLinesImportSchema.Run();
                            end;
                        "File Import Type"::"Sales Line":
                            begin
                                SalesLinesImportSchema.SetRecord(Rec);
                                SalesLinesImportSchema.Run();
                            end;
                        "File Import Type"::"Deposit Lines":
                            begin
                                DepositImportSchema.SetRecord(Rec);
                                DepositImportSchema.Run();
                            end;
                    end;
                end;
            }
        }
    }
}