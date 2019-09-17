table 14135153 "lvngPerfWorksheetStyling"
{
    Caption = 'Performance Worksheet Styling';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; lvngBold; Boolean)
        {
            Caption = 'Bold';
            DataClassification = CustomerContent;
        }
        field(12; lvngItalic; Boolean)
        {
            Caption = 'Italic';
            DataClassification = CustomerContent;
        }
        field(13; lvngUnderline; Boolean)
        {
            Caption = 'Underline';
            DataClassification = CustomerContent;
        }
        field(14; lvngBackgroundColor; Text[250])
        {
            Caption = 'Background Color';
            DataClassification = CustomerContent;
        }
        field(15; lvngFontColor; Text[250])
        {
            Caption = 'Font Color';
            DataClassification = CustomerContent;
        }
        field(16; lvngNegBackgroundColor; Text[250])
        {
            Caption = 'Negative Background Color';
            DataClassification = CustomerContent;
        }
        field(17; lvngNegFontColor; Text[250])
        {
            Caption = 'Negative Font Color';
            DataClassification = CustomerContent;
        }
        field(18; lvngFontSize; Integer)
        {
            Caption = 'Font Size';
            DataClassification = CustomerContent;
        }
        field(20; lvngValueFormatting; enum lvngPerformanceValueFormatting)
        {
            Caption = 'Value Formatting';
            DataClassification = CustomerContent;
        }
        field(21; lvngValueSignFormat; enum lvngNumericalFormatting)
        {
            Caption = 'Value Sign Formatting';
            DataClassification = CustomerContent;
        }
        field(22; lvngBlankZero; Boolean)
        {
            Caption = 'Blank Zero';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngCode)
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