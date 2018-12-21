tableextension 14135100 "lvngGLEntry" extends "G/L Entry" //MyTargetTableId
{
    fields
    {
        field(14135100; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            TableRelation = lvngLoan;
        }

        field(14135101; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
        }
        field(14135102; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
        }
        field(14135103; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
        }
        field(14135104; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
        }
        field(14135105; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
        }
        field(14135106; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
        }

        field(14135150; lvngWarehouseLineCode; Code[50])
        {
            Caption = 'Warehouse Line Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngWarehouseLineCode where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(14135151; lvngBorrowerSearchName; Code[100])
        {
            Caption = 'Borrower Search Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (lvngLoan.lvngSearchName where (lvngLoanNo = field (lvngLoanNo)));
        }
        field(14135500; lvngImportID; Guid)
        {
            Caption = 'Import ID';
            DataClassification = CustomerContent;
        }


    }

}