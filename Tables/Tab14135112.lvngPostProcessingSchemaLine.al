table 14135112 "lvngPostProcessingSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Post Processing Schema Lines';
    LookupPageId = lvngPostProcessingSchemaLines;

    fields
    {
        field(1; "Journal Batch Code"; Code[20]) { Caption = 'Loan Journal Batch Code'; DataClassification = CustomerContent; TableRelation = lvngLoanJournalBatch; NotBlank = true; }
        field(2; "Line No."; Integer) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; Priority; Integer) { DataClassification = CustomerContent; }
        field(11; Type; enum lvngPostProcessingType) { DataClassification = CustomerContent; }
        field(12; Description; Text[50]) { DataClassification = CustomerContent; }
        field(13; "Assign To"; Enum lvngPostProcessingAssignTo) { DataClassification = CustomerContent; }
        field(14; "Rounding Expression"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 5 : 5; }
        field(15; "From Field No."; Integer) { DataClassification = CustomerContent; }
        field(16; "To Field No."; Integer) { DataClassification = CustomerContent; }
        field(17; "Expression Code"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ConditionsMgmt: Codeunit lvngConditionsMgmt;
                ExpressionList: page lvngExpressionList;
                SelectedExpressionCode: Code[20];
                ExpressionType: Enum lvngExpressionType;
            begin
                Clear(ExpressionList);
                SelectedExpressionCode := ExpressionList.SelectExpression(ConditionsMgmt.GetConditionsMgmtConsumerId(), "Expression Code", 'JOURNAL', ExpressionType::Switch);
                if SelectedExpressionCode <> '' then
                    "Expression Code" := SelectedExpressionCode;
            end;
        }
        field(18; "Custom Value"; Text[250]) { DataClassification = CustomerContent; }
        field(19; "From Character No."; Integer) { DataClassification = CustomerContent; MinValue = 1; }
        field(20; "Characters Count"; Integer) { DataClassification = CustomerContent; }
        field(21; "Copy Field Part"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Journal Batch Code", "Line No.") { Clustered = true; }
        key(lvngPriorityKey; Priority) { }
    }
}