table 14135145 "lvnCompanyDataTransfer"
{
    DataClassification = CustomerContent;
    Caption = 'Company Data Transfer';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TableMetaData: Record "Table Metadata";
                TablesListPage: Page lvnTablesList;
            begin
                TableMetadata.Reset();
                TableMetadata.SetRange(ID, 14135100, 14135999);
                TableMetadata.SetRange(TableType, TableMetadata.TableType::Normal);
                TableMetadata.FindSet();
                repeat
                    TableMetadata.Mark(true);
                until TableMetadata.Next() = 0;
                TableMetadata.SetFilter(ID, '%1..%2', 1, 99999999);
                TableMetadata.SetFilter(Name, '*Setup*');
                TableMetadata.FindSet();
                repeat
                    TableMetadata.Mark(true);
                until TableMetadata.Next() = 0;
                TableMetadata.SetRange(Name);
                TableMetadata.SetRange(ID);
                TableMetadata.MarkedOnly(true);
                Clear(TablesListPage);
                TablesListPage.SetTableView(TableMetadata);
                TablesListPage.LookupMode := true;
                if TablesListPage.RunModal() = Action::LookupOK then begin
                    TablesListPage.GetRecord(TableMetadata);
                    Validate("Table ID", TableMetadata.ID);
                end;
            end;
        }
        field(10; "Table Name"; Text[50]) { Caption = 'Table Name'; FieldClass = FlowField; CalcFormula = lookup(AllObj."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID"))); Editable = false; }
        field(11; Active; Boolean) { Caption = 'Active'; DataClassification = CustomerContent; InitValue = true; }
    }

    keys
    {
        key(PK; "Table ID") { Clustered = true; }
    }
}