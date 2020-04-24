table 14135189 lvngCloseManagerTemplateHeader
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Template Header';
    LookupPageId = lvngCloseManagerTemplateList;
    DrillDownPageId = lvngCloseManagerTemplateList;

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(10; Name; Text[50]) { Caption = 'Name'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    trigger OnDelete()
    var
        CloseManagerTemplateLine: Record lvngCloseManagerTemplateLine;
    begin
        CloseManagerTemplateLine.Reset();
        CloseManagerTemplateLine.SetRange("Template No.", "No.");
        CloseManagerTemplateLine.DeleteAll(true);
    end;

}