page 14135231 "lvnCloseManagerEntryCard"
{
    PageType = List;
    SourceTable = lvnCloseManagerEntryHeader;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Close Manager Entry Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
            part(Subform; lvnCloseManagerEntrySubform)
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Template No." = field("Template No.");
                UpdatePropagation = Both;
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
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;

                trigger OnAction()
                var
                    CloseManagerSetup: Record lvnCloseManagerSetup;
                    CloseManagerEntryHeader: Record lvnCloseManagerEntryHeader;
                    CloseManagerEntryHdrArchive: Record lvnCloseManagerArchEntryHdr;
                    CloseManagerEntryLine: Record lvnCloseManagerEntryLine;
                    CloseManagerEntryLineArchive: Record lvnCloseManagerArchEntryLine;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                begin
                    Clear(CloseManagerSetup);
                    CloseManagerSetup.Get();
                    CloseManagerSetup.TestField("Quick Entry Archive Nos.");
                    Rec.CalcFields("Tasks Awaiting Approval", "Outstanding Reconcilliations");
                    if (Rec."Tasks Awaiting Approval" > 0) or (Rec."Outstanding Reconcilliations" > 0) then
                        if not Confirm(ArchiveIncompleteEntryQst, false) then
                            Error(UnableToArchiveIncompleteErr);
                    Clear(CloseManagerEntryHeader);
                    CloseManagerEntryHeader.Get(Rec."Template No.");
                    Clear(CloseManagerEntryHdrArchive);
                    CloseManagerEntryHdrArchive.TransferFields(CloseManagerEntryHeader);
                    CloseManagerEntryHdrArchive."No." := NoSeriesMgt.GetNextNo(CloseManagerSetup."Quick Entry Archive Nos.", 0D, true);
                    CloseManagerEntryHdrArchive."Template No." := CloseManagerEntryHeader."Template No.";
                    CloseManagerEntryHdrArchive.Insert(true);
                    CloseManagerEntryLine.SetRange("Template No.", CloseManagerEntryHeader."Template No.");
                    if CloseManagerEntryLine.FindSet() then
                        repeat
                            Clear(CloseManagerEntryLineArchive);
                            CloseManagerEntryLineArchive.TransferFields(CloseManagerEntryLine);
                            CloseManagerEntryLineArchive."No." := CloseManagerEntryHdrArchive."No.";
                            CloseManagerEntryLineArchive."Template No." := CloseManagerEntryLine."Template No.";
                            CloseManagerEntryLineArchive.Insert(true);
                        until CloseManagerEntryLine.Next() = 0;
                    CloseManagerEntryHeader.Delete(true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CloseManagerTemplateLine: Record lvnCloseManagerTemplateLine;
        CloseManagerEntryLine: Record lvnCloseManagerEntryLine;
        OrigCloseManagerEntryLine: Record lvnCloseManagerEntryLine;
    begin
        Clear(CloseManagerEntryLine);
        CloseManagerEntryLine.SetRange("Template No.", Rec."Template No.");
        if CloseManagerEntryLine.FindSet() then
            repeat
                if not CloseManagerTemplateLine.Get(CloseManagerEntryLine."Template No.", CloseManagerEntryLine."Line No.") then
                    CloseManagerEntryLine.Delete(true);
            until CloseManagerEntryLine.Next() = 0;
        Clear(CloseManagerTemplateLine);
        CloseManagerTemplateLine.SetRange("Template No.", Rec."Template No.");
        if CloseManagerTemplateLine.FindSet() then
            repeat
                if not CloseManagerEntryLine.Get(CloseManagerTemplateLine."Template No.", CloseManagerTemplateLine."Line No.") then begin
                    CloseManagerEntryLine.TransferFields(CloseManagerTemplateLine);
                    CloseManagerEntryLine."Template No." := CloseManagerTemplateLine."Template No.";
                    CloseManagerEntryLine."Line No." := CloseManagerTemplateLine."Line No.";
                    CloseManagerEntryLine.Insert(true);
                end;
                OrigCloseManagerEntryLine := CloseManagerEntryLine;
                CloseManagerEntryLine.TransferFields(CloseManagerTemplateLine);
                CloseManagerEntryLine."Assigned To" := OrigCloseManagerEntryLine."Assigned To";
                CloseManagerEntryLine."Assigned Approver" := OrigCloseManagerEntryLine."Assigned Approver";
                CloseManagerEntryLine.Modify(true);
            until CloseManagerTemplateLine.Next() = 0;
    end;

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
        ArchiveIncompleteEntryQst: Label 'Are you sure you want to Archive this Close Manager Entry? There are still open tasks left.';
        UnableToArchiveIncompleteErr: Label 'Unable to archive entry with open tasks';
}