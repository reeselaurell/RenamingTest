table 14135102 lvngLoan
{
    DataClassification = CustomerContent;
    Caption = 'Loan';
    LookupPageId = lvngLoanList;
    DrillDownPageId = lvngLoanList;
    DataCaptionFields = "No.", "Search Name";

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; "Search Name"; Code[100]) { Caption = 'Search Name'; DataClassification = CustomerContent; }
        field(11; "Borrower First Name"; Text[30]) { Caption = 'Borrower First Name'; DataClassification = CustomerContent; }
        field(12; "Borrower Last Name"; Text[30]) { Caption = 'Borrower Last Name'; DataClassification = CustomerContent; }
        field(13; "Borrower Middle Name"; Text[30]) { Caption = 'Borrower Middle Name'; DataClassification = CustomerContent; }
        field(14; "Title Customer No."; Code[20]) { Caption = 'Title Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(15; "Investor Customer No."; Code[20]) { Caption = 'Investor Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(16; "Borrower Customer No"; Code[20]) { Caption = 'Borrower Customer No.'; DataClassification = CustomerContent; TableRelation = Customer."No."; }
        field(17; "Alternative Loan No."; Code[50]) { Caption = 'Alternative Loan No.'; DataClassification = CustomerContent; }
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
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(81; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(82; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(83; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(84; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(85; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(86; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(87; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(88; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; DataClassification = CustomerContent; TableRelation = "Business Unit"; }
        field(100; "Loan Term (Months)"; Integer) { Caption = 'Loan Term (Months)'; DataClassification = CustomerContent; }
        field(101; "Interest Rate"; Decimal) { Caption = 'Interest Rate'; DataClassification = CustomerContent; DecimalPlaces = 3 : 3; }
        field(102; "First Payment Due"; Date) { Caption = 'First Payment Due'; DataClassification = CustomerContent; }
        field(103; "First Payment Due To Investor"; Date) { Caption = 'First Payment Due to Investor'; DataClassification = CustomerContent; }
        field(104; "Next Payment Date"; Date) { Caption = 'Next Payment Date'; DataClassification = CustomerContent; }
        field(105; "Monthly Escrow Amount"; Decimal) { Caption = 'Monthly Escrow Amount'; DataClassification = CustomerContent; }
        field(106; "Monthly Payment Amount"; Decimal) { Caption = 'Monthly Payment Amount (P+I)'; DataClassification = CustomerContent; }
        field(107; "Late Fee"; Decimal) { Caption = 'Servicing Late Fee'; DataClassification = CustomerContent; }
        field(300; "Borrower SSN"; Code[20]) { Caption = 'Borrower SSN'; DataClassification = CustomerContent; }
        field(301; "Co-Borrower SSN"; Code[20]) { Caption = 'Co-Borrower SSN'; DataClassification = CustomerContent; }
        field(302; "Borrower SSN Key"; Guid) { Caption = 'Borrower SSN Key'; DataClassification = CustomerContent; }
        field(303; "Co-Borrower SSN Key"; Guid) { Caption = 'Co-Borrower SSN Key'; DataClassification = CustomerContent; }
        field(500; "Commission Base Amount"; Decimal) { Caption = 'Commission Base Amount'; DataClassification = CustomerContent; }
        field(501; "Commission Date"; Date) { Caption = 'Commission Date'; DataClassification = CustomerContent; }
        field(502; "Commission Bps"; Decimal) { Caption = 'Commission Bps'; DataClassification = CustomerContent; }
        field(503; "Commission Amount"; Decimal) { Caption = 'Commission Amount'; DataClassification = CustomerContent; }
        field(600; "Constr. Interest Rate"; Decimal) { Caption = 'Construction Interest Rate'; DataClassification = CustomerContent; DecimalPlaces = 3 : 3; }
        field(1000; "Servicing Finished"; Boolean) { Caption = 'Servicing Finished'; DataClassification = CustomerContent; }
        field(80000; "Creation Date"; Date) { Caption = 'Creation Date'; DataClassification = CustomerContent; }
        field(80001; "Modified Date"; Date) { Caption = 'Modified Date'; DataClassification = CustomerContent; }
        field(14135999; lvngDocumentGuid; Guid) { Caption = 'Document GUID'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(SearchName; "Search Name") { }
        key(CommissionDate; "Commission Date") { }
        key(FundedDate; "Date Funded") { }
        key(SoldDate; "Date Sold") { }
        key(AlternativeLoanNo; "Alternative Loan No.") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Search Name", "Alternative Loan No.") { }
        fieldgroup(Brick; "No.", "Search Name", "Loan Amount") { }
    }

    trigger OnInsert()
    var
        EmptyGuid: Guid;
    begin
        "Creation Date" := Today();
        "Modified Date" := "Creation Date";
        if lvngDocumentGuid = EmptyGuid then
            lvngDocumentGuid := CreateGuid();
    end;

    trigger OnModify()
    begin
        "Modified Date" := Today();
    end;

    trigger OnDelete()
    var
        LoanAddress: Record lvngLoanAddress;
        LoanValue: Record lvngLoanValue;
    begin
        LoanAddress.Reset();
        LoanAddress.SetRange("Loan No.", "No.");
        LoanAddress.DeleteAll(false);
        LoanValue.Reset();
        LoanValue.SetRange("Loan No.", "No.");
        LoanValue.DeleteAll(false);
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimensionManagement.SaveDefaultDim(Database::lvngLoan, "No.", FieldNumber, ShortcutDimCode);
        Modify();
    end;

    procedure GetLoanAddress(AddressType: enum lvngAddressType): Text;
    var
        LoanAddress: Record lvngLoanAddress;
        AddressFormat: Label '%1 %2, %3 %4 %5';
        FormattedAddress: Text;
    begin
        if LoanAddress.Get("No.", AddressType) then begin
            FormattedAddress := strsubstno(AddressFormat, LoanAddress.Address, LoanAddress."Address 2", LoanAddress.City, LoanAddress.State, LoanAddress."ZIP Code");
            if DelChr(FormattedAddress, '=', ' ,') = '' then
                exit('')
            else
                exit(FormattedAddress);
        end;
    end;
}