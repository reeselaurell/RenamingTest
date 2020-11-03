page 14135178 "lvnImportJobSchedulerCard"
{
    PageType = Card;
    SourceTable = lvnImportJobSchedulerTask;
    Caption = 'Import Job Scheduler Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Rec.Code) { Caption = 'Code'; ApplicationArea = All; }
                field(Type; Rec.Type) { Caption = 'Type'; ApplicationArea = All; }
                field("Import Folder"; Rec."Import Folder") { Caption = 'Import Folder'; ApplicationArea = All; }
                field("Archive Folder"; Rec."Archive Folder") { Caption = 'Archive Folder'; ApplicationArea = All; }
                field("Error Folder"; Rec."Error Folder") { Caption = 'Error Folder'; ApplicationArea = All; }
            }

            group(LoanJournal)
            {
                Caption = 'Loan Journal';

                field("Loan Journal Type"; Rec."Loan Journal Type") { Caption = 'Loan Journal Type'; ApplicationArea = All; }
                field("Loan Journal Batch"; Rec."Loan Journal Batch") { Caption = 'Loan Journal Batch'; ApplicationArea = All; }
            }

            group(GeneralJournal)
            {
                Caption = 'General Journal';

                field("Gen. Journal Template"; Rec."Gen. Journal Template") { Caption = 'Gen. Journal Template'; ApplicationArea = All; }
                field("Gen. Journal Batch"; Rec."Gen. Journal Batch") { Caption = 'Gen. Journal Batch'; ApplicationArea = All; }
                field(Post; Rec.Post) { Caption = 'Post'; ApplicationArea = All; }
            }
        }
    }
}