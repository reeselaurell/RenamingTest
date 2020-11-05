table 14135199 "lvnExpressionLine"
{
    fields
    {
        field(1; "Expression Code"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Consumer Id"; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(4; "Split No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Left Side"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(11; Comparison; Enum lvnComparison)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Right Side"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Expression Code", "Consumer Id", "Line No.", "Split No.") { Clustered = true; }
    }
}