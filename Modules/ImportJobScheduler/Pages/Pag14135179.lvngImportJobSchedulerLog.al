page 14135179 lvngImportJobSchedulerLog
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
                field("Entry No."; Rec."Entry No.") { Caption = 'Entry No.'; ApplicationArea = All; }
                field("Job Scheduler Task Code"; Rec."Job Scheduler Task Code") { Caption = 'Job Scheduler Task Code'; ApplicationArea = All; }
                field("File Name"; Rec."File Name") { Caption = 'File Name'; ApplicationArea = All; }
                field("Import Failed"; Rec."Import Failed") { Caption = 'Import Failed'; ApplicationArea = All; }
                field("Error Text"; Rec."Error Text") { Caption = 'Error Text'; ApplicationArea = All; }
                field("Journal Entries Count"; Rec."Journal Entries Count") { Caption = 'Journal Entries Count'; ApplicationArea = All; }
                field("Total Debit Amount"; Rec."Total Debit Amount") { Caption = 'Total Debit Amount'; ApplicationArea = All; }
                field("Total Credit Amount"; Rec."Total Credit Amount") { Caption = 'Total Credit Amount'; ApplicationArea = All; }
            }
        }
    }
}