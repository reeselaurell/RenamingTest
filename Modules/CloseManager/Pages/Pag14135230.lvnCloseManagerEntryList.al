page 14135230 "lvnCloseManagerEntryList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvnCloseManagerEntryHeader;
    CardPageId = lvnCloseManagerEntryCard;
    InsertAllowed = false;
    Caption = 'Close Manager Entries';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

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
        }
        area(FactBoxes)
        {
            part(DocumentsExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
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

                trigger OnAction()
                var
                    CloseManagerTemplateHeader: Record lvnCloseManagerTemplateHeader;
                    CloseManagerEntryHeader: Record lvnCloseManagerEntryHeader;
                    CloseManagerTemplates: Page lvnCloseManagerTemplateList;
                    CloseManagerEntryCard: Page lvnCloseManagerEntryCard;
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
        TemplateEntryAlreadyExistsMsg: Label 'This Template already has an Entry. The existing Entry was opened.';
}