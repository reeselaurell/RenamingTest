page 14135235 lvngCloseManagerArchEntryList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngCloseManagerArchEntryHdr;
    CardPageId = lvngCloseManagerArchEntryCard;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'Close Manager Archive Entries';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Template No."; Rec."Template No.") { ApplicationArea = All; }
                field("Period Date"; Rec."Period Date") { ApplicationArea = All; }
                field("Total Tasks"; Rec."Total Tasks") { ApplicationArea = All; }
                field("Tasks Approved"; Rec."Tasks Approved") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; Rec."Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; Rec."Outstanding Reconcilliations") { ApplicationArea = All; }
                field(PercentComplete; PercentComplete) { ApplicationArea = All; Caption = 'Percent Complete'; }
            }
        }

        area(FactBoxes)
        {
            part(DocumentsExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    var
        PercentComplete: Integer;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Guid" := CreateGuid();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Total Tasks", "Tasks Approved");
        if Rec."Total Tasks" = 0 then
            PercentComplete := 100
        else
            PercentComplete := Round(Rec."Tasks Approved" / Rec."Total Tasks" * 100, 1, '=');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentsExchange.Page.ReloadDocuments(Rec."Document Guid");
    end;
}