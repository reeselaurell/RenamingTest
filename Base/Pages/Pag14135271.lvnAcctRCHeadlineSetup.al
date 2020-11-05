page 14135271 "lvnAcctRCHeadlineSetup"
{
    Caption = 'LV Accountant Headline Setup';
    PageType = Card;
    SourceTable = lvnLVAcctRCHeadlineSetup;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field("Net Income G/L Account"; Rec."Net Income G/L Account No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Branch Performace Date Filter"; Rec."Branch Performace Date Range")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("LO Performace Date Filter"; Rec."LO Performace Date Range")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
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