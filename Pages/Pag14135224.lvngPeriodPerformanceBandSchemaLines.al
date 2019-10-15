page 14135224 lvngPeriodPerfBandSchemaLines
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
                field("Line No."; "Band No.") { ApplicationArea = All; Caption = 'Band No.'; }
                field("Period Type"; "Period Type") { ApplicationArea = All; }
                field("Period Offset"; "Period Offset") { ApplicationArea = All; }
                field("Period Length Formula"; "Period Length Formula") { ApplicationArea = All; }
                field("Band Type"; "Band Type") { ApplicationArea = All; }
                field("Header Description"; "Header Description") { ApplicationArea = All; }
                field("Dynamic Date Description"; "Dynamic Date Description") { ApplicationArea = All; }
                field("Date From"; "Date From") { ApplicationArea = All; }
                field("Date To"; "Date To") { ApplicationArea = All; }
                field("Row Formula Code"; "Row Formula Code")
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
                        NewCode := ExpressionList.SelectExpression(PerformanceMgmt.GetPeriodRowExpressionConsumerId(), "Schema Code", "Row Formula Code", ExpressiontType::Formula + ExpressiontType::Switch);
                        if NewCode <> '' then
                            "Row Formula Code" := NewCode;
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
        PeriodPerfSchemaLine.SetRange("Schema Code", "Schema Code");
        if PeriodPerfSchemaLine.FindLast() then
            "Band No." := PeriodPerfSchemaLine."Band No." + 10
        else
            "Band No." := 10;
    end;
}