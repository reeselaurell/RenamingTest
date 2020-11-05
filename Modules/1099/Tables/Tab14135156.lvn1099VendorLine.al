table 14135156 "lvn1099VendorLine"
{
    Caption = 'Form 1099 Vendors List';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Federal ID No."; Text[30])
        {
            Caption = 'Federal ID No.';
            DataClassification = CustomerContent;
        }
        field(10; "MISC-01"; Decimal)
        {
            Caption = 'MISC-01';
            DataClassification = CustomerContent;
        }
        field(11; "MISC-02"; Decimal)
        {
            Caption = 'MISC-02';
            DataClassification = CustomerContent;
        }
        field(12; "MISC-03"; Decimal)
        {
            Caption = 'MISC-03';
            DataClassification = CustomerContent;
        }
        field(13; "MISC-04"; Decimal)
        {
            Caption = 'MISC-04';
            DataClassification = CustomerContent;
        }
        field(14; "MISC-05"; Decimal)
        {
            Caption = 'MISC-05';
            DataClassification = CustomerContent;
        }
        field(15; "MISC-06"; Decimal)
        {
            Caption = 'MISC-06';
            DataClassification = CustomerContent;
        }
        field(16; "MISC-07"; Decimal)
        {
            Caption = 'MISC-07';
            DataClassification = CustomerContent;
        }
        field(17; "MISC-08"; Decimal)
        {
            Caption = 'MISC-08';
            DataClassification = CustomerContent;
        }
        field(18; "MISC-09"; Decimal)
        {
            Caption = 'MISC-09';
            DataClassification = CustomerContent;
        }
        field(19; "MISC-10"; Decimal)
        {
            Caption = 'MISC-10';
            DataClassification = CustomerContent;
        }
        field(20; "MISC-13"; Decimal)
        {
            Caption = 'MISC-13';
            DataClassification = CustomerContent;
        }
        field(21; "MISC-14"; Decimal)
        {
            Caption = 'MISC-14';
            DataClassification = CustomerContent;
        }
        field(22; "MISC-15-A"; Decimal)
        {
            Caption = 'MISC-15-A';
            DataClassification = CustomerContent;
        }
        field(23; "MISC-15-B"; Decimal)
        {
            Caption = 'MISC-15-B';
            DataClassification = CustomerContent;
        }
        field(24; "MISC-16"; Decimal)
        {
            Caption = 'MISC-16';
            DataClassification = CustomerContent;
        }
        field(25; "Default MISC"; Code[10])
        {
            Caption = 'Default MISC';
            DataClassification = CustomerContent;
            TableRelation = "IRS 1099 Form-Box";
        }
        field(26; "Not Assigned Amount"; Decimal)
        {
            Caption = 'Not Assigned Amount';
            DataClassification = CustomerContent;
        }
        field(100; "Total Payments Amount"; Decimal)
        {
            Caption = 'Total Payments Amount';
            DataClassification = CustomerContent;
        }
        field(110; "Legal Name"; Text[100])
        {
            Caption = 'Legal Name';
            DataClassification = CustomerContent;
        }
        field(111; "Legal Address"; Text[100])
        {
            Caption = 'Legal Address';
            DataClassification = CustomerContent;
        }
        field(112; "Legal Address City"; Text[30])
        {
            Caption = 'Legal Address City';
            DataClassification = CustomerContent;
        }
        field(113; "Legal Address ZIP Code"; Text[20])
        {
            Caption = 'Legal Address Post Code';
            DataClassification = CustomerContent;
        }
        field(114; "Legal Address State"; Text[30])
        {
            Caption = 'Legal Address State';
            DataClassification = CustomerContent;
        }
        field(115; "FATCA Filing Requirement"; Boolean)
        {
            Caption = 'FATCA Filing Requirement';
            DataClassification = CustomerContent;
        }
        field(120; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(Key2; "Federal ID No.") { }
    }
}