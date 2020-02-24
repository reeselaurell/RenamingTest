table 14135161 lvngFlexibleImportSchema
{
    Caption = 'Flexible Import Schema';
    DataClassification = CustomerContent;
    LookupPageId = lvngFlexibleImportSchemaList;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[250]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Skip Rows"; Integer) { Caption = 'Skip Rows'; DataClassification = CustomerContent; }
        field(12; "Field Separator Character"; Text[10]) { Caption = 'Field Separator Character'; DataClassification = CustomerContent; }
        field(13; "Field Delimiter Character"; Text[250]) { Caption = 'Field Delimiter Character'; DataClassification = CustomerContent; }
        field(20; "Default Reason Code"; Code[10]) { Caption = 'Default Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(21; "Document No. Prefix"; Code[3]) { Caption = 'Document No. Prefix'; DataClassification = CustomerContent; }
        field(22; "Loan No. Prefix"; Code[10]) { Caption = 'Loan No. Prefix'; DataClassification = CustomerContent; }
        field(23; "Use Document No. From Series"; Boolean) { Caption = 'Use Document No. From Series'; DataClassification = CustomerContent; }
        field(30; "Loan No. Column No."; Integer) { Caption = 'Loan No. Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(31; "Document No. Column No."; Integer) { Caption = 'Document No. Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(32; "Document Type Column No."; Integer) { Caption = 'Document Type Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(33; "Posting Date Column No."; Integer) { Caption = 'Posting Date Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(34; "Document Date Column No."; Integer) { Caption = 'Document Date Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(35; "Comment Column No."; Integer) { Caption = 'Comment Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(36; "External Document Column No."; Integer) { Caption = 'External Document Column No.'; DataClassification = CustomerContent; BlankZero = true; }
        field(41; "Dimension 1 Code Column No."; Integer) { Caption = 'Dimension 1 Code Column No.'; CaptionClass = GetCaption(1); DataClassification = CustomerContent; BlankZero = true; }
        field(42; "Dimension 2 Code Column No."; Integer) { Caption = 'Dimension 2 Code Column No.'; CaptionClass = GetCaption(2); DataClassification = CustomerContent; BlankZero = true; }
        field(43; "Dimension 3 Code Column No."; Integer) { Caption = 'Dimension 3 Code Column No.'; CaptionClass = GetCaption(3); DataClassification = CustomerContent; BlankZero = true; }
        field(44; "Dimension 4 Code Column No."; Integer) { Caption = 'Dimension 4 Code Column No.'; CaptionClass = GetCaption(4); DataClassification = CustomerContent; BlankZero = true; }
        field(45; "Dimension 5 Code Column No."; Integer) { Caption = 'Dimension 5 Code Column No.'; CaptionClass = GetCaption(5); DataClassification = CustomerContent; BlankZero = true; }
        field(46; "Dimension 6 Code Column No."; Integer) { Caption = 'Dimension 6 Code Column No.'; CaptionClass = GetCaption(6); DataClassification = CustomerContent; BlankZero = true; }
        field(47; "Dimension 7 Code Column No."; Integer) { Caption = 'Dimension 7 Code Column No.'; CaptionClass = GetCaption(7); DataClassification = CustomerContent; BlankZero = true; }
        field(48; "Dimension 8 Code Column No."; Integer) { Caption = 'Dimension 8 Code Column No.'; CaptionClass = GetCaption(8); DataClassification = CustomerContent; BlankZero = true; }
        field(49; "Business Unit Code Column No."; Integer) { Caption = 'Business Unit Code Column No.'; DataClassification = CustomerContent; BlankZero = true; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        ColumnNoLbl: Label ' Column No.';

    trigger OnDelete()
    var
        FlexibleImportSchemaLine: Record lvngFlexibleImportSchemaLine;
    begin
        FlexibleImportSchemaLine.Reset();
        FlexibleImportSchemaLine.SetRange("Schema Code", Code);
        FlexibleImportSchemaLine.DeleteAll(true);
    end;

    local procedure GetCaption(DimCode: Integer): Text;
    begin
        exit(CaptionClassTranslate('1,2,' + Format(DimCode)) + ColumnNoLbl);
    end;
}