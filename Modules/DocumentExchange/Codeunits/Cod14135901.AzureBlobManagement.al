codeunit 14135901 lvngAzureBlobManagement
{
    var
        AzureBlobSetup: Record lvngDocumentExchangeSetup;
        AzureBlobSetupRetrieved: Boolean;

    procedure UploadFile(var TempBlob: Codeunit "Temp Blob"; ContainerName: Text; FileName: Text): Text
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
        Client.Post(AzureBlobSetup."Azure Base Url" +
            'UploadBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&filename=' + EncodeUriComponent(FileName) +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), RequestContent, ResponseMsg);
        ResponseMsg.Content().ReadAs(Output);
        exit(Output);
    end;

    procedure FileExists(ContainerName: Text; FileName: Text): Boolean
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        StatusCode: Integer;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" +
            'BlobExists?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&filename=' + EncodeUriComponent(FileName) +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
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

    procedure DeleteFile(ContainerName: Text; FileName: Text): Boolean
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
    begin
        GetAzureBlobSetup();
        Client.Delete(AzureBlobSetup."Azure Base Url" +
            'DeleteBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&filename=' + EncodeUriComponent(FileName) +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
        exit(ResponseMsg.IsSuccessStatusCode());
    end;

    procedure DeleteContainer(ContainerName: Text): Boolean
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
    begin
        GetAzureBlobSetup();
        Client.Delete(AzureBlobSetup."Azure Base Url" +
            'DeleteContainer?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
        exit(ResponseMsg.IsSuccessStatusCode());
    end;

    procedure DownloadFile(ContainerName: Text; FileName: Text; var Stream: InStream)
    var
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMsg: HttpResponseMessage;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" +
            'DownloadBlob?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&filename=' + EncodeUriComponent(FileName) +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(ResponseMsg.ReasonPhrase);
        ResponseMsg.Content.ReadAs(Stream);
    end;

    procedure GetContainerList(var NameValueBuffer: Record "Name/Value Buffer")
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        Content: Text;
        Json: JsonArray;
        Token: JsonToken;
        LineNo: Integer;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" +
            'ListContainers?code=' + EncodeUriComponent((AzureBlobSetup."Access Key")), ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(ResponseMsg.ReasonPhrase);
        ResponseMsg.Content.ReadAs(Content);
        Json.ReadFrom(Content);
        LineNo := 1;
        foreach Token in Json do begin
            Clear(NameValueBuffer);
            NameValueBuffer.ID := LineNo;
            LineNo += 1;
            NameValueBuffer.Name := Token.AsValue().AsText();
            NameValueBuffer.Insert();
        end;
    end;

    procedure GetFileList(ContainerName: Text; var NameValueBuffer: Record "Name/Value Buffer")
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        Content: Text;
        Json: JsonArray;
        Token: JsonToken;
        LineNo: Integer;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" +
            'ListBlobs?code=' + EncodeUriComponent((AzureBlobSetup."Access Key")) +
            '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(ResponseMsg.ReasonPhrase);
        ResponseMsg.Content.ReadAs(Content);
        Json.ReadFrom(Content);
        LineNo := 1;
        foreach Token in Json do begin
            Clear(NameValueBuffer);
            NameValueBuffer.ID := LineNo;
            LineNo += 1;
            NameValueBuffer.Name := Token.AsValue().AsText();
            NameValueBuffer.Insert();
        end;
    end;

    procedure CopyFile(FromContainerName: Text; FromFileName: Text; ToContainerName: Text; ToFileName: Text): Text
    begin
        exit(TransferFile(FromContainerName, FromFileName, ToContainerName, ToFileName, true));
    end;

    procedure MoveFile(FromContainerName: Text; FromFileName: Text; ToContainerName: Text; ToFileName: Text): Text
    begin
        exit(TransferFile(FromContainerName, FromFileName, ToContainerName, ToFileName, false));
    end;

    procedure CreateContainer(ContainerName: Text): Text
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        Output: Text;
    begin
        GetAzureBlobSetup();
        Client.Get(AzureBlobSetup."Azure Base Url" + 'CreateContainer?code=' + EncodeUriComponent((AzureBlobSetup."Access Key")) + '&container=' + EncodeUriComponent(ValidateContainerName(ContainerName)), ResponseMsg);
        if not ResponseMsg.IsSuccessStatusCode() then
            Error(ResponseMsg.ReasonPhrase);
        ResponseMsg.Content().ReadAs(Output);
        exit(Output);
    end;

    local procedure TransferFile(FromContainerName: Text; FromFileName: Text; ToContainerName: Text; ToFileName: Text; KeepCopy: Boolean): Text
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        FunctionName: Text;
        Output: Text;
    begin
        GetAzureBlobSetup();
        if ToFileName = '' then
            ToFileName := FromFileName;
        if KeepCopy then
            FunctionName := 'CopyBlob'
        else
            FunctionName := 'MoveBlob';
        Client.Get(AzureBlobSetup."Azure Base Url" +
             FunctionName + '?code=' + EncodeUriComponent(AzureBlobSetup."Access Key") +
            '&from_filename=' + EncodeUriComponent(FromFileName) +
            '&from_container=' + EncodeUriComponent(ValidateContainerName(FromContainerName)) +
            '&to_filename=' + EncodeUriComponent(ToFileName) +
            '&to_container=' + EncodeUriComponent(ValidateContainerName(ToContainerName)), ResponseMsg);
        ResponseMsg.Content().ReadAs(Output);
        exit(Output);
    end;

    local procedure ValidateContainerName(ContainerName: Text) Result: Text
    var
        AllowedChars: Text;
        Idx: Integer;
        LastIdx: Integer;
        C: Text;
    begin
        AllowedChars := '1234567890qwertyuiopasdfghjklzxcvbnm-';
        LastIdx := StrLen(ContainerName);
        if LastIdx > 63 then
            LastIdx := 63;
        for Idx := 1 to LastIdx do begin
            C := LowerCase(ContainerName[Idx]);
            if (StrPos(AllowedChars, C) <> 0) and ((Idx <> 1) or (C <> '-')) then
                Result += C;
        end;
        if StrLen(Result) > 63 then
            Result := CopyStr(Result, 1, 63)
        else
            while (StrLen(Result) < 3) do
                Result := Result + '0';
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