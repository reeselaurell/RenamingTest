page 14135218 "lvnDimPerfBandSchemaLines"
{
    PageType = List;
    SourceTable = lvnDimPerfBandSchemaLine;
    Caption = 'Dimension Performance Band Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Band No."; Rec."Band No.")
                {
                    ApplicationArea = All;
                }
                field("Dimension Filter"; Rec."Dimension Filter")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        DimensionValue.Reset();
                        DimensionValue.SetRange("Dimension Code", DimensionCode);
                        if Page.RunModal(Page::"Dimension Values", DimensionValue) = Action::LookupOK then begin
                            Text := DimensionValue.Code;
                            Rec."Header Description" := DimensionValue.Name;
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field("Header Description"; Rec."Header Description")
                {
                    ApplicationArea = All;
                }
                field("Band Type"; Rec."Band Type")
                {
                    ApplicationArea = All;
                }
                field("Row Formula Code"; Rec."Row Formula Code")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        PerformanceMgmt: Codeunit lvnPerformanceMgmt;
                        ExpressionList: Page lvnExpressionList;
                        ExpressiontType: Enum lvnExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(PerformanceMgmt.GetDimensionRowExpressionConsumerId(), Rec."Schema Code", Rec."Row Formula Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            Rec."Row Formula Code" := NewCode;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DimPerfSchemaLine: Record lvnDimPerfBandSchemaLine;
    begin
        DimPerfSchemaLine.Reset();
        DimPerfSchemaLine.SetRange("Schema Code", Rec."Schema Code");
        if DimPerfSchemaLine.FindLast() then
            Rec."Band No." := DimPerfSchemaLine."Band No." + 10
        else
            Rec."Band No." := 10;
    end;

    var
        DimensionCode: Code[20];

    procedure SetParams(DimCode: Code[20])
    begin
        DimensionCode := DimCode;
    end;
}