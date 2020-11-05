controladdin lvnDocumentListControl
{
    Scripts = 'Resources/js/jquery.min.js',
        'ControlAddIns/DocumentListControl/js/DocumentListControl.js',
        'ControlAddIns/DocumentListControl/js/script.js';
    StartupScript = 'ControlAddIns/DocumentListControl/js/init.js';
    StyleSheets = 'ControlAddIns/DocumentListControl/css/style.css';
    VerticalStretch = false;
    HorizontalStretch = true;
    RequestedHeight = 400;

    event AddInReady();
    event FileDrop(Id: Text; FileName: Text; BinaryContent: Text);
    event FileClick(Id: Text);
    event UploadClick();
    event RefreshClick();
    event DeleteFile(Id: Text);
    procedure Clear();
    procedure AppendDocument(Name: Text; Id: Text);
    procedure ChunkUploadComplete(Id: Text);
    procedure SetControlError(Error: Text);
}