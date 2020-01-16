codeunit 14135901 lvngAzureBlobManagement
{
    var
        AzureBlobSetup: Record lvngDocumentExchangeSetup;
        AzureBlobSetupRetrieved: Boolean;

    procedure UploadFile(var TempBlob: Codeunit "Temp Blob"; DirectoryName: Text; FileName: Text): Text
    var
        InputStream: InStream;
        RequestContent: HttpContent;
        Client: HttpClient;
        ContentHeaders: HttpHeaders;
        ResponseMsg: HttpResponseMessage;
        Output: Text;
    begin
        GetAzureBlobSetup();
        TempBlob.CreateInStream(InputStream);
        RequestContent.WriteFrom(InputStream);
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/octet-stream');
        Client.Post(AzureBlobSetup."Azure Base Url" + 'UploadBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") + '&filename=' + EncodeUriComponent(FileName) + '&container=' + EncodeUriComponent(DirectoryName), RequestContent, ResponseMsg);
        ResponseMsg.Content().ReadAs(Output);
        exit(Output);
    end;

    procedure FileExists(DirectoryName: Text; FileName: Text): Boolean
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        StatusCode: Integer;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" + 'BlobExists?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") + '&filename=' + EncodeUriComponent(FileName) + '&container=' + EncodeUriComponent(DirectoryName), ResponseMsg);
        StatusCode := ResponseMsg.HttpStatusCode(); //Prevents compilation error with implicit cast
        case StatusCode of
            302:
                exit(true);
            404:
                exit(false)
            else
                Error(ResponseMsg.ReasonPhrase);
        end;
    end;

    procedure DeleteFile(DirectoryName: Text; FileName: Text): Boolean
    var
        JsonObj: JsonObject;
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMsg: HttpResponseMessage;
        Input: Text;
        StatusCode: Integer;
    begin
        GetAzureBlobSetup();
        Client.Delete(AzureBlobSetup."Azure Base Url" + 'DeleteBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") + '&filename=' + EncodeUriComponent(FileName) + '&container=' + EncodeUriComponent(DirectoryName), ResponseMsg);
        StatusCode := ResponseMsg.HttpStatusCode(); //Prevents compilation error with implicit cast
        exit(StatusCode = 200);
    end;

    procedure DownloadFile(DirectoryName: Text; FileName: Text; var Stream: InStream)
    var
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMsg: HttpResponseMessage;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" + 'DownloadBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") + '&filename=' + EncodeUriComponent(FileName) + '&container=' + EncodeUriComponent(DirectoryName), ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(ResponseMsg.ReasonPhrase);
        ResponseMsg.Content.ReadAs(Stream);
    end;

    local procedure GetAzureBlobSetup()
    begin
        if not AzureBlobSetupRetrieved then begin
            AzureBlobSetup.Get();
            AzureBlobSetup.TestField("Azure Base Url");
            if not AzureBlobSetup."Azure Base Url".EndsWith('/') then
                AzureBlobSetup."Azure Base Url" += '/';
            AzureBlobSetupRetrieved := true;
        end;
    end;

    local procedure EncodeUriComponent(Component: Text): Text
    var
        C: Integer;
        Idx: Integer;
        Builder: TextBuilder;
        Hex: Text;
    begin
        if Component = '' then
            exit('');
        Hex := '0123456789ABCDEF';
        for Idx := 1 to StrLen(Component) do begin
            C := Component[Idx];
            case C of
                ' ':
                    Builder.Append('+');
                '0' .. '9', 'a' .. 'z', 'A' .. 'Z', '_', '-', '.':
                    Builder.Append(Component[Idx]);
                else
                    Builder.Append('%');
                    Builder.Append(Hex[(C div 16) + 1]);
                    Builder.Append(Hex[(C mod 16) + 1]);
            end;
        end;
        exit(Builder.ToText());
    end;
}