page 14135143 "lvngJournalDataImport"
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
            repeater(lvngRepeater)
            {
                field(lvngLineNo; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentType; "Document Type")
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvngExternalDocumentNo; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentDate; "Document Date")
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; "Due Date")
                {
                    ApplicationArea = All;
                }
                field(lvngAccountType; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; "Account No.")
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; Description)
                {
                    ApplicationArea = All;
                }

                field(lvngAmount; Amount)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(lvngAppliesToDocNo; "Applies-To Doc. No.")
                {
                    ApplicationArea = All;
                }
                field(lvngAppliesToDocType; "Applies-To Doc. Type")
                {
                    ApplicationArea = All;
                }
                field(lvngBalAccountType; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field(lvngBalAccountNo; "Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field(lvngPaymentMethodCode; "Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field(lvngPostingGroup; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field(lvngDepreciationBookCode; "Depreciation Book Code")
                {
                    ApplicationArea = All;
                }

                field(lvngFAPostingType; "FA Posting Type")
                {
                    ApplicationArea = All;
                }
                field(lvngRecurringMethod; "Recurring Method")
                {
                    ApplicationArea = All;
                }
                field(lvngRecurringFrequency; "Recurring Frequency")
                {
                    ApplicationArea = All;
                }
                field(lvngBankPaymentType; "Bank Payment Type")
                {
                    ApplicationArea = All;
                }
                field(lvngComment; Comment)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension3Code; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension4Code; "Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension5Code; "Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension6Code; "Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension7Code; "Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension8Code; "Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitCode; "Business Unit Code")
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Value; "Global Dimension 1 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngGlobalDimension2Value; "Global Dimension 2 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension3Value; "Shortcut Dimension 3 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension4Value; "Shortcut Dimension 4 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension5Value; "Shortcut Dimension 5 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension6Value; "Shortcut Dimension 6 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension7Value; "Shortcut Dimension 7 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension8Value; "Shortcut Dimension 8 Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngAccountValue; "Account Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngBalAccountValue; "Bal. Account Value")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(lvngImportBufferErrors; lvngImportBufferErrors)
            {
                Caption = 'Errors';
                ApplicationArea = All;
                SubPageLink = "Line No." = field("Line No.");
            }
        }
    }

    procedure SetParams(var lvngGenJnlImportBuffer: Record lvngGenJnlImportBuffer; var lvngImportBufferError: Record lvngImportBufferError)
    begin
        lvngGenJnlImportBuffer.reset;
        if not lvngGenJnlImportBuffer.FindSet() then
            exit;
        repeat
            Clear(Rec);
            Rec := lvngGenJnlImportBuffer;
            Rec.Insert();
        until lvngGenJnlImportBuffer.Next() = 0;
        CurrPage.lvngImportBufferErrors.Page.SetEntries(lvngImportBufferError);
    end;
}