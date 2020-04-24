table 14135152 lvngLoanNormalizedViewSetup
{
    Caption = 'Loan Normalized View Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(2; Description; Text[30]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(10; "Custom Text 1"; Integer) { Caption = 'Custom Text 1'; DataClassification = CustomerContent; }
        field(11; "Custom Text 2"; Integer) { Caption = 'Custom Text 2'; DataClassification = CustomerContent; }
        field(12; "Custom Text 3"; Integer) { Caption = 'Custom Text 3'; DataClassification = CustomerContent; }
        field(13; "Custom Text 4"; Integer) { Caption = 'Custom Text 4'; DataClassification = CustomerContent; }
        field(14; "Custom Text 5"; Integer) { Caption = 'Custom Text 5'; DataClassification = CustomerContent; }
        field(15; "Custom Text 6"; Integer) { Caption = 'Custom Text 6'; DataClassification = CustomerContent; }
        field(16; "Custom Text 7"; Integer) { Caption = 'Custom Text 7'; DataClassification = CustomerContent; }
        field(17; "Custom Text 8"; Integer) { Caption = 'Custom Text 8'; DataClassification = CustomerContent; }
        field(18; "Custom Text 9"; Integer) { Caption = 'Custom Text 9'; DataClassification = CustomerContent; }
        field(19; "Custom Text 10"; Integer) { Caption = 'Custom Text 10'; DataClassification = CustomerContent; }
        field(30; "Custom Decimal 1"; Integer) { Caption = 'Custom Decimal 1'; DataClassification = CustomerContent; }
        field(31; "Custom Decimal 2"; Integer) { Caption = 'Custom Decimal 2'; DataClassification = CustomerContent; }
        field(32; "Custom Decimal 3"; Integer) { Caption = 'Custom Decimal 3'; DataClassification = CustomerContent; }
        field(33; "Custom Decimal 4"; Integer) { Caption = 'Custom Decimal 4'; DataClassification = CustomerContent; }
        field(34; "Custom Decimal 5"; Integer) { Caption = 'Custom Decimal 5'; DataClassification = CustomerContent; }
        field(35; "Custom Decimal 6"; Integer) { Caption = 'Custom Decimal 6'; DataClassification = CustomerContent; }
        field(36; "Custom Decimal 7"; Integer) { Caption = 'Custom Decimal 7'; DataClassification = CustomerContent; }
        field(37; "Custom Decimal 8"; Integer) { Caption = 'Custom Decimal 8'; DataClassification = CustomerContent; }
        field(38; "Custom Decimal 9"; Integer) { Caption = 'Custom Decimal 9'; DataClassification = CustomerContent; }
        field(39; "Custom Decimal 10"; Integer) { Caption = 'Custom Decimal 10'; DataClassification = CustomerContent; }
        field(40; "Custom Decimal 11"; Integer) { Caption = 'Custom Decimal 11'; DataClassification = CustomerContent; }
        field(41; "Custom Decimal 12"; Integer) { Caption = 'Custom Decimal 12'; DataClassification = CustomerContent; }
        field(42; "Custom Decimal 13"; Integer) { Caption = 'Custom Decimal 13'; DataClassification = CustomerContent; }
        field(43; "Custom Decimal 14"; Integer) { Caption = 'Custom Decimal 14'; DataClassification = CustomerContent; }
        field(44; "Custom Decimal 15"; Integer) { Caption = 'Custom Decimal 15'; DataClassification = CustomerContent; }
        field(45; "Custom Decimal 16"; Integer) { Caption = 'Custom Decimal 16'; DataClassification = CustomerContent; }
        field(46; "Custom Decimal 17"; Integer) { Caption = 'Custom Decimal 17'; DataClassification = CustomerContent; }
        field(47; "Custom Decimal 18"; Integer) { Caption = 'Custom Decimal 18'; DataClassification = CustomerContent; }
        field(48; "Custom Decimal 19"; Integer) { Caption = 'Custom Decimal 19'; DataClassification = CustomerContent; }
        field(49; "Custom Decimal 20"; Integer) { Caption = 'Custom Decimal 20'; DataClassification = CustomerContent; }
        field(50; "Custom Decimal 21"; Integer) { Caption = 'Custom Decimal 21'; DataClassification = CustomerContent; }
        field(100; "Custom Date 1"; Integer) { Caption = 'Custom Date 1'; DataClassification = CustomerContent; }
        field(101; "Custom Date 2"; Integer) { Caption = 'Custom Date 2'; DataClassification = CustomerContent; }
        field(102; "Custom Date 3"; Integer) { Caption = 'Custom Date 3'; DataClassification = CustomerContent; }
        field(103; "Custom Date 4"; Integer) { Caption = 'Custom Date 4'; DataClassification = CustomerContent; }
        field(104; "Custom Date 5"; Integer) { Caption = 'Custom Date 5'; DataClassification = CustomerContent; }
        field(105; "Custom Date 6"; Integer) { Caption = 'Custom Date 6'; DataClassification = CustomerContent; }
        field(1000; "Last Update DateTime"; DateTime) { Caption = 'Last Update Date Time'; DataClassification = CustomerContent; }
        field(1001; "Last Updated By"; Code[50]) { Caption = 'Last Updated By'; DataClassification = CustomerContent; }
        field(1002; "Entries Count"; Integer) { Caption = 'Entries Count'; FieldClass = FlowField; CalcFormula = count (lvngLoanNormalizedView where("View Code" = field(Code))); Editable = false; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}