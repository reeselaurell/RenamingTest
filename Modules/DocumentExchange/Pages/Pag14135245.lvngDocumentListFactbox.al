page 14135245 lvngDocumentListFactbox
{
    PageType = CardPart;
    Caption = 'Document Exchange';

    layout
    {
        area(Content)
        {
            usercontrol(AddIn; DocumentListControl)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    ControlInitialized := true;
                    if ReloadNeeded then
                        ReloadDocuments(false);
                end;

                trigger FileDrop(Id: Text; FileName: Text; BinaryContent: Text)
                var
                    Convert: Codeunit "Base64 Convert";
                begin
                    if Id = '' then begin
                        Id := Format(CreateGuid());
                        Clear(DropBlob);
                        Clear(DropStream);
                        DropBlob.CreateOutStream(DropStream);
                        DropName := FileName;
                    end else
                        if FileName = '' then begin
                            DXCMgmt.AttachDocument(CurrentObjectId, DropName, DropBlob, CurrentDateTime(), '', false, false);
                            ReloadDocuments(true);
                            exit;
                        end;
                    Convert.FromBase64(BinaryContent, DropStream);
                    CurrPage.AddIn.ChunkUploadComplete(Id);
                end;

                trigger FileClick(Id: Text)
                var
                    FileName: Text;
                    IStream: InStream;
                begin
                    FileName := DXCMgmt.GetDocument(Id, IStream);
                    DownloadFromStream(IStream, SaveDocumentLbl, '', FileMaskTxt, FileName);
                end;

                trigger UploadClick()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                    IStream: InStream;
                    OStream: OutStream;
                begin
                    if UploadIntoStream(SelectDocumentLbl, '', FileMaskTxt, FileName, IStream) then begin
                        TempBlob.CreateOutStream(OStream);
                        CopyStream(OStream, IStream);
                        DXCMgmt.AttachDocument(CurrentObjectId, FileName, TempBlob, CurrentDateTime(), '', false, false);
                        ReloadDocuments(true);
                    end;
                end;

                trigger RefreshClick()
                begin
                    ReloadDocuments(true);
                end;

                trigger DeleteFile(Id: Text)
                var
                    DocumentExchangeLine: Record lvngDocumentExchangeLine;
                begin
                    DocumentExchangeLine.Get(Id);
                    if Confirm(DeletePromptQst, true, DocumentExchangeLine."Original Name") then begin
                        DXCMgmt.DeleteDocument(DocumentExchangeLine.Id);
                        ReloadDocuments(true);
                    end;
                end;
            }
        }
    }

    var
        DeletePromptQst: Label 'File %1 will be deleted permanently. This action cannot be undone. Are you sure?';
        SaveDocumentLbl: Label 'Save document';
        DXCRecordNotConfiguredErr: Label 'Error: Document Exchange Id is not configured for this record';
        DXCSetupNotConfiguredErr: Label 'Error: Document Exchange is not configured';
        SelectDocumentLbl: Label 'Select a Document';
        FileMaskTxt: Label 'All Files|*.*';
        DXCMgmt: Codeunit lvngDocumentExchangeManagement;
        CurrentObjectId: Guid;
        ProposedObjectId: Guid;
        ReloadNeeded: Boolean;
        ControlInitialized: Boolean;
        DropBlob: Codeunit "Temp Blob";
        DropStream: OutStream;
        DropName: Text;

    trigger OnInit()
    begin
        CurrentObjectId := CreateGuid();//Will ensure correct first initialization
    end;

    local procedure ReloadDocuments(Force: Boolean)
    var
        DocumentExchangeLine: Record lvngDocumentExchangeLine;
    begin
        ReloadNeeded := false;
        if not Force and (ProposedObjectId = CurrentObjectId) then
            exit;
        CurrentObjectId := ProposedObjectId;
        CurrPage.AddIn.Clear();
        if not DXCMgmt.CheckDocumentExchange() then
            CurrPage.AddIn.SetControlError(DXCSetupNotConfiguredErr)
        else
            if IsNullGuid(CurrentObjectId) then
                CurrPage.AddIn.SetControlError(DXCRecordNotConfiguredErr)
            else begin
                CurrPage.AddIn.SetControlError('');
                DocumentExchangeLine.Reset();
                DocumentExchangeLine.SetCurrentKey("Object Id");
                DocumentExchangeLine.SetRange("Object Id", CurrentObjectId);
                if DocumentExchangeLine.FindSet() then
                    repeat
                        CurrPage.AddIn.AppendDocument(DocumentExchangeLine."Original Name", DocumentExchangeLine.Id);
                    until DocumentExchangeLine.Next() = 0;
            end;
    end;

    procedure ReloadDocuments(NewId: Guid)
    begin
        ProposedObjectId := NewId;
        if not ControlInitialized then
            ReloadNeeded := true
        else
            ReloadDocuments(false);
    end;
}
