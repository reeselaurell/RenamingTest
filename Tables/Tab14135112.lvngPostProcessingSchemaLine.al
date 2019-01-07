table 14135112 "lvngPostProcessingSchemaLine"
{
    DataClassification = CustomerContent;
    Caption = 'Post Processing Schema Lines';
    LookupPageId = lvngPostProcessingSchemaLines;

    fields
    {
        field(1; lvngJournalBatchCode; Code[20])
        {
            Caption = 'Loan Journal Batch Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanJournalBatch;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; lvngPriority; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(11; lvngType; enum lvngPostProcessingType)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(12; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(13; lvngAssignTo; Enum lvngPostProcessingAssignTo)
        {
            Caption = 'Assign To';
            DataClassification = CustomerContent;
        }

        field(14; lvngRoundExpression; Decimal)
        {
            Caption = 'Rounding Expression';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        field(15; lvngFromFieldNo; Integer)
        {
            Caption = 'From Field No.';
            DataClassification = CustomerContent;

        }
        field(16; lvngToFieldNo; Integer)
        {
            Caption = 'To Field No.';
            DataClassification = CustomerContent;
        }

        field(17; lvngFunctionCode; Code[20])
        {
            Caption = 'Function Code';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                lvngSelectedFunctionCode: Code[20];
            begin
                Clear(lvngExpressionList);
                lvngSelectedFunctionCode := lvngExpressionList.SelectExpression('JOURNAL');
                if lvngSelectedFunctionCode <> '' then
                    lvngFunctionCode := lvngSelectedFunctionCode;
            end;
        }

    }

    keys
    {
        key(PK; lvngJournalBatchCode, lvngLineNo)
        {
            Clustered = true;
        }
        key(lvngPriorityKey; lvngPriority)
        {

        }
    }

    var
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionList: page lvngExpressionList;

}