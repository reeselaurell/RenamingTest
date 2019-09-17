table 14135152 "lvngPerfSchemaLineAccounts"
{
    Caption = 'Performance Schema Line Account';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPerformanceSchema.lvngCode;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvngPerformanceSchemaLine.lvngLineNo where(lvngCode = field(lvngCode));
        }
        field(3; lvngGLAccountNo; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where("Account Type" = const(Posting));
        }
        field(10; lvngDescription; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup ("G/L Account".Name where("No." = field(lvngGLAccountNo)));
            Editable = false;
        }

    }

    keys
    {
        key(PK; lvngCode, lvngLineNo, lvngGLAccountNo)
        {
            Clustered = true;
        }
    }

}