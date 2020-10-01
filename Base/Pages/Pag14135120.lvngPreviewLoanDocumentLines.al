page 14135120 lvngPreviewLoanDocumentLines
{
    Caption = 'Preview Loan Document Lines';
    PageType = ListPart;
    SourceTable = lvngLoanDocumentLine;
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field("Balancing Entry"; Rec."Balancing Entry") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Code"; Rec."Business Unit Code") { ApplicationArea = All; }
                field("Servicing Type"; Rec."Servicing Type") { ApplicationArea = All; }
                field("Processing Schema Code"; Rec."Processing Schema Code") { ApplicationArea = All; }
                field("Processing Schema Line No."; Rec."Processing Schema Line No.") { ApplicationArea = All; }
            }
        }
    }

    var
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    procedure SetLines(var LoanDocumentLine: Record lvngLoanDocumentLine)
    begin
        LoanDocumentLine.Reset();
        LoanDocumentLine.FindSet();
        repeat
            Clear(Rec);
            Rec := LoanDocumentLine;
            Rec.Insert();
        until LoanDocumentLine.Next() = 0;
    end;
}