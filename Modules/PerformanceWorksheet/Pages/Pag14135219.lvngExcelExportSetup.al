page 14135219 lvngExcelExportSetup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = lvngExcelExportSetup;
    Caption = 'Excel Export Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Base Url"; "Base Url") { ApplicationArea = All; }
                field("Access Key"; "Access Key") { ApplicationArea = All; }
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