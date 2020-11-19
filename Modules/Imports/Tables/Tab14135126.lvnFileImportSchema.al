table 14135126 "lvnFileImportSchema"
{
    DataClassification = CustomerContent;
    Caption = 'File Import Schema';
    LookupPageId = lvnFileImportSchemas;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(5; "File Import Type"; Enum lvnFileImportType)
        {
            Caption = 'Import Type';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Field Separator"; Text[10])
        {
            Caption = 'Field Separator';
            DataClassification = CustomerContent;
        }
        field(12; "Skip Rows"; Integer)
        {
            Caption = 'Skip Rows';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(13; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
            DataClassification = CustomerContent;
        }
        field(14; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            DataClassification = CustomerContent;
        }
        field(15; "Use Dimension Hierarchy"; Boolean)
        {
            Caption = 'Use Dimension Hierarchy';
            DataClassification = CustomerContent;
        }
        field(20; "Dimension 1 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 1 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(21; "Dimension 2 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 2 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(22; "Dimension 3 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 3 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(23; "Dimension 4 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 4 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(24; "Dimension 5 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 5 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(25; "Dimension 6 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 6 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(26; "Dimension 7 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 7 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(27; "Dimension 8 Mapping Type"; enum lvnDimensionMappingType)
        {
            Caption = 'Dimension 8 Mapping Type';
            DataClassification = CustomerContent;
        }
        field(30; "Dimension 1 Mandatory"; Boolean)
        {
            Caption = 'Dimension 1 Mandatory';
            DataClassification = CustomerContent;
        }
        field(31; "Dimension 2 Mandatory"; Boolean)
        {
            Caption = 'Dimension 2 Mandatory';
            DataClassification = CustomerContent;
        }
        field(32; "Dimension 3 Mandatory"; Boolean)
        {
            Caption = 'Dimension 3 Mandatory';
            DataClassification = CustomerContent;
        }
        field(33; "Dimension 4 Mandatory"; Boolean)
        {
            Caption = 'Dimension 4 Mandatory';
            DataClassification = CustomerContent;
        }
        field(34; "Dimension 5 Mandatory"; Boolean)
        {
            Caption = 'Dimension 5 Mandatory';
            DataClassification = CustomerContent;
        }
        field(35; "Dimension 6 Mandatory"; Boolean)
        {
            Caption = 'Dimension 6 Mandatory';
            DataClassification = CustomerContent;
        }
        field(36; "Dimension 7 Mandatory"; Boolean)
        {
            Caption = 'Dimension 7 Mandatory';
            DataClassification = CustomerContent;
        }
        field(37; "Dimension 8 Mandatory"; Boolean)
        {
            Caption = 'Dimension 8 Mandatory';
            DataClassification = CustomerContent;
        }
        field(40; "Default Dimension 1 Code"; Code[20])
        {
            Caption = 'Default Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(41; "Default Dimension 2 Code"; Code[20])
        {
            Caption = 'Default Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(42; "Default Dimension 3 Code"; Code[20])
        {
            Caption = 'Default Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
        }
        field(43; "Default Dimension 4 Code"; Code[20])
        {
            Caption = 'Default Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
        }
        field(44; "Default Dimension 5 Code"; Code[20])
        {
            Caption = 'Default Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = CustomerContent;
        }
        field(45; "Default Dimension 6 Code"; Code[20])
        {
            Caption = 'Default Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = CustomerContent;
        }
        field(46; "Default Dimension 7 Code"; Code[20])
        {
            Caption = 'Default Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
        }
        field(47; "Default Dimension 8 Code"; Code[20])
        {
            Caption = 'Default Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = CustomerContent;
        }
        field(50; "Dimension Validation Rule"; enum lvnDimensionValidationRule)
        {
            Caption = 'Dimension Validation Rule';
            DataClassification = CustomerContent;
        }
        field(100; "Gen. Jnl. Account Type"; Enum lvnGenJnlAccountType)
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(101; "Account Mapping Type"; Enum lvnAccountMappingType)
        {
            Caption = 'Account Mapping Type';
            DataClassification = CustomerContent;
        }
        field(102; "Default Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Account No.';

            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAccount: Record "Bank Account";
                FixedAsset: Record "Fixed Asset";
                GLAccount: Record "G/L Account";
                ICPartner: Record "IC Partner";
            begin
                case "Gen. Jnl. Account Type" of
                    "Gen. Jnl. Account Type"::"Bank Account":
                        if Page.RunModal(0, BankAccount) = Action::LookupOK then
                            "Default Account No." := BankAccount."No.";
                    "Gen. Jnl. Account Type"::Customer:
                        if Page.RunModal(0, Customer) = Action::LookupOK then
                            "Default Account No." := Customer."No.";
                    "Gen. Jnl. Account Type"::"Fixed Asset":
                        if Page.RunModal(0, FixedAsset) = Action::LookupOK then
                            "Default Account No." := FixedAsset."No.";
                    "Gen. Jnl. Account Type"::"G/L Account":
                        begin
                            GLAccount.Reset;
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            if Page.RunModal(0, GLAccount) = Action::LookupOK then
                                "Default Account No." := GLAccount."No.";
                        end;
                    "Gen. Jnl. Account Type"::"IC Partner":
                        if Page.RunModal(0, ICPartner) = Action::LookupOK then
                            "Default Account No." := ICPartner.Code;
                    "Gen. Jnl. Account Type"::Vendor:
                        if Page.RunModal(0, Vendor) = Action::LookupOK then
                            "Default Account No." := Vendor."No.";
                end;
            end;
        }
        field(103; "Subs. G/L With Bank Acc."; Boolean)
        {
            Caption = 'Substitute G/L Account with Bank Account';
            DataClassification = CustomerContent;
        }
        field(104; "Use Bal. Account"; Boolean)
        {
            Caption = 'Use Balancing Account';
            DataClassification = CustomerContent;
        }
        field(105; "Gen. Jnl. Bal. Account Type"; Enum lvnGenJnlAccountType)
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(106; "Bal. Account Mapping Type"; Enum lvnAccountMappingType)
        {
            Caption = 'Bal. Account Mapping Type';
            DataClassification = CustomerContent;
        }
        field(107; "Default Bal. Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Bal. Account No.';

            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                BankAccount: Record "Bank Account";
                FixedAsset: Record "Fixed Asset";
                GLAccount: Record "G/L Account";
                ICPartner: Record "IC Partner";
            begin
                case "Gen. Jnl. Bal. Account Type" of
                    "Gen. Jnl. Bal. Account Type"::"Bank Account":
                        if Page.RunModal(0, BankAccount) = Action::LookupOK then
                            "Default Bal. Account No." := BankAccount."No.";
                    "Gen. Jnl. Bal. Account Type"::Customer:
                        if Page.RunModal(0, Customer) = Action::LookupOK then
                            "Default Bal. Account No." := Customer."No.";
                    "Gen. Jnl. Bal. Account Type"::"Fixed Asset":
                        if Page.RunModal(0, FixedAsset) = Action::LookupOK then
                            "Default Bal. Account No." := FixedAsset."No.";
                    "Gen. Jnl. Bal. Account Type"::"G/L Account":
                        begin
                            GLAccount.Reset();
                            GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                            if Page.RunModal(0, GLAccount) = Action::LookupOK then
                                "Default Bal. Account No." := GLAccount."No.";
                        end;
                    "Gen. Jnl. Bal. Account Type"::"IC Partner":
                        if Page.RunModal(0, ICPartner) = Action::LookupOK then
                            "Default Bal. Account No." := ICPartner.Code;
                    "Gen. Jnl. Bal. Account Type"::Vendor:
                        if Page.RunModal(0, Vendor) = Action::LookupOK then
                            "Default Bal. Account No." := Vendor."No.";
                end;
            end;
        }
        field(108; "Reverse Amount Sign"; Boolean)
        {
            Caption = 'Reverse Amount Sign';
            DataClassification = CustomerContent;
        }
        field(109; "Document Type"; Enum lvnGenJnlImportDocumentType)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(110; "Document Type Option"; enum lvnImportDocumentTypeOption)
        {
            Caption = 'Document Type Option';
            DataClassification = CustomerContent;
        }
        field(111; "Document No. Series"; Code[10])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(112; "Document No. Filling"; enum lvnGenJnlDocumentNoFilling)
        {
            Caption = 'Document No. Filling';
            DataClassification = CustomerContent;
        }
        field(113; "Document No. Prefix"; Code[10])
        {
            Caption = 'Document No. Prefix';
            DataClassification = CustomerContent;
        }
        field(114; "Use Single Document No."; Boolean)
        {
            Caption = 'Use Single Document No.';
            DataClassification = CustomerContent;
        }
        field(115; "Loan No. Validation Rule"; Enum lvnLoanNoValidationRule)
        {
            Caption = 'Loan No. Validation Rule';
            DataClassification = CustomerContent;
        }
        field(116; "Applies-To Doc. Type"; enum lvnGenJnlImportDocumentType)
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = CustomerContent;
        }
        field(117; "Bank Payment Type"; Enum lvnBankPaymentType)
        {
            Caption = 'Bank Payment Type';
            DataClassification = CustomerContent;
        }
        field(118; "Recurring Method"; enum lvnRecurrencyMethod)
        {
            Caption = 'Recurring Method';
            DataClassification = CustomerContent;
        }
        field(119; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
            DataClassification = CustomerContent;
        }
        field(120; "Deposit Document Type"; enum lvnDepositDocumentType)
        {
            Caption = 'Deposit Document Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}