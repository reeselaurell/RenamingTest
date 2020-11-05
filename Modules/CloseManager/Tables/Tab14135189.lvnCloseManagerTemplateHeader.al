table 14135189 "lvnCloseManagerTemplateHeader"
{
    DataClassification = CustomerContent;
    Caption = 'Close Manager Template Header';
    LookupPageId = lvnCloseManagerTemplateList;
    DrillDownPageId = lvnCloseManagerTemplateList;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    trigger OnDelete()
    var
        CloseManagerTemplateLine: Record lvnCloseManagerTemplateLine;
    begin
        CloseManagerTemplateLine.Reset();
        CloseManagerTemplateLine.SetRange("Template No.", "No.");
        CloseManagerTemplateLine.DeleteAll(true);
    end;
}