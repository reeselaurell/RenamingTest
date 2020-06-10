page 14135252 lvngPurchInvoiceImportSubform
{
    Caption = 'Purchase Invoice Import Lines';
    PageType = ListPart;
    SourceTable = lvngPurchInvLineBuffer;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; Style = Attention; StyleExpr = ErrorStyle; }
                field(Type; Type) { ApplicationArea = All; }
                field("No."; "No.") { ApplicationArea = All; }
                field("Direct Unit Cost"; "Direct Unit Cost") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field("Description 2"; "Description 2") { ApplicationArea = All; }
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1)); }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2)); }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
                // field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
            }
        }
    }

    var
        [InDataSet]
        ErrorStyle: Boolean;

    trigger OnModifyRecord(): Boolean
    var
        PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
        PurchInvError: Record lvngInvoiceErrorDetail;
    begin
        PurchInvError.Reset();
        PurchInvError.DeleteAll();
        PurchInvImportMgmt.ValidateLineEntries();
    end;

    trigger OnAfterGetRecord()
    var
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        ErrorStyle := false;
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.SetRange("Header Error", false);
        InvoiceErrorDetail.SetRange("Document No.", "Document No.");
        InvoiceErrorDetail.SetRange("Line No.", "Line No.");
        if InvoiceErrorDetail.FindSet() then
            ErrorStyle := true
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchInvImportMgmt: Codeunit lvngPurchInvoiceImportMgmt;
        InvoiceErrorDetail: Record lvngInvoiceErrorDetail;
    begin
        InvoiceErrorDetail.Reset();
        InvoiceErrorDetail.DeleteAll();
        PurchInvImportMgmt.ValidateHeaderEntries();
        PurchInvImportMgmt.ValidateLineEntries();
        CurrPage.Update(false);
    end;
}