page 14135194 lvngFlexibleImportSchemaCard
{
    PageType = Card;
    SourceTable = lvngFlexibleImportSchema;
    Caption = 'Flexible Import Schema Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Code) { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Skip Rows"; "Skip Rows") { ApplicationArea = All; }
                field("Field Separator Character"; "Field Separator Character") { ApplicationArea = All; }
                field("Field Delimiter Character"; "Field Delimiter Character") { ApplicationArea = All; }
                field("Document Type Column No."; "Document Type Column No.") { ApplicationArea = All; }
                field("Use Document No. From Series"; "Use Document No. From Series") { ApplicationArea = All; }
                field("Document No. Column No."; "Document No. Column No.") { ApplicationArea = All; }
                field("Document No. Prefix"; "Document No. Prefix") { ApplicationArea = All; }
                field("Loan No. Prefix"; "Loan No. Prefix") { ApplicationArea = All; }
                field("Default Reason Code"; "Default Reason Code") { ApplicationArea = All; }
                field("Loan No. Column No."; "Loan No. Column No.") { ApplicationArea = All; }
                field("Posting Date Column No."; "Posting Date Column No.") { ApplicationArea = All; }
                field("Document Date Column No."; "Document Date Column No.") { ApplicationArea = All; }
                field("Comment Column No."; "Comment Column No.") { ApplicationArea = All; }
                field("External Document Column No."; "External Document Column No.") { ApplicationArea = All; Caption = 'External Document No. Column No.'; }
                field("Dimension 1 Code Column No."; "Dimension 1 Code Column No.") { ApplicationArea = All; }
                field("Dimension 2 Code Column No."; "Dimension 2 Code Column No.") { ApplicationArea = All; }
                field("Dimension 3 Code Column No."; "Dimension 3 Code Column No.") { ApplicationArea = All; }
                field("Dimension 4 Code Column No."; "Dimension 4 Code Column No.") { ApplicationArea = All; }
                field("Dimension 5 Code Column No."; "Dimension 5 Code Column No.") { ApplicationArea = All; }
                field("Dimension 6 Code Column No."; "Dimension 6 Code Column No.") { ApplicationArea = All; }
                field("Dimension 7 Code Column No."; "Dimension 7 Code Column No.") { ApplicationArea = All; }
                field("Dimension 8 Code Column No."; "Dimension 8 Code Column No.") { ApplicationArea = All; }
            }
            part(SchemaLine; lvngFlexibleImportSchemaLine) { Caption = 'Schema Lines'; ApplicationArea = All; SubPageLink = "Schema Code" = field(Code); ShowFilter = false; }
        }
    }
}