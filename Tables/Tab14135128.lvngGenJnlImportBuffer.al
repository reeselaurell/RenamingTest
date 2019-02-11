table 14135128 "lvngGenJnlImportBuffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(10; lvngAccountType; enum lvngGenJnlAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }

        field(11; lvngAccountNo; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }

        field(12; lvngDocumentType; Enum lvngGenJnlImportDocumentType)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(13; lvngDocumentNo; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(14; lvngExternalDocumentNo; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(15; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(16; lvngComment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(17; lvngBalAccountType; enum lvngGenJnlAccountType)
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(18; lvngBalAccountNo; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = CustomerContent;
        }
        field(19; lvngReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
        }
        field(20; lvngPostingGroup; Code[20])
        {
            Caption = 'Posting Group';
            DataClassification = CustomerContent;
        }
        field(21; lvngAmount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(22; lvngAppliesToDocType; Enum lvngGenJnlImportDocumentType)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = CustomerContent;
        }
        field(23; lvngAppliesToDocNo; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = CustomerContent;
        }
        field(24; lvngPaymentMethodCode; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
        }
        field(25; lvngPostingDate; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(26; lvngDocumentDate; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(27; lvngDueDate; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(28; lvngRecurringMethod; enum lvngRecurringMethod)
        {
            Caption = 'Recurring Method';
            DataClassification = CustomerContent;
        }
        field(29; lvngRecurringFrequency; DateFormula)
        {
            Caption = 'Recurring Frequency';
            DataClassification = CustomerContent;
        }
        field(30; lvngBankPaymentType; enum lvngBankPaymentType)
        {
            Caption = 'Bank Payment Type';
            DataClassification = CustomerContent;
        }
        field(31; lvngDepreciationBookCode; Code[10])
        {
            Caption = 'Depreciation Book Code';
            DataClassification = CustomerContent;
        }
        field(32; lvngFAPostingType; Enum lvngFAPostingType)
        {
            Caption = 'FA Posting Type';
            DataClassification = CustomerContent;
        }
        field(80; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
        }

        field(88; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
        }

        field(14135100; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngLineNo)
        {
            Clustered = true;
        }
    }

    procedure A()
    begin

    end;

}