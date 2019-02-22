table 14135131 "lvngServiceLine"
{
    Caption = 'Service Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngServicingDocumentType; enum lvngServicingDocumentType)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(2; lvngDocumentNo; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = lvngServiceHeader.lvngNo where (lvngServicingDocumentType = field (lvngServicingDocumentType));
            DataClassification = CustomerContent;
        }
        field(3; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; lvngAccountNo; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = "G/L Account"."No." where ("Account Type" = const (Posting));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
            begin
                GLAccount.Get(lvngAccountNo);
                lvngDescription := GLAccount.Name;
            end;
        }
        field(11; lvngDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(12; lvngAmount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(14; lvngServicingType; enum lvngServicingType)
        {
            Caption = 'Servicing Type';
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
    }

    keys
    {
        key(PK; lvngServicingDocumentType, lvngDocumentNo, lvngLineNo)
        {
            Clustered = true;
        }
    }

    var
        DimensionManagement: Codeunit DimensionManagement;

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