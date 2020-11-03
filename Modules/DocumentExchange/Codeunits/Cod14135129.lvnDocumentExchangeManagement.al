codeunit 14135129 "lvnDocumentExchangeManagement"
{
    var
        DocumentExchangeSetup: Record lvnDocumentExchangeSetup;
        DocumentGuidTxt: Label 'lvnDocumentGuid';
        MultipleRecordsErr: Label 'Target table has multiple records with different Ids related to the file being imported';
        SuccessMsg: Label 'Document attached successfully';
        NoRecordFoundErr: Label 'Import rule was found, however target table does not have any related records';
        NoDXCIdFoundErr: Label 'Import rule was found, however target table does not have Document Exchange Id field';
        NoRuleFoundErr: Label 'No matching import rule was found';
        NoImportRulesErr: Label 'Import rules are not configured';
        EmptyGuid: Guid;
        DocumentExchangeSetupRetrieved: Boolean;
        AzureBlobMgmt: Codeunit lvnAzureBlobManagement;

    procedure CheckDocumentExchange(): Boolean
    begin
        if (not DocumentExchangeSetup.Get()) then
            exit(false);
        DocumentExchangeSetupRetrieved := true;
        exit(DocumentExchangeSetup."Azure Base Url" <> '');
    end;

    procedure AttachDocument(ObjectId: Guid; FileName: Text; var Content: Codeunit "Temp Blob"; AttachmentDateTime: DateTime; UsedCompanyName: Text; Importing: Boolean; SkipOperations: Boolean): Guid
    var
        DocumentExchangeLine: Record lvnDocumentExchangeLine;
        FileMgmt: Codeunit "File Management";
    begin
        if UsedCompanyName <> '' then
            DocumentExchangeLine.ChangeCompany(UsedCompanyName);
        DocumentExchangeLine.Init();
        DocumentExchangeLine."Object Id" := ObjectId;
        DocumentExchangeLine."Original Name" := FileMgmt.GetFileName(FileName);
        DocumentExchangeLine."Is Imported" := Importing;
        DocumentExchangeLine."Creation Date/Time" := AttachmentDateTime;
        SetupDocumentLine(DocumentExchangeLine);
        if not SkipOperations then
            AzureBlobMgmt.UploadFile(Content, DocumentExchangeLine."Storage Path", DocumentExchangeLine."Storage Name");
        DocumentExchangeLine.Insert();
        exit(DocumentExchangeLine.Id);
    end;

    procedure GetDocument(DocumentId: Text; var Stream: InStream): Text
    var
        DocumentExchangeLine: Record lvnDocumentExchangeLine;
    begin
        DocumentExchangeLine.Get(DocumentId);
        AzureBlobMgmt.DownloadFile(DocumentExchangeLine."Storage Path", DocumentExchangeLine."Storage Name", Stream);
        exit(DocumentExchangeLine."Original Name");
    end;

    procedure DeleteDocument(DocumentId: Guid): Boolean
    var
        DocumentExchangeLine: Record lvnDocumentExchangeLine;
    begin
        DocumentExchangeLine.Get(DocumentId);
        AzureBlobMgmt.DeleteFile(DocumentExchangeLine."Storage Path", DocumentExchangeLine."Storage Name");
        DocumentExchangeLine.Delete();
    end;

    procedure TryAttachDocument(CompanyName: Text; FileName: Text): Text
    var
        FileManagement: Codeunit "File Management";
        DocumentName: Text;
        DocumentImportRule: Record lvnDocumentImportRule;
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        FieldNo: Integer;
        TableView: Text;
        DocumentGuid: Guid;
        HashSet: List of [Guid];
        FileContent: Codeunit "Temp Blob";
        IStream: InStream;
    begin
        FileContent.CreateInStream(IStream);
        AzureBlobMgmt.DownloadFile('temp', FileName, IStream);
        AzureBlobMgmt.DeleteFile('temp', FileName);
        DocumentName := FileManagement.GetFileNameWithoutExtension(FileName);
        DocumentImportRule.Reset();
        if CompanyName <> '' then
            DocumentImportRule.ChangeCompany(CompanyName);
        DocumentImportRule.SetCurrentKey(Order);
        if DocumentImportRule.FindSet() then begin
            repeat
                if (DocumentImportRule.Prefix = '') or (StrPos(DocumentName, DocumentImportRule.Prefix) = 1) then begin
                    if CompanyName = '' then
                        RecordReference.Open(DocumentImportRule."Table No.")
                    else
                        RecordReference.Open(DocumentImportRule."Table No.", false, CompanyName);
                    FieldNo := GetDXCFieldNo(RecordReference);
                    if FieldNo <> 0 then begin
                        TableView := 'where(';
                        if DocumentImportRule."Table View" <> '' then
                            TableView := TableView + DocumentImportRule."Table View" + ',';
                        TableView := TableView + DocumentImportRule."Field Name" + '=const(' + DocumentName + '))';
                        RecordReference.SetView(TableView);
                        if RecordReference.FindSet(true) then begin
                            FieldReference := RecordReference.Field(FieldNo);
                            if RecordReference.Count() = 1 then begin
                                DocumentGuid := FieldReference.Value();
                                if IsNullGuid(DocumentGuid) then begin
                                    DocumentGuid := CreateGuid();
                                    FieldReference.Value(DocumentGuid);
                                    RecordReference.Modify();
                                end;
                            end else begin
                                Clear(HashSet);
                                repeat
                                    DocumentGuid := FieldReference.Value();
                                    if not HashSet.Contains(DocumentGuid) then
                                        HashSet.Add(DocumentGuid);
                                until RecordReference.Next() = 0;
                                if HashSet.Contains(EmptyGuid) then begin
                                    HashSet.Remove(EmptyGuid);
                                    case HashSet.Count() of
                                        0:
                                            DocumentGuid := CreateGuid();
                                        1:
                                            DocumentGuid := GetFirstKey(HashSet)
                                        else begin
                                                AttachDocument(LogMessage(false, MultipleRecordsErr, FileName, CompanyName), FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
                                                exit(MultipleRecordsErr);
                                            end;
                                    end;
                                end;
                            end;
                            AttachDocument(DocumentGuid, FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
                            LogMessage(true, SuccessMsg, FileName, CompanyName);
                            exit('');
                        end else
                            if not DocumentImportRule."Fall Through" then begin
                                AttachDocument(LogMessage(false, NoRecordFoundErr, FileName, CompanyName), FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
                                exit(NoRecordFoundErr);
                            end;
                    end else begin
                        AttachDocument(LogMessage(false, NoDXCIdFoundErr, FileName, CompanyName), FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
                        exit(NoDXCIdFoundErr);
                    end;
                    RecordReference.Close();
                end;
            until DocumentImportRule.Next() = 0;
            AttachDocument(LogMessage(false, NoRuleFoundErr, FileName, CompanyName), FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
            exit(NoRuleFoundErr);
        end else begin
            AttachDocument(LogMessage(false, NoImportRulesErr, FileName, CompanyName), FileName, FileContent, CurrentDateTime(), CompanyName, false, false);
            exit(NoImportRulesErr);
        end;
    end;

    local procedure SetupDocumentLine(var DocumentExchangeLine: Record lvnDocumentExchangeLine)
    var
        Idx: Integer;
        PlainFileName: Text;
        FileExtension: Text;
        FileMgmt: Codeunit "File Management";
    begin
        GetDocumentExchangeSetup();
        DocumentExchangeLine.Id := CreateGuid();
        DocumentExchangeLine."Storage Path" := Format(DT2Date(DocumentExchangeLine."Creation Date/Time"), 0, 9);
        DocumentExchangeLine."Storage Name" := DocumentExchangeLine."Original Name";
        Idx := 1;
        while AzureBlobMgmt.FileExists(DocumentExchangeLine."Storage Path", DocumentExchangeLine."Storage Name") do begin
            if PlainFileName = '' then begin
                PlainFileName := FileMgmt.GetFileNameWithoutExtension(DocumentExchangeLine."Original Name");
                FileExtension := FileMgmt.GetExtension(DocumentExchangeLine."Original Name");
                if FileExtension <> '' then
                    if FileExtension[1] <> '.' then
                        FileExtension := '.' + FileExtension;
            end;
            DocumentExchangeLine."Storage Name" := PlainFileName + ' (' + Format(Idx) + ')' + FileExtension;
            Idx := Idx + 1;
        end;
    end;

    local procedure GetDocumentExchangeSetup()
    begin
        if not DocumentExchangeSetupRetrieved then begin
            DocumentExchangeSetup.Get();
            DocumentExchangeSetupRetrieved := true;
        end;
    end;

    local procedure GetDXCFieldNo(var RecordReference: RecordRef): Integer
    var
        Field: Record Field;
    begin
        Field.Reset();
        Field.SetRange(TableNo, RecordReference.Number());
        Field.SetRange(FieldName, DocumentGuidTxt);
        if Field.IsEmpty() then
            exit(0)
        else begin
            Field.FindFirst();
            exit(Field."No.");
        end;
    end;

    local procedure GetFirstKey(var HashSet: List of [Guid]): Guid
    var
        Item: Guid;
    begin
        foreach Item in HashSet do
            exit(Item);
        exit(EmptyGuid);
    end;

    local procedure LogMessage(Success: Boolean; Message: Text; FileName: Text; CompanyName: Text) Result: Guid
    var
        DocumentExchangeLog: Record lvnDocumentExchangeLog;
    begin
        if CompanyName <> '' then
            DocumentExchangeLog.ChangeCompany(CompanyName);
        if not Success then
            Result := CreateGuid();
        DocumentExchangeLog.Init();
        DocumentExchangeLog."Creation Date/Time" := CurrentDateTime();
        DocumentExchangeLog.Success := Success;
        DocumentExchangeLog."File Name" := CopyStr(FileName, 1, 250);
        DocumentExchangeLog.Message := CopyStr(Message, 1, 250);
        DocumentExchangeLog."Document Guid" := Result;
        DocumentExchangeLog.Insert();
    end;
}
