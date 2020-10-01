page 14135177 lvngImportJobSchedulerTasks
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = lvngImportJobSchedulerTask;
    Caption = 'Import Job Scheduler Tasks';
    CardPageId = lvngImportJobSchedulerCard;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { Caption = 'Code'; ApplicationArea = All; }
                field(Type; Rec.Type) { Caption = 'Type'; ApplicationArea = All; }
                field("Import Folder"; Rec."Import Folder") { Caption = 'Import Folder'; ApplicationArea = All; }
                field("Archive Folder"; Rec."Archive Folder") { Caption = 'Archive Folder'; ApplicationArea = All; }
                field("Error Folder"; Rec."Error Folder") { Caption = 'Error Folder'; ApplicationArea = All; }
            }
        }
    }
}