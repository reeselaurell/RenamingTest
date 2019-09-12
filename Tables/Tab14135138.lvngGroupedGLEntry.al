table 14135138 "lvngGroupedGLEntry"
{
    Caption = 'Grouped G/L Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngPostingDate; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(2; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1));
        }
        field(3; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));
        }
        field(4; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(3));
        }
        field(5; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(4));
        }
        field(6; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(5));
        }
        field(7; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(6));
        }
        field(8; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(7));
        }
        field(9; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(8));
        }

        field(10; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }
        field(11; lvngGLAccountNo; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(100; lvngAmount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(101; lvngDebitAmount; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(102; lvngCreditAmount; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; lvngPostingDate, lvngGLAccountNo, lvngGlobalDimension1Code, lvngGlobalDimension2Code, lvngShortcutDimension3Code, lvngShortcutDimension4Code, lvngShortcutDimension5Code, lvngShortcutDimension6Code, lvngShortcutDimension7Code, lvngShortcutDimension8Code, lvngBusinessUnitCode)
        {
            Clustered = true;
        }
    }

}