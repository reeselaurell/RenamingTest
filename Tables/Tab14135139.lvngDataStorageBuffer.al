table 14135139 lvngDataStorageBuffer
{
    DataClassification = CustomerContent;
    Caption = 'Data Storage Buffer';
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(10; "Value as Text"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Value as Text';
        }
        field(11; Bold; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Bold';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}