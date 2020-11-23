$(document).on('dragover', ShutUp)
    .on('dragenter', function (e) {
        ShutUp(e);
        if (drag_count == 0) {
            drop_zone.css('display', 'block');
            drop_zone.animate({ opacity: 1 }, 400);
        }
        drag_count++;
    })
    .on('dragleave', function (e) {
        ShutUp(e);
        drag_count--;
        if (drag_count == 0) {
            drop_zone.animate({ opacity: 0 }, 400, 'swing', function () {
                drop_zone.css('display', 'none');
            });
        }
    })
    .on('drop', function (e) {
        ShutUp(e);
        drag_count--;
        drop_zone.css('opacity', 0);
        drop_zone.css('display', 'none');
        if (e.originalEvent && e.originalEvent.dataTransfer && e.originalEvent.dataTransfer.files && e.originalEvent.dataTransfer.files.length) {
            for (var i = 0; i < e.originalEvent.dataTransfer.files.length; i++) {
                var file = e.originalEvent.dataTransfer.files[i];
                if (file.size / 1048576 > 10) {
                    if (!confirm('File ' + file.name + ' is larger than 10 Megabytes. It is recommended to upload large files using "Upload" button instead.\n Do you want to continue?')) {
                        continue;
                    }
                }
                upload_queue.push(file);
            }
            BeginFileUpload();
        }
    });
$('#controlAddIn').append($.parseHTML(DocumentListControl));
$('li.btn').mousedown(function () {
    $(this).addClass('pressed');
}).mouseup(function () {
    $(this).removeClass('pressed');
});
drop_zone = $('#drop-zone');
file_list = $('#file-list');
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddInReady');
