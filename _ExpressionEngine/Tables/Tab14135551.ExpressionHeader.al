table 14135551 lvngExpressionHeader
{
    LookupPageId = lvngExpressionList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Consumer Id"; Guid) { DataClassification = CustomerContent; }
        field(10; Type; Enum lvngExpressionType) { DataClassification = CustomerContent; }
        field(11; Description; Text[100]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code, "Consumer Id") { Clustered = true; }
    }

    trigger OnDelete()
    var
        ExpressionLine: Record lvngExpressionLine;
    begin
        ExpressionLine.Reset();
        ExpressionLine.SetRange("Expression Code", Code);
        ExpressionLine.SetRange("Consumer Id", "Consumer Id");
        ExpressionLine.DeleteAll(true);
    end;
}