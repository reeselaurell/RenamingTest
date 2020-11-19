report 14135109 "lvnDimensionChangeSetImport"
{
    Caption = 'Dimension Change Set Import';
    ProcessingOnly = true;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            RequestFilterFields = "Entry No.", "G/L Account No.", "Posting Date", "Document Type", "Document No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
            lvnShortcutDimension3Code, lvnShortcutDimension4Code, lvnShortcutDimension5Code, lvnShortcutDimension6Code, lvnShortcutDimension7Code, lvnShortcutDimension8Code, "Business Unit Code";

            trigger OnPreDataItem()
            begin
                Progress.Open(ImportingMsg, Current, Total);
            end;

            trigger OnAfterGetRecord()
            begin
                Current := Current + 1;
                Progress.Update(1, Current);
                Clear(DimensionChangeJnlEntry);
                DimensionChangeJnlEntry."Change Set ID" := ChangeSetID;
                DimensionChangeJnlEntry.TransferValuesFromRecord(GLEntry);
                DimensionChangeJnlEntry.Insert();
            end;

            trigger OnPostDataItem()
            begin
                Progress.Close();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'General';

                    field(OverwriteField; Overwrite) { Caption = 'Overwrite Existing Entries'; ApplicationArea = All; }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        Total := GLEntry.Count();
        Current := 0;
        if Total >= 50000 then
            if not Confirm(LargeCountMsg, false, Total) then
                CurrReport.Quit();
        if Overwrite then begin
            DimensionChangeJnlEntry.SetRange("Change Set ID", ChangeSetID);
            DimensionChangeJnlEntry.DeleteAll();
        end;
    end;

    var
        DimensionChangeJnlEntry: Record lvnDimensionChangeJnlEntry;
        Overwrite: Boolean;
        ChangeSetID: Guid;
        Progress: Dialog;
        Total: Integer;
        Current: Integer;
        LargeCountMsg: Label 'Your selection contains very large number of entries (%1)\This may lock database for all users for a long time\Are you sure you want to proceed?';
        ImportingMsg: Label 'Importing entry #1######## of #2########';

    procedure SetParams(pChangeSetID: Guid)
    begin
        ChangeSetID := pChangeSetID;
    end;
}