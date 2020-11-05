page 14135182 "lvnServicedDocumentSubpage"
{
    Caption = 'Serviced Document Lines';
    PageType = ListPart;
    SourceTable = lvnLoanDocumentLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account No."; Rec."Account No.")
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
                    Visible = DimensionVisible1;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible2;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible3;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible4;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible5;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible6;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible7;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = DimensionVisible8;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Servicing Type"; Rec."Servicing Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LoanDocumentLine: Record lvnLoanDocumentLine;
    begin
        Rec."Account Type" := Rec."Account Type"::"G/L Account";
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Transaction Type", Rec."Transaction Type");
        LoanDocumentLine.SetRange("Document No.", Rec."Document No.");
        if LoanDocumentLine.FindLast() then
            Rec."Line No." := LoanDocumentLine."Line No." + 100
        else
            Rec."Line No." := 100;
        if (LoanDocument."Transaction Type" <> Rec."Transaction Type") or (LoanDocument."Document No." <> Rec."Document No.") then begin
            LoanDocument.Get(Rec."Transaction Type", Rec."Document No.");
            Rec."Reason Code" := LoanDocument."Reason Code";
        end;
    end;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    var
        LoanDocument: Record lvnLoanDocument;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}