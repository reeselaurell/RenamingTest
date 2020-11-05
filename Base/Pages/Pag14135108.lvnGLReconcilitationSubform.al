page 14135108 "lvnGLReconcilitationSubform"
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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension3Code; Rec.lvnShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension4Code; Rec.lvnShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension5Code; Rec.lvnShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension6Code; Rec.lvnShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension7Code; Rec.lvnShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvnShortcutDimension8Code; Rec.lvnShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }
                field(lvnSourceName; Rec.lvnSourceName)
                {
                    ApplicationArea = All;
                }
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
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
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
                    Rec.ShowDimensions();
                    CurrPage.SaveRecord();
                end;
            }
        }
    }
}