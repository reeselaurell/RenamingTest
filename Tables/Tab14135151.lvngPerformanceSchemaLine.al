table 14135151 "lvngPerformanceSchemaLine"
{
    Caption = 'Performance Schema Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngPerformanceLineSourceType; Enum lvngPerformanceLineSourceType)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; lvngLoanDateType; enum lvngLoanDateType)
        {
            Caption = 'Loan Date Type';
            DataClassification = CustomerContent;
        }
        field(20; lvngShortcutDimension1Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 1 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,3,1';
        }
        field(21; lvngShortcutDimension2Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 2 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,3,2';
        }
        field(22; lvngShortcutDimension3Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 3 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,3';
        }
        field(23; lvngShortcutDimension4Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 4 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,4';
        }
        field(24; lvngShortcutDimension5Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 5 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,5';
        }
        field(25; lvngShortcutDimension6Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 6 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,6';
        }
        field(26; lvngShortcutDimension7Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 7 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,7';
        }
        field(27; lvngShortcutDimension8Filter; Text[2048])
        {
            Caption = 'Shortcut Dimension 8 Filter';
            DataClassification = CustomerContent;
            CaptionClass = '1,4,8';
        }
        field(28; lvngBusinessUnitFilter; Code[2048])
        {
            Caption = 'Business Unit Filter';
            DataClassification = CustomerContent;
        }
        field(29; lvngUseGLAccountsList; Boolean)
        {
            Caption = 'Use G/L Accounts List';
            DataClassification = CustomerContent;
        }
        field(30; lvngGLAccountFilter; Text[2048])
        {
            Caption = 'G/L Account Filter';
            DataClassification = CustomerContent;
        }
        field(31; lvngHideIfZero; Boolean)
        {
            Caption = 'Hide if Zero';
            DataClassification = CustomerContent;
        }
        field(50; lvngDateFilter; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(70; lvngDescriptionStyleCode; Code[20])
        {
            Caption = 'Description Style Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPerfWorksheetStyling.lvngCode;
        }
        field(71; lvngColumn1StyleCode; Code[20])
        {
            Caption = 'Column 1 Style Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPerfWorksheetStyling.lvngCode;
        }
        field(72; lvngColumn2StyleCode; Code[20])
        {
            Caption = 'Column 2 Style Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPerfWorksheetStyling.lvngCode;
        }
        field(73; lvngColumn3StyleCode; Code[20])
        {
            Caption = 'Column 3 Style Code';
            DataClassification = CustomerContent;
            TableRelation = lvngPerfWorksheetStyling.lvngCode;
        }

    }

    keys
    {
        key(PK; lvngCode, lvngLineNo)
        {
            Clustered = true;
        }
    }

}