page 14135184 lvngFlexibleImportSchemaCard
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

                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Skip Rows"; Rec."Skip Rows") { ApplicationArea = All; }
                field("Field Separator Character"; Rec."Field Separator Character") { ApplicationArea = All; }
                field("Field Delimiter Character"; Rec."Field Delimiter Character") { ApplicationArea = All; }
                field("Document Type Column No."; Rec."Document Type Column No.") { ApplicationArea = All; }
                field("Use Document No. From Series"; Rec."Use Document No. From Series") { ApplicationArea = All; }
                field("Document No. Column No."; Rec."Document No. Column No.") { ApplicationArea = All; }
                field("Document No. Prefix"; Rec."Document No. Prefix") { ApplicationArea = All; }
                field("Loan No. Prefix"; Rec."Loan No. Prefix") { ApplicationArea = All; }
                field("Default Reason Code"; Rec."Default Reason Code") { ApplicationArea = All; }
                field("Loan No. Column No."; Rec."Loan No. Column No.") { ApplicationArea = All; }
                field("Posting Date Column No."; Rec."Posting Date Column No.") { ApplicationArea = All; }
                field("Document Date Column No."; Rec."Document Date Column No.") { ApplicationArea = All; }
                field("Comment Column No."; Rec."Comment Column No.") { ApplicationArea = All; }
                field("External Document Column No."; Rec."External Document Column No.") { ApplicationArea = All; Caption = 'External Document No. Column No.'; }
                field("Dimension 1 Code Column No."; Rec."Dimension 1 Code Column No.") { ApplicationArea = All; }
                field("Dimension 2 Code Column No."; Rec."Dimension 2 Code Column No.") { ApplicationArea = All; }
                field("Dimension 3 Code Column No."; Rec."Dimension 3 Code Column No.") { ApplicationArea = All; }
                field("Dimension 4 Code Column No."; Rec."Dimension 4 Code Column No.") { ApplicationArea = All; }
                field("Dimension 5 Code Column No."; Rec."Dimension 5 Code Column No.") { ApplicationArea = All; }
                field("Dimension 6 Code Column No."; Rec."Dimension 6 Code Column No.") { ApplicationArea = All; }
                field("Dimension 7 Code Column No."; Rec."Dimension 7 Code Column No.") { ApplicationArea = All; }
                field("Dimension 8 Code Column No."; Rec."Dimension 8 Code Column No.") { ApplicationArea = All; }
            }
            part(SchemaLine; lvngFlexibleImportSchemaLine) { Caption = 'Schema Lines'; ApplicationArea = All; SubPageLink = "Schema Code" = field(Code); ShowFilter = false; }
        }
    }
}