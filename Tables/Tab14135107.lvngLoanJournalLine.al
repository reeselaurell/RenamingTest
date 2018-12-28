table 14135107 "lvngLoanJournalLine"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Journal Line';

    fields
    {
        field(1; lvngLoanJournalBatchCode; Code[20])
        {
            Caption = 'Batch Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanJournalBatch;
        }
        field(2; lvngLineNo; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; lvngLoanNo; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
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
        field(200; lvngBorrowerAddress; Text[50])
        {
            Caption = 'Borrower Address';
            DataClassification = CustomerContent;
        }
        field(201; lvngBorrowerAddress2; Text[50])
        {
            Caption = 'Borrower Address 2';
            DataClassification = CustomerContent;
        }
        field(202; lvngBorrowerCity; Text[30])
        {
            Caption = 'Borrower City';
            DataClassification = CustomerContent;

        }
        field(203; lvngBorrowerState; Text[30])
        {
            Caption = 'Borrower State';
            DataClassification = CustomerContent;
        }

        field(204; lvngBorrowerZIPCode; Code[20])
        {
            Caption = 'Borrower ZIP Code';
            DataClassification = CustomerContent;
        }

        field(210; lvngCoBorrowerAddress; Text[50])
        {
            Caption = 'Co-Borrower Address';
            DataClassification = CustomerContent;
        }
        field(211; lvngCoBorrowerAddress2; Text[50])
        {
            Caption = 'Co-Borrower Address 2';
            DataClassification = CustomerContent;
        }
        field(212; lvngCoBorrowerCity; Text[30])
        {
            Caption = 'Co-Borrower City';
            DataClassification = CustomerContent;

        }
        field(213; lvngCoBorrowerState; Text[30])
        {
            Caption = 'Co-Borrower State';
            DataClassification = CustomerContent;
        }

        field(214; lvngCoBorrowerZIPCode; Code[20])
        {
            Caption = 'Co-Borrower ZIP Code';
            DataClassification = CustomerContent;
        }
        field(220; lvngPropertyAddress; Text[50])
        {
            Caption = 'Property Address';
            DataClassification = CustomerContent;
        }
        field(221; lvngPropertyAddress2; Text[50])
        {
            Caption = 'Property Address 2';
            DataClassification = CustomerContent;
        }
        field(222; lvngPropertyCity; Text[30])
        {
            Caption = 'Property City';
            DataClassification = CustomerContent;

        }
        field(223; lvngPropertyState; Text[30])
        {
            Caption = 'Property State';
            DataClassification = CustomerContent;
        }

        field(224; lvngPropertyZIPCode; Code[20])
        {
            Caption = 'Property ZIP Code';
            DataClassification = CustomerContent;
        }
        field(230; lvngMailingAddress; Text[50])
        {
            Caption = 'Mailing Address';
            DataClassification = CustomerContent;
        }
        field(231; lvngMailingAddress2; Text[50])
        {
            Caption = 'Mailing Address 2';
            DataClassification = CustomerContent;
        }
        field(232; lvngMailingCity; Text[30])
        {
            Caption = 'Mailing City';
            DataClassification = CustomerContent;

        }
        field(233; lvngMailingState; Text[30])
        {
            Caption = 'Mailing State';
            DataClassification = CustomerContent;
        }

        field(234; lvngMailingZIPCode; Code[20])
        {
            Caption = 'Mailing ZIP Code';
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

        field(5000; lvngProcessingSchemaCode; Code[20])
        {
            Caption = 'Processing Schema Code';
            DataClassification = CustomerContent;
            TableRelation = lvngLoanProcessingSchema.lvngCode;
        }

        field(5001; lvngReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }


    }

    keys
    {
        key(PK; lvngLoanJournalBatchCode, lvngLineNo)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        lvngLoanJournalValue: Record lvngLoanJournalValue;
        lvngLoanImportErrorLine: Record lvngLoanImportErrorLine;
    begin
        lvngLoanJournalValue.reset;
        lvngLoanJournalValue.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalBatchCode);
        lvngLoanJournalValue.SetRange(lvngLineNo, lvngLineNo);
        lvngLoanJournalValue.DeleteAll();
        lvngLoanImportErrorLine.reset;
        lvngLoanImportErrorLine.SetRange(lvngLoanJournalBatchCode, lvngLoanJournalBatchCode);
        lvngLoanImportErrorLine.SetRange(lvngLineNo, lvngLineNo);
        lvngLoanImportErrorLine.DeleteAll();
    end;

}