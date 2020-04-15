page 14135255 lvngCloseManagerEntryCard
{
    PageType = List;
    SourceTable = lvngCloseManagerEntryHeader;
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

                field("Period Date"; "Period Date") { ApplicationArea = All; }
                field("Total Tasks"; "Total Tasks") { ApplicationArea = All; }
                field("Outstanding Reconcilliations"; "Outstanding Reconcilliations") { ApplicationArea = All; }
                field("Tasks Awaiting Approval"; "Tasks Awaiting Approval") { ApplicationArea = All; }
                field("Tasks Approved"; "Tasks Approved") { ApplicationArea = All; }
                field(PercentComplete; PercentComplete) { ApplicationArea = All; Caption = 'Percent Complete'; }
            }

            part(Subform; lvngCloseManagerEntrySubform)
            {
                Caption = 'Lines';
                SubPageLink = "Template No." = field("Template No.");
                UpdatePropagation = Both;
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
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CloseManagerSetup: Record lvngCloseManagerSetup;
                    CloseManagerEntryHeader: Record lvngCloseManagerEntryHeader;
                    CloseManagerEntryHdrArchive: Record lvngCloseManagerArchEntryHdr;
                    CloseManagerEntryLine: Record lvngCloseManagerEntryLine;
                    CloseManagerEntryLineArchive: Record lvngCloseManagerArchEntryLine;
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                begin
                    Clear(CloseManagerSetup);
                    CloseManagerSetup.Get();
                    CloseManagerSetup.TestField("Quick Entry Archive Nos.");
                    CalcFields("Tasks Awaiting Approval", "Outstanding Reconcilliations");
                    if ("Tasks Awaiting Approval" > 0) or ("Outstanding Reconcilliations" > 0) then
                        if not Confirm(ArchiveIncompleteEntryQst, false) then
                            Error(UnableToArchiveIncompleteErr);
                    Clear(CloseManagerEntryHeader);
                    CloseManagerEntryHeader.Get("Template No.");
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

    var
        ArchiveIncompleteEntryQst: Label 'Are you sure you want to Archive this Close Manager Entry? There are still open tasks left.';
        UnableToArchiveIncompleteErr: Label 'Unable to archive entry with open tasks';
        PercentComplete: Integer;

    trigger OnOpenPage()
    var
        CloseManagerTemplateLine: Record lvngCloseManagerTemplateLine;
        CloseManagerEntryLine: Record lvngCloseManagerEntryLine;
        OrigCloseManagerEntryLine: Record lvngCloseManagerEntryLine;
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