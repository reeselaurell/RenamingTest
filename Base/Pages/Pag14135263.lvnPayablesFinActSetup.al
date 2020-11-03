page 14135263 "lvnPayablesFinActSetup"
{
    PageType = Card;
    Caption = 'Payables Finance Activity Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = lvnPayablesFinActSetup;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Filter by User"; Rec."Filter by User") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}