page 14135248 "lvnStorageBrowser"
{
    Caption = 'Storage Browser';
    DataCaptionExpression = GetCaption;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name) { ApplicationArea = All; CaptionClass = GetColumnName; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Containers)
            {
                Caption = 'Containers';
                Visible = not BrowsingFiles;

                action(NewContainer)
                {
                    Caption = 'New...';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = NewItem;
                    Visible = not BrowsingFiles;

                    trigger OnAction()
                    var
                        FPBuilder: FilterPageBuilder;
                        NameValueBuffer: Record "Name/Value Buffer" temporary;
                        ContainerName: Text;
                    begin
                        FPBuilder.PageCaption(NewContainerLbl);
                        FPBuilder.AddRecord(ContainersLbl, Rec);
                        FPBuilder.AddField(ContainersLbl, Rec.Name);
                        if FPBuilder.RunModal() then begin
                            NameValueBuffer.SetView(FPBuilder.GetView(ContainersLbl));
                            ContainerName := NameValueBuffer.GetFilter(Name);
                            if ContainerName <> '' then begin
                                AzureBlobMgmt.CreateContainer(ContainerName);
                                Refresh();
                            end;
                        end;
                    end;
                }

                action(BrowseContents)
                {
                    Caption = 'Browse...';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ShowList;
                    Visible = not BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    var
                        StorageBrowser: Page lvnStorageBrowser;
                    begin
                        if Rec.Name <> '' then begin
                            Clear(StorageBrowser);
                            StorageBrowser.SetParams(Rec.Name);
                            StorageBrowser.Run();
                        end;
                    end;
                }

                action(DeleteContainer)
                {
                    Caption = 'Delete';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Delete;
                    Visible = not BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    begin
                        if Rec.Name <> '' then
                            if Confirm(DeleteContainerPromptQst, false, Rec.Name) then begin
                                AzureBlobMgmt.DeleteContainer(Rec.Name);
                                Refresh();
                            end;
                    end;
                }
            }
            group(Files)
            {
                Caption = 'Files';
                Visible = BrowsingFiles;

                action(UploadFile)
                {
                    Caption = 'Upload...';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Open;
                    Visible = BrowsingFiles;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileName: Text;
                        IStream: InStream;
                        OStream: OutStream;
                    begin
                        if UploadIntoStream(SelectFileLbl, '', FileMaskTxt, FileName, IStream) then begin
                            TempBlob.CreateOutStream(OStream);
                            CopyStream(OStream, IStream);
                            AzureBlobMgmt.UploadFile(TempBlob, Container, FileName);
                            Refresh();
                        end;
                    end;
                }

                action(DownloadFile)
                {
                    Caption = 'Download';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Close;
                    Visible = BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    var
                        IStream: InStream;
                        FileName: Text;
                    begin
                        AzureBlobMgmt.DownloadFile(Container, Rec.Name, IStream);
                        FileName := Rec.Name;
                        DownloadFromStream(IStream, SaveFileLbl, '', FileMaskTxt, FileName);
                    end;
                }

                action(CopyFile)
                {
                    Caption = 'Copy To...';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Copy;
                    Visible = BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    var
                        StorageBrowser: Page lvnStorageBrowser;
                        DstContainer: Text;
                    begin
                        Clear(StorageBrowser);
                        StorageBrowser.LookupMode(true);
                        StorageBrowser.ExcludeFromView(Container);
                        if StorageBrowser.RunModal() = Action::LookupOK then begin
                            DstContainer := StorageBrowser.GetSelectedName();
                            if DstContainer <> '' then
                                AzureBlobMgmt.CopyFile(Container, Rec.Name, DstContainer, Rec.Name);
                        end;
                    end;
                }

                action(MoveFile)
                {
                    Caption = 'Move To...';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = CreateMovement;
                    Visible = BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    var
                        StorageBrowser: Page lvnStorageBrowser;
                        DstContainer: Text;
                    begin
                        Clear(StorageBrowser);
                        StorageBrowser.LookupMode(true);
                        StorageBrowser.ExcludeFromView(Container);
                        if StorageBrowser.RunModal() = Action::LookupOK then begin
                            DstContainer := StorageBrowser.GetSelectedName();
                            if DstContainer <> '' then begin
                                AzureBlobMgmt.MoveFile(Container, Rec.Name, DstContainer, Rec.Name);
                                Refresh();
                            end;
                        end;
                    end;
                }

                action(DeleteFile)
                {
                    Caption = 'Delete';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Delete;
                    Visible = BrowsingFiles;
                    Enabled = Rec.Name <> '';

                    trigger OnAction()
                    begin
                        if Rec.Name <> '' then
                            if Confirm(DeleteFilePromptQst, false, Rec.Name) then begin
                                AzureBlobMgmt.DeleteFile(Container, Rec.Name);
                                Refresh();
                            end;
                    end;
                }
            }
        }
    }

    var
        ContainersLbl: Label 'Containers';
        FilesCaptionLbl: Label 'Files in %1';
        NewContainerLbl: Label 'Create Container';
        DeleteContainerPromptQst: Label 'Container %1 and all its contents will be deleted permanently. This action cannot be undone. Are you sure?';
        FilesLbl: Label 'Files';
        DeleteFilePromptQst: Label 'File %1 will be deleted permanently. This action cannot be undone. Are you sure?';
        SaveFileLbl: Label 'Save file';
        SelectFileLbl: Label 'Select a file';
        FileMaskTxt: Label 'All Files|*.*';
        [InDataSet]
        BrowsingFiles: Boolean;
        Container: Text;
        AzureBlobMgmt: Codeunit lvnAzureBlobManagement;
        ExcludeName: Text;

    trigger OnOpenPage()
    begin
        Refresh();
    end;

    procedure SetParams(ContainerName: Text)
    begin
        Container := ContainerName;
        if Container <> '' then
            BrowsingFiles := true;
    end;

    procedure ExcludeFromView(Name: Text)
    begin
        ExcludeName := Name;
    end;

    procedure GetSelectedName(): Text
    begin
        exit(Rec.Name);
    end;

    local procedure GetCaption(): Text
    begin
        if BrowsingFiles then
            exit(StrSubstNo(FilesCaptionLbl, Container))
        else
            exit(ContainersLbl);
    end;

    local procedure GetColumnName(): Text
    begin
        if BrowsingFiles then
            exit(FilesLbl)
        else
            exit(ContainersLbl);
    end;

    local procedure Refresh()
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if BrowsingFiles then
            AzureBlobMgmt.GetFileList(Container, Rec)
        else
            AzureBlobMgmt.GetContainerList(Rec);
        if ExcludeName <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetFilter(Name, '<>%1', ExcludeName);
            Rec.FilterGroup(0);
        end;
        CurrPage.Update(false);
    end;
}