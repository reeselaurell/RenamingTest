page 14135236 "lvnCloseManagerArchEntryCard"
{
    PageType = Card;
    SourceTable = lvnCloseManagerArchEntryHdr;
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

                field("Template No."; Rec."Template No.")
                {
                    ApplicationArea = All;
                }
                field("Period Date"; Rec."Period Date")
                {
                    ApplicationArea = All;
                }
                field("Total Tasks"; Rec."Total Tasks")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Reconcilliations"; Rec."Outstanding Reconcilliations")
                {
                    ApplicationArea = All;
                }
                field("Tasks Awaiting Approval"; Rec."Tasks Awaiting Approval")
                {
                    ApplicationArea = All;
                }
                field("Tasks Approved"; Rec."Tasks Approved")
                {
                    ApplicationArea = All;
                }
                field(PercentComplete; PercentComplete)
                {
                    ApplicationArea = All;
                    Caption = 'Percent Complete';
                }
            }
            part(CloseManagerEntryArchSubForm; lvnCloseManagerArchEntrySubFm)
            {
                Caption = 'Close Manager Entry Archive Subform';
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(DocumentsExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

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

    var
        PercentComplete: Integer;
}