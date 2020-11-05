codeunit 14135121 "lvnFilesImportAutomation"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ImportJobSchedulerTask: Record lvnImportJobSchedulerTask;
        ImportJobSchedulerLog: Record lvnImportJobSchedulerLog;
        FileList: Record "Name/Value Buffer" temporary;
        FileMgmt: Codeunit "File Management";
        StorageMgmt: Codeunit lvnAzureBlobManagement;
        Postfix: Text;
        NewFileName: Text;
        FileExtension: Text;
    begin
        Postfix := Format(CurrentDateTime, 0, '_<Year4><Month,2><Day,2>_<Hours,2><Minutes,2><Seconds,2>');
        ImportJobSchedulerTask.Reset();
        ImportJobSchedulerTask.SetRange(Code, Rec."Parameter String");
        ImportJobSchedulerTask.FindFirst();
        FileList.Reset();
        FileList.DeleteAll();
        StorageMgmt.GetFileList(ImportJobSchedulerTask."Import Folder", FileList);
        FileList.Reset();
        if FileList.FindSet() then
            repeat
                Clear(ImportJobSchedulerLog);
                ImportJobSchedulerLog.Init();
                ImportJobSchedulerLog."Job Scheduler Task Code" := ImportJobSchedulerTask.Code;
                ImportJobSchedulerLog."File Name" := FileList.Name;
                ImportJobSchedulerLog."Import Date/Time" := CurrentDateTime;
                ImportJobSchedulerLog."Import ID" := CreateGuid();
                ImportJobSchedulerLog.Insert(true);
                Commit();
                NewFileName := FileMgmt.GetFileNameWithoutExtension(FileList.Name) + Postfix;
                FileExtension := FileMgmt.GetExtension(FileList.Name);
                if not ProcessFileImport(ImportJobSchedulerTask, FileList.Name, ImportJobSchedulerLog."Import ID") then begin
                    ImportJobSchedulerLog."Error Text" := CopyStr(GetLastErrorText(), 1, MaxStrLen(ImportJobSchedulerLog."Error Text"));
                    ImportJobSchedulerLog."Import Failed" := true;
                    ImportJobSchedulerLog.Modify();
                    Commit();
                    StorageMgmt.MoveFile(ImportJobSchedulerTask."Import Folder", FileList.Name, ImportJobSchedulerTask."Error Folder", NewFileName + '.err' + FileExtension);
                end else begin
                    if ImportJobSchedulerTask.Type = ImportJobSchedulerTask.Type::"General Journal" then begin
                        CalcJournalStatistics(ImportJobSchedulerTask, ImportJobSchedulerLog);
                        ImportJobSchedulerLog.Modify();
                        Commit();
                        if ImportJobSchedulerTask.Post then
                            if not PostGeneralJournal(ImportJobSchedulerTask) then begin
                                ImportJobSchedulerLog."Error Text" := CopyStr(GetLastErrorText(), 1, MaxStrLen(ImportJobSchedulerLog."Error Text"));
                                ImportJobSchedulerLog."Posting Failed" := true;
                                ImportJobSchedulerLog.Modify();
                                Commit();
                            end;
                    end;
                    if ImportJobSchedulerLog."Posting Failed" then
                        StorageMgmt.MoveFile(ImportJobSchedulerTask."Import Folder", FileList.Name, ImportJobSchedulerTask."Error Folder", NewFileName + '.err' + FileExtension)
                    else
                        StorageMgmt.MoveFile(ImportJobSchedulerTask."Import Folder", FileList.Name, ImportJobSchedulerTask."Error Folder", NewFileName + '.old' + FileExtension)
                end;
            until FileList.Next() = 0;
    end;

    [TryFunction]
    procedure ProcessFileImport(
        var ImportJobSchedulerTask: Record lvnImportJobSchedulerTask;
        FileName: Text;
        ImportID: Guid)
    begin
        case ImportJobSchedulerTask.Type of
            ImportJobSchedulerTask.Type::"General Journal":
                ProcessGeneralJournalImportFile(ImportJobSchedulerTask, FileName, ImportID);
            ImportJobSchedulerTask.Type::"Loan Journal":
                ProcessLoanImportFile(ImportJobSchedulerTask, FileName);
        end;
    end;

    local procedure CalcJournalStatistics(
        var ImportJobSchedulerTask: Record lvnImportJobSchedulerTask;
        var ImportJobSchedulerLog: Record lvnImportJobSchedulerLog)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", ImportJobSchedulerTask."Gen. Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", ImportJobSchedulerTask."Gen. Journal Batch");
        GenJnlLine.SetRange(lvnImportID, ImportJobSchedulerLog."Import ID");
        if GenJnlLine.FindSet() then begin
            ImportJobSchedulerLog."Journal Entries Count" := GenJnlLine.Count;
            GenJnlLine.CalcSums("Debit Amount", "Credit Amount");
            ImportJobSchedulerLog."Total Credit Amount" := GenJnlLine."Credit Amount";
            ImportJobSchedulerLog."Total Debit Amount" := GenJnlLine."Debit Amount";
        end;
    end;

    local procedure PostGeneralJournal(var ImportJobSchedulerTask: Record lvnImportJobSchedulerTask): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", ImportJobSchedulerTask."Gen. Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", ImportJobSchedulerTask."Gen. Journal Batch");
        GenJnlLine.FindSet();
        exit(GenJnlPostBatch.Run(GenJnlLine));
    end;

    local procedure ProcessGeneralJournalImportFile(
        var ImportJobSchedulerTask: Record lvnImportJobSchedulerTask;
        FileName: Text;
        ImportID: Guid)
    var
        GenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
        ImportBufferError: Record lvnImportBufferError temporary;
        GenJnlFileImportMgmt: Codeunit lvnGenJnlFileImportManagement;
    begin
        GenJnlFileImportMgmt.AutoFileImport(ImportJobSchedulerTask."Data Import Schema Code", ImportJobSchedulerTask."Import Folder", FileName, GenJnlImportBuffer, ImportBufferError);
        ImportBufferError.Reset();
        if not ImportBufferError.IsEmpty() then begin
            ImportBufferError.FindFirst();
            //TODO: Add associated error list instead of just throwing first error
            Error(ImportBufferError.Description);
        end else
            GenJnlFileImportMgmt.CreateJournalLines(GenJnlImportBuffer, ImportJobSchedulerTask."Gen. Journal Template", ImportJobSchedulerTask."Gen. Journal Batch", ImportID);
    end;

    local procedure ProcessLoanImportFile(var ImportJobSchedulerTask: Record lvnImportJobSchedulerTask; FileName: Text)
    var
        LoanImportSchema: Record lvnLoanImportSchema;
        LoanJournalImport: Codeunit lvnLoanJournalImport;
        ValidateLoanJournal: Codeunit lvnValidateLoanJournal;
        ValidateFundedJournal: Codeunit lvnValidateFundedJournal;
        ValidateSoldJournal: Codeunit lvnValidateSoldJournal;
    begin
        LoanImportSchema.Get(ImportJobSchedulerTask."Data Import Schema Code");
        Clear(LoanJournalImport);
        LoanJournalImport.ReadCSVStream(ImportJobSchedulerTask."Loan Journal Batch", LoanImportSchema, ImportJobSchedulerTask."Import Folder", FileName);
        Commit();
        case ImportJobSchedulerTask."Loan Journal Type" of
            ImportJobSchedulerTask."Loan Journal Type"::Loan:
                ValidateLoanJournal.ValidateLoanLines(ImportJobSchedulerTask."Loan Journal Batch");
            ImportJobSchedulerTask."Loan Journal Type"::Funded:
                ValidateFundedJournal.ValidateFundedLines(ImportJobSchedulerTask."Loan Journal Batch");
            ImportJobSchedulerTask."Loan Journal Type"::Sold:
                ValidateSoldJournal.ValidateSoldLines(ImportJobSchedulerTask."Loan Journal Batch");
        end;
    end;
}