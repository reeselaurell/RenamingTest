page 14135257 lvngSalesInvoiceImportSubform
{
    Caption = 'Sales Invoice Import Lines';
    PageType = ListPart;
    SourceTable = lvngSalesInvLineBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Description 2"; Rec."Description 2") { ApplicationArea = All; }
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
                // field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            }
        }
    }

    procedure SetSubform(var pSalesInvLineBuffer: Record lvngSalesInvLineBuffer)
    begin
        if pSalesInvLineBuffer.FindSet() then begin
            Rec.Reset();
            Rec.DeleteAll();
            repeat
                Rec := pSalesInvLineBuffer;
                Rec.Insert();
            until pSalesInvLineBuffer.Next() = 0;
        end
    end;

    procedure UpdateLines(var pSalesInvLineBuffer: Record lvngSalesInvLineBuffer)
    begin
        Rec.Reset();
        pSalesInvLineBuffer.Reset();
        pSalesInvLineBuffer.DeleteAll();
        if Rec.FindSet() then
            repeat
                pSalesInvLineBuffer := Rec;
                pSalesInvLineBuffer.Insert();
            until Rec.Next() = 0;
    end;
}