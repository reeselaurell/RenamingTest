page 14135244 "lvnDocumentExchangeSetup"
{
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = lvnDocumentExchangeSetup;
    Caption = 'Storage Setup';
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
                field("Azure Base Url"; Rec."Azure Base Url") { ApplicationArea = All; }
                field("Access Key"; Rec."Access Key") { ApplicationArea = All; }
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