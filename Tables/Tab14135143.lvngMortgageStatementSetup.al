table 14135143 lvngMortgageStatementSetup
{
    Caption = 'Mortgage Statement Setup';
    DataClassification = CustomerContent;


    fields
    {
        field(1; Code; Code[10]) { DataClassification = CustomerContent; Caption = 'Code'; }
        field(10; "Serv. Department Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Phone No.'; }
        field(11; "Serv. Department Fax No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Fax No.'; }
        field(12; "Serv. Department Working Days"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Working Days'; }
        field(13; "Serv. Department Working Hours"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Working Hours'; }
        field(14; "Serv. Department E-Mail"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department E-Mail'; }
        field(15; "Serv. Department Address 1"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department Address 1'; }
        field(16; "Serv. Department Address 2"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department Address 2'; }
        field(17; "Serv. Department State"; Code[10]) { DataClassification = CustomerContent; Caption = 'Serv. Department State'; }
        field(18; "Serv. Department Zip Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Serv. Department Zip Code'; }
        field(19; "Serv. Department City"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department City'; }
        field(30; "Collection Dep. Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Phone No.'; }
        field(31; "Collection Dep. Working Days"; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Working Days'; }
        field(32; "Collection Dep. Working Hours"; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Working Hours'; }
        field(34; "Collection Dep.Fax No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Fax No'; }
        field(40; "Company Website"; Text[30]) { DataClassification = CustomerContent; Caption = 'Company Website'; }
        field(41; "Statement Logo"; Blob) { DataClassification = CustomerContent; Caption = 'Statement Logo'; Subtype = Bitmap; }
        field(42; "Name On Statement Report"; Text[50]) { DataClassification = CustomerContent; Caption = 'Name on Statement Report'; }
        field(43; "Late Payment Fee Percent"; Decimal) { DataClassification = CustomerContent; Caption = 'Late Payment Fee %'; }
        field(44; "Late Payment Date Formula"; DateFormula) { DataClassification = CustomerContent; Caption = 'Late Payment Date Formula'; }
        field(45; "Toll Free Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Toll Free Phone No.'; }
        field(46; "Serv. Report Due Date"; Option) { DataClassification = CustomerContent; Caption = 'Servicing Report Due Date'; OptionMembers = "Ledger Entries","Custom Formula"; }
        field(47; "Serv. Due Date Formula"; DateFormula) { DataClassification = CustomerContent; Caption = 'Serv. Due Date Formula'; }
        field(72000; "ConstructionDeptEmail"; Text[50]) { DataClassification = CustomerContent; Caption = 'Construction Dept. E-Mail'; }
        field(72001; "ConstructionDeptPhoneNo"; Text[30]) { DataClassification = CustomerContent; Caption = 'Construction Dept. Phone No.'; }
        field(72002; "NMLS ID"; Text[30]) { DataClassification = CustomerContent; Caption = 'NMLS ID'; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}