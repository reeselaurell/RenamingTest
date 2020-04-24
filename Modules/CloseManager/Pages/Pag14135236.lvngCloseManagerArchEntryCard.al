page 14135236 lvngCloseManagerArchEntryCard
{
    PageType = Card;
    SourceTable = lvngCloseManagerArchEntryHdr;
    Editable = false;
    Caption = 'Close Manager Entry Archive Card';

    layout
    {
        area(Content)
        {
            grid(General)
            {
                Caption = 'General';
                GridLayout = Columns;

                field("Template No."; "Template No.") { ApplicationArea = All; }
                field("Period Date"; "Period Date") { ApplicationArea = All; }
                field("Total Tasks"; "Total Tasks") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; "Outstanding Reconcilliations") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; "Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Tasks Approved"; "Tasks Approved") { ApplicationArea = All; }
                field(PercentComplete; PercentComplete) { ApplicationArea = All; Caption = 'Percent Complete'; }
            }

            part(CloseManagerEntryArchSubForm; lvngCloseManagerArchEntrySubFm)
            {
                Caption = 'Close Manager Entry Archive Subform';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
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