var drop_zone;
var drag_count = 0;
var upload_progress;
var upload_queue = [];
var file_list;

function ShutUp(e) {
    e.preventDefault();
    e.stopPropagation();
}

function BeginFileUpload() {
    if (upload_queue.length == 0)
        return;
    var file = upload_queue.pop();
    var rdr = new FileReader();
    rdr.onerror = function (e) {
        alert('Drag & drop failed, try using upload dialog!');
    }
    rdr.onloadend = function (e) {
        if (!e.target.result) {
            return;
        }
        upload_progress = {
            pos: 0,
            buffer: e.target.result,
            name: file.name
        };
        UploadFileChunk();
    }
    rdr.readAsArrayBuffer(file);
}

function UploadFileChunk() {
    if (upload_progress) {
        if (upload_progress.pos >= upload_progress.buffer.byteLength) {
            if (!upload_progress.id) {
                //Handle empty file
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FileDrop', ['', upload_progress.name, '']);
                return;
            }
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FileDrop', [upload_progress.id, '', '']);
            upload_progress = undefined;
            BeginFileUpload();
            return;
        }
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FileDrop', [upload_progress.id, upload_progress.name, ArraySliceToBase64(upload_progress.buffer, upload_progress.pos, Math.min(1048575, upload_progress.buffer.byteLength - upload_progress.pos))]);
        upload_progress.pos += 1048575;
    }
}

function ChunkUploadComplete(id) {
    if (upload_progress)
        upload_progress.id = id;
    window.setTimeout(function () {
        UploadFileChunk();
    }, 10);
}

function UploadDialog() {
    try
    {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UploadClick');
    }
    catch (e) {
        alert(e);
    }
}

function Refresh() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RefreshClick');
}

function ArraySliceToBase64(arrayBuffer, offset, length) {
    var base64 = ''
    var encodings = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    var bytes = new Uint8Array(arrayBuffer, offset, length)
    var byteLength = bytes.byteLength
    var byteRemainder = byteLength % 3
    var mainLength = byteLength - byteRemainder

    var a, b, c, d
    var chunk

    // Main loop deals with bytes in chunks of 3
    for (var i = 0; i < mainLength; i = i + 3) {
        // Combine the three bytes into a single integer
        chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2]

        // Use bitmasks to extract 6-bit segments from the triplet
        a = (chunk & 16515072) >> 18 // 16515072 = (2^6 - 1) << 18
        b = (chunk & 258048) >> 12 // 258048   = (2^6 - 1) << 12
        c = (chunk & 4032) >> 6 // 4032     = (2^6 - 1) << 6
        d = chunk & 63               // 63       = 2^6 - 1

        // Convert the raw binary segments to the appropriate ASCII encoding
        base64 += encodings[a] + encodings[b] + encodings[c] + encodings[d]
    }

    // Deal with the remaining bytes and padding
    if (byteRemainder == 1) {
        chunk = bytes[mainLength]

        a = (chunk & 252) >> 2 // 252 = (2^6 - 1) << 2

        // Set the 4 least significant bits to zero
        b = (chunk & 3) << 4 // 3   = 2^2 - 1

        base64 += encodings[a] + encodings[b] + '=='
    } else if (byteRemainder == 2) {
        chunk = (bytes[mainLength] << 8) | bytes[mainLength + 1]

        a = (chunk & 64512) >> 10 // 64512 = (2^6 - 1) << 10
        b = (chunk & 1008) >> 4 // 1008  = (2^6 - 1) << 4

        // Set the 2 least significant bits to zero
        c = (chunk & 15) << 2 // 15    = 2^4 - 1

        base64 += encodings[a] + encodings[b] + encodings[c] + '='
    }

    return base64
}

function Clear() {
    file_list.empty();
}
function AppendDocument(name, id) {
    var li = $('<li>').addClass('item').attr('data-id', id).click(function () {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FileClick', [$(this).data('id')]);
    });
    li.append($('<a>').attr('href', '#').html('&times;').click(function (e) {
        e.stopPropagation();
        e.preventDefault();
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DeleteFile',[$(this).parent().data('id')])
    }));
    li.append($('<div>').text(name));
    var items = file_list.children('li');
    var min = 0;
    var max = items.length;
    var iter = 0;
    while (min != max) {
        if (iter++ > items.length) {
            break;
        }
        var cur = Math.floor((min + max) / 2);
        var other = items.eq(cur).find('div').text();
        var comp = other.localeCompare(name);
        if (comp == 0)
            min = max = cur;
        else if (comp < 0)
            min = cur + 1;
        else
            max = cur;
    }
    if (items.length == 0)
        file_list.append(li);
    else if (min == 0)
        items.eq(min).before(li)
    else
        items.eq(min - 1).after(li);
}
function SetControlError(error) {
    if (error) {
        $('#control').hide();
        $('#error').text(error);
        $('#error').show();
    }
    else {
        $('#control').show();
        $('#error').hide();
    }
}