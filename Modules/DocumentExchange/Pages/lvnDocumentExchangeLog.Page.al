page 14135247 "lvnDocumentExchangeLog"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = lvnDocumentExchangeLog;
    SourceTableView = where(Success = const(false));
    Caption = 'Document Exchange Log';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Creation Date/Time"; Rec."Creation Date/Time")
                {
                    ApplicationArea = All;
                }
                field(Success; Rec.Success)
                {
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}