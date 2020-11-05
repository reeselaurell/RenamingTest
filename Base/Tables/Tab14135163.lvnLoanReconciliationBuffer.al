table 14135163 "lvnLoanReconciliationBuffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = lvnLoan."No.";

            trigger OnValidate()
            var
                Loan: Record lvnLoan;
            begin
                Loan.Get("Loan No.");
                Rec.TransferFields(Loan, false);
            end;
        }
        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(11; "Date Closed"; Date)
        {
            Caption = 'Date Closed';
            DataClassification = CustomerContent;
        }
        field(12; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(13; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
        field(14; "Date Funded"; Date)
        {
            Caption = 'Date Funded';
            DataClassification = CustomerContent;
        }
        field(15; "Date Sold"; Date)
        {
            Caption = 'Date Sold';
            DataClassification = CustomerContent;
        }
        field(16; "Borrower First Name"; Text[50])
        {
            Caption = 'Borrower First Name';
            DataClassification = CustomerContent;
        }
        field(17; "Borrower Middle Name"; Text[50])
        {
            Caption = 'Borrower Middle Name';
            DataClassification = CustomerContent;
        }
        field(18; "Borrower Last Name"; Text[50])
        {
            Caption = 'Borrower Last Name';
            DataClassification = CustomerContent;
        }
        field(19; "Warehouse Line Code"; Code[50])
        {
            Caption = 'Warehouse Line Code';
            DataClassification = CustomerContent;
        }
        field(20; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(23; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(24; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(25; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(26; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(27; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(28; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(29; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit".Code;
        }
        field(30; "File Amount"; Decimal)
        {
            Caption = 'File Amount';
            DataClassification = CustomerContent;
        }
        field(31; "Debit Amount"; Decimal)
        {
            Caption = 'Debit Amount';
            DataClassification = CustomerContent;
        }
        field(32; "Credit Amount"; Decimal)
        {
            Caption = 'Credit Amount';
            DataClassification = CustomerContent;
        }
        field(33; Unbalanced; Boolean)
        {
            Caption = 'Unbalanced';
            DataClassification = CustomerContent;
        }
        field(34; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(35; "Difference"; Decimal)
        {
            Caption = 'Difference';
            DataClassification = CustomerContent;
        }
        field(36; Reclass; Boolean)
        {
            Caption = 'Reclass';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Loan No.", "G/L Account No.") { Clustered = true; }
    }
}