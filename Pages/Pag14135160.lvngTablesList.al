page 14135160 lvngTablesList
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

                field(ID; ID) { Caption = 'ID'; ApplicationArea = All; }
                field(Name; Name) { Caption = 'Name'; ApplicationArea = All; }
            }
        }
    }
}