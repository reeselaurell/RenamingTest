pageextension 14135101 "lvnGLEntry" extends "General Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Global Dimension 2 Code")
        {
            Visible = true;
        }
        addlast(Control1)
        {
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
            field(lvnLoanNo; Rec.lvnLoanNo)
            {
                ApplicationArea = All;
            }
            field(lvnServicingType; Rec.lvnServicingType)
            {
                ApplicationArea = All;
            }
            field(lvnBorrowerSearchName; Rec.lvnBorrowerSearchName)
            {
                ApplicationArea = All;
            }
            field(lvnEntryDate; Rec.lvnEntryDate)
            {
                ApplicationArea = All;
            }
            field(lvnVoided; Rec.lvnVoided)
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvnDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvnDocumentGuid);
    end;
}