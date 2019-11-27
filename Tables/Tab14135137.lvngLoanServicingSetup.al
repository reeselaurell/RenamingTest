table 14135137 lvngLoanServicingSetup
{
    DataClassification = CustomerContent;
    Caption = 'Loan Servicing Setup';

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; DataClassification = CustomerContent; }
        field(10; "Principal Red. Reason Code"; Code[10]) { Caption = 'Principal Reduction Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(11; "Additional Escrow Reason Code"; Code[10]) { Caption = 'Additional Escrow Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(12; "Serviced Reason Code"; Code[10]) { Caption = 'Serviced Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(13; "Late Payment Reason Code"; Code[10]) { Caption = 'Late Payment Reason Code'; DataClassification = CustomerContent; TableRelation = "Reason Code"; }
        field(16; "Serviced Void Reason Code"; code[10]) { DataClassification = CustomerContent; Caption = 'Serviced Void Reason Code'; TableRelation = "Reason Code"; }
        field(19; "Serviced Source Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Serviced Source Code'; TableRelation = "Source Code".Code; }
        field(30; "Interest G/L Acc. Switch Code"; Code[20]) { DataClassification = CustomerContent; /* TableRelation = lvngExpressionHeader.Code where (Type = const(Switch)); //TODO: This one is not good, needed lookup with consumer id included. However this field is unused as of 11/19/19 */ Caption = 'Interest G/L Account Switch Code'; }
        field(31; "Principal G/L Acc. Switch Code"; Code[20]) { DataClassification = CustomerContent; /* TableRelation = lvngExpressionHeader.Code where (Type = const(Switch)); //TODO: This one is not good, needed lookup with consumer id included. However this field is unused as of 11/19/19 */ Caption = 'Principal G/L Account Switch Code'; }
        field(35; "Interest Cost Center Option"; enum lvngServDimSelectionType) { Caption = 'Interest Cost Center Option'; DataClassification = CustomerContent; }
        field(36; "Principal Cost Center Option"; enum lvngServDimSelectionType) { Caption = 'Principal Cost Center Option'; DataClassification = CustomerContent; }
        field(37; "Interest Cost Center"; Code[20])
        {
            Caption = 'Interest Cost Center';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                DimensionsManagement.LookupCostCenter("Interest Cost Center");
            end;
        }
        field(38; "Principal Cost Center"; Code[20])
        {
            Caption = 'Principal Cost Center';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                DimensionsManagement.LookupCostCenter("Principal Cost Center");
            end;
        }
        field(40; "Interest G/L Account No."; Code[20]) { Caption = 'Interest G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(41; "Principal G/L Account No."; Code[20]) { Caption = 'Principal G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(42; "Principal Red. G/L Account No."; Code[20]) { Caption = 'Principal Reduction G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"."No." where("Account Type" = const(Posting)); }
        field(43; "Add. Escrow G/L Account No."; Code[20]) { Caption = 'Additional Escrow G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"."No." where("Account Type" = const(Posting)); }
        field(44; "Late Payment G/L Account No."; Code[20]) { Caption = 'Late Payment G/L Account No.'; DataClassification = CustomerContent; TableRelation = "G/L Account"."No." where("Account Type" = const(Posting)); }
        field(52; "Serviced No. Series"; Code[20]) { Caption = 'Serviced No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(55; "Void Serviced No. Series"; Code[20]) { Caption = 'Serviced Void No. Series'; DataClassification = CustomerContent; TableRelation = "No. Series".Code; }
        field(56; "Late Fee Rule"; enum lvngServicingLateFeeRule) { Caption = 'Late Fee Rule'; DataClassification = CustomerContent; }
        field(60; "Borrower Customer Template"; Code[20]) { Caption = 'Borrower Customer Template'; DataClassification = CustomerContent; TableRelation = "Customer Template".Code; }
        field(100; "Test Escrow Totals"; Boolean) { Caption = 'Test Escrow Total Amount'; DataClassification = CustomerContent; }
        field(700; Code; Code[10]) { DataClassification = CustomerContent; Caption = 'Code'; }
        field(701; "Serv. Department Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Phone No.'; }
        field(702; "Serv. Department Fax No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Fax No.'; }
        field(703; "Serv. Department Working Days"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Working Days'; }
        field(704; "Serv. Department Working Hours"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department Working Hours'; }
        field(705; "Serv. Department E-Mail"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department E-Mail'; }
        field(706; "Serv. Department Address 1"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department Address 1'; }
        field(707; "Serv. Department Address 2"; Text[50]) { DataClassification = CustomerContent; Caption = 'Serv. Department Address 2'; }
        field(708; "Serv. Department State"; Code[10]) { DataClassification = CustomerContent; Caption = 'Serv. Department State'; }
        field(709; "Serv. Department Zip Code"; Code[20]) { DataClassification = CustomerContent; Caption = 'Serv. Department Zip Code'; }
        field(710; "Serv. Department City"; Text[30]) { DataClassification = CustomerContent; Caption = 'Serv. Department City'; }
        field(711; "Collection Dep. Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Phone No.'; }
        field(712; "Collection Dep. Working Days"; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Working Days'; }
        field(713; "Collection Dep. Working Hours"; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Working Hours'; }
        field(714; "Collection Dep.Fax No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Collection Dep. Fax No'; }
        field(715; "Company Website"; Text[30]) { DataClassification = CustomerContent; Caption = 'Company Website'; }
        field(716; "Statement Logo"; Blob) { DataClassification = CustomerContent; Caption = 'Statement Logo'; Subtype = Bitmap; }
        field(717; "Name On Statement Report"; Text[50]) { DataClassification = CustomerContent; Caption = 'Name on Statement Report'; }
        field(718; "Late Payment Fee Percent"; Decimal) { DataClassification = CustomerContent; Caption = 'Late Payment Fee %'; }
        field(719; "Late Payment Date Formula"; DateFormula) { DataClassification = CustomerContent; Caption = 'Late Payment Date Formula'; }
        field(720; "Toll Free Phone No."; Text[30]) { DataClassification = CustomerContent; Caption = 'Toll Free Phone No.'; }
        field(721; "Serv. Report Due Date"; Option) { DataClassification = CustomerContent; Caption = 'Servicing Report Due Date'; OptionMembers = "Ledger Entries","Custom Formula"; }
        field(722; "Serv. Due Date Formula"; DateFormula) { DataClassification = CustomerContent; Caption = 'Serv. Due Date Formula'; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    var
        DimensionsManagement: Codeunit lvngDimensionsManagement;
}