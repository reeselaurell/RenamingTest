page 14135902 lvngDocumentImportRules
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = lvngDocumentImportRule;
    Caption = 'Document Import Rules';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Order; Order) { ApplicationArea = All; }
                field(Prefix; Prefix) { ApplicationArea = All; }
                field("Table No."; "Table No.") { ApplicationArea = All; TableRelation = AllObj."Object ID" where ("Object Type" = const (Table)); }
                field("Field Name"; "Field Name") { ApplicationArea = All; TableRelation = Field.FieldName where (TableNo = field ("Table No.")); }
                field("Table View"; "Table View") { ApplicationArea = All; }
                field("Fall Through"; "Fall Through") { ApplicationArea = All; }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        DocumentImportRule: Record lvngDocumentImportRule;
    begin
        DocumentImportRule.Reset();
        DocumentImportRule.SetCurrentKey(Order);
        if not DocumentImportRule.FindLast() then
            Order := 1
        else
            Order := DocumentImportRule.Order + 1
    end;
}