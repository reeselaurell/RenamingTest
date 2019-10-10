table 14135231 lvngStyle
{
    DataClassification = CustomerContent;
    LookupPageId = lvngStyleList;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { DataClassification = CustomerContent; }
        field(11; Bold; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(12; Italic; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(13; Underline; Enum lvngDefaultBoolean) { DataClassification = CustomerContent; }
        field(14; "Background Color"; Text[100]) { DataClassification = CustomerContent; }
        field(15; "Font Color"; Text[100]) { DataClassification = CustomerContent; }
        field(16; "Font Size"; Integer) { DataClassification = CustomerContent; }
        field(17; "Font Name"; Text[100]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

}