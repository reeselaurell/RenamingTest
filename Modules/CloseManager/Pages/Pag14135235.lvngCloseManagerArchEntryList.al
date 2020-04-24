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

                field("No."; "No.") { ApplicationArea = All; }
                field("Template No."; "Template No.") { ApplicationArea = All; }
                field("Period Date"; "Period Date") { ApplicationArea = All; }
                field("Total Tasks"; "Total Tasks") { ApplicationArea = All; }
                field("Tasks Approved"; "Tasks Approved") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; "Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; "Outstanding Reconcilliations") { ApplicationArea = All; }
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
        "Document Guid" := CreateGuid();
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Total Tasks", "Tasks Approved");
        if "Total Tasks" = 0 then
            PercentComplete := 100
        else
            PercentComplete := Round("Tasks Approved" / "Total Tasks" * 100, 1, '=');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentsExchange.Page.ReloadDocuments("Document Guid");
    end;
}