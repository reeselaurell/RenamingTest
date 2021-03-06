page 14135267 "lvnLoanManagerWarehouseAct"
{
    Caption = 'Total Funded Last Business Day by Warehouse Line';
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Group)
            {
                ShowCaption = false;
                CuegroupLayout = Wide;

                field(WarehouseLine1; WarehouseLineFund[1])
                {
                    CaptionClass = GetWarehouseLineCaption(1);
                    ApplicationArea = All;
                    Visible = LineVisible1;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[1]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[1]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine2; WarehouseLineFund[2])
                {
                    CaptionClass = GetWarehouseLineCaption(2);
                    ApplicationArea = All;
                    Visible = LineVisible2;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[2]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[2]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine3; WarehouseLineFund[3])
                {
                    CaptionClass = GetWarehouseLineCaption(3);
                    ApplicationArea = All;
                    Visible = LineVisible3;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[3]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[3]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine4; WarehouseLineFund[4])
                {
                    CaptionClass = GetWarehouseLineCaption(4);
                    ApplicationArea = All;
                    Visible = LineVisible4;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[4]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[4]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine5; WarehouseLineFund[5])
                {
                    CaptionClass = GetWarehouseLineCaption(5);
                    ApplicationArea = All;
                    Visible = LineVisible5;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[5]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[5]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine6; WarehouseLineFund[6])
                {
                    CaptionClass = GetWarehouseLineCaption(6);
                    ApplicationArea = All;
                    Visible = LineVisible6;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[6]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[6]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine7; WarehouseLineFund[7])
                {
                    CaptionClass = GetWarehouseLineCaption(7);
                    ApplicationArea = All;
                    Visible = LineVisible7;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line From Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[7]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[7]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
                field(WarehouseLine8; WarehouseLineFund[8])
                {
                    CaptionClass = GetWarehouseLineCaption(8);
                    ApplicationArea = All;
                    Visible = LineVisible8;
                    AutoFormatExpression = '$<precision, 0:0><standard format, 0>';
                    AutoFormatType = 10;
                    ToolTip = 'Specifies the Total Loan Funded Amount by Warehouse Line from Previous Business Day';

                    trigger OnDrillDown()
                    var
                        FundedDoc: Record lvnLoanFundedDocument;
                    begin
                        FundedDoc.Reset();
                        FundedDoc.SetFilter("Document No.", FundedDocFilter[8]);
                        FundedDoc.SetRange("Warehouse Line Code", WarehouseLineCodes[8]);
                        if FundedDoc.FindSet() then
                            Page.Run(Page::lvnPostedFundedDocuments, FundedDoc);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CalculateWarehouseLineValues();
    end;

    var
        WarehouseLineFund: array[8] of Decimal;
        WarehouseLineCaptions: array[8] of Text[250];
        WarehouseLineCodes: array[8] of Code[50];
        LineVisible1: Boolean;
        LineVisible2: Boolean;
        LineVisible3: Boolean;
        LineVisible4: Boolean;
        LineVisible5: Boolean;
        LineVisible6: Boolean;
        LineVisible7: Boolean;
        LineVisible8: Boolean;
        FundedDocFilter: array[8] of Text;

    local procedure CalculateWarehouseLineValues()
    var
        WarehouseLine: Record lvnWarehouseLine;
        FundedDoc: Record lvnLoanFundedDocument;
        FundedDocLine: Record lvnLoanFundedDocumentLine;
        Idx: Integer;
    begin
        LineVisible1 := false;
        LineVisible2 := false;
        LineVisible3 := false;
        LineVisible4 := false;
        LineVisible5 := false;
        LineVisible6 := false;
        LineVisible7 := false;
        LineVisible8 := false;
        Clear(WarehouseLineCaptions);
        WarehouseLine.Reset();
        WarehouseLine.SetRange("Show In Rolecenter", true);
        if WarehouseLine.FindSet() then
            repeat
                Idx := Idx + 1;
                WarehouseLineCaptions[Idx] := WarehouseLine.Description;
                WarehouseLineCodes[Idx] := WarehouseLine.Code;
                case Idx of
                    1:
                        LineVisible1 := true;
                    2:
                        LineVisible2 := true;
                    3:
                        LineVisible3 := true;
                    4:
                        LineVisible4 := true;
                    5:
                        LineVisible5 := true;
                    6:
                        LineVisible6 := true;
                    7:
                        LineVisible7 := true;
                    8:
                        LineVisible8 := true;
                end;
                FundedDoc.SetRange("Warehouse Line Code", WarehouseLine.Code);
                FundedDocFilter[Idx] := '';
                FundedDoc.SetFilter("Posting Date", '<>%1', CalcDate('<CD>'));
                FundedDoc.SetCurrentKey("Posting Date");
                FundedDoc.SetAscending("Posting Date", false);
                if FundedDoc.FindFirst() then begin
                    FundedDoc.SetRange("Posting Date", FundedDoc."Posting Date");
                    if FundedDoc.FindSet() then
                        repeat
                            if FundedDocFilter[Idx] = '' then
                                FundedDocFilter[Idx] := FundedDoc."Document No."
                            else
                                FundedDocFilter[Idx] := FundedDocFilter[Idx] + '|' + FundedDoc."Document No.";
                            FundedDocLine.SetRange("Document No.", FundedDoc."Document No.");
                            if FundedDocLine.FindSet() then begin
                                FundedDocLine.CalcSums(Amount);
                                WarehouseLineFund[Idx] += FundedDocLine.Amount;
                            end;
                        until FundedDoc.Next() = 0;
                end;
            until (WarehouseLine.Next() = 0) or (Idx = 8);
    end;

    local procedure GetWarehouseLineCaption(LineNo: Integer): Text[250]
    begin
        exit(WarehouseLineCaptions[LineNo]);
    end;
}