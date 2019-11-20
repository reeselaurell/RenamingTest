page 14135143 lvngJournalDataImport
{
    PageType = List;
    SourceTable = lvngGenJnlImportBuffer;
    Caption = 'Journal Data Import';
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; }
                field("Document Type"; "Document Type") { ApplicationArea = All; }
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field("External Document No."; "External Document No.") { ApplicationArea = All; }
                field("Document Date"; "Document Date") { ApplicationArea = All; }
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("Due Date"; "Due Date") { ApplicationArea = All; }
                field("Account Type"; "Account Type") { ApplicationArea = All; }
                field("Account No."; "Account No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; }
                field("Loan No."; "Loan No.") { ApplicationArea = All; }
                field("Applies-To Doc. No."; "Applies-To Doc. No.") { ApplicationArea = All; }
                field("Applies-To Doc. Type"; "Applies-To Doc. Type") { ApplicationArea = All; }
                field("Bal. Account Type"; "Bal. Account Type") { ApplicationArea = All; }
                field("Bal. Account No."; "Bal. Account No.") { ApplicationArea = All; }
                field("Payment Method Code"; "Payment Method Code") { ApplicationArea = All; }
                field("Posting Group"; "Posting Group") { ApplicationArea = All; }
                field("Depreciation Book Code"; "Depreciation Book Code") { ApplicationArea = All; }
                field("FA Posting Type"; "FA Posting Type") { ApplicationArea = All; }
                field("Recurring Method"; "Recurring Method") { ApplicationArea = All; }
                field("Recurring Frequency"; "Recurring Frequency") { ApplicationArea = All; }
                field("Bank Payment Type"; "Bank Payment Type") { ApplicationArea = All; }
                field(Comment; Comment) { ApplicationArea = All; }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 6 Code"; "Shortcut Dimension 6 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 7 Code"; "Shortcut Dimension 7 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 8 Code"; "Shortcut Dimension 8 Code") { ApplicationArea = All; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Value"; "Global Dimension 1 Value") { ApplicationArea = All; Visible = false; }
                field("Global Dimension 2 Value"; "Global Dimension 2 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 3 Value"; "Shortcut Dimension 3 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 4 Value"; "Shortcut Dimension 4 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 5 Value"; "Shortcut Dimension 5 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 6 Value"; "Shortcut Dimension 6 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 7 Value"; "Shortcut Dimension 7 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 8 Value"; "Shortcut Dimension 8 Value") { ApplicationArea = All; Visible = false; }
                field("Account Value"; "Account Value") { ApplicationArea = All; Visible = false; }
                field("Bal. Account Value"; "Bal. Account Value") { ApplicationArea = All; Visible = false; }
            }
        }

        area(FactBoxes)
        {
            part(ImportBufferErrors; lvngImportBufferErrors)
            {
                Caption = 'Errors';
                ApplicationArea = All;
                SubPageLink = "Line No." = field("Line No.");
            }
        }
    }

    procedure SetParams(var GenJnlImportBuffer: Record lvngGenJnlImportBuffer; var ImportBufferError: Record lvngImportBufferError)
    begin
        GenJnlImportBuffer.Reset();
        if not GenJnlImportBuffer.FindSet() then
            exit;
        repeat
            Clear(Rec);
            Rec := GenJnlImportBuffer;
            Rec.Insert();
        until GenJnlImportBuffer.Next() = 0;
        CurrPage.ImportBufferErrors.Page.SetEntries(ImportBufferError);
    end;
}