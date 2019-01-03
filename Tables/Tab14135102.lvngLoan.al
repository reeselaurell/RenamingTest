table 14135102 "lvngLoan"
{
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanList;

    fields
    {
        field(1; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(10; lvngSearchName; Code[100])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }

        field(11; lvngBorrowerFirstName; Text[30])
        {
            Caption = 'Borrower First Name';
            DataClassification = CustomerContent;
        }

        field(12; lvngBorrowerLastName; Text[30])
        {
            Caption = 'Borrower Last Name';
            DataClassification = CustomerContent;
        }
        field(13; lvngBorrowerMiddleName; Text[30])
        {
            Caption = 'Borrower Middle Name';
            DataClassification = CustomerContent;
        }

        field(14; lvngTitleCustomerNo; Code[20])
        {
            Caption = 'Title Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        field(15; lvngInvestorCustomerNo; Code[20])
        {
            Caption = 'Investor Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        field(16; lvngBorrowerCustomerNo; Code[20])
        {
            Caption = 'Borrower Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }

        field(20; lvngApplicationDate; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }

        field(21; lvngDateClosed; Date)
        {
            Caption = 'Date Closed';
            DataClassification = CustomerContent;
        }

        field(22; lvngDateFunded; Date)
        {
            Caption = 'Date Funded';
            DataClassification = CustomerContent;
        }

        field(23; lvngDateSold; Date)
        {
            Caption = 'Date Sold';
            DataClassification = CustomerContent;
        }

        field(24; lvngDateLocked; Date)
        {
            Caption = 'Date Locked';
            DataClassification = CustomerContent;
        }
        field(25; lvngLoanAmount; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }

        field(26; lvngBlocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }

        field(27; lvngWarehouseLineCode; Code[50])
        {
            Caption = 'Warehouse Line Code';
            DataClassification = CustomerContent;
            TableRelation = lvngWarehouseLine;
        }

        field(80; lvngGlobalDimension1Code; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (1));
        }
        field(81; lvngGlobalDimension2Code; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (2));
        }
        field(82; lvngShortcutDimension3Code; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (3));
        }
        field(83; lvngShortcutDimension4Code; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (4));
        }
        field(84; lvngShortcutDimension5Code; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (5));
        }
        field(85; lvngShortcutDimension6Code; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (6));
        }
        field(86; lvngShortcutDimension7Code; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (7));
        }
        field(87; lvngShortcutDimension8Code; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where ("Global Dimension No." = CONST (8));
        }

        field(88; lvngBusinessUnitCode; Code[10])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Business Unit";
        }

        field(100; lvngLoanTermMonths; Integer)
        {
            Caption = 'Loan Term (Months)';
            DataClassification = CustomerContent;
        }

        field(101; lvngInterestRate; Decimal)
        {
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
        }

        field(102; lvngFirstPaymentDue; Date)
        {
            Caption = 'First Payment Due';
            DataClassification = CustomerContent;
        }

        field(103; lvngFirstPaymentDueToInvestor; Date)
        {
            Caption = 'First Payment Due to Investor';
            DataClassification = CustomerContent;
        }

        field(104; lvngNextPaymentDate; Date)
        {
            Caption = 'Next Payment Date';
            DataClassification = CustomerContent;
        }

        field(105; lvngMonthlyEscrowAmount; Decimal)
        {
            Caption = 'Monthly Escrow Amount';
            DataClassification = CustomerContent;
        }

        field(106; lvngMonthlyPaymentAmount; Decimal)
        {
            Caption = 'Monthly Payment Amount';
            DataClassification = CustomerContent;
        }

        field(500; lvngCommissionBaseAmount; Decimal)
        {
            Caption = 'Commission Base Amount';
            DataClassification = CustomerContent;
        }

        field(501; lvngCommissionDate; Date)
        {
            Caption = 'Commission Date';
            DataClassification = CustomerContent;
        }


        field(600; lvngConstrInterestRate; Decimal)
        {
            Caption = 'Construction Interest Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
        }

        field(80000; lvngCreationDate; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }

        field(80001; lvngModifiedDate; Date)
        {
            Caption = 'Modified Date';
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(PK; lvngLoanNo)
        {
            Clustered = true;
        }

        key(SearchName; lvngSearchName)
        {

        }


    }

    trigger OnInsert()
    begin
        lvngCreationDate := Today();
    end;

    trigger OnModify()
    begin
        lvngModifiedDate := Today();
    end;

}