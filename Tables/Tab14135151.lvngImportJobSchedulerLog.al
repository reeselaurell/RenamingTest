table 14135151 lvngImportJobSchedulerLog
{
    Caption = 'Import Job Scheduler Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; DataClassification = CustomerContent; AutoIncrement = true; }
        field(10; "Job Scheduler Task Code"; Code[20]) { Caption = 'Job Scheduler Task Code'; DataClassification = CustomerContent; TableRelation = lvngImportJobSchedulerTask.Code; }
        field(11; "File Name"; Text[250]) { Caption = 'File Name'; DataClassification = CustomerContent; }
        field(12; "Import Failed"; Boolean) { Caption = 'Import Failed'; DataClassification = CustomerContent; }
        field(13; "Import Date/Time"; DateTime) { Caption = 'Import Date/Time'; DataClassification = CustomerContent; }
        field(14; "Error Text"; Text[250]) { Caption = 'Error Text'; DataClassification = CustomerContent; }
        field(15; "Posting Failed"; Boolean) { Caption = 'Posting Failed'; DataClassification = CustomerContent; }
        field(100; "Import ID"; Guid) { Caption = 'Import ID'; DataClassification = CustomerContent; }
        field(102; "Journal Entries Count"; Integer) { Caption = 'Journal Entries Count'; DataClassification = CustomerContent; Editable = false; }
        field(103; "Total Debit Amount"; Decimal) { Caption = 'Total Debit Amount'; DataClassification = CustomerContent; Editable = false; }
        field(104; "Total Credit Amount"; Decimal) { Caption = 'Total Credit Amount'; DataClassification = CustomerContent; Editable = false; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}