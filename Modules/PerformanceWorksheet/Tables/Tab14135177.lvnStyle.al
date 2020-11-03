table 14135177 "lvnStyle"
{
    Caption = 'Style';
    DataClassification = CustomerContent;
    LookupPageId = lvnStyleList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; Bold; Enum lvnDefaultBoolean) { Caption = 'Bold'; DataClassification = CustomerContent; }
        field(12; Italic; Enum lvnDefaultBoolean) { Caption = 'Italic'; DataClassification = CustomerContent; }
        field(13; Underline; Enum lvnDefaultBoolean) { Caption = 'Underline'; DataClassification = CustomerContent; }
        field(14; "Background Color"; Text[100]) { Caption = 'Background Color'; DataClassification = CustomerContent; }
        field(15; "Font Color"; Text[100]) { Caption = 'Font Color'; DataClassification = CustomerContent; }
        field(16; "Font Size"; Integer) { Caption = 'Font Size'; DataClassification = CustomerContent; }
        field(17; "Font Name"; Text[100]) { Caption = 'Font Name'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

}