page 14135247 lvngDocumentExchangeLog
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = lvngDocumentExchangeLog;
    SourceTableView = where (Success = const (false));
    Caption = 'Document Exchange Log';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Creation Date/Time"; "Creation Date/Time") { ApplicationArea = All; }
                field(Success; Success) { ApplicationArea = All; }
                field("File Name"; "File Name") { ApplicationArea = All; }
                field(Message; Message) { ApplicationArea = All; }
            }
        }
    }
}