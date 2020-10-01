page 14135142 lvngJournalDataImport
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
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; }
                field("Account Type"; Rec."Account Type") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
                field("Loan No."; Rec."Loan No.") { ApplicationArea = All; }
                field("Applies-To Doc. No."; Rec."Applies-To Doc. No.") { ApplicationArea = All; }
                field("Applies-To Doc. Type"; Rec."Applies-To Doc. Type") { ApplicationArea = All; }
                field("Bal. Account Type"; Rec."Bal. Account Type") { ApplicationArea = All; }
                field("Bal. Account No."; Rec."Bal. Account No.") { ApplicationArea = All; }
                field("Payment Method Code"; Rec."Payment Method Code") { ApplicationArea = All; }
                field("Posting Group"; Rec."Posting Group") { ApplicationArea = All; }
                field("Depreciation Book Code"; Rec."Depreciation Book Code") { ApplicationArea = All; }
                field("FA Posting Type"; Rec."FA Posting Type") { ApplicationArea = All; }
                field("Recurring Method"; Rec."Recurring Method") { ApplicationArea = All; }
                field("Recurring Frequency"; Rec."Recurring Frequency") { ApplicationArea = All; }
                field("Bank Payment Type"; Rec."Bank Payment Type") { ApplicationArea = All; }
                field(Comment; Rec.Comment) { ApplicationArea = All; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { ApplicationArea = All; }
                field("Business Unit Code"; Rec."Business Unit Code") { ApplicationArea = All; }
                field("Global Dimension 1 Value"; Rec."Global Dimension 1 Value") { ApplicationArea = All; Visible = false; }
                field("Global Dimension 2 Value"; Rec."Global Dimension 2 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 3 Value"; Rec."Shortcut Dimension 3 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 4 Value"; Rec."Shortcut Dimension 4 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 5 Value"; Rec."Shortcut Dimension 5 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 6 Value"; Rec."Shortcut Dimension 6 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 7 Value"; Rec."Shortcut Dimension 7 Value") { ApplicationArea = All; Visible = false; }
                field("Shortcut Dimension 8 Value"; Rec."Shortcut Dimension 8 Value") { ApplicationArea = All; Visible = false; }
                field("Account Value"; Rec."Account Value") { ApplicationArea = All; Visible = false; }
                field("Bal. Account Value"; Rec."Bal. Account Value") { ApplicationArea = All; Visible = false; }
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