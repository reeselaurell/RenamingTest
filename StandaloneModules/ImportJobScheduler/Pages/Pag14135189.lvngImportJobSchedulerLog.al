page 14135189 lvngImportJobSchedulerLog
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngImportJobSchedulerLog;
    Caption = 'Import Job Scheduler Log';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.") { Caption = 'Entry No.'; ApplicationArea = All; }
                field("Job Scheduler Task Code"; "Job Scheduler Task Code") { Caption = 'Job Scheduler Task Code'; ApplicationArea = All; }
                field("File Name"; "File Name") { Caption = 'File Name'; ApplicationArea = All; }
                field("Import Failed"; "Import Failed") { Caption = 'Import Failed'; ApplicationArea = All; }
                field("Error Text"; "Error Text") { Caption = 'Error Text'; ApplicationArea = All; }
                field("Journal Entries Count"; "Journal Entries Count") { Caption = 'Journal Entries Count'; ApplicationArea = All; }
                field("Total Debit Amount"; "Total Debit Amount") { Caption = 'Total Debit Amount'; ApplicationArea = All; }
                field("Total Credit Amount"; "Total Credit Amount") { Caption = 'Total Credit Amount'; ApplicationArea = All; }
            }
        }
    }
}