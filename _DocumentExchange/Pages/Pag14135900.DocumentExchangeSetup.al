page 14135900 lvngDocumentExchangeSetup
{
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = lvngDocumentExchangeSetup;
    Caption = 'Document Exchange Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            // group(OnPremises)
            // {
            //     Caption = 'On Premises';

            //     field("Storage Root"; "Storage Root") { ApplicationArea = All; }
            // }
            group(Azure)
            {
                field("Azure Base Url"; "Azure Base Url") { ApplicationArea = All; }
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