page 14135230 lvngCloseManagerEntryList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngCloseManagerEntryHeader;
    CardPageId = lvngCloseManagerEntryCard;
    InsertAllowed = false;
    Caption = 'Close Manager Entries';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Template No."; "Template No.") { ApplicationArea = All; }
                field("Period Date"; "Period Date") { ApplicationArea = All; }
                field("Total Tasks"; "Total Tasks") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; "Outstanding Reconcilliations") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; "Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Tasks Approved"; "Tasks Approved") { ApplicationArea = All; }
                field(PercentComplete; PercentComplete) { ApplicationArea = All; Caption = 'Percent Complete'; }
            }
        }

        area(FactBoxes)
        {
            part(DocumentsExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateEntry)
            {
                ApplicationArea = All;
                Caption = 'Create Entry';
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CloseManagerTemplateHeader: Record lvngCloseManagerTemplateHeader;
                    CloseManagerEntryHeader: Record lvngCloseManagerEntryHeader;
                    CloseManagerTemplates: Page lvngCloseManagerTemplateList;
                    CloseManagerEntryCard: Page lvngCloseManagerEntryCard;
                begin
                    Clear(CloseManagerTemplates);
                    CloseManagerTemplates.Editable := false;
                    CloseManagerTemplates.LookupMode := true;
                    if CloseManagerTemplates.RunModal() = Action::LookupOK then begin
                        CloseManagerTemplates.GetRecord(CloseManagerTemplateHeader);
                        if not CloseManagerEntryHeader.Get(CloseManagerTemplateHeader."No.") then begin
                            Clear(CloseManagerEntryHeader);
                            CloseManagerEntryHeader."Template No." := CloseManagerTemplateHeader."No.";
                            CloseManagerEntryHeader."Document GUID" := CreateGuid();
                            CloseManagerEntryHeader.Insert(true);
                            Commit();
                        end else
                            Message(TemplateEntryAlreadyExistsMsg);
                        Clear(CloseManagerEntryCard);
                        CloseManagerEntryCard.Editable := true;
                        CloseManagerEntryCard.SetRecord(CloseManagerEntryHeader);
                        CloseManagerEntryCard.Run();
                    end;
                end;
            }
        }
    }

    var
        TemplateEntryAlreadyExistsMsg: Label 'This Template already has an Entry. The existing Entry was opened.';
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