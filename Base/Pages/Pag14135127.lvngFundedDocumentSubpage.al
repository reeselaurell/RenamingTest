page 14135127 lvngFundedDocumentSubpage
{
    Caption = 'Funded Document Lines';
    PageType = ListPart;
    SourceTable = lvngLoanDocumentLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account Type"; "Account Type") { ApplicationArea = All; }
                field("Account No."; "Account No.") { ApplicationArea = All; }
                field("Balancing Entry"; "Balancing Entry") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                field("Servicing Type"; "Servicing Type") { ApplicationArea = All; }
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

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LoanDocumentLine: Record lvngLoanDocumentLine;
    begin
        LoanDocumentLine.Reset();
        LoanDocumentLine.SetRange("Transaction Type", "Transaction Type");
        LoanDocumentLine.SetRange("Document No.", "Document No.");
        if LoanDocumentLine.FindLast() then
            "Line No." := LoanDocumentLine."Line No." + 100
        else
            "Line No." := 100;
    end;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}