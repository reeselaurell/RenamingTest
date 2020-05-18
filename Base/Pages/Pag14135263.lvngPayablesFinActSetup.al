page 14135263 lvngPayablesFinActSetup
{
    PageType = Card;
    Caption = 'Payables Finance Activity Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = lvngPayablesFinActSetup;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Filter by User"; "Filter by User") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}