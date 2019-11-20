page 14135201 lvngLoanActivities
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
                field(lvngWarehouseLine1; FundedDocumentsCount[1])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(1);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible1;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[1]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine2; FundedDocumentsCount[2])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(2);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible2;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[2]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine3; FundedDocumentsCount[3])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(3);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible3;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[3]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine4; FundedDocumentsCount[4])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(4);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible4;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[4]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine5; FundedDocumentsCount[5])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(5);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible5;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[5]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine6; FundedDocumentsCount[6])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(6);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible6;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[6]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine7; FundedDocumentsCount[7])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(7);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible7;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[7]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
                field(lvngWarehouseLine8; FundedDocumentsCount[8])
                {
                    Caption = 'Warehouse Line';
                    CaptionClass = GetWarehouseLineCaption(8);
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = lvngLoanJournalBatches;
                    ToolTip = 'Warehouse Line Information';
                    Visible = FundedDocumentVisible8;

                    trigger OnDrillDown()
                    var
                        LoanDocument: Record lvngLoanDocument;
                    begin
                        LoanDocument.Reset();
                        LoanDocument.SetRange("Warehouse Line Code", FundedDocumentsWarehouseLineCodes[8]);
                        LoanDocument.SetRange("Transaction Type", LoanDocument."Transaction Type"::Funded);
                        Page.Run(0, LoanDocument);
                    end;
                }
            }
        }
    }

    var
        WarehouseLine: Record lvngWarehouseLine;
        FundedDocumentsCount: array[8] of Integer;
        FundedDocumentsWarehouseLineCaptions: array[8] of Text;
        FundedDocumentsWarehouseLineCodes: array[8] of Code[50];
        FundedDocumentVisible1: Boolean;
        FundedDocumentVisible2: Boolean;
        FundedDocumentVisible3: Boolean;
        FundedDocumentVisible4: Boolean;
        FundedDocumentVisible5: Boolean;
        FundedDocumentVisible6: Boolean;
        FundedDocumentVisible7: Boolean;
        FundedDocumentVisible8: Boolean;

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
        Idx: Integer;
    begin
        Clear(FundedDocumentVisible1);
        Clear(FundedDocumentVisible2);
        Clear(FundedDocumentVisible3);
        Clear(FundedDocumentVisible4);
        Clear(FundedDocumentVisible5);
        Clear(FundedDocumentVisible6);
        Clear(FundedDocumentVisible7);
        Clear(FundedDocumentVisible8);
        Clear(FundedDocumentsCount);
        Clear(FundedDocumentsWarehouseLineCaptions);
        WarehouseLine.reset;
        WarehouseLine.SetRange("Show In Rolecenter", true);
        if WarehouseLine.FindSet() then begin
            repeat
                Idx := Idx + 1;
                FundedDocumentsWarehouseLineCaptions[Idx] := WarehouseLine.Description;
                FundedDocumentsWarehouseLineCodes[Idx] := WarehouseLine.Code;
                SetRange("Warehouse Line Code Filter", WarehouseLine.Code);
                CalcFields("Funded Documents");
                FundedDocumentsCount[Idx] := "Funded Documents";
                case Idx of
                    1:
                        FundedDocumentVisible1 := true;
                    2:
                        FundedDocumentVisible2 := true;
                    3:
                        FundedDocumentVisible3 := true;
                    4:
                        FundedDocumentVisible4 := true;
                    5:
                        FundedDocumentVisible5 := true;
                    6:
                        FundedDocumentVisible6 := true;
                    7:
                        FundedDocumentVisible7 := true;
                    8:
                        FundedDocumentVisible8 := true;
                end;
            until (WarehouseLine.Next() = 0) or (Idx = 8);
        end;
    end;

    local procedure GetWarehouseLineCaption(lvngIndex: Integer): Text
    begin
        exit(FundedDocumentsWarehouseLineCaptions[lvngIndex]);
    end;
}