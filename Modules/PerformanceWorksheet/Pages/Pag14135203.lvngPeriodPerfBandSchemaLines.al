page 14135203 lvngPeriodPerfBandSchemaLines
{
    PageType = List;
    SourceTable = lvngPeriodPerfBandSchemaLine;
    Caption = 'Period Performance Band Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Band No.") { ApplicationArea = All; Caption = 'Band No.'; }
                field("Period Type"; Rec."Period Type") { ApplicationArea = All; }
                field("Period Offset"; Rec."Period Offset") { ApplicationArea = All; }
                field("Period Length Formula"; Rec."Period Length Formula") { ApplicationArea = All; }
                field("Band Type"; Rec."Band Type") { ApplicationArea = All; }
                field("Header Description"; Rec."Header Description") { ApplicationArea = All; }
                field("Dynamic Date Description"; Rec."Dynamic Date Description") { ApplicationArea = All; }
                field("Date From"; Rec."Date From") { ApplicationArea = All; }
                field("Date To"; Rec."Date To") { ApplicationArea = All; }
                field("Row Formula Code"; Rec."Row Formula Code")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        PerformanceMgmt: Codeunit lvngPerformanceMgmt;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(PerformanceMgmt.GetPeriodRowExpressionConsumerId(), Rec."Schema Code", Rec."Row Formula Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            Rec."Row Formula Code" := NewCode;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PeriodPerfSchemaLine: Record lvngPeriodPerfBandSchemaLine;
    begin
        PeriodPerfSchemaLine.Reset();
        PeriodPerfSchemaLine.SetRange("Schema Code", Rec."Schema Code");
        if PeriodPerfSchemaLine.FindLast() then
            Rec."Band No." := PeriodPerfSchemaLine."Band No." + 10
        else
            Rec."Band No." := 10;
    end;
}