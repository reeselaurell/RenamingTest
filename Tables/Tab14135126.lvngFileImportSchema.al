table 14135126 "lvngFileImportSchema"
{
    DataClassification = CustomerContent;
    Caption = 'File Import Schema';
    LookupPageId = lvngFileImportSchemas;

    fields
    {
        field(1; lvngCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(5; lvngFileImportType; Enum lvngFileImportType)
        {
            Caption = 'Import Type';
            DataClassification = CustomerContent;
        }
        field(10; lvngDescription; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; lvngFieldSeparator; Text[10])
        {
            Caption = 'Field Separator';
            DataClassification = CustomerContent;
        }
        field(12; lvngSkipRows; Integer)
        {
            Caption = 'Skip Rows';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(13; lvngReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            DataClassification = CustomerContent;
        }
        field(14; lvngPostingGroup; Code[10])
        {
            Caption = 'Posting Group';
            DataClassification = CustomerContent;

        }

        field(20; lvngDimension1MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 1 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(21; lvngDimension2MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 2 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(22; lvngDimension3MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 3 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(23; lvngDimension4MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 4 Mapping Type';
        }
        field(24; lvngDimension5MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 5 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(25; lvngDimension6MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 6 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(26; lvngDimension7MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 7 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(27; lvngDimension8MappingType; enum lvngDimensionMappingType)
        {
            Caption = 'Dimension 8 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(30; lvngDimension1Mandatory; Boolean)
        {
            Caption = 'Dimension 1 Mandatory';
            DataClassification = CustomerContent;
        }
        field(31; lvngDimension2Mandatory; Boolean)
        {
            Caption = 'Dimension 2 Mandatory';
            DataClassification = CustomerContent;
        }
        field(32; lvngDimension3Mandatory; Boolean)
        {
            Caption = 'Dimension 3 Mandatory';
            DataClassification = CustomerContent;
        }
        field(33; lvngDimension4Mandatory; Boolean)
        {
            Caption = 'Dimension 4 Mandatory';
            DataClassification = CustomerContent;
        }
        field(34; lvngDimension5Mandatory; Boolean)
        {
            Caption = 'Dimension 5 Mandatory';
            DataClassification = CustomerContent;
        }
        field(35; lvngDimension6Mandatory; Boolean)
        {
            Caption = 'Dimension 6 Mandatory';
            DataClassification = CustomerContent;
        }
        field(36; lvngDimension7Mandatory; Boolean)
        {
            Caption = 'Dimension 7 Mandatory';
            DataClassification = CustomerContent;
        }
        field(37; lvngDimension8Mandatory; Boolean)
        {
            Caption = 'Dimension 8 Mandatory';
            DataClassification = CustomerContent;
        }
        field(40; lvngDefaultDimension1Code; Code[20])
        {
            Caption = 'Default Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (1));
            DataClassification = CustomerContent;
        }
        field(41; lvngDefaultDimension2Code; Code[20])
        {
            Caption = 'Default Dimension 2 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (2));
            DataClassification = CustomerContent;
        }
        field(42; lvngDefaultDimension3Code; Code[20])
        {
            Caption = 'Default Dimension 3 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (3));
            DataClassification = CustomerContent;
        }
        field(43; lvngDefaultDimension4Code; Code[20])
        {
            Caption = 'Default Dimension 4 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (4));
            DataClassification = CustomerContent;
        }
        field(44; lvngDefaultDimension5Code; Code[20])
        {
            Caption = 'Default Dimension 5 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (5));
            DataClassification = CustomerContent;
        }
        field(45; lvngDefaultDimension6Code; Code[20])
        {
            Caption = 'Default Dimension 6 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (6));
            DataClassification = CustomerContent;
        }
        field(46; lvngDefaultDimension7Code; Code[20])
        {
            Caption = 'Default Dimension 7 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (7));
            DataClassification = CustomerContent;
        }
        field(47; lvngDefaultDimension8Code; Code[20])
        {
            Caption = 'Default Dimension 8 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = Const (8));
            DataClassification = CustomerContent;
        }
        field(50; lvngDimensionValidationRule; enum lvngDimensionValidationRule)
        {
            Caption = 'Dimensions Validation Rule';
            DataClassification = CustomerContent;
        }

        field(100; lvngGenJnlAccountType; Enum lvngGenJnlAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(101; lvngAccountMappingType; Enum lvngAccountMappingType)
        {
            Caption = 'Account Mapping Type';
            DataClassification = CustomerContent;
        }
        field(102; lvngDefaultAccountNo; Code[20])
        {
            Caption = 'Default Account No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAccount: Record "Bank Account";
                FixedAsset: Record "Fixed Asset";
                GLAccount: Record "G/L Account";
                ICPartner: Record "IC Partner";
            begin
                case lvngGenJnlAccountType of
                    lvngGenJnlAccountType::"Bank Account":
                        begin
                            if page.RunModal(0, BankAccount) = Action::LookupOK then begin
                                lvngDefaultAccountNo := BankAccount."No.";
                            end;
                        end;
                    lvngGenJnlAccountType::Customer:
                        begin
                            if Page.RunModal(0, Customer) = Action::LookupOK then begin
                                lvngDefaultAccountNo := Customer."No.";
                            end;
                        end;
                    lvngGenJnlAccountType::"Fixed Asset":
                        begin
                            if Page.RunModal(0, FixedAsset) = Action::LookupOK then begin
                                lvngDefaultAccountNo := FixedAsset."No.";
                            end;
                        end;
                    lvngGenJnlAccountType::"G/L Account":
                        begin
                            GLAccount.reset;
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            if Page.RunModal(0, GLAccount) = Action::LookupOK then begin
                                lvngDefaultAccountNo := GLAccount."No.";
                            end;
                        end;
                    lvngGenJnlAccountType::"IC Partner":
                        begin
                            if Page.RunModal(0, ICPartner) = Action::LookupOK then begin
                                lvngDefaultAccountNo := ICPartner.Code;
                            end;
                        end;
                    lvngGenJnlAccountType::Vendor:
                        begin
                            if Page.RunModal(0, Vendor) = Action::LookupOK then begin
                                lvngDefaultAccountNo := Vendor."No.";
                            end;
                        end;
                end;
            end;
        }
        field(103; lvngSubsGLWithBankAcc; Boolean)
        {
            Caption = 'Substitute G/L Account with Bank Account';
            DataClassification = CustomerContent;
        }
        field(104; lvngUseBalAccount; Boolean)
        {
            Caption = 'Use Balancing Account';
            DataClassification = CustomerContent;
        }
        field(105; lvngGenJnlBalAccountType; Enum lvngGenJnlAccountType)
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(106; lvngBalAccountMappingType; Enum lvngAccountMappingType)
        {
            Caption = 'Bal. Account Mapping Type';
            DataClassification = CustomerContent;
        }
        field(107; lvngDefaultBalAccountNo; Code[20])
        {
            Caption = 'Bal. Default Account No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAccount: Record "Bank Account";
                FixedAsset: Record "Fixed Asset";
                GLAccount: Record "G/L Account";
                ICPartner: Record "IC Partner";
            begin
                case lvngGenJnlBalAccountType of
                    lvngGenJnlBalAccountType::"Bank Account":
                        begin
                            if page.RunModal(0, BankAccount) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := BankAccount."No.";
                            end;
                        end;
                    lvngGenJnlBalAccountType::Customer:
                        begin
                            if Page.RunModal(0, Customer) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := Customer."No.";
                            end;
                        end;
                    lvngGenJnlBalAccountType::"Fixed Asset":
                        begin
                            if Page.RunModal(0, FixedAsset) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := FixedAsset."No.";
                            end;
                        end;
                    lvngGenJnlBalAccountType::"G/L Account":
                        begin
                            GLAccount.reset;
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            if Page.RunModal(0, GLAccount) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := GLAccount."No.";
                            end;
                        end;
                    lvngGenJnlBalAccountType::"IC Partner":
                        begin
                            if Page.RunModal(0, ICPartner) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := ICPartner.Code;
                            end;
                        end;
                    lvngGenJnlBalAccountType::Vendor:
                        begin
                            if Page.RunModal(0, Vendor) = Action::LookupOK then begin
                                lvngDefaultBalAccountNo := Vendor."No.";
                            end;
                        end;
                end;
            end;
        }
        field(108; lvngReverseAmountSign; Boolean)
        {
            Caption = 'Reverse Amount Sign';
            DataClassification = CustomerContent;
        }

        field(109; lvngDocumentType; Enum lvngGenJnlImportDocumentType)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(110; lvngDocumentTypeOption; enum lvngDocumentTypeOption)
        {
            Caption = 'Document Type Option';
            DataClassification = CustomerContent;

        }
        field(111; lvngDocumentNoSeries; Code[10])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(112; lvngDocumentNoFilling; enum lvngGenJnlDocumentNoFilling)
        {
            Caption = 'Document No. Filling';
            DataClassification = CustomerContent;
        }
        field(113; lvngDocumentNoPrefix; Code[10])
        {
            Caption = 'Document No. Prefix';
            DataClassification = CustomerContent;
        }
        field(114; lvngUseSingleDocumentNo; Boolean)
        {
            Caption = 'Use Single Document No.';
            DataClassification = CustomerContent;
        }
        field(115; lvngLoanNoValidationRule; Enum lvngLoanNoValidationRule)
        {
            Caption = 'Loan No. Validation Rule';
            DataClassification = CustomerContent;
        }
        field(116; lvngAppliesToDocType; enum lvngGenJnlImportDocumentType)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = CustomerContent;
        }
        field(117; lvngBankPaymentType; Enum lvngBankPaymentType)
        {
            Caption = 'Bank Payment Type';
            DataClassification = CustomerContent;
        }
        field(118; lvngRecurringMethod; enum lvngRecurringMethod)
        {
            Caption = 'Recurring Method';
            DataClassification = CustomerContent;
        }
        field(119; lvngRecurringFrequency; DateFormula)
        {
            Caption = 'Recurring Frequency';
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(PK; lvngCode)
        {
            Clustered = true;
        }
    }

}