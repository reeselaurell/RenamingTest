page 14135109 lvngGLReconcilitationSubform
{
    PageType = ListPart;
    SourceTable = "G/L Entry";
    Caption = 'G/L Reconciliation Subform';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Document Type"; "Document Type") { ApplicationArea = All; }
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field("Debit Amount"; "Debit Amount") { ApplicationArea = All; }
                field("Credit Amount"; "Credit Amount") { ApplicationArea = All; }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code) { ApplicationArea = All; }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code) { ApplicationArea = All; }
                field(lvngShortcutDimension5Code; lvngShortcutDimension5Code) { ApplicationArea = All; }
                field(lvngShortcutDimension6Code; lvngShortcutDimension6Code) { ApplicationArea = All; }
                field(lvngShortcutDimension7Code; lvngShortcutDimension7Code) { ApplicationArea = All; }
                field(lvngShortcutDimension8Code; lvngShortcutDimension8Code) { ApplicationArea = All; }
                field(lvngSourceName; lvngSourceName) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Navigate)
            {
                Caption = 'Navigate';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: page Navigate;
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.Run();
                end;
            }

            action(Dimensions)
            {
                Caption = 'Dimensions';
                ApplicationArea = All;
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDimensions();
                    CurrPage.SaveRecord();
                end;
            }
        }
    }
}