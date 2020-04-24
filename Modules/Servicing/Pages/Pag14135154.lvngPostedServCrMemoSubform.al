page 14135154 lvngPostedServCrMemoSubform
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = lvngServiceLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account No."; "Account No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Servicing Type"; "Servicing Type") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; Visible = DimensionVisible1; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; Visible = DimensionVisible2; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; Visible = DimensionVisible3; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; Visible = DimensionVisible4; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; Visible = DimensionVisible5; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; Visible = DimensionVisible6; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; Visible = DimensionVisible7; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; Visible = DimensionVisible8; }
                field("Line No."; "Line No.") { ApplicationArea = All; }
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
        ServiceLine: Record lvngServiceLine;
    begin
        ServiceLine.Reset();
        ServiceLine.SetRange("Servicing Document Type", "Servicing Document Type");
        ServiceLine.SetRange("Document No.", "Document No.");
        if ServiceLine.FindLast() then
            "Line No." := ServiceLine."Line No.";
        "Line No." := "Line No." + 100;
    end;

    trigger OnOpenPage()
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;
}