pageextension 14135101 lvngGLEntry extends "General Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code") { Visible = true; }
        modify("Global Dimension 2 Code") { Visible = true; }

        addlast(Control1)
        {
            field(lvngShortcutDimension3Code; Rec.lvngShortcutDimension3Code) { ApplicationArea = All; }
            field(lvngShortcutDimension4Code; Rec.lvngShortcutDimension4Code) { ApplicationArea = All; }
            field(lvngShortcutDimension5Code; Rec.lvngShortcutDimension5Code) { ApplicationArea = All; }
            field(lvngShortcutDimension6Code; Rec.lvngShortcutDimension6Code) { ApplicationArea = All; }
            field(lvngShortcutDimension7Code; Rec.lvngShortcutDimension7Code) { ApplicationArea = All; }
            field(lvngShortcutDimension8Code; Rec.lvngShortcutDimension8Code) { ApplicationArea = All; }
            field(lvngLoanNo; Rec.lvngLoanNo) { ApplicationArea = All; }
            field(lvngServicingType; Rec.lvngServicingType) { ApplicationArea = All; }
            field(lvngBorrowerSearchName; Rec.lvngBorrowerSearchName) { ApplicationArea = All; }
            field(lvngEntryDate; Rec.lvngEntryDate) { ApplicationArea = All; }
            field(lvngVoided; Rec.lvngVoided) { ApplicationArea = All; }
        }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvngDocumentGuid);
    end;
}