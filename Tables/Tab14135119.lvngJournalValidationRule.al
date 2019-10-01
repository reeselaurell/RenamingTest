table 14135119 "lvngJournalValidationRule"
{
    DataClassification = CustomerContent;
    Caption = 'Journal Validation Rule';
    LookupPageId = lvngJournalValidationRules;

    fields
    {
        field(1; lvngJournalBatchCode; Code[20])
        {
            Caption = 'Batch Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanJournalBatch.lvngCode;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; lvngConditionCode; Code[20])
        {
            Caption = 'Condition Code';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                lvngSelectedConditionCode: Code[20];
            begin
                Clear(lvngExpressionList);
                lvngSelectedConditionCode := lvngExpressionList.SelectExpression(lvngConditionsMgmt.GetConditionsMgmtConsumerId(), 'JOURNAL');
                if lvngSelectedConditionCode <> '' then
                    lvngConditionCode := lvngSelectedConditionCode;
            end;
        }
        field(12; lvngErrorMessage; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngJournalBatchCode, lvngLineNo)
        {
            Clustered = true;
        }
    }

    var
        lvngConditionsMgmt: Codeunit lvngConditionsMgmt;
        lvngExpressionList: page lvngExpressionList;

}