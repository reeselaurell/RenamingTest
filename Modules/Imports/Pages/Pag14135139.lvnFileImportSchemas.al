page 14135139 "lvnFileImportSchemas"
{
    Caption = 'File Import Schemas';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnFileImportSchema;

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
                field("File Import Type"; Rec."File Import Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Field Separator"; Rec."Field Separator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Use <TAB> for Tab or any other symbol';
                }
                field("Skip Rows"; Rec."Skip Rows")
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
            action(Edit)
            {
                Caption = 'Edit Schema';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    GenJnlImportSchema: Page lvnGenJnlImportSchema;
                    PurchaseLinesImportSchema: Page lvnPurchaseLinesImportSchema;
                    SalesLinesImportSchema: Page lvnSalesLinesImportSchema;
                    DepositImportSchema: Page lvnDepositImportSchema;
                begin
                    case Rec."File Import Type" of
                        Rec."File Import Type"::"General Journal":
                            begin
                                GenJnlImportSchema.SetRecord(Rec);
                                GenJnlImportSchema.Run();
                            end;
                        Rec."File Import Type"::"Purchase Line":
                            begin
                                PurchaseLinesImportSchema.SetRecord(Rec);
                                PurchaseLinesImportSchema.Run();
                            end;
                        Rec."File Import Type"::"Sales Line":
                            begin
                                SalesLinesImportSchema.SetRecord(Rec);
                                SalesLinesImportSchema.Run();
                            end;
                        Rec."File Import Type"::"Deposit Lines":
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