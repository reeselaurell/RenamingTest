page 14135250 lvngCloseManagerSetup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngCloseManagerSetup;
    Caption = 'Close Manager Setup';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Quick Entry Archive Nos."; "Quick Entry Archive Nos.") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}