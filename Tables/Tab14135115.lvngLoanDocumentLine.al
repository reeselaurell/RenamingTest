table 14135115 "lvngLoanDocumentLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Document Line';
    fields
    {
        field(1; lvngTransactionType; enum lvngTransactionType)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(2; lvngDocumentNo; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanDocument.lvngDocumentNo where (lvngTransactionType = field (lvngTransactionType));
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

            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(1, lvngGlobalDimension1Code, lvngDimensionSetID);
            end;
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (2));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(2, lvngGlobalDimension2Code, lvngDimensionSetID);
            end;
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(3, lvngShortcutDimension3Code, lvngDimensionSetID);
            end;
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(4, lvngShortcutDimension4Code, lvngDimensionSetID);
            end;
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(5, lvngShortcutDimension5Code, lvngDimensionSetID);
            end;
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(6, lvngShortcutDimension6Code, lvngDimensionSetID);
            end;
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(7, lvngShortcutDimension7Code, lvngDimensionSetID);
            end;
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
            trigger OnValidate()
            begin
                DimensionManagement.ValidateShortcutDimValues(8, lvngShortcutDimension8Code, lvngDimensionSetID);
            end;
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
        key(PK; lvngTransactionType, lvngDocumentNo, lvngLineNo)
        {
            Clustered = true;
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

    procedure GenerateDimensionSetId()
    begin
        DimensionManagement.ValidateShortcutDimValues(1, lvngGlobalDimension1Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(2, lvngGlobalDimension2Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(3, lvngShortcutDimension3Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(4, lvngShortcutDimension4Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(5, lvngShortcutDimension5Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(6, lvngShortcutDimension6Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(7, lvngShortcutDimension7Code, lvngDimensionSetID);
        DimensionManagement.ValidateShortcutDimValues(8, lvngShortcutDimension8Code, lvngDimensionSetID);
    end;

}