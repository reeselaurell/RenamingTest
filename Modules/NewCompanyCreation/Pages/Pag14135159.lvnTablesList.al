page 14135159 "lvnTablesList"
{
    Caption = 'Tables List';
    PageType = List;
    SourceTable = "Table Metadata";
    SourceTableView = where(TableType = const(Normal));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(ID; Rec.ID)
                {
                    Caption = 'ID';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
            }
        }
    }
}