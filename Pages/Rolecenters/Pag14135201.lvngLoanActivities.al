page 14135201 "lvngLoanActivities"
{
    Caption = 'Loan Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = lvngLoanActivitiesCue;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            cuegroup(lvngDocumentsByWarehouseLine)
            {
                Caption = 'Funded by Warehouse Line';
                ShowCaption = false;
                field(lvngWarehouseLine1; lvngFundedDocumentsCount[1])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(1);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible1;

                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[1]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine2; lvngFundedDocumentsCount[2])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(2);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible2;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[2]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine3; lvngFundedDocumentsCount[3])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(3);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible3;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[3]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine4; lvngFundedDocumentsCount[4])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(4);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible4;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[4]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine5; lvngFundedDocumentsCount[5])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(5);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible5;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[5]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine6; lvngFundedDocumentsCount[6])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(6);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible6;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[6]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine7; lvngFundedDocumentsCount[7])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(7);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible7;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[7]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }
                field(lvngWarehouseLine8; lvngFundedDocumentsCount[8])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(8);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = lvngFundedDocumentVisible8;
                    trigger OnDrillDown()
                    var
                        lvngLoanDocument: Record lvngLoanDocument;
                    begin
                        lvngLoanDocument.reset;
                        lvngLoanDocument.SetRange(lvngWarehouseLineCode, lvngFundedDocumentsWarehouseLineCodes[8]);
                        lvngLoanDocument.SetRange(lvngTransactionType, lvngLoanDocument.lvngTransactionType::lvngFunded);
                        page.Run(0, lvngLoanDocument);
                    end;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        If not Get() then begin
            Init();
            Insert();
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues();
    end;

    local procedure CalculateCueFieldValues()
    var
        lvngIndex: Integer;
    begin
        Clear(lvngFundedDocumentVisible1);
        Clear(lvngFundedDocumentVisible2);
        Clear(lvngFundedDocumentVisible3);
        Clear(lvngFundedDocumentVisible4);
        Clear(lvngFundedDocumentVisible5);
        Clear(lvngFundedDocumentVisible6);
        Clear(lvngFundedDocumentVisible7);
        Clear(lvngFundedDocumentVisible8);
        Clear(lvngFundedDocumentsCount);
        Clear(lvngFundedDocumentsWarehouseLineCaptions);
        lvngWarehouseLine.reset;
        lvngWarehouseLine.SetRange("Show In Rolecenter", true);
        if lvngWarehouseLine.FindSet() then begin
            repeat
                lvngIndex := lvngIndex + 1;
                lvngFundedDocumentsWarehouseLineCaptions[lvngIndex] := lvngWarehouseLine.Description;
                lvngFundedDocumentsWarehouseLineCodes[lvngIndex] := lvngWarehouseLine.Code;
                SetRange(lvngWarehouseLineCodeFilter, lvngWarehouseLine.Code);
                CalcFields(lvngFundedDocuments);
                lvngFundedDocumentsCount[lvngIndex] := lvngFundedDocuments;
                case lvngIndex of
                    1:
                        lvngFundedDocumentVisible1 := true;
                    2:
                        lvngFundedDocumentVisible2 := true;
                    3:
                        lvngFundedDocumentVisible3 := true;
                    4:
                        lvngFundedDocumentVisible4 := true;
                    5:
                        lvngFundedDocumentVisible5 := true;
                    6:
                        lvngFundedDocumentVisible6 := true;
                    7:
                        lvngFundedDocumentVisible7 := true;
                    8:
                        lvngFundedDocumentVisible8 := true;
                end;
            until (lvngWarehouseLine.Next() = 0) or (lvngIndex = 8);
        end;
    end;

    local procedure GetWarehouseLineCaption(lvngIndex: Integer): Text
    begin
        exit(lvngFundedDocumentsWarehouseLineCaptions[lvngIndex]);
    end;

    var
        lvngWarehouseLine: Record lvngWarehouseLine;
        lvngFundedDocumentsCount: array[8] of Integer;
        lvngFundedDocumentsWarehouseLineCaptions: array[8] of Text;
        lvngFundedDocumentsWarehouseLineCodes: array[8] of Code[50];
        lvngFundedDocumentVisible1: Boolean;
        lvngFundedDocumentVisible2: Boolean;
        lvngFundedDocumentVisible3: Boolean;
        lvngFundedDocumentVisible4: Boolean;
        lvngFundedDocumentVisible5: Boolean;
        lvngFundedDocumentVisible6: Boolean;
        lvngFundedDocumentVisible7: Boolean;
        lvngFundedDocumentVisible8: Boolean;

}