page 14135246 lvngDocumentImportRules
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
                field(Order; Rec.Order) { ApplicationArea = All; }
                field(Prefix; Rec.Prefix) { ApplicationArea = All; }
                field("Table No."; Rec."Table No.") { ApplicationArea = All; TableRelation = AllObj."Object ID" where("Object Type" = const(Table)); }
                field("Field Name"; Rec."Field Name") { ApplicationArea = All; TableRelation = Field.FieldName where(TableNo = field("Table No.")); }
                field("Table View"; Rec."Table View") { ApplicationArea = All; }
                field("Fall Through"; Rec."Fall Through") { ApplicationArea = All; }
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
            Rec.Order := 1
        else
            Rec.Order := DocumentImportRule.Order + 1
    end;
}