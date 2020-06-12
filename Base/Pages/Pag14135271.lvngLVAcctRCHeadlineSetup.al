page 14135271 lvngAcctRCHeadlineSetup
{
    Caption = 'LV Accountant Headline Setup';
    PageType = Card;
    SourceTable = lvngLVAcctRCHeadlineSetup;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field("Net Income G/L Account"; "Net Income G/L Account No.") { ApplicationArea = All; Importance = Promoted; }
                field("Branch Performace Date Filter"; "Branch Performace Date Range") { ApplicationArea = All; Importance = Promoted; }
                field("LO Performace Date Filter"; "LO Performace Date Range") { ApplicationArea = All; Importance = Promoted; }
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