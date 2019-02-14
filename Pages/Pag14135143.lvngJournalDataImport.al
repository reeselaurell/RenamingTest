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
                field(lvngLineNo; lvngLineNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentType; lvngDocumentType)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentNo; lvngDocumentNo)
                {
                    ApplicationArea = All;
                }
                field(lvngExternalDocumentNo; lvngExternalDocumentNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDocumentDate; lvngDocumentDate)
                {
                    ApplicationArea = All;
                }
                field(lvngPostingDate; lvngPostingDate)
                {
                    ApplicationArea = All;
                }
                field(lvngDueDate; lvngDueDate)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountType; lvngAccountType)
                {
                    ApplicationArea = All;
                }
                field(lvngAccountNo; lvngAccountNo)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }

                field(lvngAmount; lvngAmount)
                {
                    ApplicationArea = All;
                }
                field(lvngReasonCode; lvngReasonCode)
                {
                    ApplicationArea = All;
                }
                field(lvngLoanNo; lvngLoanNo)
                {
                    ApplicationArea = All;
                }
                field(lvngAppliesToDocNo; lvngAppliesToDocNo)
                {
                    ApplicationArea = All;
                }
                field(lvngAppliesToDocType; lvngAppliesToDocType)
                {
                    ApplicationArea = All;
                }
                field(lvngBalAccountType; lvngBalAccountType)
                {
                    ApplicationArea = All;
                }
                field(lvngBalAccountNo; lvngBalAccountNo)
                {
                    ApplicationArea = All;
                }
                field(lvngPaymentMethodCode; lvngPaymentMethodCode)
                {
                    ApplicationArea = All;
                }
                field(lvngPostingGroup; lvngPostingGroup)
                {
                    ApplicationArea = All;
                }
                field(lvngDepreciationBookCode; lvngDepreciationBookCode)
                {
                    ApplicationArea = All;
                }

                field(lvngFAPostingType; lvngFAPostingType)
                {
                    ApplicationArea = All;
                }
                field(lvngRecurringMethod; lvngRecurringMethod)
                {
                    ApplicationArea = All;
                }
                field(lvngRecurringFrequency; lvngRecurringFrequency)
                {
                    ApplicationArea = All;
                }
                field(lvngBankPaymentType; lvngBankPaymentType)
                {
                    ApplicationArea = All;
                }
                field(lvngComment; lvngComment)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Code; lvngGlobalDimension1Code)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension2Code; lvngGlobalDimension2Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension3Code; lvngShortcutDimension3Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension4Code; lvngShortcutDimension4Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension5Code; lvngShortcutDimension5Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension6Code; lvngShortcutDimension6Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension7Code; lvngShortcutDimension7Code)
                {
                    ApplicationArea = All;
                }
                field(lvngShortcutDimension8Code; lvngShortcutDimension8Code)
                {
                    ApplicationArea = All;
                }
                field(lvngBusinessUnitCode; lvngBusinessUnitCode)
                {
                    ApplicationArea = All;
                }
                field(lvngGlobalDimension1Value; lvngGlobalDimension1Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngGlobalDimension2Value; lvngGlobalDimension2Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension3Value; lvngShortcutDimension3Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension4Value; lvngShortcutDimension4Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension5Value; lvngShortcutDimension5Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension6Value; lvngShortcutDimension6Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension7Value; lvngShortcutDimension7Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngShortcutDimension8Value; lvngShortcutDimension8Value)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngAccountValue; lvngAccountValue)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(lvngBalAccountValue; lvngBalAccountValue)
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
                SubPageLink = lvngLineNo = field (lvngLineNo);
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