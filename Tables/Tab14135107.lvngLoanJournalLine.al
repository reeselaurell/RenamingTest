table 14135107 lvngLoanJournalLine
{
    DataClassification = CustomerContent;
    Caption = 'Loan Journal Line';

    fields
    {
        field(1; "Loan Journal Batch Code"; Code[20]) { Caption = 'Batch Code'; DataClassification = CustomerContent; TableRelation = lvngLoanJournalBatch; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(5; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; }
        field(10; "Search Name"; Code[100]) { Caption = 'Search Name'; DataClassification = CustomerContent; }
        field(11; "Borrower First Name"; Text[30]) { Caption = 'Borrower First Name'; DataClassification = CustomerContent; }
        field(12; "Borrower Last Name"; Text[30]) { Caption = 'Borrower Last Name'; DataClassification = CustomerContent; }
        field(13; "Borrower Middle Name"; Text[30]) { Caption = 'Borrower Middle Name'; DataClassification = CustomerContent; }
        field(14; "Title Customer No."; Code[20]) { Caption = 'Title Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(15; "Investor Customer No."; Code[20]) { Caption = 'Investor Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(16; "Borrower Customer No."; Code[20]) { Caption = 'Borrower Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(17; "Alternative Loan No."; Code[50]) { DataClassification = CustomerContent; Caption = 'Alternative Loan No.'; }
        field(20; "Application Date"; Date) { Caption = 'Application Date'; DataClassification = CustomerContent; }
        field(21; "Date Closed"; Date) { Caption = 'Date Closed'; DataClassification = CustomerContent; }
        field(22; "Date Funded"; Date) { Caption = 'Date Funded'; DataClassification = CustomerContent; }
        field(23; "Date Sold"; Date) { Caption = 'Date Sold'; DataClassification = CustomerContent; }
        field(24; "Date Locked"; Date) { Caption = 'Date Locked'; DataClassification = CustomerContent; }
        field(25; "Loan Amount"; Decimal) { Caption = 'Loan Amount'; DataClassification = CustomerContent; }
        field(26; Blocked; Boolean) { Caption = 'Blocked'; DataClassification = CustomerContent; }
        field(27; "Warehouse Line Code"; Code[50]) { Caption = 'Warehouse Line Code'; DataClassification = CustomerContent; TableRelation = lvngWarehouseLine; }
        field(28; "Co-Borrower First Name"; Text[30]) { Caption = 'Co-Borrower First Name'; DataClassification = CustomerContent; }
        field(29; "Co-Borrower Last Name"; Text[30]) { Caption = 'Co-Borrower Last Name'; DataClassification = CustomerContent; }
        field(30; "Co-Borrower Middle Name"; Text[30]) { Caption = 'Co-Borrower Middle Name'; DataClassification = CustomerContent; }
        field(31; "203K Contractor Name"; Text[100]) { Caption = '203K Contractor Name'; DataClassification = CustomerContent; }
        field(32; "203K Inspector Name"; Text[100]) { Caption = '203K Inspector Name'; DataClassification = CustomerContent; }
        field(80; "Global Dimension 1 Code"; Code[20]) { Caption = 'Global Dimension 1 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,1'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1)); }
        field(81; "Global Dimension 2 Code"; Code[20]) { Caption = 'Global Dimension 2 Code'; DataClassification = CustomerContent; CaptionClass = '1,1,2'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2)); }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { Caption = 'Shortcut Dimension 3 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,3'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(3)); }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { Caption = 'Shortcut Dimension 4 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,4'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(4)); }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { Caption = 'Shortcut Dimension 5 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,5'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(5)); }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { Caption = 'Shortcut Dimension 6 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,6'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(6)); }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { Caption = 'Shortcut Dimension 7 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,7'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(7)); }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { Caption = 'Shortcut Dimension 8 Code'; DataClassification = CustomerContent; CaptionClass = '1,2,8'; TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(8)); }
        field(88; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(100; "Loan Term (Months)"; Integer) { Caption = 'Loan Term (Months)'; DataClassification = CustomerContent; }
        field(101; "Interest Rate"; Decimal) { Caption = 'Interest Rate'; DataClassification = CustomerContent; DecimalPlaces = 3 : 3; }
        field(102; "First Payment Due"; Date) { Caption = 'First Payment Due'; DataClassification = CustomerContent; }
        field(103; "First Payment Due To Investor"; Date) { Caption = 'First Payment Due to Investor'; DataClassification = CustomerContent; }
        field(104; "Next Payment Date"; Date) { Caption = 'Next Payment Date'; DataClassification = CustomerContent; }
        field(105; "Monthly Escrow Amount"; Decimal) { Caption = 'Monthly Escrow Amount'; DataClassification = CustomerContent; }
        field(106; "Monthly Payment Amount"; Decimal) { Caption = 'Monthly Payment Amount (P+I)'; DataClassification = CustomerContent; }
        field(107; "Late Fee"; Decimal) { Caption = 'Servicing Late Fee'; DataClassification = CustomerContent; }
        field(200; "Borrower Address"; Text[50]) { Caption = 'Borrower Address'; DataClassification = CustomerContent; }
        field(201; "Borrower Address 2"; Text[50]) { Caption = 'Borrower Address 2'; DataClassification = CustomerContent; }
        field(202; "Borrower City"; Text[30]) { Caption = 'Borrower City'; DataClassification = CustomerContent; }
        field(203; "Borrower State"; Text[30]) { Caption = 'Borrower State'; DataClassification = CustomerContent; }
        field(204; "Borrower ZIP Code"; Code[20]) { Caption = 'Borrower ZIP Code'; DataClassification = CustomerContent; }
        field(210; "Co-Borrower Address"; Text[50]) { Caption = 'Co-Borrower Address'; DataClassification = CustomerContent; }
        field(211; "Co-Borrower Address 2"; Text[50]) { Caption = 'lvngCoBorrowerAddress2'; DataClassification = CustomerContent; }
        field(212; "Co-Borrower City"; Text[30]) { Caption = 'Co-Borrower City'; DataClassification = CustomerContent; }
        field(213; "Co-Borrower State"; Text[30]) { Caption = 'Co-Borrower State'; DataClassification = CustomerContent; }
        field(214; "Co-Borrower ZIP Code"; Code[20]) { Caption = 'Co-Borrower ZIP Code'; DataClassification = CustomerContent; }
        field(220; "Property Address"; Text[50]) { Caption = 'Property Address'; DataClassification = CustomerContent; }
        field(221; "Property Address 2"; Text[50]) { Caption = 'Property Address 2'; DataClassification = CustomerContent; }
        field(222; "Property City"; Text[30]) { Caption = 'Property City'; DataClassification = CustomerContent; }
        field(223; "Property State"; Text[30]) { Caption = 'Property State'; DataClassification = CustomerContent; }
        field(224; "Property ZIP Code"; Code[20]) { Caption = 'Property ZIP Code'; DataClassification = CustomerContent; }
        field(230; "Mailing Address"; Text[50]) { Caption = 'Mailing Address'; DataClassification = CustomerContent; }
        field(231; "Mailing Address 2"; Text[50]) { Caption = 'Mailing Address 2'; DataClassification = CustomerContent; }
        field(232; "Mailing City"; Text[30]) { Caption = 'Mailing City'; DataClassification = CustomerContent; }
        field(233; "Mailing State"; Text[30]) { Caption = 'Mailing State'; DataClassification = CustomerContent; }
        field(234; "Mailing ZIP Code"; Code[20]) { Caption = 'Mailing ZIP Code'; DataClassification = CustomerContent; }
        field(500; "Commission Base Amount"; Decimal) { Caption = 'Commission Base Amount'; DataClassification = CustomerContent; }
        field(501; "Commission Date"; Date) { Caption = 'Commission Date'; DataClassification = CustomerContent; }
        field(502; "Commission Bps"; Decimal) { Caption = 'Commission Bps'; DataClassification = CustomerContent; }
        field(503; "Commission Amount"; Decimal) { Caption = 'Commission Amount'; DataClassification = CustomerContent; }
        field(600; "Constr. Interest Rate"; Decimal) { Caption = 'Construction Interest Rate'; DataClassification = CustomerContent; DecimalPlaces = 3 : 3; }
        field(5000; "Processing Schema Code"; Code[20]) { Caption = 'Processing Schema Code'; DataClassification = CustomerContent; TableRelation = lvngLoanProcessingSchema.Code; }
        field(5001; "Reason Code"; Code[10]) { Caption = 'Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code".Code; }
        field(10000; "Calculated Document Amount"; Decimal) { Caption = 'Document Amount'; DataClassification = CustomerContent; }
        field(50000; "Error Exists"; Boolean) { Caption = 'Error Exists'; FieldClass = FlowField; CalcFormula = exist (lvngLoanImportErrorLine where("Loan Journal Batch Code" = field("Loan Journal Batch Code"), "Line No." = field("Line No."))); }
    }

    keys
    {
        key(PK; "Loan Journal Batch Code", "Line No.") { Clustered = true; }
    }

    trigger OnDelete()
    var
        LoanJournalValue: Record lvngLoanJournalValue;
        LoanImportErrorLine: Record lvngLoanImportErrorLine;
    begin
        LoanJournalValue.Reset();
        LoanJournalValue.SetRange("Loan Journal Batch Code", "Loan Journal Batch Code");
        LoanJournalValue.SetRange("Line No.", "Line No.");
        LoanJournalValue.DeleteAll();
        LoanImportErrorLine.Reset();
        LoanImportErrorLine.SetRange("Loan Journal Batch Code", "Loan Journal Batch Code");
        LoanImportErrorLine.SetRange("Line No.", "Line No.");
        LoanImportErrorLine.DeleteAll();
    end;
}