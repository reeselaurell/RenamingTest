page 14135188 lvngImportJobSchedulerCard
{
    PageType = Card;
    SourceTable = lvngImportJobSchedulerTask;
    Caption = 'Import Job Scheduler Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Code) { Caption = 'Code'; ApplicationArea = All; }
                field(Type; Type) { Caption = 'Type'; ApplicationArea = All; }
                field("Import Folder"; "Import Folder") { Caption = 'Import Folder'; ApplicationArea = All; }
                field("Archive Folder"; "Archive Folder") { Caption = 'Archive Folder'; ApplicationArea = All; }
                field("Error Folder"; "Error Folder") { Caption = 'Error Folder'; ApplicationArea = All; }
            }

            group(LoanJournal)
            {
                Caption = 'Loan Journal';

                field("Loan Journal Type"; "Loan Journal Type") { Caption = 'Loan Journal Type'; ApplicationArea = All; }
                field("Loan Journal Batch"; "Loan Journal Batch") { Caption = 'Loan Journal Batch'; ApplicationArea = All; }
            }

            group(GeneralJournal)
            {
                Caption = 'General Journal';

                field("Gen. Journal Template"; "Gen. Journal Template") { Caption = 'Gen. Journal Template'; ApplicationArea = All; }
                field("Gen. Journal Batch"; "Gen. Journal Batch") { Caption = 'Gen. Journal Batch'; ApplicationArea = All; }
                field(Post; Post) { Caption = 'Post'; ApplicationArea = All; }
            }
        }
    }
}