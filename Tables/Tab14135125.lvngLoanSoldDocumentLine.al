table 14135125 "lvngLoanSoldDocumentLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Sold Document Line';
    fields
    {
        field(2; lvngDocumentNo; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngAccountType; enum lvngAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(11; lvngAccountNo; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if (lvngAccountType = const (lvngGLAccount)) "G/L Account"."No." where ("Account Type" = const (Posting), Blocked = const (false)) else
            if (lvngAccountType = const (lvngBankAccount)) "Bank Account" where (Blocked = const (false));
        }
        field(12; lvngReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }
        field(13; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; lvngAmount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }

        field(80; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (1));
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (2));
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
        }

        field(88; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }

        field(89; lvngDimensionSetID; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
        }
        field(200; lvngServicingType; enum lvngServicingType)
        {
            Caption = 'Servicing Type';
            DataClassification = CustomerContent;
        }
        field(1000; lvngProcessingSchemaCode; code[20])
        {
            Caption = 'Processing Schema Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchema.lvngCode;
        }
        field(1001; lvngProcessingSchemaLineNo; Integer)
        {
            Caption = 'Processing Schema Line No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchemaline.lvngLineNo where (lvngProcessingCode = field (lvngProcessingSchemaCode));
        }
        field(1002; lvngBalancingEntry; boolean)
        {
            Caption = 'Balancing Entry';
            DataClassification = CustomerContent;
        }
        field(1003; lvngTagCode; Code[10])
        {
            Caption = 'Tag Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngDocumentNo, lvngLineNo)
        {
            Clustered = true;
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

}